Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752918AbaBVKW3 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 22 Feb 2014 05:22:29 -0500
Received: from gw-1.arm.linux.org.uk ([78.32.30.217]:46765 "EHLO
	pandora.arm.linux.org.uk" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1752498AbaBVKW2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 22 Feb 2014 05:22:28 -0500
Date: Sat, 22 Feb 2014 10:22:21 +0000
From: Russell King - ARM Linux <linux@arm.linux.org.uk>
To: Russ Dill <Russ.Dill@ti.com>
Cc: Sebastian Capella <sebastian.capella@linaro.org>,
        Lorenzo Pieralisi <lorenzo.pieralisi@arm.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-pm@vger.kernel.org" <linux-pm@vger.kernel.org>,
        "linaro-kernel@lists.linaro.org" <linaro-kernel@lists.linaro.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "Rafael J. Wysocki" <rjw@rjwysocki.net>,
        Len Brown <len.brown@intel.com>, Pavel Machek <pavel@ucw.cz>,
        Nicolas Pitre <nico@linaro.org>,
        Santosh Shilimkar <santosh.shilimkar@ti.com>,
        Will Deacon <Will.Deacon@arm.com>,
        Jonathan Austin <Jonathan.Austin@arm.com>,
        Catalin Marinas <Catalin.Marinas@arm.com>,
        Uwe Kleine-K?nig <u.kleine-koenig@pengutronix.de>,
        Stephen Boyd <sboyd@codeaurora.org>
Subject: Re: [PATCH RFC v1 3/3] ARM hibernation / suspend-to-disk
Message-ID: <20140222102221.GF21483@n2100.arm.linux.org.uk>
References: <1392774729-3235-1-git-send-email-sebastian.capella@linaro.org> <1392774729-3235-4-git-send-email-sebastian.capella@linaro.org> <20140219161254.GB19343@e102568-lin.cambridge.arm.com> <20140219193315.3732.21819@capellas-linux> <20140220162754.GC15994@e102568-lin.cambridge.arm.com> <20140221183956.29890.80931@capellas-linux> <20140221235911.14777.13919@capellas-linux> <20140222043714.19852.67450@capellas-linux> <530847E3.4070401@ti.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <530847E3.4070401@ti.com>
User-Agent: Mutt/1.5.19 (2009-01-05)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Feb 21, 2014 at 10:46:59PM -0800, Russ Dill wrote:
> If there is worry about this, you could setup a page mapping in a
> __nosave region, preventing it from being overwritten.

Why would we need _another_ set of pages tables?  Aren't two (swapper_pg_dir
and the idmap one) enough?

You do need to switch to the idmap one if you're going to call cpu_resume
at its physical address, because that requires the identity mapping in
order to work.

-- 
FTTC broadband for 0.8mile line: 5.8Mbps down 500kbps up.  Estimation
in database were 13.1 to 19Mbit for a good line, about 7.5+ for a bad.
Estimate before purchase was "up to 13.2Mbit".

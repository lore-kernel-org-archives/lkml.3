Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753239AbaBCSOj (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 Feb 2014 13:14:39 -0500
Received: from mail-we0-f179.google.com ([74.125.82.179]:49114 "EHLO
	mail-we0-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752638AbaBCSOi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 Feb 2014 13:14:38 -0500
Date: Mon, 3 Feb 2014 18:15:44 +0000
From: Leif Lindholm <leif.lindholm@linaro.org>
To: Will Deacon <will.deacon@arm.com>
Cc: "msalter@redhat.com" <msalter@redhat.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "grant.likely@secretlab.ca" <grant.likely@secretlab.ca>,
        "linux-efi@vger.kernel.org" <linux-efi@vger.kernel.org>,
        "linux@arm.linux.org.uk" <linux@arm.linux.org.uk>,
        "patches@linaro.org" <patches@linaro.org>,
        "roy.franz@linaro.org" <roy.franz@linaro.org>,
        "matt.fleming@intel.com" <matt.fleming@intel.com>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>
Subject: Re: [PATCH v4 2/5] arm: add new asm macro update_sctlr
Message-ID: <20140203181544.GK11329@bivouac.eciton.net>
References: <1389445524-30623-3-git-send-email-leif.lindholm@linaro.org>
 <20140122112055.GF1621@mudshark.cambridge.arm.com>
 <20140129182805.GF11329@bivouac.eciton.net>
 <1391029124.2488.50.camel@deneb.redhat.com>
 <20140130131247.GG11329@bivouac.eciton.net>
 <20140203103415.GA12187@mudshark.cambridge.arm.com>
 <20140203155542.GI11329@bivouac.eciton.net>
 <20140203160051.GG14112@mudshark.cambridge.arm.com>
 <20140203164636.GJ11329@bivouac.eciton.net>
 <20140203165718.GO14112@mudshark.cambridge.arm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140203165718.GO14112@mudshark.cambridge.arm.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Feb 03, 2014 at 04:57:18PM +0000, Will Deacon wrote:
> > mov[tw]: why?
> > Then we end up battling different available immediate fields in A32/T32
> > instruction sets and v5/v6/v7 architecture versions.
> 
> I was making the assumption that UEFI was going to be v7 only... is this not
> true?

There is no such requirement in the specification.
It even mentions requirements for ARMv4 in one place :)

But I also don't understand why ldr= should be avoided.
This is not performance sensitive (called once on system boot), and
it's already executing with the caches off, so even if it ends up
being a literal load it does not pollute.

/
    Leif

Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751210AbaDOUzj (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Apr 2014 16:55:39 -0400
Received: from gw-1.arm.linux.org.uk ([78.32.30.217]:35651 "EHLO
	pandora.arm.linux.org.uk" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1750931AbaDOUzi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Apr 2014 16:55:38 -0400
Date: Tue, 15 Apr 2014 21:54:53 +0100
From: Russell King - ARM Linux <linux@arm.linux.org.uk>
To: Sebastian Capella <sebastian.capella@linaro.org>
Cc: One Thousand Gnomes <gnomes@lxorguk.ukuu.org.uk>,
        Pavel Machek <pavel@ucw.cz>,
        Linux Kernel <linux-kernel@vger.kernel.org>,
        "linux-pm@vger.kernel.org" <linux-pm@vger.kernel.org>,
        "linaro-kernel@lists.linaro.org" <linaro-kernel@lists.linaro.org>,
        Len Brown <len.brown@intel.com>,
        "Rafael J. Wysocki" <rjw@rjwysocki.net>,
        Ezequiel Garcia <ezequiel.garcia@free-electrons.com>
Subject: Re: [PATCH RFC] PM / Hibernate: no kernel_power_off when
	pm_power_off NULL
Message-ID: <20140415205453.GX24070@n2100.arm.linux.org.uk>
References: <1395348795-8554-1-git-send-email-sebastian.capella@linaro.org> <1395348795-8554-2-git-send-email-sebastian.capella@linaro.org> <20140320212336.GA17368@amd.pavel.ucw.cz> <20140320213502.795a5d3c@alan.etchedpixels.co.uk> <CADHgK6uXg0CXZC5s5Z5Kpy6dYH58UChL-p9ozCCcoUU=-0KJYw@mail.gmail.com> <CADHgK6sh6TUc4jBQFQHTQuhze9=r2FBzF6aULUc_c+bbWYjp5w@mail.gmail.com> <CADHgK6sCmPVZ--eyEnqnjfs_4C_PfHTgAUQ_Nb4oJP0mBDnQUw@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CADHgK6sCmPVZ--eyEnqnjfs_4C_PfHTgAUQ_Nb4oJP0mBDnQUw@mail.gmail.com>
User-Agent: Mutt/1.5.19 (2009-01-05)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Apr 15, 2014 at 11:34:52AM -0700, Sebastian Capella wrote:
> Ping..
> 
> There appears to be disagreement on the correct path to take on this.
> 
> Pavel and Alan recommend that arm's machine_power_off shall never return
> 
> Russell suggests hibernation be modified to handle machine_power_off
> returning; that x86 architecture (and others as well) can have
> machine_power_off returning.
> 
> Discussions available at the links below:
> https://lkml.org/lkml/2014/3/25/554  -- linux-arm discussion
> https://lkml.org/lkml/2014/3/20/649  -- linux-pm discussion
> 
> Should I continue with the original hibernation patch from the
> linux-pm discussion?
> 
> Does anyone have any response to Russel's commentsl?

What I'm basically saying is that I see no reason for ARM to do something
different to what x86 does.

What is pretty clear to me is that ARM is compatible with x86, which is
compatible with kernel/reboot.c, and it's the hibernate code which is
the odd one out.

-- 
FTTC broadband for 0.8mile line: now at 9.7Mbps down 460kbps up... slowly
improving, and getting towards what was expected from it.

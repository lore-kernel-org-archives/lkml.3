Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752805AbaBTKhk (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Feb 2014 05:37:40 -0500
Received: from service87.mimecast.com ([91.220.42.44]:34359 "EHLO
	service87.mimecast.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751830AbaBTKhi convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Feb 2014 05:37:38 -0500
Date: Thu, 20 Feb 2014 10:37:31 +0000
From: Lorenzo Pieralisi <lorenzo.pieralisi@arm.com>
To: Russ Dill <Russ.Dill@ti.com>
Cc: Sebastian Capella <sebastian.capella@linaro.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-pm@vger.kernel.org" <linux-pm@vger.kernel.org>,
        "linaro-kernel@lists.linaro.org" <linaro-kernel@lists.linaro.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "Rafael J. Wysocki" <rjw@rjwysocki.net>,
        Russell King <linux@arm.linux.org.uk>, Len Brown <len.brown@intel.com>,
        Pavel Machek <pavel@ucw.cz>, Nicolas Pitre <nico@linaro.org>,
        Santosh Shilimkar <santosh.shilimkar@ti.com>,
        Will Deacon <Will.Deacon@arm.com>,
        Jonathan Austin <Jonathan.Austin@arm.com>,
        Catalin Marinas <Catalin.Marinas@arm.com>,
        Uwe Kleine-K?nig <u.kleine-koenig@pengutronix.de>,
        Stephen Boyd <sboyd@codeaurora.org>
Subject: Re: [PATCH RFC v1 3/3] ARM hibernation / suspend-to-disk
Message-ID: <20140220103731.GB15994@e102568-lin.cambridge.arm.com>
References: <1392774729-3235-1-git-send-email-sebastian.capella@linaro.org>
 <1392774729-3235-4-git-send-email-sebastian.capella@linaro.org>
 <20140219161254.GB19343@e102568-lin.cambridge.arm.com>
 <530501A7.2030703@ti.com>
MIME-Version: 1.0
In-Reply-To: <530501A7.2030703@ti.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-OriginalArrivalTime: 20 Feb 2014 10:37:35.0957 (UTC) FILETIME=[C4EE0850:01CF2E27]
X-MC-Unique: 114022010373503601
Content-Type: text/plain; charset=WINDOWS-1252
Content-Transfer-Encoding: 8BIT
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Feb 19, 2014 at 07:10:31PM +0000, Russ Dill wrote:
> -----BEGIN PGP SIGNED MESSAGE-----
> Hash: SHA1
> 
> On 02/19/2014 08:12 AM, Lorenzo Pieralisi wrote:
> 
> + *  https://patchwork.kernel.org/patch/96442/
> 

I am guessing the snippets of code your comments refer to.

> I think the idea here is to get the CPU into a state so that later
> when we resume from the resume kernel, the actual CPU state matches
> the state we have in kernel. The main thing flush_thread does is clear
> out any and all FP state.

Which has already been saved through syscore_suspend()....

> The may be part of the patchset that is OBE.

It has to be updated then.

> cpu_resume makes many assumptions about the state of the state of the
> CPU, the primary being that the MMU is disabled, but also that all
> caches and IRQs are disabled. soft_restart does all this for us.
> 
> 
> 
> ah, you are saying just return from __swsusp_arch_save_image and allow
> cpu_suspend_abort to be called, placing the result of swsusp_save
> somewhere else. This may work and would reduce the complexity of the
> code slightly.

Yes. Basically you are doing a soft reboot just to return 0.

> This is taken from the previous iteration of the patchset, I think the
> comment is OBE.

Updated it please then.

> But this is still required to select the right mapping for our copying.

/me confused. Please describe what switching to idmap is meant to
achieve. In the patch above the copied swapper pgdir is not even used, I
would like to understand why this is done.

> I don't remember why I needed to prevent gcc from manipulating the
> stack here.

That's not a good reason to mark a function with attr __naked. If it is
needed we leave it there, if it is not it has to go.

> This is another holdover from previous patch versions that may be OBE.

See above.

Lorenzo


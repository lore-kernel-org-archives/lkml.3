Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753910AbaBZTDm (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 Feb 2014 14:03:42 -0500
Received: from service87.mimecast.com ([91.220.42.44]:54928 "EHLO
	service87.mimecast.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751853AbaBZTDk convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 Feb 2014 14:03:40 -0500
Date: Wed, 26 Feb 2014 19:03:33 +0000
From: Lorenzo Pieralisi <lorenzo.pieralisi@arm.com>
To: Sebastian Capella <sebastian.capella@linaro.org>
Cc: Russell King - ARM Linux <linux@arm.linux.org.uk>,
        Len Brown <len.brown@intel.com>,
        "linaro-kernel@lists.linaro.org" <linaro-kernel@lists.linaro.org>,
        Catalin Marinas <Catalin.Marinas@arm.com>,
        Jonathan Austin <Jonathan.Austin@arm.com>,
        "linux-pm@vger.kernel.org" <linux-pm@vger.kernel.org>,
        Will Deacon <Will.Deacon@arm.com>, Nicolas Pitre <nico@linaro.org>,
        "Rafael J. Wysocki" <rjw@rjwysocki.net>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Uwe Kleine-K?nig <u.kleine-koenig@pengutronix.de>,
        Russ Dill <Russ.Dill@ti.com>, Pavel Machek <pavel@ucw.cz>,
        Cyril Chemparathy <cyril@ti.com>,
        Santosh Shilimkar <santosh.shilimkar@ti.com>,
        Stephen Boyd <sboyd@codeaurora.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>
Subject: Re: [PATCH RFC v1 3/3] ARM hibernation / suspend-to-disk
Message-ID: <20140226190333.GD22839@e102568-lin.cambridge.arm.com>
References: <1392774729-3235-1-git-send-email-sebastian.capella@linaro.org>
 <1392774729-3235-4-git-send-email-sebastian.capella@linaro.org>
 <20140219161254.GB19343@e102568-lin.cambridge.arm.com>
 <20140222103840.GH21483@n2100.arm.linux.org.uk>
 <20140222120910.GA9012@e102568-lin.cambridge.arm.com>
 <20140223200208.12998.47604@capellas-linux>
 <20140225113251.GB6855@e102568-lin.cambridge.arm.com>
 <20140225175531.18229.77850@capellas-linux>
 <20140226102427.GA22839@e102568-lin.cambridge.arm.com>
 <20140226175055.3502.49656@capellas-linux>
MIME-Version: 1.0
In-Reply-To: <20140226175055.3502.49656@capellas-linux>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-OriginalArrivalTime: 26 Feb 2014 19:03:40.0525 (UTC) FILETIME=[7619E9D0:01CF3325]
X-MC-Unique: 114022619033702001
Content-Type: text/plain; charset=WINDOWS-1252
Content-Transfer-Encoding: 8BIT
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Feb 26, 2014 at 05:50:55PM +0000, Sebastian Capella wrote:
> Quoting Lorenzo Pieralisi (2014-02-26 02:24:27)
> > On Tue, Feb 25, 2014 at 05:55:31PM +0000, Sebastian Capella wrote:
> > 
> > Please add:
> > 
> > "swsusp_save() is executed in the suspend finisher so that the CPU context
> > pointer and memory are part of the saved image, which is required by the
> > resume kernel image to restart execution from swsusp_arch_suspend()"
> > 
> > >  * soft_restart is not technically needed, but is used
> > >  * to get success returned from cpu_suspend.
> > >  * After resume, the hibernation snapshot is written out.
> > 
> > "When soft reboot completes, the hibernation snapshot is written out."
> > 
> > Resume is confusing since this code is resuming twice :D on image saving
> > and on kernel image restoration.
> 
> Thanks Lorenzo!
> 
> Here's what I've got.
> 
> /*
>  * Snapshot kernel memory and reset the system.
>  *
>  * swsusp_save() is executed in the suspend finisher so that the CPU
>  * context pointer and memory are part of the saved image, which is
>  * required by the resume kernel image to restart execution from
>  * swsusp_arch_suspend().
>  *
>  * soft_restart is not technically needed, but is used to get success
>  * returned from cpu_suspend.
>  * 
>  * When soft reboot completes, the hibernation snapshot is
>  * written out.
>  */
> 
> Does this look ok?  I'll prepare a v4 patchset.

Yes it does, I will wait and review v4 then.

Thank you,
Lorenzo


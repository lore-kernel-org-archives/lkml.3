Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751690Ab3FWL1L (ORCPT <rfc822;w@1wt.eu>);
	Sun, 23 Jun 2013 07:27:11 -0400
Received: from hydra.sisk.pl ([212.160.235.94]:47909 "EHLO hydra.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750953Ab3FWL1F (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 23 Jun 2013 07:27:05 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Shuah Khan <shuah.kh@samsung.com>
Cc: "pavel@ucw.cz" <pavel@ucw.cz>, "len.brown@intel.com" <len.brown@intel.com>,
        "gregkh@linuxfoundation.org" <gregkh@linuxfoundation.org>,
        "joe@perches.com" <joe@perches.com>,
        "linux-pm@vger.kernel.org" <linux-pm@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "shuahkhan@gmail.com" <shuahkhan@gmail.com>
Subject: Re: [PATCHv v3] power: Include additional information in pm_print_times
Date: Sun, 23 Jun 2013 13:36:29 +0200
Message-ID: <3043483.hQyzHovghE@vostro.rjw.lan>
User-Agent: KMail/4.9.5 (Linux/3.10.0-rc5+; KDE/4.9.5; x86_64; ; )
In-Reply-To: <B8EFE96D1287C24090BAD9D858E15E6172EFEE@sisaex02sj>
References: <1371497795-20084-1-git-send-email-shuah.kh@samsung.com> <2534796.mOHH0DCD2A@vostro.rjw.lan> <B8EFE96D1287C24090BAD9D858E15E6172EFEE@sisaex02sj>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="utf-8"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Saturday, June 22, 2013 12:58:28 AM Shuah Khan wrote:
> On 06/21/2013 06:15 PM, Rafael J. Wysocki wrote:
> > On Monday, June 17, 2013 01:36:35 PM Shuah Khan wrote:
> >> Change __device_suspend() path to include driver name and the ops that
> >> get run for a device. This additional information helps associate the
> >> driver and the type of pm_ops the device uses in the suspend path very
> >> quickly, which will aid in debugging problems in suspend and resume paths.
> >> Changed both start and end debug messages to include pm_ops information
> >> and use dev_info() instead of pr_info(). Changed the end message to include
> >> parent device information and have the same format as the start message.
> >>
> >> dmesg output before the change:
> >>
> >> [  164.390032] calling  1-1+ @ 69, parent: usb1
> >> [  164.390035] call 1-1+ returned 0 after 0 usecs
> >>
> >> [  164.390352] calling  00:0a+ @ 2457, parent: pnp0
> >> [  164.390357] call 00:0a+ returned 0 after 3 usecs
> >>
> >> [  164.390361] calling  00:09+ @ 2457, parent: pnp0
> >> [  164.496458] call 00:09+ returned 0 after 103500 usecs
> >>
> >> [  164.496494] calling  00:05+ @ 2457, parent: pnp0
> >> [  164.496511] call 00:05+ returned 0 after 14 usecs
> >>
> >> dmesg output after the change:
> >>
> >> [  545.985394] usb 1-1: Start: type pm ops @ 68, parent: usb1
> >> [  545.987650] usb 1-1: End  : type pm ops @ 68, parent: usb1 time(2184 usecs) err(0)
> >>
> >> [  545.982544] system 00:0a: Start: legacy bus pm ops @ 2391, parent: pnp0
> >> [  545.982554] system 00:0a: End  : legacy bus pm ops @ 2391, parent: pnp0 time(4 usecs) err(0)
> >>
> >> [  545.982569] tpm_tis 00:09: Start: legacy bus pm ops @ 2391, parent: pnp0
> >> [  546.087017] tpm_tis 00:09: End  : legacy bus pm ops @ 2391, parent: pnp0 time(101936 usecs) err(0)
> >>
> >> [  546.087069] rtc_cmos 00:05: Start: legacy bus pm ops @ 2391, parent: pnp0
> >> [  546.087084] rtc_cmos 00:05: End  : legacy bus pm ops @ 2391, parent: pnp0 time(11 usecs) err(0)
> >>
> >
> > I was about to apply your patch, but then I noticed something that might cause
> > problems to happen.
> >
> > Namely, there are tools that use these messages to create suspend/resume time
> > charts and they will stop working after the proposed changes.
> >
> > Please keep the existing formatting the way it is and only append the additional
> > information at the end of each line.
> >
> > Thanks,
> > Rafael
> >
> 
> Hi Rafael,

Hi,

> Yes changing the format would cause problems for scripts that rely on 
> the exact format. Would you like to pick the v2 version of the patch 
> that appends the additional information at the end, instead of changing 
> the format? Here is the link. If you would like me to resend it, I can 
> do that.
> 
> https://lkml.org/lkml/2013/6/14/448

Well, this one replaces pr_info() with dev_info() and the format changes
as a result.  Please keep the existing format as is literally and append any
new information to the end of the line.

Thanks,
Rafael


-- 
I speak only for myself.
Rafael J. Wysocki, Intel Open Source Technology Center.

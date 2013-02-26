Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932620Ab3BZQuK (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Feb 2013 11:50:10 -0500
Received: from magic.merlins.org ([209.81.13.136]:48353 "EHLO
	mail1.merlins.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759552Ab3BZQuI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Feb 2013 11:50:08 -0500
Date: Tue, 26 Feb 2013 08:50:04 -0800
From: Marc MERLIN <marc@merlins.org>
To: Mathieu Desnoyers <mathieu.desnoyers@efficios.com>,
        Jeff Garzik <jgarzik@pobox.com>
Cc: Linux Kernel mailing List <linux-kernel@vger.kernel.org>,
        linux-ide@vger.kernel.org, desnoyers@efficios.com
Subject: Re: Reproduceable SATA lockup on 3.7.8 with SSD
Message-ID: <20130226165004.GD22367@merlins.org>
References: <20130226002731.GC25875@merlins.org> <512CD4F7.806@pobox.com> <20130226002731.GC25875@merlins.org> <20130226010232.GA18133@Krystal>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <512CD4F7.806@pobox.com> <20130226010232.GA18133@Krystal>
X-Sysadmin: BOFH
X-URL: http://marc.merlins.org/
X-Operating-System: Proudly running Linux 3.1.5-core2-volpreempt-noide-hm64-20111218/Debian squeeze/sid
X-Mailer: Some Outlooks can't quote properly without this header
User-Agent: Mutt/1.5.13 (2006-08-11)
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: marc@merlins.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Feb 26, 2013 at 10:29:59AM -0500, Jeff Garzik wrote:
> On 02/25/2013 07:27 PM, Marc MERLIN wrote:
> >Howdy,
> >
> >I seem to have the same problem (or similar) as Mathieu Desnoyers in
> >https://lkml.org/lkml/2013/2/22/437
> >
> >I can reliably get my SSD to drop from the SATA bus given the right 
> >workload
> >on linux.
> >
> >How can I tell if it's linux's fault of the drive's fault?
> 
> Manually force speed to 3.0 Gbps, then 1.5 Gbps, and see what happens.
> 
> Try module/kernel parameter libata.force=1.5Gbps or libata.force=3.0Gbps

Ok, so by reading my log at time of failure, you saw that speed was
flipping between the two? (I couldn't see that, but I'm not good at reading
it).

Also, just to make sure, you're not saying that you want me to change the
speed at runtime, but 
1) boot once with speed forced at 3Gbps and try and reproduce
2) boot a 2nd time with speed forced at 1.5Gbps and try and reproduce

If libata is not a module in my kernel, I can still put 
libata.force=1.5Gbps 
on the lilo/grub command line, correct?

Thanks,
Marc

On Mon, Feb 25, 2013 at 08:02:32PM -0500, Mathieu Desnoyers wrote:
> - try diagnostic tools from your drive vendor, if it reports your drive
>   as bad, then it might just be your drive failing,

Good point, drive is brand new (just replaced).

> - try to run a SMART test from smartmontools,

Unfortunately, OCZ does not support SMART.

> - try to reproduce your issue with a simple test-case (trying my test
>   program might help) that clearly fails quickly, and all the time, on
>   your problematic hardware,

My test fails 100% on my hardware too. Very easy to reproduce.
I think it's basically a big amount of read/writes that cause it.

> - find out if there are known firmware upgrades for your drive provided
>   by your vendor, try them out,

Did that, I have the latest.

> - find out if there are known BIOS upgrades for your machine provided by
>   your vendor, try them out,
> - try test-case on various kernel versions,
> - try test-case on various distributions (just in case),
> - try test-case with power management disabled in your machine's BIOS,
> - try test-case with other SSD drives of the exact same model as
>   yours, so you can see if it's just you own drive failing,
> - try moving your drive to a different machine (same model, different
>   model), and see if the test-case still fails,
> - try with other SSD drives (from other vendors) on your machine,
> - check if you partition mount options enable TRIM or not, try to
>   disable TRIM explicitly (see mount(8), discard/nodiscard option),
> - try using a different filesystem (just in case),
> - try using a different block I/O scheduler,
> - try using your drive vendor's SSD eraser, to reinitialize your entire
>   disk (yes, you will lose you entire data). This might be useful if
>   TRIM handling has changed after a firmware upgrade for instance.
 
Those will take a while :) especially without spare hardware.

I'll try older kernels first when I have a chance though.

Thanks for your reply.
Marc
-- 
"A mouse is a device used to point at the xterm you want to type in" - A.S.R.
Microsoft is to operating systems ....
                                      .... what McDonalds is to gourmet cooking
Home page: http://marc.merlins.org/  

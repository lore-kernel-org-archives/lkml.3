Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757568Ab3EBLaU (ORCPT <rfc822;w@1wt.eu>);
	Thu, 2 May 2013 07:30:20 -0400
Received: from ud10.udmedia.de ([194.117.254.50]:51288 "EHLO
	mail.ud10.udmedia.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754699Ab3EBLaS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 2 May 2013 07:30:18 -0400
Date: Thu, 2 May 2013 13:30:11 +0200
From: Markus Trippelsdorf <markus@trippelsdorf.de>
To: Thomas Gleixner <tglx@linutronix.de>
Cc: linux-kernel@vger.kernel.org
Subject: Re: WARNING: at kernel/cpu/idle.c:96
Message-ID: <20130502113011.GA508@x4>
References: <20130430155203.GA512@x4>
 <alpine.LFD.2.02.1305021242180.3972@ionos>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.LFD.2.02.1305021242180.3972@ionos>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 2013.05.02 at 12:43 +0200, Thomas Gleixner wrote:
> On Tue, 30 Apr 2013, Markus Trippelsdorf wrote:
> 
> > Just booted todays git tree and got the following warning:
> > 
> > ------------[ cut here ]------------
> > WARNING: at kernel/cpu/idle.c:96 cpu_startup_entry+0x14d/0x160()
> > Hardware name: System Product Name
> > Pid: 0, comm: swapper/2 Not tainted 3.9.0-03462-gab86e97-dirty #424
> > Call Trace:
> > smpboot: Booting Node   0, Processors  #1 #2
> >  [<ffffffff8105b7c0>] ? warn_slowpath_common+0x60/0xa0
> >  [<ffffffff8108c26d>] ? cpu_startup_entry+0x14d/0x160
> > ---[ end trace 40a24a5550891913 ]---
> 
> Fix below.

Unfortunately the fix doesn't work:

------------[ cut here ]------------
WARNING: at kernel/cpu/idle.c:96 cpu_startup_entry+0x14d/0x160()
CPU: 2 PID: 0 Comm: swapper/2 Not tainted 3.9.0-07391-g20b4fb4-dirty #432
Hardware name: System manufacturer System Product Name/M4A78T-E, BIOS 3503    04/13/2011
 ffffffff81528e8b ffffffff8105b791 ffff8802168b1fd8 ffff8802168b1fd8
 ffff8802168b1fd8 ffff8802168b1fd8 ffff8802168b1fd8 ffffffff8108cc8d
 0000000010001b76 0000000000000000 0000000000000000 0000000000000000
Call Trace:
 [<ffffffff81528e8b>] ? dump_stack+0xc/0x15
 [<ffffffff8105b791>] ? warn_slowpath_common+0x51/0x80
 [<ffffffff8108cc8d>] ? cpu_startup_entry+0x14d/0x160
---[ end trace 35da8e4b222a0736 ]---

BTW another issue is that "perf top" shows the following on an otherwise idle
machine:

 67.76%  [kernel]                    [k] cpu_startup_entry
 12.90%  [kernel]                    [k] amd_e400_idle

-- 
Markus

Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759437Ab3EBOG7 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 2 May 2013 10:06:59 -0400
Received: from ud10.udmedia.de ([194.117.254.50]:44733 "EHLO
	mail.ud10.udmedia.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758558Ab3EBOG6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 2 May 2013 10:06:58 -0400
Date: Thu, 2 May 2013 16:06:54 +0200
From: Markus Trippelsdorf <markus@trippelsdorf.de>
To: Thomas Gleixner <tglx@linutronix.de>
Cc: linux-kernel@vger.kernel.org
Subject: Re: WARNING: at kernel/cpu/idle.c:96
Message-ID: <20130502140654.GA509@x4>
References: <20130430155203.GA512@x4>
 <alpine.LFD.2.02.1305021242180.3972@ionos>
 <20130502113011.GA508@x4>
 <alpine.LFD.2.02.1305021557030.3972@ionos>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.LFD.2.02.1305021557030.3972@ionos>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 2013.05.02 at 15:58 +0200, Thomas Gleixner wrote:
> On Thu, 2 May 2013, Markus Trippelsdorf wrote:
> > On 2013.05.02 at 12:43 +0200, Thomas Gleixner wrote:
> > > On Tue, 30 Apr 2013, Markus Trippelsdorf wrote:
> > > 
> > > > Just booted todays git tree and got the following warning:
> > > > 
> > > > ------------[ cut here ]------------
> > > > WARNING: at kernel/cpu/idle.c:96 cpu_startup_entry+0x14d/0x160()
> > > > Hardware name: System Product Name
> > > > Pid: 0, comm: swapper/2 Not tainted 3.9.0-03462-gab86e97-dirty #424
> > > > Call Trace:
> > > > smpboot: Booting Node   0, Processors  #1 #2
> > > >  [<ffffffff8105b7c0>] ? warn_slowpath_common+0x60/0xa0
> > > >  [<ffffffff8108c26d>] ? cpu_startup_entry+0x14d/0x160
> > > > ---[ end trace 40a24a5550891913 ]---
> > > 
> > > Fix below.
> > 
> > Unfortunately the fix doesn't work:
> 
> Moo. I missed amd_e400_idle() returning early w/o enabling interrupts.

This fixes the issue. Thanks.

-- 
Markus

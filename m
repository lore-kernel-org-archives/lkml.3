Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752037Ab3EJLwN (ORCPT <rfc822;w@1wt.eu>);
	Fri, 10 May 2013 07:52:13 -0400
Received: from mail-ee0-f50.google.com ([74.125.83.50]:58116 "EHLO
	mail-ee0-f50.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751511Ab3EJLwL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 10 May 2013 07:52:11 -0400
Date: Fri, 10 May 2013 13:52:07 +0200
From: Ingo Molnar <mingo@kernel.org>
To: Jiri Kosina <jkosina@suse.cz>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
        linux-kernel@vger.kernel.org
Subject: Re: [GIT] HID
Message-ID: <20130510115207.GA20038@gmail.com>
References: <alpine.LNX.2.00.1304301023040.20139@pobox.suse.cz>
 <20130510114759.GA19857@gmail.com>
 <alpine.LNX.2.00.1305101349000.23038@pobox.suse.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.LNX.2.00.1305101349000.23038@pobox.suse.cz>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Jiri Kosina <jkosina@suse.cz> wrote:

> On Fri, 10 May 2013, Ingo Molnar wrote:
> 
> > hi Jiri,
> > 
> > * Jiri Kosina <jkosina@suse.cz> wrote:
> > 
> > > Linus,
> > > 
> > > please pull from
> > > 
> > >   git://git.kernel.org/pub/scm/linux/kernel/git/jikos/hid.git for-linus
> > > 
> > > to receive HID subsystem updates for 3.10. Highlights:
> > > 
> > > 
> > > - hid driver transport cleanup, finalizing the long-desired decoupling of 
> > >   core from transport layers, by Benjamin Tissoires and Henrik Rydberg
> > > - support for hybrid finger/pen multitouch HID devices, by Benjamin 
> > >   Tissoires
> > > - fix for long-standing issue in Logitech unifying driver sometimes not
> > >   inializing properly due to device specifics, by Andrew de los Reyes
> > > - Wii remote driver updates to support 2nd generation of devices, by David 
> > >   Herrmann
> > > - support for Apple IR remote
> > > - roccat driver now supports new devices (Roccat Kone Pure, IskuFX), by 
> > >   Stefan Achatz
> > > - debugfs locking fixes in hid debug interface, by Jiri Kosina
> > 
> > FYI, there's a new HID related lockdep and RCU splat upstream, probably 
> > relatd to the debugfs locking fixes:
> > 
> > [   79.088631] ======================================================
> > [   79.088631] [ INFO: HARDIRQ-safe -> HARDIRQ-unsafe lock order detected ]
> > [   79.088631] 3.9.0-13694-g7cf229a-dirty #224212 Tainted: G        W   
> > [   79.088631] ------------------------------------------------------
> > [   79.088631] swapper/0/1 [HC0[0]:SC0[0]:HE0:SE1] is trying to acquire:
> > [   79.088631]  (&hdev->debug_list_lock){+.+...}, at: [<ffffffff82e510d9>] hid_debug_event+0x2e/0xd0
> > [   79.088631] 
> > 
> > See the full bootlog below. It's from an allyesconfig x86-64 bootup log.
> 
> Hi Ingo,
> 
> thanks for the report. I have a fix for this in my tree already and am 
> going to send pull request to Linus shortly.

Great, thanks!

	Ingo

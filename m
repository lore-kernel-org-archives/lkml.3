Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758093Ab3CNPSZ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 Mar 2013 11:18:25 -0400
Received: from iolanthe.rowland.org ([192.131.102.54]:52486 "HELO
	iolanthe.rowland.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1758072Ab3CNPSW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 Mar 2013 11:18:22 -0400
Date: Thu, 14 Mar 2013 11:18:21 -0400 (EDT)
From: Alan Stern <stern@rowland.harvard.edu>
X-X-Sender: stern@iolanthe.rowland.org
To: Jiri Kosina <jkosina@suse.cz>
cc: Peter Hurley <peter@hurleysoftware.com>, Thomas Meyer <thomas@m3y3r.de>,
        Shawn Starr <shawn.starr@rogers.com>,
        Kernel development list <linux-kernel@vger.kernel.org>,
        USB list <linux-usb@vger.kernel.org>, <linux-acpi@vger.kernel.org>,
        "Rafael J. Wysocki" <rjw@sisk.pl>, Bjorn Helgaas <bhelgaas@google.com>,
        <linux-pci@vger.kernel.org>
Subject: Re: [3.9-rc1] irq 16: nobody cared  (was [3.9-rc1] very poor interrupt
 responses)
In-Reply-To: <alpine.LNX.2.00.1303141555090.30118@pobox.suse.cz>
Message-ID: <Pine.LNX.4.44L0.1303141111350.1983-100000@iolanthe.rowland.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 14 Mar 2013, Jiri Kosina wrote:

> On Thu, 14 Mar 2013, Alan Stern wrote:
> 
> > > [    4.116847] irq 16: nobody cared (try booting with the "irqpoll" option)
> > > [    4.116849] Pid: 1, comm: systemd Not tainted 3.9.0-rc2-00188-g6c23cbb #186
> > > [    4.116850] Call Trace:
> > > [    4.116860]  <IRQ>  [<ffffffff810db0f8>] __report_bad_irq+0x38/0xf0
> > > [    4.116862]  [<ffffffff810db3a3>] note_interrupt+0x1f3/0x240
> > > [    4.116865]  [<ffffffff810d8977>] handle_irq_event_percpu+0x147/0x230
> > > [    4.116867]  [<ffffffff810d8aa9>] handle_irq_event+0x49/0x70
> > > [    4.116869]  [<ffffffff810dbbc1>] handle_fasteoi_irq+0x61/0x100
> > > [    4.116873]  [<ffffffff81004689>] handle_irq+0x59/0x150
> > > [    4.116877]  [<ffffffff8104e916>] ? irq_enter+0x16/0x80
> > > [    4.116879]  [<ffffffff81003d4b>] do_IRQ+0x5b/0xe0
> > > [    4.116883]  [<ffffffff815563ad>] common_interrupt+0x6d/0x6d
> > > [    4.116888]  <EOI>  [<ffffffff81320dc1>] ? cfb_imageblit+0x581/0x5b0
> > > [    4.116891]  [<ffffffff8131e019>] bit_putcs+0x329/0x560
> > > [    4.116893]  [<ffffffff8131dc8f>] ? bit_cursor+0x5cf/0x630
> > > [    4.116896]  [<ffffffff81317a28>] fbcon_putcs+0xf8/0x130
> > > [    4.116898]  [<ffffffff8131dcf0>] ? bit_cursor+0x630/0x630
> > > [    4.116900]  [<ffffffff8131a27e>] fbcon_redraw+0x16e/0x1e0
> > > [    4.116902]  [<ffffffff8131a554>] fbcon_scroll+0x264/0xe40
> > > [    4.116905]  [<ffffffff8138a263>] scrup+0x113/0x120
> > > [    4.116907]  [<ffffffff8138a4d0>] lf+0x80/0x90
> > > [    4.116910]  [<ffffffff8138e1dd>] do_con_trol+0xcd/0x1360
> > > [    4.116912]  [<ffffffff8138f725>] do_con_write+0x2b5/0xa10
> > > [    4.116915]  [<ffffffff81552bb7>] ? __mutex_lock_slowpath+0x237/0x2e0
> > > [    4.116917]  [<ffffffff8138fed9>] con_write+0x19/0x30
> > > [    4.116920]  [<ffffffff8137823b>] do_output_char+0x1eb/0x220
> > > [    4.116922]  [<ffffffff813782b6>] process_output+0x46/0x70
> > > [    4.116924]  [<ffffffff81378b0f>] n_tty_write+0x13f/0x2f0
> > > [    4.116928]  [<ffffffff8107a900>] ? try_to_wake_up+0x2b0/0x2b0
> > > [    4.116930]  [<ffffffff8137553c>] tty_write+0x1cc/0x280
> > > [    4.116932]  [<ffffffff813789d0>] ? n_tty_ioctl+0x110/0x110
> > > [    4.116934]  [<ffffffff8137569d>] redirected_tty_write+0xad/0xc0
> > > [    4.116937]  [<ffffffff811733ab>] vfs_write+0xcb/0x130
> > > [    4.116939]  [<ffffffff81173bac>] sys_write+0x5c/0xa0
> > > [    4.116943]  [<ffffffff8155e4a9>] system_call_fastpath+0x16/0x1b
> > > [    4.116943] handlers:
> > > [    4.116959] [<ffffffffa0048450>] usb_hcd_irq [usbcore]
> > > [    4.116960] Disabling IRQ #16
> > > 
> > > I don't think I have seen this message on rc1+ (8343bce, to be precise), 
> > > but I have definitely seen sluggish system response on that kernel as 
> > > well.
> > > 
> > > Attaching lspci, /proc/interrupts and dmesg. 
> > 
> > Can you try to do a git bisect for this?  Is the sluggish system 
> > response clear enough that you can tell reliably when it is present and 
> > when it isn't?
> 
> That was my first thought, but unfortunately I am afraid there will be 
> point at which I will easily make a bisection mistake, as the 
> responsiveness of the system varies over time, so it's not really a 
> 100% objective measure.

All right.

There have been only three significant changes to uhci-hcd since last 
summer, and two of them appear to be completely unrelated to this 
issue.  The three commits are

	3171fcabb169  USB: uhci: beautify source code
	13996ca7afd5  USB: uhci: check buffer length to avoid memory 
			overflow
	0f815a0a700b  USB: UHCI: fix IRQ race during initialization

Reverting the first two almost certainly will not have any effect, but
you may as well try it anyway.  The third commit may be relevant.

If you revert all three and still see the problem then it must be
caused by changes outside of the USB stack.  Differences in interrupt
routing could be a result of changes to PCI or ACPI.  Have you compared 
the current /proc/interrupts with versions from earlier kernels without 
this problem?

Is occurrence of the "nobody cared" connected with any particular
device?  Somebody reported a similar problem not long ago (although
IIRC it was for OHCI rather than UHCI) which appeared to be related to
activity on the built-in webcam.

Alan Stern


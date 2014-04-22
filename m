Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932269AbaDVLQd (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Apr 2014 07:16:33 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:44929 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932111AbaDVLQa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Apr 2014 07:16:30 -0400
Date: Tue, 22 Apr 2014 04:16:51 -0700
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: One Thousand Gnomes <gnomes@lxorguk.ukuu.org.uk>
Cc: Manfred Schlaegl <manfred.schlaegl@gmx.at>, Jiri Slaby <jslaby@suse.cz>,
        Peter Hurley <peter@hurleysoftware.com>, Alan Cox <alan@redhat.com>,
        linux-kernel@vger.kernel.org,
        Manfred Schlaegl <manfred.schlaegl@ginzinger.com>
Subject: Re: [PATCH] tty: Fix race condition between
 __tty_buffer_request_room and flush_to_ldisc
Message-ID: <20140422111651.GA26268@kroah.com>
References: <5343EE9C.9010004@gmx.at>
 <5350DDE9.1040102@gmx.at>
 <20140422115552.253b69c4@alan.etchedpixels.co.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140422115552.253b69c4@alan.etchedpixels.co.uk>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Apr 22, 2014 at 11:55:52AM +0100, One Thousand Gnomes wrote:
> On Fri, 18 Apr 2014 10:10:17 +0200
> Manfred Schlaegl <manfred.schlaegl@gmx.at> wrote:
> 
> > On 2014-04-08 14:42, Manfred Schlaegl wrote:
> > > The race was introduced while development of linux-3.11 by
> > > e8437d7ecbc50198705331449367d401ebb3181f and
> > > e9975fdec0138f1b2a85b9624e41660abd9865d4.
> > > Originally it was found and reproduced on linux-3.12.15 and
> > > linux-3.12.15-rt25, by sending 500 byte blocks with 115kbaud to the
> > > target uart in a loop with 100 milliseconds delay.
> > > 
> > > In short:
> > >  1. The consumer flush_to_ldisc is on to remove the head tty_buffer.
> > >  2. The producer adds a number of bytes, so that a new tty_buffer must
> > > 	be allocated and added by __tty_buffer_request_room.
> > >  3. The consumer removes the head tty_buffer element, without handling
> > > 	newly committed data.
> > 
> > Hi!
> > 
> > Reminder: The Problem is still existent in linux-3.11, 3.12, 3.13. 3.14 and pre 3.15 kernels.
> > 
> > The lastly delivered patch cleanly applies to pre 3.15 (torvalds tree) and 3.14(.1).
> 
> Greg ?? what is happening about this one. We can't just ignore losing
> bytes caused by incorrect lock removal. We are seeing breakages in things
> like bluetooth over serial which are quite probably down to this problem.

It's in my queue, sorry, been traveling...

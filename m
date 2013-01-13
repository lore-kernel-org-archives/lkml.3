Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755897Ab3AMTQN (ORCPT <rfc822;w@1wt.eu>);
	Sun, 13 Jan 2013 14:16:13 -0500
Received: from smtp-out002.kontent.com ([81.88.40.216]:33086 "EHLO
	smtp-out002.kontent.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755800Ab3AMTQL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 13 Jan 2013 14:16:11 -0500
From: Oliver Neukum <oliver@neukum.org>
To: Alex Riesen <raa.lkml@gmail.com>
Cc: Alan Stern <stern@rowland.harvard.edu>, Jens Axboe <axboe@kernel.dk>,
        linux-usb@vger.kernel.org,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: USB device cannot be reconnected and khubd "blocked for more than 120 seconds"
Date: Sun, 13 Jan 2013 20:16:11 +0100
Message-ID: <1406914.PAZOOLqX4X@linux-5eaq.site>
User-Agent: KMail/4.8.5 (Linux/3.4.11-2.16-desktop; KDE/4.8.5; x86_64; ; )
In-Reply-To: <CALxABCYtKJD4YrPxy6p+Frim8erccp3ine7SVEV9ReoaRh1BWQ@mail.gmail.com>
References: <CALxABCaE3=XpGmgNJs1pre11aJ8T0pntVzf_mA6_OYNzis9nvQ@mail.gmail.com> <Pine.LNX.4.44L0.1301131153520.17578-100000@netrider.rowland.org> <CALxABCYtKJD4YrPxy6p+Frim8erccp3ine7SVEV9ReoaRh1BWQ@mail.gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sunday 13 January 2013 18:42:49 Alex Riesen wrote:
> On Sun, Jan 13, 2013 at 5:56 PM, Alan Stern <stern@rowland.harvard.edu> wrote:
> > On Sun, 13 Jan 2013, Alex Riesen wrote:
> >>
> >> Yes, almost. What about khubd hanging when machine is shutdown?
> >
> > What about it?  I have trouble understanding all the descriptions you
> > have provided so far, because you talk about several different things
> > and change your mind a lot.  Can you provide a single, simple scenario
> > that illustrates this problem?
> 
> 1. Compile a kernel with deadline elevator as module
> 2. Boot into it, make sure the elevator is selected
>   (I used "elevator=deadline" in the kernel command line)
> 3. Insert a FAT formatted mass storage device in an USB2 port
>    Observe "io scheduler deadline registered"
> 4. Pull the stick out, wait a moment, and either shutdown or just
>    and press alt-sysrq-W:

That makes it clear. The elevator probably has scheduled work
which cannot finish waiting on a lock and scsi_remove_host()
wants to flush work.

This is not a USB problem. You need to involve the SCSI people.
khubd just stops working because disconnects are processed
in its context and the removal deadlocks.

	Regards
		Oliver



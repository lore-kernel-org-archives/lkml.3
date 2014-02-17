Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754293AbaBQUTM (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Feb 2014 15:19:12 -0500
Received: from hygieia.santi-shop.eu ([78.46.175.2]:38971 "EHLO
	hygieia.santi-shop.eu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751847AbaBQUTK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Feb 2014 15:19:10 -0500
X-Greylist: delayed 432 seconds by postgrey-1.27 at vger.kernel.org; Mon, 17 Feb 2014 15:19:10 EST
Date: Mon, 17 Feb 2014 21:11:51 +0100
From: Bruno =?UTF-8?B?UHLDqW1vbnQ=?= <bonbons@linux-vserver.org>
To: Daniel J Blueman <daniel@quora.org>
Cc: linux-input@vger.kernel.org, linux-usb@vger.kernel.org,
        Linux Kernel <linux-kernel@vger.kernel.org>,
        Dmitry Torokhov <dmitry.torokhov@gmail.com>
Subject: Re: USB keyboard occasional key stuck
Message-ID: <20140217211151.02f8afbe@neptune.home>
In-Reply-To: <CAMVG2ss9nA4zcOT3c47EwEMrR7Z_gAQU-HTYGjdWcdYzihSnbg@mail.gmail.com>
References: <CAMVG2ss9nA4zcOT3c47EwEMrR7Z_gAQU-HTYGjdWcdYzihSnbg@mail.gmail.com>
X-Mailer: Claws Mail 3.9.0 (GTK+ 2.24.22; i686-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 17 February 2014 Daniel J Blueman <daniel@quora.org> wrote:
> Across 5+ years of kernels, I've been seeing occasional (1-2 times per
> day) key-stuck issues where eg a fn+delete combo repeats delete until
> I press delete again. I've seen this happen with fn+ctrl+left, leaving
> left held and likewise with right.
> 
> This has occurred on Apple laptops, external USB keyboards and Dell
> laptops, so seems like a linux USB input issue, as I haven't seen
> occur on Windows or MacOS on the same hardware.
> 
> It seems a good move for me to rebuild and run a kernel with some USB
> HID instrumentation to locate this issue over time. Without apriori
> knowledge of the linux USB input stack, what is a good initial
> approach?

I've seen some similar behavior on servers connected to a KVM switch
(USB keyboard/mouse) where without apparent reason the ENTER key became
pressed and did continuously send repeat events.

Physically touching the KVM keyboard or unbinding&rebinding the HID
keyboard solved the issue (on a console that triggers a busy loop of
agettys on active vt).

I've been tempted to attribute it to the KVM switch doing something
when switching to another server via key-press (yes, some co-worker
as at the KVM terminal when the getty load started).

On the other hand, some other co-worker had "dead keyboard" issues
though only under X, things still worked at console level, for quite
some time now. Annoying but not regular enough to look further into it.


If you want to look at what happens for you, monitoring the USB activity
for your keyboard (in combination with output from event device) might
be the most useful way (it would also catch details on when the USB
side goes into power-saving, if at all).

Bruno

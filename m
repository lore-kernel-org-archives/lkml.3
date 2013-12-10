Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752220Ab3LJH3n (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Dec 2013 02:29:43 -0500
Received: from mail-la0-f50.google.com ([209.85.215.50]:46927 "EHLO
	mail-la0-f50.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751823Ab3LJH3k (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Dec 2013 02:29:40 -0500
Message-ID: <1386660574.7152.203.camel@host5.omatika.ru>
Subject: Re: [PATCH v2] fix printk output
From: Sergei Ianovich <ynvich@gmail.com>
To: Rusty Russell <rusty@rustcorp.com.au>
Cc: linux-kernel@vger.kernel.org,
        Hannes Frederic Sowa <hannes@stressinduktion.org>
Date: Tue, 10 Dec 2013 11:29:34 +0400
In-Reply-To: <87a9g9s27z.fsf@rustcorp.com.au>
References: <20131127220746.GA11255@order.stressinduktion.org>
	 <1385826152-17531-1-git-send-email-ynvich@gmail.com>
	 <87a9g9s27z.fsf@rustcorp.com.au>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.8.5-2+b1 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2013-12-10 at 15:59 +1030, Rusty Russell wrote:
> Sergei Ianovich <ynvich@gmail.com> writes:
> Hmm, the copy here is gratuitous.  Using current->comm is safe, just
> possibly ambigious if someone is changing the task name at the same time.
> 
> And we really want this one line anyway:
> 
>   		printk(KERN_WARNING
>  		       "%s: waiting module removal not supported: please upgrade\n",
>                         current->comm);

I would put tool's name in the end for clarity. Message comes from the
kernel and the kernel recommends to upgrade the tool. "%s: ..." could
make the impression that the tool recommends to upgrade the kernel.

> BTW, did you actually hit this?

# modprobe usb_storage
[  600.807274] usbcore: registered new interface driver usb-storage
# modprobe -r usb_storage
[  604.216318] waiting module removal not supported: please upgrade[
604.222164] usbcore: deregistering interface driver usb-storage
# modprobe -V
kmod version 9

I am using the latest kmod package from emdebian unstable-grip.


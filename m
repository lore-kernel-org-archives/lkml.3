Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752227Ab3KLEy2 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 Nov 2013 23:54:28 -0500
Received: from g1t0028.austin.hp.com ([15.216.28.35]:42382 "EHLO
	g1t0028.austin.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751222Ab3KLEyV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 Nov 2013 23:54:21 -0500
Message-ID: <1384232059.25633.10.camel@buesod1.americas.hpqcorp.net>
Subject: Re: Linux kernel API about sector count
From: Davidlohr Bueso <davidlohr@hp.com>
To: =?UTF-8?Q?=E9=9F=A9=E7=A3=8A?= <bonben1989@gmail.com>
Cc: Mihai =?UTF-8?Q?Don=C8=9Bu?= <mihai.dontu@gmail.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Date: Mon, 11 Nov 2013 20:54:19 -0800
In-Reply-To: <CAK2Ky6wGwLV1uT-tkjw0=xUutsNtGVZGjLwShaT3C9zgGHSxzw@mail.gmail.com>
References: <CAK2Ky6yh6U1wiAAPC9TgWduzO4NS9Km0FGgRvMntTm=qYkWt7A@mail.gmail.com>
	 <20131111150507.0bb1083e@mdontu-l>
	 <CAK2Ky6wxDJnz3t9zK_Mumad4bsQnM_kzKds1bvhwYKQ98v3adw@mail.gmail.com>
	 <CAK2Ky6wGwLV1uT-tkjw0=xUutsNtGVZGjLwShaT3C9zgGHSxzw@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.6.4 (3.6.4-3.fc18) 
Mime-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2013-11-12 at 10:52 +0800, 韩磊 wrote:
>  I need a API in linux kernel about the disk's total count of
> sector,not the sector size.
> thank you!

Have you even tried searching through the code? Take a look at how fdisk
or blockdev or any other tool that deals with devices get the total
sectors, ie:

blockdev --getsize /dev/sda1

Then follow the path for such ioctl in the in the kernel source.

> 
> 
> 2013/11/11 韩磊 <bonben1989@gmail.com>:
> > Thank you! I need disk's total count of sector,not the sector size.
> >
> > 2013/11/11 Mihai Donțu <mihai.dontu@gmail.com>:
> >> On Mon, 11 Nov 2013 20:31:14 +0800 韩磊 wrote:
> >>> Can you tell me the API about the count of sector in linux kernel?
> >>>
> >>> which .h file and function?
> >>>
> >>
> >> Looking at fdisk (util-linux) there are several ioctls:
> >>  * HDIO_GETGEO  (linux/hdreg.h)
> >>  * BLKGETSIZE64 (linux/fs.h), sector size is assumed 512
> >>
> >> The HDIO interface *seems* to be legacy:
> >> http://www.mjmwired.net/kernel/Documentation/ioctl/hdio.txt
> >>
> >> Also see:
> >> https://git.kernel.org/cgit/utils/util-linux/util-linux.git/tree/fdisks/fdisk.c
> >>
> >> I hope this helps a bit.
> >>
> >> --
> >> Mihai Donțu
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/



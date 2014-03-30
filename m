Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753145AbaC3Hwz (ORCPT <rfc822;w@1wt.eu>);
	Sun, 30 Mar 2014 03:52:55 -0400
Received: from mail-we0-f175.google.com ([74.125.82.175]:63077 "EHLO
	mail-we0-f175.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751429AbaC3Hwy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 30 Mar 2014 03:52:54 -0400
Message-ID: <5337CDA3.7000906@gmail.com>
Date: Sun, 30 Mar 2014 09:54:11 +0200
From: Francis Moreau <francis.moro@gmail.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.4.0
MIME-Version: 1.0
To: LKML <linux-kernel@vger.kernel.org>
Subject: Re: Can't umount /mnt/dev after calling dd(1) and with /mnt/dev is
 a bind mount
References: <532DBFC8.4020202@gmail.com>
In-Reply-To: <532DBFC8.4020202@gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

up

On 03/22/2014 05:52 PM, Francis Moreau wrote:
> Hello,
> 
> I'm posting here because it might be a behaviour related to the kernel
> internals that I can't explain from my user point of view :)
> 
> Basically I'm doing this:
> 
>   mount -o bind /dev/ /mnt/dev &&
>   chroot /mnt dd bs=440 conv=notrunc count=1 if=gptmbr.bin of=/dev/loop0
>   umount /mnt/dev
> 
> but umount gives the following error: "umount: /mnt/dev: target is busy"
> 
> I tried to see if any processes were still using a file in dev with
> fuser(1) but there weren't. Futhermore inserting a call to fuser(1)
> right before umount fixed the issue, so it really seems a timing issue.
> 
> stracing umount showed that umount failed here:
> umount("/mnt/dev", 0)                   = -1 EBUSY (Device or resource busy)
> 
> I replaced the bind mount of /dev by:
>     mount -t devtmpfs none /mnt/dev
> and it worked.
> 
> Could anybody tell me what I'm doing wrong ?
> 
> Thanks.
> 


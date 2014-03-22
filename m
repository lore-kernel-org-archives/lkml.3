Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751246AbaCVTYJ (ORCPT <rfc822;w@1wt.eu>);
	Sat, 22 Mar 2014 15:24:09 -0400
Received: from zeniv.linux.org.uk ([195.92.253.2]:53462 "EHLO
	ZenIV.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750831AbaCVTYG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 22 Mar 2014 15:24:06 -0400
Date: Sat, 22 Mar 2014 19:24:04 +0000
From: Al Viro <viro@ZenIV.linux.org.uk>
To: Francis Moreau <francis.moro@gmail.com>
Cc: LKML <linux-kernel@vger.kernel.org>
Subject: Re: Can't umount /mnt/dev after calling dd(1) and with /mnt/dev is a
 bind mount
Message-ID: <20140322192404.GG18016@ZenIV.linux.org.uk>
References: <532DBFC8.4020202@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <532DBFC8.4020202@gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Mar 22, 2014 at 05:52:24PM +0100, Francis Moreau wrote:
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

What do you have in /proc/self/mountinfo before all that?

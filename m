Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754291AbaIVSHl (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Sep 2014 14:07:41 -0400
Received: from mail-yh0-f42.google.com ([209.85.213.42]:55020 "EHLO
	mail-yh0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753524AbaIVSHj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Sep 2014 14:07:39 -0400
MIME-Version: 1.0
In-Reply-To: <CALyZvKz4gyH64an3NWz2zY4b0NN34LwSME-oD8-Vw+e1SCF0Nw@mail.gmail.com>
References: <CALyZvKz4gyH64an3NWz2zY4b0NN34LwSME-oD8-Vw+e1SCF0Nw@mail.gmail.com>
Date: Mon, 22 Sep 2014 19:07:39 +0100
Message-ID: <CALyZvKyHQVeEZ+r3qRLXx15AXnj0-8hqfD4FNxHmQrMtygmpJg@mail.gmail.com>
Subject: Re: mount BTRFS filesystems created with 3.8+ under 2.6.32 kernels ?
From: Jason Vas Dias <jason.vas.dias@gmail.com>
To: linux-kernel <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Of course the solution was to have created the filesystem in the first
place with
'mkfs.btrfs -O ^extref' . Found this after some more googling ...
Shouldn't this be the default ?
Regards,
Jason

On 9/22/14, Jason Vas Dias <jason.vas.dias@gmail.com> wrote:
> Good day -
>
> I wonder if there is a GIT repository somewhere with a backport of the
> BTRFS
> kernel modules  that will allow BTRFS filesystems created with a 3.8 kernel
> to
> be mounted on a 2.6.32+ kernel .
>
> When I try this, the 2.6.32 kernel crashes with the message :
>  'BTRFS: couldn't mount because of unsupported optional features (40)'
> ( kernel-2.6.32-431.29.2.el6.x86_64 from RHEL 6.4+ ).
>
> The same filesystem mounts fine under Oracle EL6 which now comes with
> kernel-uek 3.8+ .  Has anyone tried to backport the 3.8 BTRFS
> capabilities to 2.6.32 ,
> or is there any way I can remove "Option 40" to get it to mount
> without crashing ?
> It is a very small BTRFS filesystem with a root filesystem and a few
> snapshots.
> I did not specify any BTRFS options in :
>   $ mkfs.btrfs /dev/sda9;
>   ... # mount on /mnt/btr & create some files
>   $ btrfs subvolume snapshot -r /mnt/btr /mnt/btr/root-0
>   $ btrfs subvolume snapshot    /mnt/btr /mnt/btr/root-w-0
> Now I can mount /dev/sda9 under any 3.8+ kernel, but not under 2.6.32 .
>
> Thanks in advance for any replies,
> Best Regards, Jason Vas Dias
>

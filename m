Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758820AbaGXMM7 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Jul 2014 08:12:59 -0400
Received: from mail-ie0-f173.google.com ([209.85.223.173]:44804 "EHLO
	mail-ie0-f173.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758630AbaGXMM5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Jul 2014 08:12:57 -0400
Message-ID: <53D0F89B.4090907@gmail.com>
Date: Thu, 24 Jul 2014 08:14:19 -0400
From: Woody Suwalski <terraluna977@gmail.com>
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:29.0) Gecko/20100101 Firefox/29.0 SeaMonkey/2.26.1
MIME-Version: 1.0
To: "Klaus A. Kreil" <klaus.kreil@univie.ac.at>, linux-kernel@vger.kernel.org
Subject: Re: unable to mount using overlayfs.v22 on kernel 3.15.5
References: <53CEDA35.40301@univie.ac.at>
In-Reply-To: <53CEDA35.40301@univie.ac.at>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Klaus A. Kreil wrote:
> Hello list,
> I have just found out about this mailing list which obviously also 
> takes care of overlayfs.
>
> I have been a happy user of overlayfs for quiet some time using it to 
> propagate a shared r/o LVM ext4 lowerdir rootfs with a small r/w ext4 
> upperdir for a number of XEN domU guests. I started with overlayfs on 
> kernel version 3.11.7 (all on gentoo-hardened). Recently I have 
> switched from 3.13.10 (using overlayfs.v21) to 3.15.5 with overlayfs.v22.
>
> overlayfs.v22 seems to have changed insofar as there's a new parameter 
> workdir=/dir with dir required to be an empty directory on the same 
> filesystem as upperdir. So I have changed my initramfs to include that 
> parameter and have also created my /dir directory (named /.work, owned 
> by root:root and 0755 mode) on all my individual upperdir filesystems 
> for all of my XEN domUs.
>
> Now when I start the new kernel 3.15.5 with the modified init script 
> from the newly created initramfs, I am ending up in a rescue shell. 
> Both the upper and lower filesystem are (as expected) mounted 
> appropriately to /mnt/root_ro and /mnt/root_rw amd /mnt/root exists. 
> Howeverm, trying to combine those two filesystems on /mnt/root (as 
> before and regardless of whether used with or without the workdir= 
> parameter) fails with an error message as follows:
>
> # mount -t overlayfs overlayfs -o 
> lowerdir=/mnt/root_ro,upperdir=/mnt/root_rw,workdir=/.work /mnt/root
> mount: mounting overlayfs on /mnt/root failed: Invalid argument
>
> The error message stays the same regardless of where on the command 
> line the overlayfs "device" parameter appears. I can't see what's 
> wrong with the command line given that - with the exception of the 
> workdir=/.work part - the command has not changed from 3.13.10 
> (overlayfs.v21), therefore currently leaving me at loss.
>
> I would very much appreciate any help and support in tracking down 
> this unexpected issue.
>
> Regards Atom2
Klaus, I have run into similar problems...
What works for me:
Once you mount the upperdir /mnt/root_rw, create /mnt/root_rw/root and 
/mnt/root_rw/workdir and use these for overlayfs mountpoints.

Woody

Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754040Ab3IXTCK (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Sep 2013 15:02:10 -0400
Received: from mx1.redhat.com ([209.132.183.28]:30345 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752221Ab3IXTCJ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Sep 2013 15:02:09 -0400
Date: Wed, 25 Sep 2013 00:31:51 +0530 (IST)
From: P J P <ppandit@redhat.com>
X-X-Sender: pjp@dhcp193-39.pnq.redhat.com
To: Rob Landley <rob@landley.net>
cc: Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/2] Fix NULL pointer dereference while loading
 initramfs
In-Reply-To: <1379986687.1974.63@driftwood>
Message-ID: <alpine.LFD.2.03.1309250016290.5312@erqung.pbz>
References: <1379986687.1974.63@driftwood>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

  Hello Rob,

+-- On Mon, 23 Sep 2013, Rob Landley wrote --+
| I've been building kernels, including with initramfs, and I don't have
| dracut(8) installed? In today's git:

  dracut(8) is a separate tool installed from package dracut.

 -> dracut-029-2.fc19.x86_64
 -> https://dracut.wiki.kernel.org/

 
| I've been messing with this area and maight be interested if I had any idea 
| what this guy was talking about?

  Kernel menuconfig selects gzip(1) as a default compression format for the 
initial ramdisk image.

  $ make menuconfig
   -> General setup
    -> Support initial ramdisk compressed using ...

If instead of gzip(1), you select bzip2(1) or xz(1) format and build a new 
kernel, the initramfs image would still be compressed with gzip(1), because 
currently there is no way to pass the selected compression format to dracut(8) 
via $ make install.

# file /boot/initramfs-3.11.0.img 
/boot/initramfs-3.11.0.img: LZMA compressed data, streamed

It shows LZMA because I've patched /sbin/new-kernel-pkg to use 
$INITRD_COMPRESS variable.

Thank you.
--
Prasad J Pandit / Red Hat Security Response Team
DB7A 84C5 D3F9 7CD1 B5EB  C939 D048 7860 3655 602B

Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751212AbaBBCko (ORCPT <rfc822;w@1wt.eu>);
	Sat, 1 Feb 2014 21:40:44 -0500
Received: from mail-pd0-f179.google.com ([209.85.192.179]:58579 "EHLO
	mail-pd0-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750882AbaBBCkm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 1 Feb 2014 21:40:42 -0500
Date: Sat, 1 Feb 2014 18:40:40 -0800 (PST)
From: David Rientjes <rientjes@google.com>
X-X-Sender: rientjes@chino.kir.corp.google.com
To: Filipe David Manana <fdmanana@gmail.com>
cc: Chris Mason <clm@fb.com>, Linus Torvalds <torvalds@linux-foundation.org>,
        linux-kernel@vger.kernel.org,
        "linux-btrfs@vger.kernel.org" <linux-btrfs@vger.kernel.org>
Subject: Re: [GIT PULL] Btrfs
In-Reply-To: <CAL3q7H5OW8GXUYB3rDMVf0Z7b-xPEbePWCg34wK8Y6HYXkn0zg@mail.gmail.com>
Message-ID: <alpine.DEB.2.02.1402011839510.1121@chino.kir.corp.google.com>
References: <52EAC9B6.7090603@fb.com> <alpine.DEB.2.02.1402011611400.5908@chino.kir.corp.google.com> <CAL3q7H5OW8GXUYB3rDMVf0Z7b-xPEbePWCg34wK8Y6HYXkn0zg@mail.gmail.com>
User-Agent: Alpine 2.02 (DEB 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 2 Feb 2014, Filipe David Manana wrote:

> >>     Btrfs: fix btrfs boot when compiled as built-in (+73/-9)
> >
> > This one, 14a958e678cd ("Btrfs: fix btrfs boot when compiled as
> > built-in"), breaks the build if CONFIG_LIBCRC32C=m:
> >
> > fs/built-in.o: In function `btrfs_check_super_csum':
> > disk-io.c:(.text+0x1a1c8b): undefined reference to `crc32c'
> > fs/built-in.o: In function `write_dev_supers.isra.120':
> > disk-io.c:(.text+0x1a2054): undefined reference to `crc32c'
> > fs/built-in.o: In function `csum_tree_block.isra.122':
> > disk-io.c:(.text+0x1a22c4): undefined reference to `crc32c'
> > fs/built-in.o: In function `btrfs_csum_data':
> > (.text+0x1a2a46): undefined reference to `crc32c'
> > fs/built-in.o: In function `send_cmd':
> > send.c:(.text+0x20fe4c): undefined reference to `crc32c'
> 
> One of the kbuild test robots reported this a few days ago too.
> The following patch, sent shortly after the robot's warning, fixes it:
> 
> https://patchwork.kernel.org/patch/3554671/
> 

Acked-by: David Rientjes <rientjes@google.com>

Fixes the build problem for me, thanks!  This needs to get into 3.14 since 
the breakage is currently in Linus's tree.

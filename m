Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753117Ab3I1H5u (ORCPT <rfc822;w@1wt.eu>);
	Sat, 28 Sep 2013 03:57:50 -0400
Received: from mail-ie0-f170.google.com ([209.85.223.170]:61629 "EHLO
	mail-ie0-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752138Ab3I1H5t (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 28 Sep 2013 03:57:49 -0400
MIME-Version: 1.0
In-Reply-To: <20130927150156.GE26069@arm.com>
References: <CALkWK0mwRbBkM=qvQPoyR+kEs8HwLx9P7bWWQnst_Z1=DRFkRA@mail.gmail.com>
 <CAHkRjk5_ep4poYY9gzcDgqaPuDtz2sgeZ0KPO6TqHttj-cS3xw@mail.gmail.com>
 <CALkWK0=YdxF43RQ-Fddp4Rzmx3aU3QdOPrjR=X+s6Wt9_RAYUg@mail.gmail.com> <20130927150156.GE26069@arm.com>
From: Ramkumar Ramachandra <artagnon@gmail.com>
Date: Sat, 28 Sep 2013 13:27:07 +0530
Message-ID: <CALkWK0mjmGmhYnxBdMzbCXJn5yQyK63Ptqr6wT1pBurZCNtmNA@mail.gmail.com>
Subject: Re: [QUERY] Building and testing Aarch64
To: Catalin Marinas <catalin.marinas@arm.com>
Cc: LKML <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Catalin Marinas wrote:
> git://git.kernel.org/pub/scm/linux/kernel/git/cmarinas/boot-wrapper-aarch64.git

Thanks, I made some progress. Now I'm stuck trying to specify the
rootfs. I boot with the following arguments (full fork of your
repository here [1]):

  console=ttyAMA0 mem=2048M devtmpfs.mount=1 earlyprintk rw
init=/bin/sh root=/dev/vda

I copied it from the command-line parameters that
linux-system-foundation.axf uses [2]. And then boot with the raring
image specified as the --block-device in Foundation_v8 like:

  $ ./Foundation_v8 --image linux-system.axf --block-device raring-arm64-rootfs

I built my linux-system.axf from my kernel tree using your Makefile.
Unfortunately, instead of the sh prompt, I get:

  VFS: Cannot open root device "vda" or unknown-block(0,0): error -6
  Please append a correct "root=" boot option; here are the available
partitions:
  Kernel panic - not syncing: VFS: Unable to mount root fs on unknown-block(0,0)

I'm not exactly sure what went wrong: I made sure to compile my kernel
with virtio support. My confusion can be summarized as: when I specify
a file as a --block-device to the Foundation_v8 emulator, under which
device node is it available to the kernel? How do I specify a proper
root device? I tried reading through foundation-v8.dts, but couldn't
understand much.

Also, I didn't understand the part of your Makefile that deals with
the filesystem: what is filesystem.cpio.gz, and where is it going to
be used?

Thanks.

[1]: https://github.com/artagnon/boot-wrapper-aarch64
[2]: http://people.debian.org/~wookey/bootstrap/rootfs/

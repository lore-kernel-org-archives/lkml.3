Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754977Ab3I1Ign (ORCPT <rfc822;w@1wt.eu>);
	Sat, 28 Sep 2013 04:36:43 -0400
Received: from mail-ie0-f170.google.com ([209.85.223.170]:37006 "EHLO
	mail-ie0-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753623Ab3I1Igl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 28 Sep 2013 04:36:41 -0400
MIME-Version: 1.0
In-Reply-To: <m2wqm1s6f5.fsf@linux-m68k.org>
References: <CALkWK0mwRbBkM=qvQPoyR+kEs8HwLx9P7bWWQnst_Z1=DRFkRA@mail.gmail.com>
 <CAHkRjk5_ep4poYY9gzcDgqaPuDtz2sgeZ0KPO6TqHttj-cS3xw@mail.gmail.com>
 <CALkWK0=YdxF43RQ-Fddp4Rzmx3aU3QdOPrjR=X+s6Wt9_RAYUg@mail.gmail.com>
 <20130927150156.GE26069@arm.com> <CALkWK0mjmGmhYnxBdMzbCXJn5yQyK63Ptqr6wT1pBurZCNtmNA@mail.gmail.com>
 <m2wqm1s6f5.fsf@linux-m68k.org>
From: Ramkumar Ramachandra <artagnon@gmail.com>
Date: Sat, 28 Sep 2013 14:06:00 +0530
Message-ID: <CALkWK0nzk6s-C97ze4Ev8gY6fwPbf-qRCfCDvDDE56HFxvzw0A@mail.gmail.com>
Subject: Re: [QUERY] Building and testing Aarch64
To: Andreas Schwab <schwab@linux-m68k.org>
Cc: Catalin Marinas <catalin.marinas@arm.com>,
        LKML <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Andreas Schwab wrote:
>> I'm not exactly sure what went wrong: I made sure to compile my kernel
>> with virtio support.
>
> Make sure you have CONFIG_VIRTIO_MMIO enabled.

Now, I get the following build error:

  LD      init/built-in.o
drivers/built-in.o: In function `vgacon_init':
:(.text+0xbc4): undefined reference to `screen_info'
:(.text+0xbc8): undefined reference to `screen_info'
drivers/built-in.o: In function `vgacon_startup':
:(.text+0xc1c): undefined reference to `screen_info'
:(.text+0xc28): undefined reference to `screen_info'
:(.text+0xc74): undefined reference to `screen_info'
drivers/built-in.o::(.text+0xf9c): more undefined references to
`screen_info' follow
make: *** [vmlinux] Error 1

Is there a bug in the Kconfig dependency tree? Sounds like VIRTIO_MMIO
requires some vga (?) drivers to be compiled in as well.

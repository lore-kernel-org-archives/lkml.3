Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S968427Ab3HJGvR (ORCPT <rfc822;w@1wt.eu>);
	Sat, 10 Aug 2013 02:51:17 -0400
Received: from mail-we0-f175.google.com ([74.125.82.175]:33030 "EHLO
	mail-we0-f175.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1030526Ab3HJGvN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 10 Aug 2013 02:51:13 -0400
MIME-Version: 1.0
In-Reply-To: <1375865207-11794-1-git-send-email-michael@ellerman.id.au>
References: <1375865207-11794-1-git-send-email-michael@ellerman.id.au>
Date: Sat, 10 Aug 2013 09:51:11 +0300
X-Google-Sender-Auth: FORjlO3OcG0cPIMo-w95AIo2Lik
Message-ID: <CAOJsxLEs45Ab95XYfb68AhABNm9d3r6_utGrYkBSRaxJFUou7w@mail.gmail.com>
Subject: Re: [PATCH] kvm tools: Fix build of guest init with biarch powerpc compilers
From: Pekka Enberg <penberg@kernel.org>
To: Michael Ellerman <michael@ellerman.id.au>
Cc: KVM General <kvm@vger.kernel.org>, LKML <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Aug 7, 2013 at 11:46 AM, Michael Ellerman
<michael@ellerman.id.au> wrote:
> On powerpc we build kvmtool as a 64bit binary. We do that by setting
> -m64 in our CFLAGS. For most things we just call $(CC) and it passes
> that info onto the linker.
>
> However there is one place where we explicitly call the linker, in the
> build of guest/init - and in that case we need to tell the linker to
> build 64bit.
>
> We have gotten away with this so far because we have been building with
> a 64bit only toolchain. However if you build with a biarch toolchain,
> which generally defaults to 32bit, we fail to link.
>
> The fix is to defined LDFLAGS appropriately and pass it to LD.
>
> Tested on powerpc and x86-64.
>
> Signed-off-by: Michael Ellerman <michael@ellerman.id.au>

Applied, thanks a lot!

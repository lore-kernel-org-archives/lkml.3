Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754546AbaJ1T4R (ORCPT <rfc822;w@1wt.eu>);
	Tue, 28 Oct 2014 15:56:17 -0400
Received: from mail-ie0-f174.google.com ([209.85.223.174]:65229 "EHLO
	mail-ie0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752641AbaJ1T4Q (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 28 Oct 2014 15:56:16 -0400
MIME-Version: 1.0
In-Reply-To: <20141028184719.GB29098@hydra.tuxags.com>
References: <20140927183403.13738.22121.stgit@zurg>
	<20140927191515.13738.18027.stgit@zurg>
	<20141028184719.GB29098@hydra.tuxags.com>
Date: Tue, 28 Oct 2014 23:56:15 +0400
Message-ID: <CALYGNiOrNfxbCJggraxgiFOdvn3jki_751cpssi+p_eST0Wdgg@mail.gmail.com>
Subject: Re: [PATCH v3 1/4] mm/balloon_compaction: redesign ballooned pages management
From: Konstantin Khlebnikov <koct9i@gmail.com>
To: Konstantin Khlebnikov <koct9i@gmail.com>,
        "linux-mm@kvack.org" <linux-mm@kvack.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Konstantin Khlebnikov <k.khlebnikov@samsung.com>,
        Andrey Ryabinin <ryabinin.a.a@gmail.com>,
        Rafael Aquini <aquini@redhat.com>, Stable <stable@vger.kernel.org>,
        Sasha Levin <sasha.levin@oracle.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Oct 28, 2014 at 9:47 PM, Matt Mullins <mmullins@mmlx.us> wrote:
> On Sat, Sep 27, 2014 at 11:15:16PM +0400, Konstantin Khlebnikov wrote:
>> This patch fixes all of them.
>
> It seems to have rendered virtio_balloon completely ineffective without
> CONFIG_COMPACTION and CONFIG_BALLOON_COMPACTION, even for the case that I'm
> expanding the memory available to my VM.

What do you mean by ineffective?

That it cannot handle fragmentation? I saw that without compaction
ballooning works even better:
it allocates pages without GFP_MOVABLE and buddy allocator returns
much less scattered pages.

>
> Was this intended?  Should Kconfig be updated so that VIRTIO_BALLOON depends on
> BALLOON_COMPACTION now?

Nope, this is independent feature.

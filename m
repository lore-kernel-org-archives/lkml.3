Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752430AbaIMAJW (ORCPT <rfc822;w@1wt.eu>);
	Fri, 12 Sep 2014 20:09:22 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:57576 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751453AbaIMAJV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 12 Sep 2014 20:09:21 -0400
Date: Fri, 12 Sep 2014 17:09:19 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Konstantin Khlebnikov <koct9i@gmail.com>
Cc: Konstantin Khlebnikov <k.khlebnikov@samsung.com>,
        Rafael Aquini <aquini@redhat.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        linux-mm@kvack.org, Andrey Ryabinin <ryabinin.a.a@gmail.com>,
        Sasha Levin <sasha.levin@oracle.com>
Subject: Re: [PATCH v2 0/6] mm/balloon_compaction: fixes and cleanups
Message-Id: <20140912170919.da0719f24020dc2c4a9ae0a7@linux-foundation.org>
In-Reply-To: <20140830163834.29066.98205.stgit@zurg>
References: <20140830163834.29066.98205.stgit@zurg>
X-Mailer: Sylpheed 3.2.0beta5 (GTK+ 2.24.10; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 30 Aug 2014 20:41:06 +0400 Konstantin Khlebnikov <koct9i@gmail.com> wrote:

> I've checked compilation of linux-next/x86 for allnoconfig, defconfig and
> defconfig + kvmconfig + virtio-balloon with and without balloon-compaction.
> For stable kernels first three patches should be enough.
> 
> changes since v1:
> 
> mm/balloon_compaction: ignore anonymous pages
> * no changes
> 
> mm/balloon_compaction: keep ballooned pages away from normal migration path
> * fix compilation without CONFIG_BALLOON_COMPACTION
> 
> mm/balloon_compaction: isolate balloon pages without lru_lock
> * no changes
> 
> mm: introduce common page state for ballooned memory
> * move __Set/ClearPageBalloon into linux/mm.h
> * remove inc/dec_zone_page_state from __Set/ClearPageBalloon
> 
> mm/balloon_compaction: use common page ballooning
> * call inc/dec_zone_page_state from balloon_page_insert/delete
> 
> mm/balloon_compaction: general cleanup
> * fix compilation without CONFIG_MIGRATION
> * fix compilation without CONFIG_BALLOON_COMPACTION
> 

The patch "selftests/vm/transhuge-stress: stress test for memory
compaction" has silently and mysteriously vanished?


Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935773AbaH0Uxu (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Aug 2014 16:53:50 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:56391 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932159AbaH0Uxt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Aug 2014 16:53:49 -0400
Date: Wed, 27 Aug 2014 13:53:48 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Akinobu Mita <akinobu.mita@gmail.com>
Cc: linux-kernel@vger.kernel.org, Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, "H. Peter Anvin" <hpa@zytor.com>,
        x86@kernel.org, linux-mm@kvack.org
Subject: Re: [PATCH 1/2] x86: use memblock_alloc_range() or
 memblock_alloc_base()
Message-Id: <20140827135348.9c9ccefebccc74083f7ba922@linux-foundation.org>
In-Reply-To: <1408892163-8073-1-git-send-email-akinobu.mita@gmail.com>
References: <1408892163-8073-1-git-send-email-akinobu.mita@gmail.com>
X-Mailer: Sylpheed 3.2.0beta5 (GTK+ 2.24.10; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 24 Aug 2014 23:56:02 +0900 Akinobu Mita <akinobu.mita@gmail.com> wrote:

> Replace memblock_find_in_range() and memblock_reserve() with
> memblock_alloc_range() or memblock_alloc_base().

Please spend a little more time preparing the changelogs?

Why are we making this change?  Because memblock_alloc_range() is
equivalent to memblock_find_in_range()+memblock_reserve() and it's just
a cleanup?  Or is there some deeper functional reason?

Does memblock_find_in_range() need to exist?  Can we convert all
callers to memblock_alloc_range()?


Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934519Ab3BSTHB (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Feb 2013 14:07:01 -0500
Received: from mail-pa0-f51.google.com ([209.85.220.51]:59222 "EHLO
	mail-pa0-f51.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933459Ab3BSTG5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Feb 2013 14:06:57 -0500
Date: Tue, 19 Feb 2013 11:06:15 -0800 (PST)
From: Hugh Dickins <hughd@google.com>
X-X-Sender: hugh@eggly.anvils
To: Will Huck <will.huckk@gmail.com>
cc: Li Haifeng <omycle@gmail.com>, linux-arm-kernel@lists.infradead.org,
        linux-kernel@vger.kernel.org, linux-mm@kvack.org
Subject: Re: Should a swapped out page be deleted from swap cache?
In-Reply-To: <5122C9B3.10306@gmail.com>
Message-ID: <alpine.LNX.2.00.1302191056390.2248@eggly.anvils>
References: <CAFNq8R4UYvygk8+X+NZgyGjgU5vBsEv1UM6MiUxah6iW8=0HrQ@mail.gmail.com> <alpine.LNX.2.00.1302180939200.2246@eggly.anvils> <5122C9B3.10306@gmail.com>
User-Agent: Alpine 2.00 (LNX 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 19 Feb 2013, Will Huck wrote:
> 
> Another question:

I don't see the connection to deleting a swapped out page from swap cache.

> 
> Why kernel memory mapping use direct mapping instead of kmalloc/vmalloc which
> will setup mapping on demand?

I may misunderstand you, and "kernel memory mapping".

kmalloc does not set up a mapping, it uses the direct mapping already set up.

It would be circular if the basic page allocation primitives used kmalloc,
since kmalloc relies on the basic page allocation primitives.

vmalloc is less efficient than using the direct mapping (repeated setup
and teardown, no use of hugepages), but necessary when you want a larger
virtual array than you're likely to find from the buddy allocator.

Hugh

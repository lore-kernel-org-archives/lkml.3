Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758133AbaFYS1X (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Jun 2014 14:27:23 -0400
Received: from mail-vc0-f172.google.com ([209.85.220.172]:49478 "EHLO
	mail-vc0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757657AbaFYS1W (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Jun 2014 14:27:22 -0400
MIME-Version: 1.0
In-Reply-To: <1403720237-19131-1-git-send-email-fabf@skynet.be>
References: <1403720237-19131-1-git-send-email-fabf@skynet.be>
Date: Wed, 25 Jun 2014 11:27:21 -0700
X-Google-Sender-Auth: 7dI8Z2r4a29CWFLmL8TZqAKWvmM
Message-ID: <CA+55aFypOwqaxfMwG5H8QSsRyMrMV7ibW_k5CQdc=EPXYmrfLg@mail.gmail.com>
Subject: Re: [PATCH 1/1] fs/omfs/inode.c: replace count*size kzalloc by kcalloc
From: Linus Torvalds <torvalds@linux-foundation.org>
To: Fabian Frederick <fabf@skynet.be>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Bob Copeland <me@bobcopeland.com>,
        Andrew Morton <akpm@linux-foundation.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jun 25, 2014 at 11:17 AM, Fabian Frederick <fabf@skynet.be> wrote:
> kcalloc manages count*sizeof overflow.

As far as I can tell, any overflow has happened long before, in

    bitmap_size = DIV_ROUND_UP(sbi->s_num_blocks, 8);

where 'sbi->s_num_blocks' i san u64, and 'bitmap_size' is an 'int'.

I don't think the patch is necessarily a bad thing, but I think it
might be more important to sanity-check that part instead.

              Linus

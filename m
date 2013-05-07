Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757035Ab3EGKiY (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 May 2013 06:38:24 -0400
Received: from www262.sakura.ne.jp ([202.181.97.72]:50183 "EHLO
	www262.sakura.ne.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755748Ab3EGKiW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 May 2013 06:38:22 -0400
X-Nat-Received: from [202.181.97.72]:50887 [ident-empty]
	by smtp-proxy.isp with TPROXY id 1367923092.5964
To: cl@linux.com
Cc: glommer@parallels.com, penberg@kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [linux-next-20130422] Bug in SLAB?
From: Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>
References: <0000013e6b90e65e-e0e184d9-7da5-4873-9572-3b40958552e2-000000@email.amazonses.com>
	<201305040348.CIF81716.OStQOHFJMFLOVF@I-love.SAKURA.ne.jp>
	<0000013e6bd7a766-8473586c-7937-4129-bad1-a4198acdddcf-000000@email.amazonses.com>
	<201305040915.AID02071.FHVQJtOFOMOLSF@I-love.SAKURA.ne.jp>
	<0000013e7a18153d-4b59eaf6-0fcd-4eec-b357-31d3d40baa7d-000000@email.amazonses.com>
In-Reply-To: <0000013e7a18153d-4b59eaf6-0fcd-4eec-b357-31d3d40baa7d-000000@email.amazonses.com>
Message-Id: <201305071938.DAC81273.HOSJOFFOQLtMFV@I-love.SAKURA.ne.jp>
X-Mailer: Winbiff [Version 2.51 PL2]
X-Accept-Language: ja,en,zh
Date: Tue, 7 May 2013 19:38:12 +0900
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
X-Anti-Virus: Kaspersky Anti-Virus for Linux Mail Server 5.6.45.2/RELEASE, bases: 07052013 #9905969, status: clean
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Christoph Lameter wrote:
> On Sat, 4 May 2013, Tetsuo Handa wrote:
> 
> > Christoph Lameter wrote:
> > > Ok could I see the kernel logs with the warnings?
> > Sure.
> 
> These are exclusively from the module load. So the kernel seems to be
> clean of large kmalloc's ?
> 
There are modules (e.g. TOMOYO) which do not check for KMALLOC_MAX_SIZE limit
and expect kmalloc() larger than KMALLOC_MAX_SIZE bytes to return NULL.

As far as I know, such modules sequentially double the buffer size. Therefore,
as long as request for KMALLOC_MAX_SIZE * 2 bytes returns NULL, they won't
trigger oops by requesting for KMALLOC_MAX_SIZE * 8 bytes.

The testcase I wrote is for module (I don't know if there is one) which
requests for KMALLOC_MAX_SIZE * 8 bytes without requesting for
KMALLOC_MAX_SIZE * 2 bytes and/or KMALLOC_MAX_SIZE * 4 bytes.

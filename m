Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752833Ab3EFGcw (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 May 2013 02:32:52 -0400
Received: from mail-wi0-f172.google.com ([209.85.212.172]:57236 "EHLO
	mail-wi0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752117Ab3EFGcv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 May 2013 02:32:51 -0400
MIME-Version: 1.0
In-Reply-To: <0000013e6b90e65e-e0e184d9-7da5-4873-9572-3b40958552e2-000000@email.amazonses.com>
References: <0000013e5b56d067-7982dfa6-08a2-4c48-ad77-6888b5114c5f-000000@email.amazonses.com>
	<201305010101.CGB86424.JFQOtSFOVOLFHM@I-love.SAKURA.ne.jp>
	<0000013e5bfc7c4d-54fa9464-dccd-4157-b4a5-22594261eaf3-000000@email.amazonses.com>
	<201305012114.AED78178.tFSHFQOOJLMOFV@I-love.SAKURA.ne.jp>
	<0000013e6705da99-094923c6-e239-43d2-8f0c-5e661656a27c-000000@email.amazonses.com>
	<201305031726.BJG78631.tQSOVOLHJFMFFO@I-love.SAKURA.ne.jp>
	<0000013e6b90e65e-e0e184d9-7da5-4873-9572-3b40958552e2-000000@email.amazonses.com>
Date: Mon, 6 May 2013 09:32:50 +0300
X-Google-Sender-Auth: TEM39bcay__uVD45MVBy2tLVSvE
Message-ID: <CAOJsxLF2ND+x0Du=d7jUKZv+ggYJpbRZaZTbLazfW5qagGTFQA@mail.gmail.com>
Subject: Re: [linux-next-20130422] Bug in SLAB?
From: Pekka Enberg <penberg@kernel.org>
To: Christoph Lameter <cl@linux.com>
Cc: Tetsuo Handa <penguin-kernel@i-love.sakura.ne.jp>,
        Glauber Costa <glommer@parallels.com>,
        LKML <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, May 3, 2013 at 9:04 PM, Christoph Lameter <cl@linux.com> wrote:
> Enabling various debugging options increases the size of structures and
> the subslab handling in SLABs kmem_cache_create will start to fail.
>
>
> Here is a fix for that:
>
> Subject: Fix bootstrap creation of kmalloc caches
>
> For SLAB the kmalloc caches must be created in ascending sizes
> in order for the OFF_SLAB sub-slab cache to work properly.
>
> Create the non power of two caches immediately after the prior power
> of two kmalloc cache. Do not create the non power of two caches
> before all other caches.
>
> Signed-off-by: Christoph Lamete <cl@linux.com>

This doesn't seem to apply against slab/next branch. What tree did you
use to generate the patch?

                        Pekka

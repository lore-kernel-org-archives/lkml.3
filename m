Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758928Ab3CYVSQ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 Mar 2013 17:18:16 -0400
Received: from mail-ie0-f177.google.com ([209.85.223.177]:36610 "EHLO
	mail-ie0-f177.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758631Ab3CYVSP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 Mar 2013 17:18:15 -0400
MIME-Version: 1.0
In-Reply-To: <1364184674-13798-2-git-send-email-iamjoonsoo.kim@lge.com>
References: <1364184674-13798-1-git-send-email-iamjoonsoo.kim@lge.com>
	<1364184674-13798-2-git-send-email-iamjoonsoo.kim@lge.com>
Date: Mon, 25 Mar 2013 22:18:15 +0100
Message-ID: <CACRpkdYifJ+Lk4EETvmOwYk6R-cKcw=6TzZdLcHpGe3MxjY+OA@mail.gmail.com>
Subject: Re: [RFC PATCH 1/6] ARM, TCM: initialize TCM in paging_init(),
 instead of setup_arch()
From: Linus Walleij <linus.walleij@linaro.org>
To: Joonsoo Kim <iamjoonsoo.kim@lge.com>
Cc: Russell King <linux@arm.linux.org.uk>,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        Nicolas Pitre <nico@linaro.org>, Will Deacon <will.deacon@arm.com>,
        Rickard ANDERSSON <rickard.andersson@stericsson.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Mar 25, 2013 at 5:11 AM, Joonsoo Kim <iamjoonsoo.kim@lge.com> wrote:

> tcm_init() call iotable_init() and it use early_alloc variants which
> do memblock allocation. Directly using memblock allocation after
> initializing bootmem should not permitted, because bootmem can't know
> where are additinally reserved.
> So move tcm_init() to a safe place before initalizing bootmem.
>
> Signed-off-by: Joonsoo Kim <iamjoonsoo.kim@lge.com>

Tested-by: Linus Walleij <linus.walleij@linaro.org>
(On the U300)

You should put this into Russell's patch tracker for his judgement.

Yours,
Linus Walleij

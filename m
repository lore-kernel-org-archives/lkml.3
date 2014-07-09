Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756472AbaGIWq6 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Jul 2014 18:46:58 -0400
Received: from mail-vc0-f176.google.com ([209.85.220.176]:45182 "EHLO
	mail-vc0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754839AbaGIWq5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Jul 2014 18:46:57 -0400
MIME-Version: 1.0
X-Originating-IP: [2620:0:1000:157d:8cce:4220:32bc:b297]
In-Reply-To: <1404324218-4743-4-git-send-email-lauraa@codeaurora.org>
References: <1404324218-4743-1-git-send-email-lauraa@codeaurora.org>
	<1404324218-4743-4-git-send-email-lauraa@codeaurora.org>
Date: Wed, 9 Jul 2014 15:46:56 -0700
Message-ID: <CAOesGMimCAYnqxkKoYpZ2ws7x9eH4K1Yw3LnLz9HC6MWyHEo3A@mail.gmail.com>
Subject: Re: [PATCHv4 3/5] common: dma-mapping: Introduce common remapping functions
From: Olof Johansson <olof@lixom.net>
To: Laura Abbott <lauraa@codeaurora.org>
Cc: Will Deacon <will.deacon@arm.com>,
        Catalin Marinas <catalin.marinas@arm.com>,
        David Riley <davidriley@chromium.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        Ritesh Harjain <ritesh.harjani@gmail.com>,
        linux-mm <linux-mm@kvack.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jul 2, 2014 at 11:03 AM, Laura Abbott <lauraa@codeaurora.org> wrote:
>
> For architectures without coherent DMA, memory for DMA may
> need to be remapped with coherent attributes. Factor out
> the the remapping code from arm and put it in a
> common location to reduced code duplication.
>
> Signed-off-by: Laura Abbott <lauraa@codeaurora.org>

Hm. The switch from ioremap to map_vm_area() here seems to imply that
lib/ioremap can/should be reworked to use just wrap the vmalloc
functions too?

Unrelated to this change.

I did a pass of review here. Nothing stands out as wrong but I don't
claim to know this area well these days.

What's the merge/ack plan here? It might reduce the complexity of
merging to add the common functions in your series, then move the ARM
code over separately?


-Olof

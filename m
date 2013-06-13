Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758391Ab3FMIvh (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Jun 2013 04:51:37 -0400
Received: from mailout3.w1.samsung.com ([210.118.77.13]:42634 "EHLO
	mailout3.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756168Ab3FMIve (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Jun 2013 04:51:34 -0400
X-AuditID: cbfec7f4-b7fd76d0000035e1-10-51b98813138a
Message-id: <51B98812.80201@samsung.com>
Date: Thu, 13 Jun 2013 10:51:30 +0200
From: Marek Szyprowski <m.szyprowski@samsung.com>
User-Agent: Mozilla/5.0 (Windows NT 5.1; rv:17.0) Gecko/20130509
 Thunderbird/17.0.6
MIME-version: 1.0
To: Arnd Bergmann <arnd@arndb.de>
Cc: James Bottomley <James.Bottomley@hansenpartnership.com>,
        Bjorn Helgaas <bhelgaas@google.com>,
        Michal Simek <michal.simek@xilinx.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Michal Simek <monstr@monstr.eu>,
        Linux-Arch <linux-arch@vger.kernel.org>
Subject: Re: [PATCH] dma-mapping: Add BUG_ON for uninitialized dma_ops
References: <f35c5051a207b0a117f2fff27365d0ea892d1610.1370263476.git.michal.simek@xilinx.com>
 <51B703D7.8050804@samsung.com> <1370958858.2286.5.camel@dabdike>
 <201306121706.39368.arnd@arndb.de>
In-reply-to: <201306121706.39368.arnd@arndb.de>
Content-type: text/plain; charset=UTF-8; format=flowed
Content-transfer-encoding: 7bit
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFjrALMWRmVeSWpSXmKPExsVy+t/xa7rCHTsDDfa+s7T4O+kYu8WSpgyL
	jf0cFh27vrJYXN41h83i3csIiycfT7M4sHv8/jWJ0WPBplKPaZNOsXn87ZrC7PF5k5zH3s+/
	WQLYorhsUlJzMstSi/TtErgyFrW9YyzoZK+Y1fmesYHxEGsXIyeHhICJxOMD0xghbDGJC/fW
	s3UxcnEICSxllFh25BmU08wk0fG6G6yKV0BD4s3t6WDdLAKqEp8e/GYDsdkEDCW63nYB2Rwc
	ogKhEr9XmkOUC0r8mHyPBcQWEVCUmPriGTPITGaB6UwSTXO/MoEkhAXcJM7v28kEsew4o8Tu
	w2fAFnAK6EssudMFZjMLmEk8alnHDGHLS2xe85Z5AqPALCRLZiEpm4WkbAEj8ypG0dTS5ILi
	pPRcQ73ixNzi0rx0veT83E2MkFD/soNx8TGrQ4wCHIxKPLwTm3cECrEmlhVX5h5ilOBgVhLh
	9TwEFOJNSaysSi3Kjy8qzUktPsTIxMEp1cC4YVeChqqLd/7Gg7seVK77r+pkf3zdu9sLQ5ln
	5RhKldybquZ4ZfaM5bs/b1fMKrpTLu34Uyk9+c4qz6kfl18tf+cTETxNTFw6yPitwo1XfK0S
	UflC04SeWF8QdvBmnxUdqTvbfjtT6N+fIiXMaq8t12++39r84CNTmdVb1ptOih5uAqkyGbVK
	LMUZiYZazEXFiQBwrgHoUwIAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On 6/12/2013 5:06 PM, Arnd Bergmann wrote:
> On Tuesday 11 June 2013, James Bottomley wrote:
> > Really, no, it's not a good idea at all.  It invites tons of patches
> > littering the code with BUG_ONs where we might possibly get a NULL
> > dereference.  All it does is add extra instructions to a code path for
> > no actual benefit.
> >
> > If you can answer the question: what more information does the BUG_ON
> > give you than the NULL deref Oops would not? then it might be
> > reasonable.
>
> The question is if a user can trigger the NULL dereference intentionally,
> in which case they might get the kernel to jump into a  user-provided
> buffer.

I don't any possibility for userspace to alter the ops pointer, so if you
think that BUG_ON() approach causes additional overhead then I'm fine to
remove it.

Best regards
-- 
Marek Szyprowski
Samsung R&D Institute Poland



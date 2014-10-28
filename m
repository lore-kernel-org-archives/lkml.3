Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932298AbaJ1VdB (ORCPT <rfc822;w@1wt.eu>);
	Tue, 28 Oct 2014 17:33:01 -0400
Received: from mail-vc0-f172.google.com ([209.85.220.172]:64754 "EHLO
	mail-vc0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932260AbaJ1Vc7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 28 Oct 2014 17:32:59 -0400
MIME-Version: 1.0
In-Reply-To: <1414530994.29180.19.camel@pasglop>
References: <1414496662-25202-1-git-send-email-will.deacon@arm.com>
	<1414496662-25202-2-git-send-email-will.deacon@arm.com>
	<CA+55aFxVtxA-j7uwVCeB4asm4DB-gz4xnsygW8_s0OYfU8hXrw@mail.gmail.com>
	<20141028160729.GH29706@arm.com>
	<CA+55aFxvz=guax4KcAszyjkqdqXGwV38O+G23xMvGFJDTrZqtg@mail.gmail.com>
	<1414530994.29180.19.camel@pasglop>
Date: Tue, 28 Oct 2014 14:32:57 -0700
X-Google-Sender-Auth: qZyWwNzpY1EiTf6NZbkG6Jc6CS4
Message-ID: <CA+55aFx_-nGxD0kkzmGrGKB_nnEEVEPt-31SA9uO3f0cOTTHVA@mail.gmail.com>
Subject: Re: [RFC PATCH 1/2] zap_pte_range: update addr when forcing flush
 after TLB batching faiure
From: Linus Torvalds <torvalds@linux-foundation.org>
To: Benjamin Herrenschmidt <benh@kernel.crashing.org>
Cc: Will Deacon <will.deacon@arm.com>, Peter Zijlstra <peterz@infradead.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Russell King - ARM Linux <linux@arm.linux.org.uk>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Oct 28, 2014 at 2:16 PM, Benjamin Herrenschmidt
<benh@kernel.crashing.org> wrote:
>>
>> Can't you just do a full invalidate and a SW IPI for larger ranges?
>
> For us, this would be great except ... we can potentially have other
> agents with an MMU that only support snooping of the broadcasts...

Ugh. Oh well. I guess on power you need to walk all the hashed entries
individually _anyway_, so there's no way you could really use a
range-based or "invalidate all" model to avoid some of the work.

                  Linus

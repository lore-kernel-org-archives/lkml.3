Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754279AbaIAOOD (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Sep 2014 10:14:03 -0400
Received: from mail-lb0-f172.google.com ([209.85.217.172]:46272 "EHLO
	mail-lb0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754258AbaIAOOA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Sep 2014 10:14:00 -0400
MIME-Version: 1.0
In-Reply-To: <54047A96.1090900@codethink.co.uk>
References: <CACVxJT9FWrGV=LOR11MoK1LEc6b9orDrA1dRAqMiT2Z=OnOQsg@mail.gmail.com>
	<54047A96.1090900@codethink.co.uk>
Date: Mon, 1 Sep 2014 17:13:58 +0300
Message-ID: <CACVxJT_nkS9evtCd5x6GH3Fiyg+hO+bJCzvz3pgdxsUj+fwQVw@mail.gmail.com>
Subject: Re: [PATCH] fs: replace int param with size_t for seq_open_private()
From: Alexey Dobriyan <adobriyan@gmail.com>
To: Rob Jones <rob.jones@codethink.co.uk>
Cc: Linux Kernel <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Sep 1, 2014 at 4:54 PM, Rob Jones <rob.jones@codethink.co.uk> wrote:
>
>
> On 01/09/14 14:43, Alexey Dobriyan wrote:
>>>
>>>   void *__seq_open_private(struct file *f, const struct seq_operations
>>> *ops,
>>> - int psize)
>>> + size_t psize)
>>
>>
>> It should be "unsigned int" at most.
>> As almost all in-kernel lengths.

> I don't agree. Ultimately this parameter ends up as a parameter to
> kmalloc where it is expected to be a size_t.

Which is a mistake too because allocations are never that large.

Save REX prefix, keep length unsigned int!

   Alexey

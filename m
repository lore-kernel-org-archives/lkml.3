Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758673AbaDVVPt (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Apr 2014 17:15:49 -0400
Received: from mail-pb0-f49.google.com ([209.85.160.49]:45288 "EHLO
	mail-pb0-f49.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757680AbaDVVPp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Apr 2014 17:15:45 -0400
Message-ID: <5356DC0D.7090305@kernel.dk>
Date: Tue, 22 Apr 2014 15:15:57 -0600
From: Jens Axboe <axboe@kernel.dk>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.4.0
MIME-Version: 1.0
To: Jianyu Zhan <nasa4836@gmail.com>
CC: LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] blk-cgroup: explicitly init the early_init field
References: <1398144370-9236-1-git-send-email-nasa4836@gmail.com> <535679A4.4050507@kernel.dk> <CAHz2CGXcTZZHYK1WbOcF3S-O74dxE+yN9z527KhgOOEcfD_-DQ@mail.gmail.com>
In-Reply-To: <CAHz2CGXcTZZHYK1WbOcF3S-O74dxE+yN9z527KhgOOEcfD_-DQ@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 04/22/2014 08:18 AM, Jianyu Zhan wrote:
> On Tue, Apr 22, 2014 at 10:16 PM, Jens Axboe <axboe@kernel.dk> wrote:
>> The rest of the members will be zero-filled by default, so your patch should
>> not change anything.
> 
> Hi, Jens
> 
> I'm sorry I should have made this more clear.
> 
> Sure, for this global variable struct, if not initailized, its all
> fields will be initialized
> to 0 or null(depending on its type).  The point here is no to deprive
> the rights of compiler/linker of doing this initialization, it is mainly for
> documentation reason. Actually this field's value would affect how ->css_alloc
> should implemented.
> 
> Concretely, if early_init is nonzero, then ->css_alloc *must not* call kzalloc,
> because in cgroup implementation, ->css_alloc will be called earlier before
> mm_init().
> 
> I don't think that the value of one field(early_init) has a so subtle
> restrition on the another field(css_alloc) is a good thing, but since
> it is there, docment it should be needed.

Then just add the comment instead. The fact the members following the
last " = something," are zeroed is a common theme in the kernel, if you
just add a patch that blindly (and unnecessarily) zeroes one other
member, somebody else will likely find that odd and remove it again.

To be honest, I don't see much of a need to do anything here, really.

-- 
Jens Axboe


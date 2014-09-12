Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754912AbaILOQT (ORCPT <rfc822;w@1wt.eu>);
	Fri, 12 Sep 2014 10:16:19 -0400
Received: from mail-vc0-f175.google.com ([209.85.220.175]:57475 "EHLO
	mail-vc0-f175.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753846AbaILOQQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 12 Sep 2014 10:16:16 -0400
MIME-Version: 1.0
In-Reply-To: <5411CD05.6050705@codethink.co.uk>
References: <1409577428-16148-1-git-send-email-rob.jones@codethink.co.uk>
	<20140901153637.GI7996@ZenIV.linux.org.uk>
	<5411CD05.6050705@codethink.co.uk>
Date: Fri, 12 Sep 2014 16:16:15 +0200
Message-ID: <CAFLxGvwfydw-DFziNAmiEOH_X7+Axqj=zrCY0ZmLZdG9xq0X7w@mail.gmail.com>
Subject: Re: [PATCH] fs: replace int param with size_t for seq_open_private()
From: Richard Weinberger <richard.weinberger@gmail.com>
To: Rob Jones <rob.jones@codethink.co.uk>
Cc: Al Viro <viro@zeniv.linux.org.uk>, LKML <linux-kernel@vger.kernel.org>,
        linux-fsdevel <linux-fsdevel@vger.kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        linux-kernel@codethink.co.uk
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Sep 11, 2014 at 6:25 PM, Rob Jones <rob.jones@codethink.co.uk> wrote:
>
>
> On 01/09/14 16:36, Al Viro wrote:
>>
>> On Mon, Sep 01, 2014 at 02:17:08PM +0100, Rob Jones wrote:
>>
>>>   void *__seq_open_private(struct file *f, const struct seq_operations
>>> *ops,
>>> -               int psize)
>>> +               size_t psize)
>>
>>
>> <sarcasm>
>> It is a horrible limitation to impose, indeed.  Why, a lousy
>> 2 gigabytes per line in procfs file - that's intolerable...
>> </sarcasm>
>>
>>
>
> OK, I know this is a trivial patch but I've gone away and thought about
> it and done some reading to see what the rest of the world thinks about
> using size_t vs unsigned int (signed int is an abomination in this
> context regardless).
>
> I think Al's sarcasm is misplaced.
>
> The correct type to use here *is* size_t. It's about consistency and,
> more importantly, it's about not making assumptions about the hardware
> architecture. It's included in the language for very good reasons and
> it seems to me to be risky to ignore those reasons.

Please don't forget to patch all for loops to use size_t instead of int too.

-- 
Thanks,
//richard

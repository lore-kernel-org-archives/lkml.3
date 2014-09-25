Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754198AbaIYRyx (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Sep 2014 13:54:53 -0400
Received: from ducie-dc1.codethink.co.uk ([185.25.241.215]:41583 "EHLO
	ducie-dc1.codethink.co.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753696AbaIYRyv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Sep 2014 13:54:51 -0400
Message-ID: <542456E0.1040404@codethink.co.uk>
Date: Thu, 25 Sep 2014 18:54:40 +0100
From: Rob Jones <rob.jones@codethink.co.uk>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Icedove/24.7.0
MIME-Version: 1.0
To: Andrew Morton <akpm@linux-foundation.org>
CC: rdunlap@infradead.org, viro@zeniv.linux.org.uk, linux-doc@vger.kernel.org,
        linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-kernel@codethink.co.uk, keescook@chromium.org,
        penguin-kernel@I-love.SAKURA.ne.jp
Subject: Re: [PATCH RESUBMIT 1/2] fs/seq_file: Create new function seq_open_init()
References: <1411557356-10673-1-git-send-email-rob.jones@codethink.co.uk>	<1411557356-10673-2-git-send-email-rob.jones@codethink.co.uk>	<20140924143904.b6f12611013876253d8ac50a@linux-foundation.org>	<5423DBED.4090306@codethink.co.uk> <20140925105033.ae4684eef16b5a323b9dbdd6@linux-foundation.org>
In-Reply-To: <20140925105033.ae4684eef16b5a323b9dbdd6@linux-foundation.org>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On 25/09/14 18:50, Andrew Morton wrote:
> On Thu, 25 Sep 2014 10:10:05 +0100 Rob Jones <rob.jones@codethink.co.uk> wrote:
>
>>> A global exported-to-modules interface should be documented, please.
>>> Especially when it has a void* argument.  seq_file.c is patchy - some
>>> of it is documented, some of it uses the read-programmers-mind
>>> approach.
>>
>> I have included documentation as the second patch. Would it have been
>> better to include them in a single patch? I didn't do that because
>> seq_file and Documentation have different maintainers. I'm still
>> learning the protocols here.
>
> A single patch would be OK.
>
> Documentation/ is nice, but I don't think people think to look there.
> Some kerneldoc within the .c would be a good addition.

Now is a good time, can you point me at an instance of good practice of
this?

>
>>> __seq_open_private() has
>>> 	void *private;
>>>
>>> single_open() has
>>> 	void *data
>>>
>>> And now seq_open_init() has
>>> 	void *p
>>>
>>> but these all refer to the same thing.  Can we have a bit of
>>> consistency in the naming please?  I suggest "private", to match
>>> the seq_file field.
>>
>> A valid point and I can easily make the change but fixing single_open()
>> would mean that the patch is addressing two issues, is that acceptable?
>> Another protocol question, sorry.
>
> I guess switch this patch to use "private" then a second one to fix
> single_open().
>
>
>

-- 
Rob Jones
Codethink Ltd
mailto:rob.jones@codethink.co.uk
tel:+44 161 236 5575

Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753869AbaIYRg3 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Sep 2014 13:36:29 -0400
Received: from ducie-dc1.codethink.co.uk ([185.25.241.215]:40910 "EHLO
	ducie-dc1.codethink.co.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752624AbaIYRg0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Sep 2014 13:36:26 -0400
Message-ID: <54245296.5070604@codethink.co.uk>
Date: Thu, 25 Sep 2014 18:36:22 +0100
From: Rob Jones <rob.jones@codethink.co.uk>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Icedove/24.7.0
MIME-Version: 1.0
To: Kees Cook <keescook@chromium.org>
CC: Randy Dunlap <rdunlap@infradead.org>, Al Viro <viro@zeniv.linux.org.uk>,
        "linux-doc@vger.kernel.org" <linux-doc@vger.kernel.org>,
        "linux-fsdevel@vger.kernel.org" <linux-fsdevel@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>, linux-kernel@codethink.co.uk,
        Andrew Morton <akpm@linux-foundation.org>,
        Tetsuo Handa <penguin-kernel@i-love.sakura.ne.jp>
Subject: Re: [PATCH RESUBMIT 0/2] fs/seq_file: Add seq_open_init()
References: <1411557356-10673-1-git-send-email-rob.jones@codethink.co.uk>	<CAGXu5jJS3Xg+uGm6L+fNau1VBHZpE=EJNRnFZAwwK5fW3B+TjA@mail.gmail.com>	<5423D90A.7090402@codethink.co.uk> <CAGXu5j+tv6_kJy7HNTsCa_kB4Q+8khS1TpWWiRwTM7QeMWF9Zg@mail.gmail.com>
In-Reply-To: <CAGXu5j+tv6_kJy7HNTsCa_kB4Q+8khS1TpWWiRwTM7QeMWF9Zg@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On 25/09/14 17:09, Kees Cook wrote:
> On Thu, Sep 25, 2014 at 1:57 AM, Rob Jones <rob.jones@codethink.co.uk> wrote:
>>
>>
>> On 24/09/14 19:06, Kees Cook wrote:
>>>
>>> On Wed, Sep 24, 2014 at 4:15 AM, Rob Jones <rob.jones@codethink.co.uk>
>>> wrote:
>>>>
>>>> Series resubmitted due to a typo in an email address.
>>>>
>>>> This patch series implements and documents a new interface function for
>>>> seq_file.
>>>>
>>>> The existing set of open functions: seq_open(), seq_open_private() and
>>>> __seq_open_private() satisfy the majority of use cases however there is
>>>> one more use case that is also very common that this new function
>>>> addresses.
>>>>
>>>> This case is where the iterator needs information that is available only
>>>> at
>>>> the time the seq_file is opened but does not need any space allocated,
>>>> e.g.
>>>> access to the inode structure. This type of open occurs, by my best
>>>> estimate,
>>>> in well over 40 places.
>>>>
>>>> Using the new function saves at least two lines of boilerplate code per
>>>> instance as well as making the code easier to follow. The additional code
>>>> in seq_file.c to implement the function is minimal as the first place
>>>> that
>>>> code can be removed is within seq_file.c itself.
>>>>
>>>> Once this patch is accepted, the instances of boilerplate code can be
>>>> addressed.
>>>
>>>
>>> Would it be possible to write a coccinelle patch for the replacements?
>>
>>
>> I'm afraid I don't know what that means.
>
> It's a very flexible tool that should be able to find all the places
> where this pattern is being used, and you can replace it with the new
> function call:
>
> http://lwn.net/Articles/315686/

I suspect that the learning curve would exceed the utility but I'll have
a look at it. Unless there's a coccinelle expert available to do it, in
which case I could point them in the right direction.

My gut reaction would be that by the time I had analysed enough cases
to come up with a viable set of SmPL scripts I would have done most of
the work required, especially if I had to learn a new syntax and tool
to do it.

But first impressions aren't always right.

>
> -Kees
>
>

-- 
Rob Jones
Codethink Ltd
mailto:rob.jones@codethink.co.uk
tel:+44 161 236 5575

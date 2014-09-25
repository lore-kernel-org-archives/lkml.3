Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753286AbaIYI54 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Sep 2014 04:57:56 -0400
Received: from ducie-dc1.codethink.co.uk ([185.25.241.215]:48189 "EHLO
	ducie-dc1.codethink.co.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751423AbaIYI5x (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Sep 2014 04:57:53 -0400
Message-ID: <5423D90A.7090402@codethink.co.uk>
Date: Thu, 25 Sep 2014 09:57:46 +0100
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
References: <1411557356-10673-1-git-send-email-rob.jones@codethink.co.uk> <CAGXu5jJS3Xg+uGm6L+fNau1VBHZpE=EJNRnFZAwwK5fW3B+TjA@mail.gmail.com>
In-Reply-To: <CAGXu5jJS3Xg+uGm6L+fNau1VBHZpE=EJNRnFZAwwK5fW3B+TjA@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On 24/09/14 19:06, Kees Cook wrote:
> On Wed, Sep 24, 2014 at 4:15 AM, Rob Jones <rob.jones@codethink.co.uk> wrote:
>> Series resubmitted due to a typo in an email address.
>>
>> This patch series implements and documents a new interface function for
>> seq_file.
>>
>> The existing set of open functions: seq_open(), seq_open_private() and
>> __seq_open_private() satisfy the majority of use cases however there is
>> one more use case that is also very common that this new function
>> addresses.
>>
>> This case is where the iterator needs information that is available only at
>> the time the seq_file is opened but does not need any space allocated, e.g.
>> access to the inode structure. This type of open occurs, by my best estimate,
>> in well over 40 places.
>>
>> Using the new function saves at least two lines of boilerplate code per
>> instance as well as making the code easier to follow. The additional code
>> in seq_file.c to implement the function is minimal as the first place that
>> code can be removed is within seq_file.c itself.
>>
>> Once this patch is accepted, the instances of boilerplate code can be
>> addressed.
>
> Would it be possible to write a coccinelle patch for the replacements?

I'm afraid I don't know what that means.

>
> This seems like a good idea. Thanks!
>
> Acked-by: Kees Cook <keescook@chromium.org>
>
> -Kees
>
>>
>> The documentation of seq_open() and its variants has been re-worked to try
>> to guide users towards the most appropriate variant for their application.
>>
>> Rob Jones (2):
>>    fs/seq_file: Create new function seq_open_init()
>>    Documentation/filesystem/seq_file: document seq_open_init()
>>
>>   Documentation/filesystems/seq_file.txt |   58 +++++++++++++++++++++-----------
>>   fs/seq_file.c                          |   34 ++++++++++++-------
>>   include/linux/seq_file.h               |    1 +
>>   3 files changed, 62 insertions(+), 31 deletions(-)
>>
>> --
>> 1.7.10.4
>>
>
>
>

-- 
Rob Jones
Codethink Ltd
mailto:rob.jones@codethink.co.uk
tel:+44 161 236 5575

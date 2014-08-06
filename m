Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755148AbaHFQQ5 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Aug 2014 12:16:57 -0400
Received: from ducie-dc1.codethink.co.uk ([185.25.241.215]:41716 "EHLO
	ducie-dc1.codethink.co.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754696AbaHFQQz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Aug 2014 12:16:55 -0400
Message-ID: <53E254F1.30605@codethink.co.uk>
Date: Wed, 06 Aug 2014 17:16:49 +0100
From: Rob Jones <rob.jones@codethink.co.uk>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Icedove/24.5.0
MIME-Version: 1.0
To: Al Viro <viro@ZenIV.linux.org.uk>
CC: linux-fsdevel@vger.kernel.org, linux-doc@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-kernel@lists.codethink.co.uk,
        ebiederm@xmission.com, ian.molton@codethink.co.uk
Subject: Re: [PATCH] seq_file: Allow private data to be supplied on seq_open
References: <1406655593-12626-1-git-send-email-rob.jones@codethink.co.uk> <20140806160259.GR18016@ZenIV.linux.org.uk>
In-Reply-To: <20140806160259.GR18016@ZenIV.linux.org.uk>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 06/08/14 17:02, Al Viro wrote:
> On Tue, Jul 29, 2014 at 06:39:53PM +0100, Rob Jones wrote:
>
>> At the moment these consumers have to obtain the struct seq_file pointer
>> (stored by seq_open() in file->private_data) and then store a pointer to
>> their own data in the private field of the struct seq_file so that it
>> can be accessed by the iterator functions.
>>
>> Although this is not a long piece of code it is unneccessary boilerplate.
>
> How many of those do we actually have?

A quick grep (I didn't examine them all) showed what looked like at
least 80 instances of the work around.

>
>> seq_open() remains in place and its behaviour remains unchanged so no
>> existing code should be broken by this patch.
>
> I have no objections against such helper, but I's rather have it
> implemented via seq_open() (and as a static inline, not an export),
> not the other way round.  Oh, and conversion of at least some users would
> be nice to have as well...
>
>

I did wonder about doing it as an inline but would argue that, for
efficiency, an external is better. There are some hundreds of calls to
seq_open(), each of which would need the compiler to insert the NULL
parameter, that seems like quite a few bytes of code added to the kernel
for the sake of saving one symbol export. However, if I'm wrong, I'll
happily change it to an inline, you guys have much more kernel
experience than me.

I'm not quite sure I understand your meaning when you say "via seq_open"
though, that function call format needs to stay the same or lots of
code will break, so I can't just add the third parameter on the end.
(C++ does have *some* advantages!) Can you clarify, please?

I was planning on changing a bunch of the instances after the patch went 
in. I can easily add a sample tidy up or two to the end, there's no
shortage of candidates.

-- 
Rob Jones
Codethink Ltd
mailto:rob.jones@codethink.co.uk
tel:+44 161 236 5575

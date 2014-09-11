Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755883AbaIKQZr (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Sep 2014 12:25:47 -0400
Received: from ducie-dc1.codethink.co.uk ([185.25.241.215]:51194 "EHLO
	ducie-dc1.codethink.co.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751091AbaIKQZp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Sep 2014 12:25:45 -0400
Message-ID: <5411CD05.6050705@codethink.co.uk>
Date: Thu, 11 Sep 2014 17:25:41 +0100
From: Rob Jones <rob.jones@codethink.co.uk>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Icedove/24.7.0
MIME-Version: 1.0
To: Al Viro <viro@ZenIV.linux.org.uk>
CC: linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org,
        akpm@linux-foundation.org, linux-kernel@codethink.co.uk
Subject: Re: [PATCH] fs: replace int param with size_t for seq_open_private()
References: <1409577428-16148-1-git-send-email-rob.jones@codethink.co.uk> <20140901153637.GI7996@ZenIV.linux.org.uk>
In-Reply-To: <20140901153637.GI7996@ZenIV.linux.org.uk>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On 01/09/14 16:36, Al Viro wrote:
> On Mon, Sep 01, 2014 at 02:17:08PM +0100, Rob Jones wrote:
>
>>   void *__seq_open_private(struct file *f, const struct seq_operations *ops,
>> -		int psize)
>> +		size_t psize)
>
> <sarcasm>
> It is a horrible limitation to impose, indeed.  Why, a lousy
> 2 gigabytes per line in procfs file - that's intolerable...
> </sarcasm>
>
>

OK, I know this is a trivial patch but I've gone away and thought about
it and done some reading to see what the rest of the world thinks about
using size_t vs unsigned int (signed int is an abomination in this
context regardless).

I think Al's sarcasm is misplaced.

The correct type to use here *is* size_t. It's about consistency and,
more importantly, it's about not making assumptions about the hardware
architecture. It's included in the language for very good reasons and
it seems to me to be risky to ignore those reasons.

I would like the patch to be considered for inclusion, it costs nothing
and could avoid a future problem coming up to bite us in the bum.

-- 
Rob Jones
Codethink Ltd
mailto:rob.jones@codethink.co.uk
tel:+44 161 236 5575

Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754504AbaIAPxr (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Sep 2014 11:53:47 -0400
Received: from ducie-dc1.codethink.co.uk ([185.25.241.215]:42660 "EHLO
	ducie-dc1.codethink.co.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754181AbaIAPxp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Sep 2014 11:53:45 -0400
Message-ID: <54049684.9010005@codethink.co.uk>
Date: Mon, 01 Sep 2014 16:53:40 +0100
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

<shrug>

Consistency?

kmalloc() expects a size_t and I haven't heard anyone whingeing about that.

Ultimately, this function calls kmalloc().

>

-- 
Rob Jones
Codethink Ltd
mailto:rob.jones@codethink.co.uk
tel:+44 161 236 5575

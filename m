Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932512AbaGOKG7 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Jul 2014 06:06:59 -0400
Received: from mail-pa0-f47.google.com ([209.85.220.47]:33971 "EHLO
	mail-pa0-f47.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758043AbaGOKG4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Jul 2014 06:06:56 -0400
Message-ID: <53C4FD27.2030906@gmail.com>
Date: Tue, 15 Jul 2014 18:06:31 +0800
From: Chen Gang <gang.chen.5i5j@gmail.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.6.0
MIME-Version: 1.0
To: "Theodore Ts'o" <tytso@mit.edu>, Andreas Dilger <adilger.kernel@dilger.ca>,
        linux-ext4@vger.kernel.org,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] fs/ext4/super.c: Let 'counters' switched by SMP
References: <53C47E59.8030502@gmail.com> <20140715093154.GB1451@thunk.org>
In-Reply-To: <20140715093154.GB1451@thunk.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 07/15/2014 05:31 PM, Theodore Ts'o wrote:
> On Tue, Jul 15, 2014 at 09:05:29AM +0800, Chen Gang wrote:
>> When SMP is disabled, 'struct percpu_counter' has no 'counters' member,
>> so need skip it when in !SMP.
>>
>> The related git commit:
>>
>>   "feab139 ext4: rearrange initialization to fix EXT4FS_DEBUG".
>>
>> The related error (with allmodconfig under score):
>>
>>     CC [M]  fs/ext4/super.o
>>   fs/ext4/super.c: In function 'ext4_commit_super':
>>   fs/ext4/super.c:4546:41: error: 'struct percpu_counter' has no member named 'counters'
>>     if (EXT4_SB(sb)->s_freeclusters_counter.counters)
>>                                            ^
>>   fs/ext4/super.c:4550:39: error: 'struct percpu_counter' has no member named 'counters'
>>     if (EXT4_SB(sb)->s_freeinodes_counter.counters)
> 
> Thanks for the pointing out the problem.  I though think the right way
> of fixing this problem, though, instead of using the #ifdef
> CONFIG_SMP, is to do this:
> 
>        if (percpu_counter_initialized(&EXT4_SB(sb)->s_freeclusters_counter))
>        	  ...
> 

That sounds fine to me (unlike my ugly fix, your fix is common and
standard), thanks.

> I'll respin the "ext4: rearrange initialization to fix EXT4FS_DEBUG"
> commit to include this fix and give you credit in the commit logs for
> pointing out this issue.
> 

Thank you for your work.


Thanks.
-- 
Chen Gang

Open, share, and attitude like air, water, and life which God blessed

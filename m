Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933262AbaGURkJ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Jul 2014 13:40:09 -0400
Received: from mail-vc0-f170.google.com ([209.85.220.170]:57550 "EHLO
	mail-vc0-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932332AbaGURkH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Jul 2014 13:40:07 -0400
MIME-Version: 1.0
X-Originating-IP: [2620:0:1000:157d:2951:8f84:e49d:77d6]
In-Reply-To: <20140715093154.GB1451@thunk.org>
References: <53C47E59.8030502@gmail.com>
	<20140715093154.GB1451@thunk.org>
Date: Mon, 21 Jul 2014 10:40:02 -0700
Message-ID: <CAOesGMhmENA+eojUYBOCJQBNq4zcWx8C-qDCv5umNPm0it8qxg@mail.gmail.com>
Subject: Re: [PATCH] fs/ext4/super.c: Let 'counters' switched by SMP
From: Olof Johansson <olof@lixom.net>
To: "Theodore Ts'o" <tytso@mit.edu>, Chen Gang <gang.chen.5i5j@gmail.com>,
        Andreas Dilger <adilger.kernel@dilger.ca>, linux-ext4@vger.kernel.org,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Ted,

On Tue, Jul 15, 2014 at 2:31 AM, Theodore Ts'o <tytso@mit.edu> wrote:
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
>           ...
>
> I'll respin the "ext4: rearrange initialization to fix EXT4FS_DEBUG"
> commit to include this fix and give you credit in the commit logs for
> pointing out this issue.

Friendly ping, since all !SMP builds in -next seem to be broken by this still.


-Olof

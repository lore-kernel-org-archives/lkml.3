Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754957AbaDNB6B (ORCPT <rfc822;w@1wt.eu>);
	Sun, 13 Apr 2014 21:58:01 -0400
Received: from cn.fujitsu.com ([59.151.112.132]:34136 "EHLO
	heian.cn.fujitsu.com" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S1754721AbaDNB56 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 13 Apr 2014 21:57:58 -0400
X-IronPort-AV: E=Sophos;i="4.97,853,1389715200"; 
   d="scan'208";a="29208433"
Message-ID: <534B3E5F.3090609@cn.fujitsu.com>
Date: Mon, 14 Apr 2014 09:48:15 +0800
From: Gu Zheng <guz.fnst@cn.fujitsu.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:7.0.1) Gecko/20110930 Thunderbird/7.0.1
MIME-Version: 1.0
To: <jaegeuk.kim@samsung.com>
CC: f2fs <linux-f2fs-devel@lists.sourceforge.net>,
        fsdevel <linux-fsdevel@vger.kernel.org>,
        linux-kernel <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 0/7] f2fs: some fix and cleanup about flush_merge
References: <5347BAA5.6070104@cn.fujitsu.com> <534B374C.8030009@cn.fujitsu.com> <1397439855.24638.24.camel@kjgkr>
In-Reply-To: <1397439855.24638.24.camel@kjgkr>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
X-Originating-IP: [10.167.226.100]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 04/14/2014 09:44 AM, Jaegeuk Kim wrote:

> Hi Gu,
> 
> I just started to review the patches and merge them individually though.
> Since I've been internally doing in my local tree, so that should be no
> problem. I'll roll back to the latest point.

OK, and please pay some attention to the flush cmds merging operation when doing
tests, it seems that some of the outstanding flush cmds(in the issue_list) will
be ignored when new cmd added.
I'll review and test it more.

> Anyway, thank you for your work. :)


Regards,
Gu

> 
> 2014-04-14 (월), 09:18 +0800, Gu Zheng:
>> Hi All,
>> There seems to be a mistake in "[PATCH 2/7]f2fs: remove the unuseful "issue_tail" list",
>> and the whole patchset needs to be reworked. So please ignore this one.
>> Sorry for the noise.
>>
>> Regards,
>> Gu
>> On 04/11/2014 05:49 PM, Gu Zheng wrote:
>>
>>> Gu Zheng (7):
>>>   f2fs: put the bio when issue_flush completed
>>>   f2fs: remove the unuseful "issue_tail" list
>>>   f2fs: use __GFP_ZERO to avoid appending set-NULL
>>>   f2fs: enable flush_merge only in f2fs is not read-only
>>>   f2fs: add the flush_merge handle in the remount flow
>>>   f2fs: introduce struct flush_cmd_control to wrap the flush_merge
>>>     fields
>>>   f2fs: introduce help function {create,destroy}_flush_cmd_control
>>>
>>>  fs/f2fs/f2fs.h    |   17 ++++++---
>>>  fs/f2fs/segment.c |  102 +++++++++++++++++++++++++++++++++++-----------------
>>>  fs/f2fs/super.c   |   32 ++++++++++++++--
>>>  3 files changed, 107 insertions(+), 44 deletions(-)
>>>
>>
>>
>> --
>> To unsubscribe from this list: send the line "unsubscribe linux-fsdevel" in
>> the body of a message to majordomo@vger.kernel.org
>> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> 



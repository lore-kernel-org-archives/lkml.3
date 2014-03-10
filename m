Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752563AbaCJBlB (ORCPT <rfc822;w@1wt.eu>);
	Sun, 9 Mar 2014 21:41:01 -0400
Received: from cn.fujitsu.com ([222.73.24.84]:17192 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1750905AbaCJBlA (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 9 Mar 2014 21:41:00 -0400
X-IronPort-AV: E=Sophos;i="4.97,621,1389715200"; 
   d="scan'208";a="9668760"
Message-ID: <531D161C.8080001@cn.fujitsu.com>
Date: Mon, 10 Mar 2014 09:32:12 +0800
From: Gu Zheng <guz.fnst@cn.fujitsu.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:7.0.1) Gecko/20110930 Thunderbird/7.0.1
MIME-Version: 1.0
To: Chao Yu <chao2.yu@samsung.com>
CC: "'Kim'" <jaegeuk.kim@samsung.com>,
        "'linux-kernel'" <linux-kernel@vger.kernel.org>,
        "'f2fs'" <linux-f2fs-devel@lists.sourceforge.net>
Subject: Re: [f2fs-dev] [PATCH 1/5] f2fs: update start nid only once each
 circle
References: <5319A2CC.3090206@cn.fujitsu.com> <001301cf3ac4$3220b8c0$96622a40$@samsung.com>
In-Reply-To: <001301cf3ac4$3220b8c0$96622a40$@samsung.com>
X-MIMETrack: Itemize by SMTP Server on mailserver/fnst(Release 8.5.3|September 15, 2011) at
 2014/03/10 09:38:15,
	Serialize by Router on mailserver/fnst(Release 8.5.3|September 15, 2011) at
 2014/03/10 09:38:17,
	Serialize complete at 2014/03/10 09:38:17
Content-Transfer-Encoding: 7bit
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 03/08/2014 07:46 PM, Chao Yu wrote:

> Hi Gu,
> 
>> -----Original Message-----
>> From: Gu Zheng [mailto:guz.fnst@cn.fujitsu.com]
>> Sent: Friday, March 07, 2014 6:43 PM
>> To: Kim
>> Cc: linux-kernel; f2fs
>> Subject: [f2fs-dev] [PATCH 1/5] f2fs: update start nid only once each circle
>>
>>
>> Signed-off-by: Gu Zheng <guz.fnst@cn.fujitsu.com>
> 
> Reviewed-by: Chao Yu <chao2.yu@samsung.com>
> 
>> ---
>>  fs/f2fs/node.c |    6 +++++-
>>  1 files changed, 5 insertions(+), 1 deletions(-)
>>
>> diff --git a/fs/f2fs/node.c b/fs/f2fs/node.c
>> index 8c14110..9653096 100644
>> --- a/fs/f2fs/node.c
>> +++ b/fs/f2fs/node.c
>> @@ -1875,11 +1875,15 @@ void destroy_node_manager(struct f2fs_sb_info *sbi)
>>  	while ((found = __gang_lookup_nat_cache(nm_i,
>>  					nid, NATVEC_SIZE, natvec))) {
>>  		unsigned idx;
>> +
>> +		nid = nat_get_nid(natvec[found - 1]) + 1;
>> +
>>  		for (idx = 0; idx < found; idx++) {
>>  			struct nat_entry *e = natvec[idx];
> 
> Could we replace argument 'e' with 'natvec[idx]'? then we could remove 'e' and
> brace here.

Agree. More neat with this cleanup.

Regards,
Gu

> 
> Thanks.
> 
>> -			nid = nat_get_nid(e) + 1;
>> +
>>  			__del_from_nat_cache(nm_i, e);
>>  		}
>> +
>>  	}
>>  	f2fs_bug_on(nm_i->nat_cnt);
>>  	write_unlock(&nm_i->nat_tree_lock);
>> --
>> 1.7.7
>>
>>
>> ------------------------------------------------------------------------------
>> Subversion Kills Productivity. Get off Subversion & Make the Move to Perforce.
>> With Perforce, you get hassle-free workflows. Merge that actually works.
>> Faster operations. Version large binaries.  Built-in WAN optimization and the
>> freedom to use Git, Perforce or both. Make the move to Perforce.
>> http://pubads.g.doubleclick.net/gampad/clk?id=122218951&iu=/4140/ostg.clktrk
>> _______________________________________________
>> Linux-f2fs-devel mailing list
>> Linux-f2fs-devel@lists.sourceforge.net
>> https://lists.sourceforge.net/lists/listinfo/linux-f2fs-devel
> 
> 



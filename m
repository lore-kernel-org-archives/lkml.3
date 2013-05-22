Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755668Ab3EVJVr (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 May 2013 05:21:47 -0400
Received: from cn.fujitsu.com ([222.73.24.84]:22194 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1754017Ab3EVJVq (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 May 2013 05:21:46 -0400
X-IronPort-AV: E=Sophos;i="4.87,719,1363104000"; 
   d="scan'208";a="7333122"
Message-ID: <519C8ED5.5010708@cn.fujitsu.com>
Date: Wed, 22 May 2013 17:24:37 +0800
From: Tang Chen <tangchen@cn.fujitsu.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:12.0) Gecko/20120430 Thunderbird/12.0.1
MIME-Version: 1.0
To: mingo@redhat.com, hpa@zytor.com, akpm@linux-foundation.org,
        yinghai@kernel.org, jiang.liu@huawei.com, wency@cn.fujitsu.com,
        isimatu.yasuaki@jp.fujitsu.com, tj@kernel.org, laijs@cn.fujitsu.com,
        davem@davemloft.net, mgorman@suse.de, minchan@kernel.org,
        mina86@mina86.com, x86@kernel.org, linux-doc@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-mm@kvack.org,
        gong.chen@linux.intel.com
Subject: Re: [PATCH v2 01/13] x86: get pg_data_t's memory from other node
References: <1367313683-10267-1-git-send-email-tangchen@cn.fujitsu.com> <1367313683-10267-2-git-send-email-tangchen@cn.fujitsu.com> <20130522085553.GB25406@gchen.bj.intel.com>
In-Reply-To: <20130522085553.GB25406@gchen.bj.intel.com>
X-MIMETrack: Itemize by SMTP Server on mailserver/fnst(Release 8.5.3|September 15, 2011) at
 2013/05/22 17:20:22,
	Serialize by Router on mailserver/fnst(Release 8.5.3|September 15, 2011) at
 2013/05/22 17:20:24,
	Serialize complete at 2013/05/22 17:20:24
Content-Transfer-Encoding: 7bit
Content-Type: text/plain; charset=UTF-8; format=flowed
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 05/22/2013 04:55 PM, Chen Gong wrote:
......
>> -	nd_pa = memblock_alloc_nid(nd_size, SMP_CACHE_BYTES, nid);
>> +	nd_pa = memblock_alloc_try_nid(nd_size, SMP_CACHE_BYTES, nid);
>
> go through the implementation of memblock_alloc_try_nid, it will call
> panic when allocation fails(a.k.a alloc = 0), if so, below information
> will be never printed. Do we really need this?

Oh, yes.

We don't need this. Will remove the following in the next version.

Thanks. :)

>
>>   	if (!nd_pa) {
>> -		pr_err("Cannot find %zu bytes in node %d\n",
>> -		       nd_size, nid);
>> +		pr_err("Cannot find %zu bytes in any node\n", nd_size);
>>   		return;
>>   	}
>>   	nd = __va(nd_pa);
>> --
>> 1.7.1
>>
>> --
>> To unsubscribe, send a message with 'unsubscribe linux-mm' in
>> the body to majordomo@kvack.org.  For more info on Linux MM,
>> see: http://www.linux-mm.org/ .
>> Don't email:<a href=mailto:"dont@kvack.org">  email@kvack.org</a>


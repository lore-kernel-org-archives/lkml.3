Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751774Ab3FNFmS (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 Jun 2013 01:42:18 -0400
Received: from cn.fujitsu.com ([222.73.24.84]:36193 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1751366Ab3FNFmQ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 Jun 2013 01:42:16 -0400
X-IronPort-AV: E=Sophos;i="4.87,863,1363104000"; 
   d="scan'208";a="7544436"
Message-ID: <51BAADE8.2040501@cn.fujitsu.com>
Date: Fri, 14 Jun 2013 13:45:12 +0800
From: Tang Chen <tangchen@cn.fujitsu.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:12.0) Gecko/20120430 Thunderbird/12.0.1
MIME-Version: 1.0
To: Dave Hansen <dave.hansen@intel.com>
CC: tglx@linutronix.de, mingo@elte.hu, hpa@zytor.com,
        akpm@linux-foundation.org, tj@kernel.org, trenn@suse.de,
        yinghai@kernel.org, jiang.liu@huawei.com, wency@cn.fujitsu.com,
        laijs@cn.fujitsu.com, isimatu.yasuaki@jp.fujitsu.com, mgorman@suse.de,
        minchan@kernel.org, mina86@mina86.com, gong.chen@linux.intel.com,
        vasilis.liaskovitis@profitbricks.com, lwoodman@redhat.com,
        riel@redhat.com, jweiner@redhat.com, prarit@redhat.com, x86@kernel.org,
        linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-mm@kvack.org
Subject: Re: [Part3 PATCH v2 2/4] mem-hotplug: Skip LOCAL_NODE_DATA pages
 in memory offline procedure.
References: <1371128636-9027-1-git-send-email-tangchen@cn.fujitsu.com> <1371128636-9027-3-git-send-email-tangchen@cn.fujitsu.com> <51B9FE8E.9000109@intel.com>
In-Reply-To: <51B9FE8E.9000109@intel.com>
X-MIMETrack: Itemize by SMTP Server on mailserver/fnst(Release 8.5.3|September 15, 2011) at
 2013/06/14 13:40:17,
	Serialize by Router on mailserver/fnst(Release 8.5.3|September 15, 2011) at
 2013/06/14 13:40:19,
	Serialize complete at 2013/06/14 13:40:19
Content-Transfer-Encoding: 7bit
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Dave,

On 06/14/2013 01:17 AM, Dave Hansen wrote:
> On 06/13/2013 06:03 AM, Tang Chen wrote:
>> +static inline bool is_local_node_data(struct page *page)
>> +{
>> +	return (unsigned long)page->lru.next == LOCAL_NODE_DATA;
>> +}
>
> page->lru is already in a union.  Could you please just add a new entry
> to the union with a nice associated comment instead of reusing it this way?
>

You mean add a new entry to the union in page structure ?

Hum, seems a good idea. :)

And as you know, NODE_INFO, SECTION_INFO, ... , they all reuse page->lru.
So I need to modify the associated code too. This is easy to do, and I can
do it in the next version soon.

Thanks. :)


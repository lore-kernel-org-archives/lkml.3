Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758261Ab3GZD5n (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Jul 2013 23:57:43 -0400
Received: from cn.fujitsu.com ([222.73.24.84]:9613 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1756730Ab3GZD5l (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Jul 2013 23:57:41 -0400
X-IronPort-AV: E=Sophos;i="4.89,748,1367942400"; 
   d="scan'208";a="8029960"
Message-ID: <51F1F453.8060602@cn.fujitsu.com>
Date: Fri, 26 Jul 2013 12:00:19 +0800
From: Tang Chen <tangchen@cn.fujitsu.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:12.0) Gecko/20120430 Thunderbird/12.0.1
MIME-Version: 1.0
To: Tejun Heo <tj@kernel.org>
CC: tglx@linutronix.de, mingo@elte.hu, hpa@zytor.com,
        akpm@linux-foundation.org, trenn@suse.de, yinghai@kernel.org,
        jiang.liu@huawei.com, wency@cn.fujitsu.com, laijs@cn.fujitsu.com,
        isimatu.yasuaki@jp.fujitsu.com, izumi.taku@jp.fujitsu.com,
        mgorman@suse.de, minchan@kernel.org, mina86@mina86.com,
        gong.chen@linux.intel.com, vasilis.liaskovitis@profitbricks.com,
        lwoodman@redhat.com, riel@redhat.com, jweiner@redhat.com,
        prarit@redhat.com, zhangyanfei@cn.fujitsu.com, yanghy@cn.fujitsu.com,
        x86@kernel.org, linux-doc@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-mm@kvack.org,
        linux-acpi@vger.kernel.org
Subject: Re: [PATCH 18/21] x86, numa: Synchronize nid info in memblock.reserve
 with numa_meminfo.
References: <1374220774-29974-1-git-send-email-tangchen@cn.fujitsu.com> <1374220774-29974-19-git-send-email-tangchen@cn.fujitsu.com> <20130723212548.GZ21100@mtj.dyndns.org> <51F0A4F9.2060802@cn.fujitsu.com> <20130725150554.GC26107@mtj.dyndns.org>
In-Reply-To: <20130725150554.GC26107@mtj.dyndns.org>
X-MIMETrack: Itemize by SMTP Server on mailserver/fnst(Release 8.5.3|September 15, 2011) at
 2013/07/26 11:55:27,
	Serialize by Router on mailserver/fnst(Release 8.5.3|September 15, 2011) at
 2013/07/26 11:55:33,
	Serialize complete at 2013/07/26 11:55:33
Content-Transfer-Encoding: 7bit
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 07/25/2013 11:05 PM, Tejun Heo wrote:
> Hello, Tang.
>
> On Thu, Jul 25, 2013 at 12:09:29PM +0800, Tang Chen wrote:
>> And as in [patch 14/21], when reserving hotpluggable memory, we use
>> pxm. So my
>
> Which is kinda nasty.

Yes, will remove it.

>
>> idea was to do a nid sync in numa_init(). After this, memblock will
>> set nid when
>> it allocates memory.
>
> Sure, that's the only place we can set the numa node IDs but my point
> is that you don't need to add another interface.  Jet let
> memblock_set_node() handle both memblock.memory and .reserved ranges.
> That way, you can make memblock simpler to use and less error-prone.

Yes, I missed the isolation phase in memblock_set_node().
So followed.

>
>> If we want to let memblock_set_node() and alloc functions set nid on
>> the reserved
>> regions, we should setup nid<->  pxm mapping when we parst SRAT for
>> the first time.
>
> I don't follow why it has to be different.  Why do you need to do
> anything differently?  What am I missing here?

No, it was me who missed the isolation phase in memblock_set_node().

Thanks.

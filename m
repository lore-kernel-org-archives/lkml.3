Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1422979Ab3FUJQ7 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 Jun 2013 05:16:59 -0400
Received: from cn.fujitsu.com ([222.73.24.84]:19709 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1422931Ab3FUJQ5 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 Jun 2013 05:16:57 -0400
X-IronPort-AV: E=Sophos;i="4.87,911,1363104000"; 
   d="scan'208";a="7627349"
Message-ID: <51C41AB4.9070500@cn.fujitsu.com>
Date: Fri, 21 Jun 2013 17:19:48 +0800
From: Tang Chen <tangchen@cn.fujitsu.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:12.0) Gecko/20120430 Thunderbird/12.0.1
MIME-Version: 1.0
To: Tejun Heo <tj@kernel.org>
CC: yinghai@kernel.org, tglx@linutronix.de, mingo@elte.hu, hpa@zytor.com,
        akpm@linux-foundation.org, trenn@suse.de, jiang.liu@huawei.com,
        wency@cn.fujitsu.com, laijs@cn.fujitsu.com,
        isimatu.yasuaki@jp.fujitsu.com, mgorman@suse.de, minchan@kernel.org,
        mina86@mina86.com, gong.chen@linux.intel.com,
        vasilis.liaskovitis@profitbricks.com, lwoodman@redhat.com,
        riel@redhat.com, jweiner@redhat.com, prarit@redhat.com, x86@kernel.org,
        linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-mm@kvack.org
Subject: Re: [Part1 PATCH v5 00/22] x86, ACPI, numa: Parse numa info earlier
References: <1371128589-8953-1-git-send-email-tangchen@cn.fujitsu.com> <20130618020357.GZ32663@mtj.dyndns.org> <51BFF464.809@cn.fujitsu.com> <20130618172129.GH2767@htj.dyndns.org> <51C298B2.9060900@cn.fujitsu.com> <20130620061719.GA16114@mtj.dyndns.org>
In-Reply-To: <20130620061719.GA16114@mtj.dyndns.org>
X-MIMETrack: Itemize by SMTP Server on mailserver/fnst(Release 8.5.3|September 15, 2011) at
 2013/06/21 17:15:39,
	Serialize by Router on mailserver/fnst(Release 8.5.3|September 15, 2011) at
 2013/06/21 17:15:47,
	Serialize complete at 2013/06/21 17:15:47
Content-Transfer-Encoding: 7bit
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi tj,

On 06/20/2013 02:17 PM, Tejun Heo wrote:
......
>
> I was suggesting two separate things.
>
> * As memblock allocator can relocate itself.  There's no point in
>    avoiding setting NUMA node while parsing and registering NUMA
>    topology.  Just parse and register NUMA info and later tell it to
>    relocate itself out of hot-pluggable node.  A number of patches in
>    the series is doing this dancing - carefully reordering NUMA
>    probing.  No need to do that.  It's really fragile thing to do.
>
> * Once you get the above out of the way, I don't think there are a lot
>    of permanent allocations in the way before NUMA is initialized.
>    Re-order the remaining ones if that's cleaner to do.  If that gets
>    overly messy / fragile, copying them around or freeing and reloading
>    afterwards could be an option too.

memblock allocator can relocate itself, but it cannot relocate the memory
it allocated for users. There could be some pointers pointing to these
memory ranges. If we do the relocation, how to update these pointers ?

Or, do you mean modify the pagetable ?  I don't think so.

So would you please tell me more about how to do the relocation ?

Thanks. :)



Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754692Ab3DKHiv (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Apr 2013 03:38:51 -0400
Received: from cn.fujitsu.com ([222.73.24.84]:59454 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1751736Ab3DKHit (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Apr 2013 03:38:49 -0400
X-IronPort-AV: E=Sophos;i="4.87,454,1363104000"; 
   d="scan'208";a="7034580"
Message-ID: <51666930.6090702@cn.fujitsu.com>
Date: Thu, 11 Apr 2013 15:41:36 +0800
From: Tang Chen <tangchen@cn.fujitsu.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:12.0) Gecko/20120430 Thunderbird/12.0.1
MIME-Version: 1.0
To: Yinghai Lu <yinghai@kernel.org>
CC: Lin Feng <linfeng@cn.fujitsu.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Christoph Lameter <cl@linux.com>, Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, "H. Peter Anvin" <hpa@zytor.com>,
        Catalin Marinas <catalin.marinas@arm.com>, will.deacon@arm.com,
        Arnd Bergmann <arnd@arndb.de>, tony@atomide.com,
        Ben Hutchings <ben@decadent.org.uk>,
        linux-arm-kernel@lists.infradead.org,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        the arch/x86 maintainers <x86@kernel.org>,
        Linux MM <linux-mm@kvack.org>,
        Yasuaki Ishimatsu <isimatu.yasuaki@jp.fujitsu.com>,
        Jiang Liu <jiang.liu@huawei.com>
Subject: Re: [PATCH 0/2] mm: vmemmap: add vmemmap_verify check for hot-add
 node/memory case
References: <1365415000-10389-1-git-send-email-linfeng@cn.fujitsu.com> <CAE9FiQVaByGOTjLVthRkEze_ekXm5LAKgKdHzrD+q1iYmjgZFQ@mail.gmail.com>
In-Reply-To: <CAE9FiQVaByGOTjLVthRkEze_ekXm5LAKgKdHzrD+q1iYmjgZFQ@mail.gmail.com>
X-MIMETrack: Itemize by SMTP Server on mailserver/fnst(Release 8.5.3|September 15, 2011) at
 2013/04/11 15:37:31,
	Serialize by Router on mailserver/fnst(Release 8.5.3|September 15, 2011) at
 2013/04/11 15:37:35,
	Serialize complete at 2013/04/11 15:37:35
Content-Transfer-Encoding: 7bit
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Yinghai,

(Add cc Liu Jiang.)

On 04/09/2013 02:40 AM, Yinghai Lu wrote:
> On Mon, Apr 8, 2013 at 2:56 AM, Lin Feng<linfeng@cn.fujitsu.com>  wrote:
>> In hot add node(memory) case, vmemmap pages are always allocated from other
>> node,
>
> that is broken, and should be fixed.
> vmemmap should be on local node even for hot add node.
>

I want some info sharing. :)

Here is the work I'm trying to do.

1. As most of people don't like movablemem_map idea, we decide to
    drop "specifying physical address" thing, and restart a new solution
    to support using SRAT info only.

    We want to modify movablecore to support "movablecore=acpi" to
    enable/disable limiting hotpluggable memory in ZONE_MOVABLE.
    And we dropped all the old design and data structures.

2. As Liu Jiang mentioned before, we can add a flag to memblock to mark
    special memory. Since we are dropping all the old data structures,
    I think I want to reuse his idea to reserve movable memory with memblock
    when booting.

3. If we add flag to memblock, we can mark different memory. And I remember
    you mentioned before that we can use memblock to reserve local node 
data
    for node-life-cycle data, like vmemmap, pagetable.

    So are you doing the similar work now ?

    If not, I think I can merge it into mine, and push a new patch-set with
    hot-add, hot-remove code modified to support putting vmemmap, 
pagetable,
    pgdat, page_cgroup, ..., on local node.

    If you are doing the similar work, I will only finish my work and wait
    for your patch.

Thanks. :)











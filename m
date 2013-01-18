Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751256Ab3ARH7i (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Jan 2013 02:59:38 -0500
Received: from cn.fujitsu.com ([222.73.24.84]:33579 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1750755Ab3ARH7g (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Jan 2013 02:59:36 -0500
X-IronPort-AV: E=Sophos;i="4.84,490,1355068800"; 
   d="scan'208";a="6611077"
Message-ID: <50F900A3.4060903@cn.fujitsu.com>
Date: Fri, 18 Jan 2013 15:58:27 +0800
From: Lin Feng <linfeng@cn.fujitsu.com>
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:15.0) Gecko/20120911 Thunderbird/15.0.1
MIME-Version: 1.0
To: Michal Hocko <mhocko@suse.cz>
CC: akpm@linux-foundation.org, linux-mm@kvack.org, tglx@linutronix.de,
        mingo@redhat.com, hpa@zytor.com, jbeulich@suse.com,
        dhowells@redhat.com, wency@cn.fujitsu.com,
        isimatu.yasuaki@jp.fujitsu.com, paul.gortmaker@windriver.com,
        laijs@cn.fujitsu.com, kamezawa.hiroyu@jp.fujitsu.com, mel@csn.ul.ie,
        minchan@kernel.org, aquini@redhat.com, jiang.liu@huawei.com,
        tony.luck@intel.com, fenghua.yu@intel.com, benh@kernel.crashing.org,
        paulus@samba.org, schwidefsky@de.ibm.com, heiko.carstens@de.ibm.com,
        davem@davemloft.net, michael@ellerman.id.au,
        gerald.schaefer@de.ibm.com, gregkh@linuxfoundation.org, x86@kernel.org,
        linux390@de.ibm.com, linux-ia64@vger.kernel.org,
        linux-s390@vger.kernel.org, sparclinux@vger.kernel.org,
        linuxppc-dev@lists.ozlabs.org, linux-kernel@vger.kernel.org,
        tangchen@cn.fujitsu.com
Subject: Re: [PATCH v3 1/2] memory-hotplug: introduce CONFIG_HAVE_BOOTMEM_INFO_NODE
 and revert register_page_bootmem_info_node() when platform not support
References: <1358324059-9608-1-git-send-email-linfeng@cn.fujitsu.com> <1358324059-9608-2-git-send-email-linfeng@cn.fujitsu.com> <20130116141436.GE343@dhcp22.suse.cz> <50F7D456.9000904@cn.fujitsu.com> <20130117130509.GE20538@dhcp22.suse.cz>
In-Reply-To: <20130117130509.GE20538@dhcp22.suse.cz>
X-MIMETrack: Itemize by SMTP Server on mailserver/fnst(Release 8.5.3|September 15, 2011) at
 2013/01/18 15:58:44,
	Serialize by Router on mailserver/fnst(Release 8.5.3|September 15, 2011) at
 2013/01/18 15:58:46,
	Serialize complete at 2013/01/18 15:58:46
Content-Transfer-Encoding: 7bit
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Michal,

On 01/17/2013 09:05 PM, Michal Hocko wrote:
> On Thu 17-01-13 18:37:10, Lin Feng wrote:
> [...]
>>> > > I am still not sure I understand the relation to MEMORY_HOTREMOVE.
>>> > > Is register_page_bootmem_info_node required/helpful even if
>>> > > !CONFIG_MEMORY_HOTREMOVE?
>> > From old kenrel's view register_page_bootmem_info_node() is defined in 
>> > CONFIG_MEMORY_HOTPLUG_SPARSE, it registers some info for 
>> > memory hotplug/remove. If we don't use MEMORY_HOTPLUG feature, this
>> > function is empty, we don't need the info at all.
>> > So this info is not required/helpful if !CONFIG_MEMORY_HOTREMOVE.
> OK, then I suggest moving it under CONFIG_MEMORY_HOTREMOVE guards rather
> than CONFIG_MEMORY_HOTPLUG.
I can't agree more ;-) 
I also find that page_isolation.c selected by MEMORY_ISOLATION under MEMORY_HOTPLUG
is also such case, I fix it by the way.

thanks,
linfeng
> 

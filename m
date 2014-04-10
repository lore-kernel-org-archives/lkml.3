Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965372AbaDJDuh (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Apr 2014 23:50:37 -0400
Received: from cn.fujitsu.com ([59.151.112.132]:21588 "EHLO
	heian.cn.fujitsu.com" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S965326AbaDJDua (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Apr 2014 23:50:30 -0400
X-IronPort-AV: E=Sophos;i="4.97,831,1389715200"; 
   d="scan'208";a="29077341"
Message-ID: <5346146D.5030801@cn.fujitsu.com>
Date: Thu, 10 Apr 2014 11:47:57 +0800
From: Zhang Yanfei <zhangyanfei@cn.fujitsu.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20131030 Thunderbird/17.0.10
MIME-Version: 1.0
To: Li Zhong <zhong@linux.vnet.ibm.com>
CC: Dave Hansen <dave.hansen@intel.com>,
        Nathan Fontenot <nfont@linux.vnet.ibm.com>,
        Yasuaki Ishimatsu <isimatu.yasuaki@jp.fujitsu.com>,
        LKML <linux-kernel@vger.kernel.org>, <gregkh@linuxfoundation.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
        KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
Subject: Re: [RFC PATCH] memory driver: make phys_index/end_phys_index reflect
 the start/end section number
References: <1396429018.2913.19.camel@ThinkPad-T5421.cn.ibm.com>  <533E0B0E.9020909@jp.fujitsu.com>  <1396945659.3162.6.camel@ThinkPad-T5421.cn.ibm.com>  <53442021.2060608@intel.com> <53443E8C.4070906@linux.vnet.ibm.com>  <53456C12.7000905@intel.com> <1397099672.25199.43.camel@ThinkPad-T5421.cn.ibm.com>
In-Reply-To: <1397099672.25199.43.camel@ThinkPad-T5421.cn.ibm.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.167.226.197]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 04/10/2014 11:14 AM, Li Zhong wrote:
> On Wed, 2014-04-09 at 08:49 -0700, Dave Hansen wrote:
>> On 04/09/2014 02:20 AM, Li Zhong wrote:
>>> Or do you mean we don't need to expose any information related to
>>> SECTION to userspace? 
>>
>> Right, we don't need to expose sections themselves to userspace.  Do we?
>>
> OK, I agree with that. 
> 
> Yanfei, I recall you once expressed your preference for section
> numbers? 

Hmmm.... Looking at the git log:

commit d33601644cd3b09afb2edd9474517edc441c8fad
Author: Nathan Fontenot <nfont@austin.ibm.com>
Date:   Thu Jan 20 10:44:29 2011 -0600

    memory hotplug: Update phys_index to [start|end]_section_nr
    
    Update the 'phys_index' property of a the memory_block struct to be
    called start_section_nr, and add a end_section_nr property.  The
    data tracked here is the same but the updated naming is more in line
    with what is stored here, namely the first and last section number
    that the memory block spans.
    
    The names presented to userspace remain the same, phys_index for
    start_section_nr and end_phys_index for end_section_nr, to avoid breaking
    anything in userspace.
    
    This also updates the node sysfs code to be aware of the new capability for
    a memory block to contain multiple memory sections and be aware of the memory
    block structure name changes (start_section_nr).  This requires an additional
    parameter to unregister_mem_sect_under_nodes so that we know which memory
    section of the memory block to unregister.
    
    Signed-off-by: Nathan Fontenot <nfont@austin.ibm.com>
    Reviewed-by: Robin Holt <holt@sgi.com>
    Reviewed-by: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
    Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

So obviously, Nathan added the end_phys_index sysfile to present the last section
number of a memory block (for end_section_nr), but what he did in the patch
seems not matching the log.

So what is the motivation of adding this 'end_phys_index' file here?

Confused.

-- 
Thanks.
Zhang Yanfei

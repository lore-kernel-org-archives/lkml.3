Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755363Ab3EZWC6 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 26 May 2013 18:02:58 -0400
Received: from mail-vb0-f52.google.com ([209.85.212.52]:62014 "EHLO
	mail-vb0-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755257Ab3EZWC5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 26 May 2013 18:02:57 -0400
Message-ID: <51A2868E.4030905@gmail.com>
Date: Sun, 26 May 2013 18:02:54 -0400
From: KOSAKI Motohiro <kosaki.motohiro@gmail.com>
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.8; rv:17.0) Gecko/20130509 Thunderbird/17.0.6
MIME-Version: 1.0
To: Michal Hocko <mhocko@suse.cz>
CC: KOSAKI Motohiro <kosaki.motohiro@gmail.com>,
        Wanpeng Li <liwanp@linux.vnet.ibm.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
        David Rientjes <rientjes@google.com>, Jiang Liu <jiang.liu@huawei.com>,
        Tang Chen <tangchen@cn.fujitsu.com>,
        "linux-mm@kvack.org" <linux-mm@kvack.org>,
        LKML <linux-kernel@vger.kernel.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org
Subject: Re: [patch v2 3/6] mm/memory_hotplug: Disable memory hotremove for
 32bit
References: <1369547921-24264-1-git-send-email-liwanp@linux.vnet.ibm.com> <1369547921-24264-3-git-send-email-liwanp@linux.vnet.ibm.com> <20130526090054.GE10651@dhcp22.suse.cz> <CAHGf_=otK_LNgd6S09Fjjo0PfTSF3X0kj+=kGNyaTAze7m-b8w@mail.gmail.com> <20130526180933.GA20270@dhcp22.suse.cz>
In-Reply-To: <20130526180933.GA20270@dhcp22.suse.cz>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

(5/26/13 2:09 PM), Michal Hocko wrote:
> On Sun 26-05-13 07:58:42, KOSAKI Motohiro wrote:
>>>> As KOSAKI Motohiro mentioned, memory hotplug don't support 32bit since
>>>> it was born,
>>>
>>> Why? any reference? This reasoning is really weak.
>>
>> I have no seen any highmem support in memory hotplug code and I don't think this
>> patch fixes all 32bit highmem issue. If anybody are interesting to
>> support it, it is good thing. But in fact, _now_ it is broken when
>> enable HIGHMEM.
>> So, I just want to mark broken until someone want to support highmem
>> and verify overall.
>>
>> And, yes, this patch is no good. Kconfig doesn't describe why disable
>> when highmem.
>> So,
>>
>> depends on 64BIT || !HIGHMEM || BROKEN
>>
>> maybe clear documentation more.
> 
> I have no objection to disbale the feature for HIGHMEM configurations I
> was merely complaining that the patch didn't describe _why_.

No worry. I withdrew the claim because several people now willing to contribute
32bit highmem improvement. I don't want to block them.



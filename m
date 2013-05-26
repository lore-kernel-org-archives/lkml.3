Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752589Ab3EZL7F (ORCPT <rfc822;w@1wt.eu>);
	Sun, 26 May 2013 07:59:05 -0400
Received: from mail-ob0-f172.google.com ([209.85.214.172]:47134 "EHLO
	mail-ob0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752488Ab3EZL7D (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 26 May 2013 07:59:03 -0400
MIME-Version: 1.0
In-Reply-To: <20130526090054.GE10651@dhcp22.suse.cz>
References: <1369547921-24264-1-git-send-email-liwanp@linux.vnet.ibm.com>
 <1369547921-24264-3-git-send-email-liwanp@linux.vnet.ibm.com> <20130526090054.GE10651@dhcp22.suse.cz>
From: KOSAKI Motohiro <kosaki.motohiro@gmail.com>
Date: Sun, 26 May 2013 07:58:42 -0400
Message-ID: <CAHGf_=otK_LNgd6S09Fjjo0PfTSF3X0kj+=kGNyaTAze7m-b8w@mail.gmail.com>
Subject: Re: [patch v2 3/6] mm/memory_hotplug: Disable memory hotremove for 32bit
To: Michal Hocko <mhocko@suse.cz>
Cc: Wanpeng Li <liwanp@linux.vnet.ibm.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
        David Rientjes <rientjes@google.com>, Jiang Liu <jiang.liu@huawei.com>,
        Tang Chen <tangchen@cn.fujitsu.com>,
        "linux-mm@kvack.org" <linux-mm@kvack.org>,
        LKML <linux-kernel@vger.kernel.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>> As KOSAKI Motohiro mentioned, memory hotplug don't support 32bit since
>> it was born,
>
> Why? any reference? This reasoning is really weak.

I have no seen any highmem support in memory hotplug code and I don't think this
patch fixes all 32bit highmem issue. If anybody are interesting to
support it, it is good thing. But in fact, _now_ it is broken when
enable HIGHMEM.
So, I just want to mark broken until someone want to support highmem
and verify overall.

And, yes, this patch is no good. Kconfig doesn't describe why disable
when highmem.
So,

depends on 64BIT || !HIGHMEM || BROKEN

maybe clear documentation more.

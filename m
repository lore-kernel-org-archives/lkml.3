Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965767Ab3HIJmq (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 Aug 2013 05:42:46 -0400
Received: from cn.fujitsu.com ([222.73.24.84]:26098 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S965376Ab3HIJmn (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 Aug 2013 05:42:43 -0400
X-IronPort-AV: E=Sophos;i="4.89,844,1367942400"; 
   d="scan'208";a="8163013"
Message-ID: <5204B93A.6030409@cn.fujitsu.com>
Date: Fri, 09 Aug 2013 17:41:14 +0800
From: Tang Chen <tangchen@cn.fujitsu.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:12.0) Gecko/20120430 Thunderbird/12.0.1
MIME-Version: 1.0
To: Yinghai Lu <yinghai@kernel.org>
CC: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>,
        Bob Moore <robert.moore@intel.com>, Lv Zheng <lv.zheng@intel.com>,
        "Rafael J. Wysocki" <rjw@sisk.pl>, Len Brown <lenb@kernel.org>,
        Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@elte.hu>,
        "H. Peter Anvin" <hpa@zytor.com>,
        Andrew Morton <akpm@linux-foundation.org>, Tejun Heo <tj@kernel.org>,
        Thomas Renninger <trenn@suse.de>, Jiang Liu <jiang.liu@huawei.com>,
        Zhang Yanfei <zhangyanfei@cn.fujitsu.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        ACPI Devel Maling List <linux-acpi@vger.kernel.org>
Subject: Re: [PATCH part4 2/4] x86, acpica, acpi: Try to find if SRAT is overrided
 earlier.
References: <1375954883-30225-1-git-send-email-tangchen@cn.fujitsu.com> <1375954883-30225-3-git-send-email-tangchen@cn.fujitsu.com> <CAE9FiQXUS9+heHagD45WAyO22NiGDMo3j2JumzvscypVhnjn9A@mail.gmail.com>
In-Reply-To: <CAE9FiQXUS9+heHagD45WAyO22NiGDMo3j2JumzvscypVhnjn9A@mail.gmail.com>
X-MIMETrack: Itemize by SMTP Server on mailserver/fnst(Release 8.5.3|September 15, 2011) at
 2013/08/09 17:41:09,
	Serialize by Router on mailserver/fnst(Release 8.5.3|September 15, 2011) at
 2013/08/09 17:41:16,
	Serialize complete at 2013/08/09 17:41:16
Content-Transfer-Encoding: 7bit
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 08/09/2013 12:29 AM, Yinghai Lu wrote:
......
>
> Please check if you can reuse first half of my patchset, so find and copy
> override table earlier. the copied acpi tables could be near kernel code range.
>

I don't think we need to do the finding step at that early time, in
head64.c stage.

Before pagetables are setup, we can use early_ioremap() to map the
memory we want to access. We don't need to use phys addr. We can do
it in setup_arch(), which has nothing to do with 32bit or 64bit.

> Move finding in head64.c stage could help xen/dom0 a bit.
> as Konrad is working on patchset with acpi override in xen hypervisor.
> We can avoid override acpi table two times. Esp xen like to change
> DMAR to XMAR.

Would you please give some more info about this, and explain why finding
override tables in head64.c stage is helpful for xen ?

Thanks.


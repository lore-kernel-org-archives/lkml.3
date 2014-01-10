Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752491AbaAJJQb (ORCPT <rfc822;w@1wt.eu>);
	Fri, 10 Jan 2014 04:16:31 -0500
Received: from mx1.redhat.com ([209.132.183.28]:44268 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751596AbaAJJQJ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 10 Jan 2014 04:16:09 -0500
Date: Fri, 10 Jan 2014 17:14:33 +0800
From: Baoquan <bhe@redhat.com>
To: Yasuaki Ishimatsu <isimatu.yasuaki@jp.fujitsu.com>
Cc: Toshi Kani <toshi.kani@hp.com>, Vivek Goyal <vgoyal@redhat.com>,
        kexec@lists.infradead.org, "Rafael J. Wysocki" <rjw@rjwysocki.net>,
        linux-kernel@vger.kernel.org, tangchen@cn.fujitsu.com,
        linux-acpi@vger.kernel.org, zhangyanfei@cn.fujitsu.com,
        dyoung@redhat.com
Subject: Re: kdump failed because of hotplug memory adding in kdump kernel
Message-ID: <20140110091433.GA14074@dhcp-16-105.nay.redhat.com>
References: <20140109145035.GB25897@redhat.com>
 <1389283439.1792.66.camel@misato.fc.hp.com>
 <20140109162427.GF25897@redhat.com>
 <1389288265.1792.108.camel@misato.fc.hp.com>
 <20140109182310.GG25897@redhat.com>
 <1389292470.1792.109.camel@misato.fc.hp.com>
 <20140109212705.GC12111@redhat.com>
 <1389304583.1792.139.camel@misato.fc.hp.com>
 <20140110071124.GA6464@dhcp-16-105.nay.redhat.com>
 <52CFAA20.2010109@jp.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <52CFAA20.2010109@jp.fujitsu.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


 >In ns
> >object tree, they are not treated as hotplug memory.
> 
> wrong.
> They are treated as hotplug memory. But the memory cannot hot removed
> because the memory has kernel memory.
> 
> >Otherwise, any hotplug memory which is not reserved for 2nd kernel can
> >be parsed and need be added as hotplug memory, and add them into movable
> >zone.
> 
> wrong.
> The memory is allocated as normal zone and it is offline.

Hi,

Thanks for answering.

I am confused. Now the fact is in 1st kernel memory is reserved for
crashkernel and passed to 2nd kernel by exactmap. Then in 2nd kernel,
reserved memory regions are added into e820. Later hotplug memory still
trigger add_memory, and cause bug I reported.


> 
> >
> >Am I right?
> >
> 
> >The other question, e820 reserve is done earlier than acpi
> >initialization, because acpi_early_init() invocation is very late in
> >start_kernel(). Does that means at the very beginning all memorys are in
> >e820, later when acpi_early_init is called, hotplug memory is detected,
> >they will be moved to different place or need be marked with a specific
> >flag?
> 
> No.
> 
> Thanks,
> Yasuaki Ishimatsu
> 


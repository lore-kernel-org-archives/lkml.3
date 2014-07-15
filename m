Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760790AbaGOXzk (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Jul 2014 19:55:40 -0400
Received: from terminus.zytor.com ([198.137.202.10]:60768 "EHLO mail.zytor.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757199AbaGOXzf (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Jul 2014 19:55:35 -0400
Message-ID: <53C5BF46.3070604@zytor.com>
Date: Tue, 15 Jul 2014 16:54:46 -0700
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.6.0
MIME-Version: 1.0
To: Yinghai Lu <yinghai@kernel.org>, Bjorn Helgaas <bhelgaas@google.com>
CC: Fabio Coatti <fabio.coatti@gmail.com>,
        Stephane Eranian <eranian@google.com>,
        Peter Zijlstra <peterz@infradead.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        LKML <linux-kernel@vger.kernel.org>, Ingo Molnar <mingo@kernel.org>,
        Arnaldo Carvalho de Melo <acme@redhat.com>,
        "ak@linux.intel.com" <ak@linux.intel.com>,
        "Yan, Zheng" <zheng.z.yan@intel.com>,
        "Rafael J. Wysocki" <rjw@rjwysocki.net>
Subject: Re: WARNING: CPU: 2 PID: 1 at arch/x86/mm/ioremap.c:171 __ioremap_caller+0x290/0x2fa()
References: <CADpTngUm7d88RJS9OV=64t6QrJU4r3M_Z8eV1QYWPeeB5SX5-w@mail.gmail.com>	<CABPqkBTu9vk_wsmYVrO6OOxgbwsLDG-A8f7dzutKwYXmoGsqnw@mail.gmail.com>	<20140710200527.GA15190@google.com>	<3524198.dm6HbYTJqK@calvin>	<CAErSpo4xH2hpPMhm-4F+jNGKeMPjA2Tr8bQEkbWQGXpbwX6W4g@mail.gmail.com>	<CAErSpo5u_KAfZL0EDVGCZ5nfvmiyv+V3+5Lw6aYoXvTouv_MeQ@mail.gmail.com> <CAE9FiQVN1WLigYt7YGHsd1f+BreApubYbjC9j9tzrCe-p5f=HA@mail.gmail.com>
In-Reply-To: <CAE9FiQVN1WLigYt7YGHsd1f+BreApubYbjC9j9tzrCe-p5f=HA@mail.gmail.com>
X-Enigmail-Version: 1.6
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 07/15/2014 04:40 PM, Yinghai Lu wrote:
>>
>> One of the reasons for iomem_resource is so we don't hand out the same
>> address space to two different devices.  We *could* do that by keeping
>> track of the union of all devices and reserved areas that we know
>> about.
>>
>> But the current resource code is more strict: it enforces a hierarchy.
>> For example, in this case, it rejects the 00:00 PNP resource because
>> it is larger than the e820 entry.  The problem with rejecting it is
>> that we might hand out [mem 0xfed14000-0xfed17fff] to another device
>> even though PNP told us that it's in use.
>>
>> I'm about to head out for a few weeks of vacation, so I won't be able
>> to do anything with this.
> 
> In that case, we could reserve the whole MCH range in e820 from
> trim_snb_memory() instead.
> 
> HPA, what is your idea about it?
> 
> Yinghai
> 

We could quirk it, but we would have to make bloody darn sure that we
don't break any systems because of unusual configuration and so on.

I agree that we need to treat fixed resources as equivalent to reserved.
 This is also a BIOS bug (it should reserve the whole region), but that
happens far too frequently.  I don't know if we have any way to do that
without massive surgery to the current code, though.

	-hpa


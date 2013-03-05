Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752577Ab3CEHoV (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Mar 2013 02:44:21 -0500
Received: from e28smtp05.in.ibm.com ([122.248.162.5]:34292 "EHLO
	e28smtp05.in.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750762Ab3CEHoU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Mar 2013 02:44:20 -0500
Message-ID: <5135A248.4010205@linux.vnet.ibm.com>
Date: Tue, 05 Mar 2013 15:44:08 +0800
From: Mike Qiu <qiudayu@linux.vnet.ibm.com>
User-Agent: Mozilla/5.0 (Windows NT 6.1; WOW64; rv:17.0) Gecko/20130215 Thunderbird/17.0.3
MIME-Version: 1.0
To: Paul Mundt <lethal@linux-sh.org>
CC: linuxppc-dev@lists.ozlabs.org, linux-kernel@vger.kernel.org,
        benh@kernel.crashing.org, tglx@linutronix.de
Subject: Re: [PATCH 2/3] irq: Add hw continuous IRQs map to virtual continuous
 IRQs support
References: <1358235536-32741-1-git-send-email-qiudayu@linux.vnet.ibm.com> <1358235536-32741-3-git-send-email-qiudayu@linux.vnet.ibm.com> <20130305024110.GB14275@linux-sh.org>
In-Reply-To: <20130305024110.GB14275@linux-sh.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 13030507-8256-0000-0000-00000678BD58
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

于 2013/3/5 10:41, Paul Mundt 写道:
> On Tue, Jan 15, 2013 at 03:38:55PM +0800, Mike Qiu wrote:
>> Adding a function irq_create_mapping_many() which can associate
>> multiple MSIs to a continous irq mapping.
>>
>> This is needed to enable multiple MSI support for pSeries.
>>
>> +int irq_create_mapping_many(struct irq_domain *domain,
>> +		irq_hw_number_t hwirq_base, int count)
>> +{
> Other than the other review comments already made, I think you can
> simplify this considerably by simply doing what irq_create_strict_mappings() does,
> and relaxing the irq_base requirements.
>
> In any event, as you are creating a new interface, I don't think you want
> to carry around half of the legacy crap that irq_create_mapping() has to
> deal with. We made the decision to avoid this with irq_create_strict_mappings()
> intentionally, too.
>
Oh, yes, you are right, I will send out V2 of my patch to make it more 
comfortable , and hope you can review my patch again

Thanks

Mike


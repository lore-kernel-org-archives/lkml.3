Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755054AbaIQDIP (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Sep 2014 23:08:15 -0400
Received: from mga02.intel.com ([134.134.136.20]:55180 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754759AbaIQDIM (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Sep 2014 23:08:12 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.04,538,1406617200"; 
   d="scan'208";a="603941955"
Message-ID: <5418FAE1.4030008@linux.intel.com>
Date: Wed, 17 Sep 2014 11:07:13 +0800
From: Jiang Liu <jiang.liu@linux.intel.com>
Organization: Intel
User-Agent: Mozilla/5.0 (Windows NT 6.2; WOW64; rv:24.0) Gecko/20100101 Thunderbird/24.5.0
MIME-Version: 1.0
To: Thomas Gleixner <tglx@linutronix.de>
CC: Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Ingo Molnar <mingo@redhat.com>, "H. Peter Anvin" <hpa@zytor.com>,
        "Rafael J. Wysocki" <rjw@rjwysocki.net>,
        Bjorn Helgaas <bhelgaas@google.com>,
        Randy Dunlap <rdunlap@infradead.org>, Yinghai Lu <yinghai@kernel.org>,
        Borislav Petkov <bp@alien8.de>, Grant Likely <grant.likely@linaro.org>,
        Marc Zyngier <marc.zyngier@arm.com>,
        Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Tony Luck <tony.luck@intel.com>, Joerg Roedel <joro@8bytes.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>, x86@kernel.org,
        linux-kernel@vger.kernel.org, linux-pci@vger.kernel.org,
        linux-acpi@vger.kernel.org, linux-arm-kernel@lists.infradead.org
Subject: Re: [RFC Part2 v1 02/21] genirq: Introduce helper functions to support
 stacked irq_chip
References: <1410444228-3134-1-git-send-email-jiang.liu@linux.intel.com> <1410444228-3134-3-git-send-email-jiang.liu@linux.intel.com> <alpine.DEB.2.10.1409161044330.4247@nanos>
In-Reply-To: <alpine.DEB.2.10.1409161044330.4247@nanos>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On 2014/9/17 1:45, Thomas Gleixner wrote:
> On Thu, 11 Sep 2014, Jiang Liu wrote:
>> +#ifdef	CONFIG_IRQ_DOMAIN_HIERARCHY
>> +void irq_chip_ack_parent(struct irq_data *data)
>> +{
>> +	data = data->parent_data;
>> +	if (data && data->chip && data->chip->irq_ack)
>> +		data->chip->irq_ack(data);
> 
> Why is this restricted to a single parent level and does not go down
> the whole stack?
Hi Thomas,
	It happens to work on x86, and we want to achieve a bit
performance advantage by not walking down the whole stack.
If preferred, I will change it to walk the whole stack.
Regards!
Gerry

> 
> Thanks,
> 
> 	tglx
> 

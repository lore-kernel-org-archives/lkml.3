Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1422928Ab3FUAzH (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Jun 2013 20:55:07 -0400
Received: from mga09.intel.com ([134.134.136.24]:40537 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1422664Ab3FUAzF (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Jun 2013 20:55:05 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.87,908,1363158000"; 
   d="scan'208";a="353268281"
Message-ID: <51C3A489.1050905@intel.com>
Date: Fri, 21 Jun 2013 08:55:37 +0800
From: Aaron Lu <aaron.lu@intel.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130514 Thunderbird/17.0.6
MIME-Version: 1.0
To: Sergei Shtylyov <sergei.shtylyov@cogentembedded.com>
CC: Aaron Lu <aaron.lu@intel.com>, Tejun Heo <tj@kernel.org>,
        Matthew Garrett <mjg@redhat.com>, Liu Jiang <liuj97@gmail.com>,
        Dirk Griesbach <spamthis@freenet.de>, linux-ide@vger.kernel.org,
        linux-kernel@vger.kernel.org, Liu Jiang <jiang.liu@huawei.com>
Subject: Re: [PATCH] libata: remove dead code from libata-acpi.c
References: <1371265368-7334-1-git-send-email-liuj97@gmail.com> <51BE6B5C.70803@intel.com> <20130617180151.GG32663@mtj.dyndns.org> <51C02571.3090100@intel.com> <51C26861.9050106@intel.com> <51C2E12F.4000603@cogentembedded.com>
In-Reply-To: <51C2E12F.4000603@cogentembedded.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 06/20/2013 07:02 PM, Sergei Shtylyov wrote:
> Hello.

Hi,

Thanks for your comments.

> 
> On 20-06-2013 6:26, Aaron Lu wrote:
>>
>> +void ata_acpi_hotplug_init(struct ata_host *host)
>> +{
>> +	int i;
>> +
>> +	for (i = 0; i < host->n_ports; i++) {
>> +		struct ata_port *ap = host->ports[i];
>> +		acpi_handle handle;
>> +		struct ata_device *dev;
>> +
>> +		if (!ap)
>> +			continue;
>> +
>> +		handle = ata_ap_acpi_handle(ap);
>> +		if (handle) {
>> +			/* we might be on a docking station */
>> +			register_hotplug_dock_device(handle,
>> +					&ata_acpi_ap_dock_ops, ap);
> 
>     Please indent this line under the next character after ( above.

Is there a link about this rule? I might have missed something about
coding style.

Thanks,
Aaron

> 
>> +		}
>> +
>> +		ata_for_each_dev(dev, &ap->link, ALL) {
>> +			handle = ata_dev_acpi_handle(dev);
>> +			if (handle) {
>> +				/* we might be on a docking station */
>> +				register_hotplug_dock_device(handle,
>> +						&ata_acpi_dev_dock_ops, dev);
> 
>     Same comment.
> 
> WBR, Sergei
> 

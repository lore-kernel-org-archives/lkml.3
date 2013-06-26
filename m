Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751631Ab3FZCB2 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Jun 2013 22:01:28 -0400
Received: from mga09.intel.com ([134.134.136.24]:5490 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751195Ab3FZCB1 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Jun 2013 22:01:27 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.87,940,1363158000"; 
   d="scan'208";a="359623418"
Message-ID: <51CA4B94.3040008@intel.com>
Date: Wed, 26 Jun 2013 10:01:56 +0800
From: Aaron Lu <aaron.lu@intel.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130514 Thunderbird/17.0.6
MIME-Version: 1.0
To: James Bottomley <James.Bottomley@HansenPartnership.com>
CC: Sergei Shtylyov <sergei.shtylyov@cogentembedded.com>,
        Tejun Heo <tj@kernel.org>, Matthew Garrett <mjg@redhat.com>,
        Liu Jiang <liuj97@gmail.com>, Dirk Griesbach <spamthis@freenet.de>,
        linux-ide@vger.kernel.org, linux-kernel@vger.kernel.org,
        Liu Jiang <jiang.liu@huawei.com>
Subject: Re: [PATCH] libata: remove dead code from libata-acpi.c
References: <1371265368-7334-1-git-send-email-liuj97@gmail.com>  <51BE6B5C.70803@intel.com> <20130617180151.GG32663@mtj.dyndns.org>  <51C02571.3090100@intel.com> <51C26861.9050106@intel.com>  <51C2E12F.4000603@cogentembedded.com> <51C3A489.1050905@intel.com> <1371828346.3040.3.camel@dabdike>
In-Reply-To: <1371828346.3040.3.camel@dabdike>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 06/21/2013 11:25 PM, James Bottomley wrote:
> On Fri, 2013-06-21 at 08:55 +0800, Aaron Lu wrote:
>> On 06/20/2013 07:02 PM, Sergei Shtylyov wrote:
>>> Hello.
>>
>> Hi,
>>
>> Thanks for your comments.
>>
>>>
>>> On 20-06-2013 6:26, Aaron Lu wrote:
>>>>
>>>> +void ata_acpi_hotplug_init(struct ata_host *host)
>>>> +{
>>>> +	int i;
>>>> +
>>>> +	for (i = 0; i < host->n_ports; i++) {
>>>> +		struct ata_port *ap = host->ports[i];
>>>> +		acpi_handle handle;
>>>> +		struct ata_device *dev;
>>>> +
>>>> +		if (!ap)
>>>> +			continue;
>>>> +
>>>> +		handle = ata_ap_acpi_handle(ap);
>>>> +		if (handle) {
>>>> +			/* we might be on a docking station */
>>>> +			register_hotplug_dock_device(handle,
>>>> +					&ata_acpi_ap_dock_ops, ap);
>>>
>>>     Please indent this line under the next character after ( above.
>>
>> Is there a link about this rule? I might have missed something about
>> coding style.
> 
> The rule is follow the coding style in the file, unless there's
> something really wrong with it (which there might be in the case of
> really old drivers).  The reason is that a mixture of coding styles
> makes the file much harder to read than a single consistent style.

Oh right, that's the rule I missed. Thanks for letting me know.

> 
> In this case, if you look at libata-acpi.c you see all continuation
> lines of function calls are aligned with open braces.

Indeed.

-Aaron

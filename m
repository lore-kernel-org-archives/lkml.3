Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751687Ab3FZG1Y (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 Jun 2013 02:27:24 -0400
Received: from mga03.intel.com ([143.182.124.21]:2445 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751374Ab3FZG1X (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 Jun 2013 02:27:23 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.87,941,1363158000"; 
   d="scan'208";a="322691520"
Message-ID: <51CA89E8.6050800@intel.com>
Date: Wed, 26 Jun 2013 14:27:52 +0800
From: Aaron Lu <aaron.lu@intel.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130514 Thunderbird/17.0.6
MIME-Version: 1.0
To: Sergei Shtylyov <sergei.shtylyov@cogentembedded.com>
CC: Tejun Heo <tj@kernel.org>, Matthew Garrett <mjg@redhat.com>,
        Liu Jiang <liuj97@gmail.com>, Dirk Griesbach <spamthis@freenet.de>,
        linux-ide@vger.kernel.org, linux-kernel@vger.kernel.org,
        Liu Jiang <jiang.liu@huawei.com>
Subject: Re: [PATCH] libata: remove dead code from libata-acpi.c
References: <1371265368-7334-1-git-send-email-liuj97@gmail.com> <51BE6B5C.70803@intel.com> <20130617180151.GG32663@mtj.dyndns.org> <51C02571.3090100@intel.com> <51C26861.9050106@intel.com> <51C2E12F.4000603@cogentembedded.com> <51C3A489.1050905@intel.com> <51C43A6D.6060806@cogentembedded.com>
In-Reply-To: <51C43A6D.6060806@cogentembedded.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 06/21/2013 07:35 PM, Sergei Shtylyov wrote:
> Hello.
> 
> On 21-06-2013 4:55, Aaron Lu wrote:
> 
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
> 
>>>      Please indent this line under the next character after ( above.
> 
>> Is there a link about this rule? I might have missed something about
>> coding style.
> 
>     Don't think so. This is a rule in some subsystems like networking, 
> and it's also the way Emacs does such things. So, in principle, you can 
> ignore my comment (although libata seems to also use this style).

FYI, the updated patch has been sent by Rafael for me:
http://marc.info/?l=linux-acpi&m=137207724507019&w=2
with your suggestion taken.

Thanks,
Aaron

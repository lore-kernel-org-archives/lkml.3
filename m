Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965663Ab3FULfO (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 Jun 2013 07:35:14 -0400
Received: from mail-la0-f45.google.com ([209.85.215.45]:45993 "EHLO
	mail-la0-f45.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754870Ab3FULfM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 Jun 2013 07:35:12 -0400
Message-ID: <51C43A6D.6060806@cogentembedded.com>
Date: Fri, 21 Jun 2013 15:35:09 +0400
From: Sergei Shtylyov <sergei.shtylyov@cogentembedded.com>
User-Agent: Mozilla/5.0 (Windows NT 6.1; WOW64; rv:17.0) Gecko/20130509 Thunderbird/17.0.6
MIME-Version: 1.0
To: Aaron Lu <aaron.lu@intel.com>
CC: Tejun Heo <tj@kernel.org>, Matthew Garrett <mjg@redhat.com>,
        Liu Jiang <liuj97@gmail.com>, Dirk Griesbach <spamthis@freenet.de>,
        linux-ide@vger.kernel.org, linux-kernel@vger.kernel.org,
        Liu Jiang <jiang.liu@huawei.com>
Subject: Re: [PATCH] libata: remove dead code from libata-acpi.c
References: <1371265368-7334-1-git-send-email-liuj97@gmail.com> <51BE6B5C.70803@intel.com> <20130617180151.GG32663@mtj.dyndns.org> <51C02571.3090100@intel.com> <51C26861.9050106@intel.com> <51C2E12F.4000603@cogentembedded.com> <51C3A489.1050905@intel.com>
In-Reply-To: <51C3A489.1050905@intel.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello.

On 21-06-2013 4:55, Aaron Lu wrote:

>>> +void ata_acpi_hotplug_init(struct ata_host *host)
>>> +{
>>> +	int i;
>>> +
>>> +	for (i = 0; i < host->n_ports; i++) {
>>> +		struct ata_port *ap = host->ports[i];
>>> +		acpi_handle handle;
>>> +		struct ata_device *dev;
>>> +
>>> +		if (!ap)
>>> +			continue;
>>> +
>>> +		handle = ata_ap_acpi_handle(ap);
>>> +		if (handle) {
>>> +			/* we might be on a docking station */
>>> +			register_hotplug_dock_device(handle,
>>> +					&ata_acpi_ap_dock_ops, ap);

>>      Please indent this line under the next character after ( above.

> Is there a link about this rule? I might have missed something about
> coding style.

    Don't think so. This is a rule in some subsystems like networking, 
and it's also the way Emacs does such things. So, in principle, you can 
ignore my comment (although libata seems to also use this style).

WBR, Sergei


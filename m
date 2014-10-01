Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752661AbaJAVUE (ORCPT <rfc822;w@1wt.eu>);
	Wed, 1 Oct 2014 17:20:04 -0400
Received: from mail-bl2on0102.outbound.protection.outlook.com ([65.55.169.102]:60672
	"EHLO na01-bl2-obe.outbound.protection.outlook.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751208AbaJAVUB (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 1 Oct 2014 17:20:01 -0400
X-WSS-ID: 0NCSB92-08-ZFF-02
X-M-MSG: 
Message-ID: <542C6FE9.10903@amd.com>
Date: Wed, 1 Oct 2014 16:19:37 -0500
From: Suravee Suthikulanit <suravee.suthikulpanit@amd.com>
User-Agent: Mozilla/5.0 (Windows NT 6.1; WOW64; rv:31.0) Gecko/20100101 Thunderbird/31.1.2
MIME-Version: 1.0
To: Matthew Garrett <mjg59@srcf.ucam.org>
CC: <catalin.marinas@arm.com>, <will.deacon@arm.com>,
        <linux-arm-kernel@lists.infradead.org>, <linux-acpi@vger.kernel.org>,
        <mark.rutland@arm.com>, <arnd@arndb.de>, <graeme.gregory@linaro.org>,
        <marc.zyngier@arm.com>, <rjw@rjwysocki.net>,
        <linux-kernel@vger.kernel.org>, <astone@redhat.com>,
        <grant.likely@linaro.org>, <hanjun.guo@linaro.org>,
        <Sudeep.Holla@arm.com>, <olof@lixom.net>, <jason@lakedaemon.net>,
        "Duran, Leo" <leo.duran@amd.com>, Jon Masters <jcm@redhat.com>
Subject: Re: [PATCH 1/4] ata: ahci_platform: Add ACPI support for AMD Seattle
 SATA controller
References: <1410828446-28502-1-git-send-email-suravee.suthikulpanit@amd.com>
 <1410828446-28502-2-git-send-email-suravee.suthikulpanit@amd.com>
 <20140917012614.GA31214@srcf.ucam.org>
In-Reply-To: <20140917012614.GA31214@srcf.ucam.org>
Content-Type: text/plain; charset="windows-1252"; format=flowed
Content-Transfer-Encoding: 7bit
X-EOPAttributedMessage: 0
X-Forefront-Antispam-Report: CIP:165.204.84.222;CTRY:US;IPV:NLI;EFV:NLI;SFV:NSPM;SFS:(10019020)(6009001)(428002)(24454002)(377454003)(199003)(51704005)(189002)(164054003)(479174003)(97736003)(101416001)(54356999)(86362001)(120886001)(50986999)(105586002)(68736004)(64126003)(23746002)(4396001)(50466002)(65816999)(76176999)(107046002)(21056001)(83506001)(120916001)(10300001)(19580395003)(19580405001)(33656002)(85852003)(31966008)(46102003)(85306004)(84676001)(110136001)(20776003)(102836001)(44976005)(36756003)(99396003)(92726001)(92566001)(76482002)(80022003)(65806001)(95666004)(64706001)(87936001)(47776003)(65956001)(106466001);DIR:OUT;SFP:1102;SCL:1;SRVR:BLUPR02MB196;H:atltwp02.amd.com;FPR:;MLV:sfv;PTR:InfoDomainNonexistent;A:1;MX:1;LANG:en;
X-Microsoft-Antispam: UriScan:;
X-Microsoft-Antispam: BCL:0;PCL:0;RULEID:;SRVR:BLUPR02MB196;
X-Forefront-PRVS: 0351D213B3
Authentication-Results: spf=none (sender IP is 165.204.84.222)
 smtp.mailfrom=Suravee.Suthikulpanit@amd.com; 
X-OriginatorOrg: amd4.onmicrosoft.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 9/16/2014 8:26 PM, Matthew Garrett wrote:
> On Mon, Sep 15, 2014 at 07:47:23PM -0500, suravee.suthikulpanit@amd.com wrote:
>> From: Suravee Suthikulpanit <Suravee.Suthikulpanit@amd.com>
>>
>> This patch adds ACPI match table in ahci_platform. The table includes
>> the acpi_device_id to match AMD Seattle SATA controller with following
>> asl structure in DSDT:
>>
>>      Device (SATA0)
>>      {
>>        Name(_HID, "AMDI0600")	// Seattle AHSATA
>
> There really ought to be a well-defined PNPID for AHCI, so you can _HID
> to AMD and _CID to something generic. That way we won't have:
>
>> +#ifdef CONFIG_ATA_ACPI
>> +static const struct acpi_device_id ahci_acpi_match[] = {
>> +	{ "AMDI0600", 0 }, /* AMD Seattle AHCI */
>> +	{ },
>> +};
>
> utter sadness here. Really, please don't end up in a situation where we
> need to add device-specific IDs to a generic driver.
>
Matthew,

Currently, there is no _CID defined for generic AHCI. We will work on 
proposing one, and provide update patches for including the new ID.

Thanks,
Suravee


Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753294AbaIXTlN (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Sep 2014 15:41:13 -0400
Received: from e9.ny.us.ibm.com ([32.97.182.139]:33312 "EHLO e9.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751237AbaIXTlL (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Sep 2014 15:41:11 -0400
Message-ID: <54231E52.2030501@linux.vnet.ibm.com>
Date: Wed, 24 Sep 2014 15:41:06 -0400
From: Stefan Berger <stefanb@linux.vnet.ibm.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.6.0
MIME-Version: 1.0
To: Scot Doyle <lkml14@scotdoyle.com>
CC: Peter Huewe <peterhuewe@gmx.de>, Ashley Lai <ashley@ashleylai.com>,
        Marcel Selhorst <tpmdd@selhorst.net>,
        Jason Gunthorpe <jgunthorpe@obsidianresearch.com>,
        Luigi Semenzato <semenzato@google.com>,
        Michael Mullin <masmullin@gmail.com>, linux-kernel@vger.kernel.org,
        tpmdd-devel@lists.sourceforge.net
Subject: Re: [PATCH v9] tpm_tis: verify interrupt during init
References: <20140827214743.GC11183@obsidianresearch.com> <alpine.LNX.2.11.1408280017420.1064@localhost.localdomain> <20140828165348.GE11183@obsidianresearch.com> <alpine.LNX.2.11.1408290234060.1020@localhost.localdomain> <20140830174920.GA26218@obsidianresearch.com> <alpine.LNX.2.11.1408302229001.579@localhost.localdomain> <20140902172015.GD13956@obsidianresearch.com> <alpine.LNX.2.11.1409021954110.1026@localhost.localdomain> <20140908220238.GB6204@obsidianresearch.com> <alpine.LNX.2.11.1409110010290.700@localhost.localdomain> <20140922171338.GB28082@obsidianresearch.com> <alpine.DEB.2.11.1409230232080.3995@localhost.localdomain> <alpine.DEB.2.11.1409230247010.4292@localhost.localdomain> <alpine.DEB.2.11.1409231136410.2947@localhost.localdomain> <5421A9F8.9070301@linux.vnet.ibm.com> <alpine.DEB.2.11.1409241936270.3152@localhost.localdomain>
In-Reply-To: <alpine.DEB.2.11.1409241936270.3152@localhost.localdomain>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-TM-AS-MML: disable
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 14092419-7182-0000-0000-0000008A5910
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 09/24/2014 03:38 PM, Scot Doyle wrote:
> On Tue, 23 Sep 2014, Stefan Berger wrote:
>> On 09/23/2014 07:55 AM, Scot Doyle wrote:
>>> On Tue, 23 Sep 2014, Scot Doyle wrote:
>>> +static void disable_interrupts(struct tpm_chip *chip)
>>> +{
>>> +	u32 intmask;
>>> +	intmask =
>>> +	    ioread32(chip->vendor.iobase +
>>> +		     TPM_INT_ENABLE(chip->vendor.locality));
>>> +	intmask |= TPM_INTF_CMD_READY_INT | TPM_INTF_LOCALITY_CHANGE_INT |
>>> +		   TPM_INTF_DATA_AVAIL_INT | TPM_INTF_STS_VALID_INT;
>> You want to disable interrupts but you set all the flags? Maybe you meant:
>>
>> intmask &= ~(FOO|BAR)
>>
>> ?
> Thanks, would this work? I think it's how tpm_tis_init masks during a probe.
>
> static void disable_interrupts(struct tpm_chip *chip)
> {
> 	u32 intmask;
> 	intmask =
> 	    ioread32(chip->vendor.iobase +
> 		     TPM_INT_ENABLE(chip->vendor.locality));
> 	intmask &= ~TPM_GLOBAL_INT_ENABLE;
> 	iowrite32(intmask,
> 		  chip->vendor.iobase +
> 		  TPM_INT_ENABLE(chip->vendor.locality));
> 	free_irq(chip->vendor.irq, chip);
> 	chip->vendor.irq = 0;
> }
>
Yes, this should be sufficient.

     Stefan


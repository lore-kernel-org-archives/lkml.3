Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932703AbaHFQ4V (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Aug 2014 12:56:21 -0400
Received: from bear.ext.ti.com ([192.94.94.41]:52950 "EHLO bear.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932695AbaHFQ4S (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Aug 2014 12:56:18 -0400
Message-ID: <53E25E24.8070506@ti.com>
Date: Wed, 6 Aug 2014 12:56:04 -0400
From: Murali Karicheri <m-karicheri2@ti.com>
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:12.0) Gecko/20120430 Thunderbird/12.0.1
MIME-Version: 1.0
To: Jason Gunthorpe <jgunthorpe@obsidianresearch.com>
CC: <linux-pci@vger.kernel.org>, <linux-arm-kernel@lists.infradead.org>,
        <linux-kernel@vger.kernel.org>, <bhelgaas@google.com>
Subject: Re: [PATCH] PCI: keystone: add a pci quirk to limit mrrs
References: <1407338300-9146-1-git-send-email-m-karicheri2@ti.com> <20140806163021.GB19914@obsidianresearch.com>
In-Reply-To: <20140806163021.GB19914@obsidianresearch.com>
Content-Type: text/plain; charset="ISO-8859-1"; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 08/06/2014 12:30 PM, Jason Gunthorpe wrote:
> On Wed, Aug 06, 2014 at 11:18:20AM -0400, Murali Karicheri wrote:
>> Keystone PCI controller has a limitation that memory read request
>> size must not exceed 256 bytes. This is a hardware limitation and
>> add a quirk to force this limit on all downstream devices by
>> updating mrrs.
>
> Does this still work if the tuning is enabled, or does the tuning run
> after this?

Yes it works with tuning enabled. Tuning happens afterwards. The 
'limiting mrrs to 256' below is from my patch.


[    2.267670] limiting mrrs to 256
[    2.267698] limiting mrrs to 256
[    2.267808] pcieport 0000:00:00.0: BAR 8: assigned [mem 
0x50000000-0x500fffff]
[    2.267818] pcieport 0000:00:00.0: BAR 9: assigned [mem 
0x50100000-0x501fffff pref]
[    2.267827] pcieport 0000:00:00.0: BAR 7: assigned [io  0x1000-0x1fff]
[    2.267840] pci 0000:01:00.0: BAR 0: assigned [mem 0x50000000-0x5001ffff]
[    2.267855] pci 0000:01:00.0: BAR 1: assigned [mem 0x50020000-0x5003ffff]
[    2.267869] pci 0000:01:00.0: BAR 6: assigned [mem 
0x50100000-0x5011ffff pref]
[    2.267877] pci 0000:01:00.1: BAR 0: assigned [mem 0x50040000-0x5005ffff]
[    2.267891] pci 0000:01:00.1: BAR 1: assigned [mem 0x50060000-0x5007ffff]
[    2.267904] pci 0000:01:00.1: BAR 6: assigned [mem 
0x50120000-0x5013ffff pref]
[    2.267913] pci 0000:01:00.0: BAR 2: assigned [io  0x1000-0x101f]
[    2.267926] pci 0000:01:00.1: BAR 2: assigned [io  0x1020-0x103f]
[    2.267946] pcieport 0000:00:00.0: Max Payload Size set to  256/ 256 
(was  128), Max Read Rq  256
[    2.267980] pci 0000:01:00.0: Max Payload Size set to  256/ 256 (was 
  128), Max Read Rq  256
[    2.268013] pci 0000:01:00.1: Max Payload Size set to  256/ 256 (was 
  128), Max Read Rq  256


>
>> +			if (pcie_get_readrq(dev)>  256) {
>> +				pr_info("limiting mrrs to 256\n");
>> +				pcie_set_readrq(dev, 256);
>
> The pr_info should either go away, or at least print the PCI bdf..

I will change this to a dev_info and print the PCI bdf as part of it.

>
> Jason


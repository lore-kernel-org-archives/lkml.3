Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754399AbaIVPAN (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Sep 2014 11:00:13 -0400
Received: from mail-bn1bon0081.outbound.protection.outlook.com ([157.56.111.81]:38144
	"EHLO na01-bn1-obe.outbound.protection.outlook.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1753943AbaIVPAK (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Sep 2014 11:00:10 -0400
X-Greylist: delayed 5687 seconds by postgrey-1.27 at vger.kernel.org; Mon, 22 Sep 2014 11:00:10 EDT
Date: Mon, 22 Sep 2014 15:25:08 +0200
From: Michal Simek <michal.simek@xilinx.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Thunderbird/31.1.0
MIME-Version: 1.0
To: Chen Gang <gang.chen.5i5j@gmail.com>, <monstr@monstr.eu>,
        "Greg Kroah-Hartman" <gregkh@linuxfoundation.org>
CC: <stern@rowland.harvard.edu>, <michal.simek@xilinx.com>,
        <linux-usb@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] drivers/usb/host/ehci-xilinx-of.c: Include "linux/of_irq.h"
 to avoid compiling error
References: <540738C7.5000106@gmail.com> <540D3C89.6080702@monstr.eu>
 <541D004C.6020108@gmail.com>
In-Reply-To: <541D004C.6020108@gmail.com>
Content-Type: text/plain; charset="windows-1252"
Content-Transfer-Encoding: 8bit
X-RCIS-Action: ALLOW
X-TM-AS-Product-Ver: IMSS-7.1.0.1224-7.5.0.1018-20950.003
X-TM-AS-User-Approved-Sender: Yes
Message-ID: <e0dec78e-193e-43ee-bdb0-fa776a6dd044@BY2FFO11FD030.protection.gbl>
X-EOPAttributedMessage: 0
X-Forefront-Antispam-Report: CIP:62.221.5.235;CTRY:GB;IPV:NLI;EFV:NLI;SFV:NSPM;SFS:(10009020)(6009001)(438002)(479174003)(377454003)(199003)(51704005)(164054003)(189002)(24454002)(47776003)(19580405001)(31696002)(6806004)(70736001)(19580395003)(81342003)(80022003)(74316001)(76482002)(44976005)(83322001)(86362001)(64706001)(120916001)(83506001)(20776003)(64126003)(87936001)(4396001)(104016003)(81542003)(54356999)(102836001)(107046002)(90102001)(230783001)(21056001)(1496007)(76176999)(92726001)(50986999)(50466002)(106466001)(46102003)(79102003)(99396002)(31966008)(85306004)(77982003)(74502003)(74662003)(83072002)(65806001)(85852003)(92566001)(95666004)(23746002)(65956001)(65826006)(107986001);DIR:OUT;SFP:1101;SCL:1;SRVR:BY2FFO11HUB002;H:xir-pvapsmtpgw01;FPR:;MLV:sfv;PTR:unknown-62-221-5-235.ipspace.xilinx.com;A:1;MX:1;LANG:en;
X-Microsoft-Antispam: BCL:0;PCL:0;RULEID:;UriScan:;
X-Forefront-PRVS: 034215E98F
Authentication-Results: spf=pass (sender IP is 62.221.5.235)
 smtp.mailfrom=michal.simek@xilinx.com; 
X-OriginatorOrg: xilinx.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Alan and Greg,

On 09/20/2014 06:19 AM, Chen Gang wrote:
> Hello Maintainers:
> 
> Please help check this patch, when you have time.
> 
> Thanks.
> 
> On 09/08/2014 01:20 PM, Michal Simek wrote:
>> On 09/03/2014 05:50 PM, Chen Gang wrote:
>>> Need include it for irq_of_parse_and_map(), the related error with
>>> allmodconfig under microblaze:
>>>
>>>   drivers/usb/host/ehci-xilinx-of.c: In function ‘ehci_hcd_xilinx_of_probe’:
>>>   drivers/usb/host/ehci-xilinx-of.c:156:2: error: implicit declaration of function ‘irq_of_parse_and_map’ [-Werror=implicit-function-declaration]
>>>     irq = irq_of_parse_and_map(dn, 0);
>>>     ^
>>>
>>> Signed-off-by: Chen Gang <gang.chen.5i5j@gmail.com>
>>> ---
>>>  drivers/usb/host/ehci-xilinx-of.c | 1 +
>>>  1 file changed, 1 insertion(+)
>>>
>>> diff --git a/drivers/usb/host/ehci-xilinx-of.c b/drivers/usb/host/ehci-xilinx-of.c
>>> index fe57710..a232836 100644
>>> --- a/drivers/usb/host/ehci-xilinx-of.c
>>> +++ b/drivers/usb/host/ehci-xilinx-of.c
>>> @@ -31,6 +31,7 @@
>>>  #include <linux/of.h>
>>>  #include <linux/of_platform.h>
>>>  #include <linux/of_address.h>
>>> +#include <linux/of_irq.h>
>>>  
>>>  /**
>>>   * ehci_xilinx_port_handed_over - hand the port out if failed to enable it
>>>
>>
>> Acked-by: Michal Simek <monstr@monstr.eu>

Alan: Can you please add this patch to your queue?
Greg: If Alan is not maintaining this part of kernel, is this patch in your queue?

I have also not a problem to add this patch through my microblaze tree
but I think it will be much better to use any USB tree.

Thanks,
Michal



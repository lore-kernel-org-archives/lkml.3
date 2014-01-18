Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753513AbaARDuC (ORCPT <rfc822;w@1wt.eu>);
	Fri, 17 Jan 2014 22:50:02 -0500
Received: from [65.55.88.12] ([65.55.88.12]:21756 "EHLO
	tx2outboundpool.messaging.microsoft.com" rhost-flags-FAIL-FAIL-OK-OK)
	by vger.kernel.org with ESMTP id S1752041AbaARDt7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 17 Jan 2014 22:49:59 -0500
X-Forefront-Antispam-Report: CIP:70.37.183.190;KIP:(null);UIP:(null);IPV:NLI;H:mail.freescale.net;RD:none;EFVD:NLI
X-SpamScore: -4
X-BigFish: VS-4(z579ehzbb2dI98dI9371I1432Izz1f42h2148h208ch1ee6h1de0h1fdah2073h2146h1202h1e76h2189h1d1ah1d2ah21bch1fc6hzz1de098h8275bh1de097hz2dh2a8h839h947hd25he5bhf0ah1288h12a5h12a9h12bdh137ah13b6h1441h1504h1537h153bh162dh1631h1758h1765h18e1h190ch1946h19b4h19c3h1ad9h1b0ah1b2fh2222h224fh1fb3h1d0ch1d2eh1d3fh1dfeh1dffh1f5fh1fe8h1ff5h209eh22d0h2336h2438h2461h2487h1155h)
Message-ID: <52D9F996.4060506@freescale.com>
Date: Sat, 18 Jan 2014 09:18:38 +0530
From: Prabhakar Kushwaha <prabhakar@freescale.com>
User-Agent: Mozilla/5.0 (Windows NT 6.1; rv:24.0) Gecko/20100101 Thunderbird/24.2.0
MIME-Version: 1.0
To: Kumar Gala <galak@kernel.crashing.org>
CC: Arnd Bergmann <arnd@arndb.de>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        <linux-kernel@vger.kernel.org>, <linuxppc-dev@lists.ozlabs.org>,
        Scott Wood <scottwood@freescale.com>
Subject: Re: [PATCH 1/2][v3] driver/memory:Move Freescale IFC driver to a
 common driver
References: <1389850929-19873-1-git-send-email-prabhakar@freescale.com> <E7780BC2-F914-4D0C-8AB9-9FE7437A5C48@kernel.crashing.org>
In-Reply-To: <E7780BC2-F914-4D0C-8AB9-9FE7437A5C48@kernel.crashing.org>
Content-Type: text/plain; charset="ISO-8859-1"; format=flowed
Content-Transfer-Encoding: 7bit
X-OriginatorOrg: freescale.com
X-FOPE-CONNECTOR: Id%0$Dn%*$RO%0$TLS%0$FQDN%$TlsDn%
X-FOPE-CONNECTOR: Id%0$Dn%FREESCALE.MAIL.ONMICROSOFT.COM$RO%1$TLS%0$FQDN%$TlsDn%
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On 1/17/2014 10:38 PM, Kumar Gala wrote:
> On Jan 15, 2014, at 11:42 PM, Prabhakar Kushwaha <prabhakar@freescale.com> wrote:
>
>> Freescale IFC controller has been used for mpc8xxx. It will be used
>> for ARM-based SoC as well. This patch moves the driver to driver/memory
>> and fix the header file includes.
>>
>> Also remove module_platform_driver() and  instead call
>> platform_driver_register() from subsys_initcall() to make sure this module
>> has been loaded before MTD partition parsing starts.
>>
>> Signed-off-by: Prabhakar Kushwaha <prabhakar@freescale.com>
>> Acked-by: Arnd Bergmann <arnd@arndb.de>
>> ---
>> Changes for v2:
>> 	- Move fsl_ifc in driver/memory
>>
>> Changes for v3:
>> 	- move device tree bindings to memory
>>
>> .../{powerpc => memory-controllers}/fsl/ifc.txt    |    0
>> arch/powerpc/sysdev/Makefile                       |    1 -
>> drivers/memory/Makefile                            |    1 +
>> {arch/powerpc/sysdev => drivers/memory}/fsl_ifc.c  |    8 ++++++--
>> drivers/mtd/nand/fsl_ifc_nand.c                    |    2 +-
>> .../include/asm => include/linux}/fsl_ifc.h        |    0
>> 6 files changed, 8 insertions(+), 4 deletions(-)
>> rename Documentation/devicetree/bindings/{powerpc => memory-controllers}/fsl/ifc.txt (100%)
>> rename {arch/powerpc/sysdev => drivers/memory}/fsl_ifc.c (98%)
>> rename {arch/powerpc/include/asm => include/linux}/fsl_ifc.h (100%)
> The Kconfig option for FSL_IFC should move into drivers/memory/Kconfig

Thanks Kumar for taking time and review this patch.

You are correct. I was checking sysdev/Kconfig  but it is defined in 
powerpc/Kconfig
I missed it :)

Regards,
Prabhakar




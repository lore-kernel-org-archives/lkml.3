Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754787AbaBUVE6 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 Feb 2014 16:04:58 -0500
Received: from ch1ehsobe006.messaging.microsoft.com ([216.32.181.186]:9883
	"EHLO ch1outboundpool.messaging.microsoft.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752417AbaBUVEz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 Feb 2014 16:04:55 -0500
X-Forefront-Antispam-Report: CIP:165.204.84.221;KIP:(null);UIP:(null);IPV:NLI;H:atltwp01.amd.com;RD:none;EFVD:NLI
X-SpamScore: 2
X-BigFish: VPS2(z426fnzbb2dI98dI9371I4015Izz1f42h2148h208ch1ee6h1de0h1fdah2073h2146h1202h1e76h2189h1d1ah1d2ah21bch1fc6hzzz2dh839h93fhd25he5bhf0ah1288h12a5h12a9h12bdh137ah13b6h1441h1504h1537h153bh162dh1631h1758h1765h18e1h190ch1946h19b4h19c3h1ad9h1b0ah2222h224fh1d0ch1d2eh1d3fh1dfeh1dffh1f5fh1fe8h1ff5h209eh22d0h2336h2438h2461h2487h24d7h2516h2545h255eh1155h)
X-WSS-ID: 0N1D6K1-07-JZO-02
X-M-MSG: 
Message-ID: <5307BF6F.8040303@amd.com>
Date: Fri, 21 Feb 2014 15:04:47 -0600
From: Aravind Gopalakrishnan <aravind.gopalakrishnan@amd.com>
User-Agent: Mozilla/5.0 (Windows NT 6.1; WOW64; rv:24.0) Gecko/20100101 Thunderbird/24.3.0
MIME-Version: 1.0
To: Borislav Petkov <bp@alien8.de>
CC: <tglx@linutronix.de>, <mingo@redhat.com>, <hpa@zytor.com>,
        <x86@kernel.org>, <dougthompson@xmission.com>, <bhelgaas@google.com>,
        <JBeulich@suse.com>, <dan.carpenter@oracle.com>,
        <linux-kernel@vger.kernel.org>, <linux-edac@vger.kernel.org>,
        <linux-pci@vger.kernel.org>, <Arindam.Nath@amd.com>
Subject: Re: [PATCH] amd64_edac: Add support for newer F16h models
References: <1392913726-16961-1-git-send-email-Aravind.Gopalakrishnan@amd.com> <20140221142749.GC11531@pd.tnic>
In-Reply-To: <20140221142749.GC11531@pd.tnic>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.180.168.240]
X-OriginatorOrg: amd.com
X-FOPE-CONNECTOR: Id%0$Dn%*$RO%0$TLS%0$FQDN%$TlsDn%
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 2/21/2014 8:27 AM, Borislav Petkov wrote:
> On Thu, Feb 20, 2014 at 10:28:46AM -0600, Aravind Gopalakrishnan wrote:
>> diff --git a/include/linux/pci_ids.h b/include/linux/pci_ids.h
>> index 97fbecd..e91ad27 100644
>> --- a/include/linux/pci_ids.h
>> +++ b/include/linux/pci_ids.h
>> @@ -528,6 +528,8 @@
>>   #define PCI_DEVICE_ID_AMD_15H_NB_F5	0x1605
>>   #define PCI_DEVICE_ID_AMD_16H_NB_F3	0x1533
>>   #define PCI_DEVICE_ID_AMD_16H_NB_F4	0x1534
>> +#define PCI_DEVICE_ID_AMD_16H_M30H_NB_F3 0x1583
>> +#define PCI_DEVICE_ID_AMD_16H_M30H_NB_F4 0x1584
> Just put those in arch/x86/include/asm/amd_nb.h as amd64_edac.c includes
> it already and you can avoid the pci_ids.h addition. Unless there are
> plans to use F{3,4} in other places too...
>

F{3,4} are used by hwmon/k10temp.c and hwmon/fam15h_power.c and they 
will need definitions to be places here in pci_ids.h
But I'm not sure if the hwmon drivers need to carry support for this 
model yet (will verify that)

If not, I'll remove them and resend.

Thanks,
-Aravind.


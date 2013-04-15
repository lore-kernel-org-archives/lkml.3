Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754718Ab3DOQnT (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Apr 2013 12:43:19 -0400
Received: from va3ehsobe003.messaging.microsoft.com ([216.32.180.13]:33931
	"EHLO va3outboundpool.messaging.microsoft.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751361Ab3DOQnP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Apr 2013 12:43:15 -0400
X-Forefront-Antispam-Report: CIP:163.181.249.108;KIP:(null);UIP:(null);IPV:NLI;H:ausb3twp01.amd.com;RD:none;EFVD:NLI
X-SpamScore: -3
X-BigFish: VPS-3(z551bizbb2dI98dI9371I1432Izz1f42h1fc6h1ee6h1de0h1fdah1202h1e76h1d1ah1d2ahzzz2dh668h839h93fhd25he5bhf0ah1288h12a5h12a9h12bdh137ah13b6h1441h1504h1537h153bh162dh1631h1758h1765h18e1h190ch1946h19b4h19c3h19ceh1ad9h1b0ah1155h)
X-WSS-ID: 0MLB2EJ-01-2D2-02
X-M-MSG: 
Message-ID: <516C2EA2.1050806@amd.com>
Date: Mon, 15 Apr 2013 11:45:22 -0500
From: Aravind <aravind.gopalakrishnan@amd.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130329 Thunderbird/17.0.5
MIME-Version: 1.0
To: Borislav Petkov <bp@alien8.de>
CC: Bjorn Helgaas <bhelgaas@google.com>, Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, "H. Peter Anvin" <hpa@zytor.com>,
        Doug Thompson <dougthompson@xmission.com>,
        Jesse Barnes <jbarnes@virtuousgeek.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-pci@vger.kernel.org" <linux-pci@vger.kernel.org>,
        <linux-edac@vger.kernel.org>
Subject: Re: [PATCH] edac: Handle EDAC ECC errors for Family 16h
References: <1366039059-15772-1-git-send-email-Aravind.Gopalakrishnan@amd.com> <CAErSpo6cD4WtPhTbcBEyfOLNASJzr+cU2Lch=fVyqn-gh15drQ@mail.gmail.com> <20130415161121.GA18440@pd.tnic>
In-Reply-To: <20130415161121.GA18440@pd.tnic>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 7bit
X-Originating-IP: [163.181.55.254]
X-OriginatorOrg: amd.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 04/15/2013 11:11 AM, Borislav Petkov wrote:
> On Mon, Apr 15, 2013 at 09:56:08AM -0600, Bjorn Helgaas wrote:
>> On Mon, Apr 15, 2013 at 9:17 AM, Aravind Gopalakrishnan
>>> @@ -172,7 +176,12 @@
>>>    */
>>>   #define PCI_DEVICE_ID_AMD_15H_NB_F1    0x1601
>>>   #define PCI_DEVICE_ID_AMD_15H_NB_F2    0x1602
>>> -
>>> +#define PCI_DEVICE_ID_AMD_16H_NB_F0    0x1530
>>> +#define PCI_DEVICE_ID_AMD_16H_NB_F1    0x1531
>>> +#define PCI_DEVICE_ID_AMD_16H_NB_F2    0x1532
>>> +#define PCI_DEVICE_ID_AMD_16H_NB_F3    0x1533
>>> +#define PCI_DEVICE_ID_AMD_16H_NB_F4    0x1534
>>> +#define PCI_DEVICE_ID_AMD_16H_NB_F5    0x1535
>>>
>>>   /*
>>>    * Function 1 - Address Map
>>> @@ -300,6 +309,7 @@ enum amd_families {
>>>          K8_CPUS = 0,
>>>          F10_CPUS,
>>>          F15_CPUS,
>>> +       F16_CPUS,
>>>          NUM_FAMILIES,
>>>   };
>>>
>>> diff --git a/include/linux/pci_ids.h b/include/linux/pci_ids.h
>>> index 1679ff6..59f732f 100644
>>> --- a/include/linux/pci_ids.h
>>> +++ b/include/linux/pci_ids.h
>>> @@ -519,6 +519,8 @@
>>>   #define PCI_DEVICE_ID_AMD_11H_NB_LINK  0x1304
>>>   #define PCI_DEVICE_ID_AMD_15H_NB_F3    0x1603
>>>   #define PCI_DEVICE_ID_AMD_15H_NB_F4    0x1604
>>> +#define PCI_DEVICE_ID_AMD_16H_NB_F3    0x1533
>>> +#define PCI_DEVICE_ID_AMD_16H_NB_F4    0x1534
>> What is the point of adding identical #defines both here and in
>> amd64_edac.h?  Also, read the note at the top of
>> include/linux/pci_ids.h.
> Yeah, they should be in pci_ids.h since they're used in amd_nb.c and
> amd64_edac.c.
>
> But, what shouldn't be is adding unused defines (*_F0 and *_F5).
> Aravind, please drop them.

     Yes, I have made the changes and sent it out as version 2 of the PATCH.
     Do have a look and let me know if I need to make any changes.


> I'll review the rest of the patch when I get around to it this week.
>



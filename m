Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753449AbaAWV5c (ORCPT <rfc822;w@1wt.eu>);
	Thu, 23 Jan 2014 16:57:32 -0500
Received: from [216.32.180.30] ([216.32.180.30]:25400 "EHLO
	va3outboundpool.messaging.microsoft.com" rhost-flags-FAIL-FAIL-OK-OK)
	by vger.kernel.org with ESMTP id S1751492AbaAWV5b (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 23 Jan 2014 16:57:31 -0500
X-Forefront-Antispam-Report: CIP:165.204.84.221;KIP:(null);UIP:(null);IPV:NLI;H:atltwp01.amd.com;RD:none;EFVD:NLI
X-SpamScore: -4
X-BigFish: VPS-4(zzbb2dI98dI9371I1432I4015Izz1f42h2148h208ch1ee6h1de0h1fdah2073h2146h1202h1e76h2189h1d1ah1d2ah21bch1fc6hzz1de098h177df4h8275eh17326ah8275bh1de097h186068ha1495iz2dh839h947hd25he5bhf0ah1288h12a5h12a9h12bdh137ah13b6h1441h1504h1537h153bh162dh1631h1758h1765h18e1h190ch1946h19b4h19c3h1ad9h1b0ah2222h224fh1d0ch1d2eh1d3fh1dfeh1dffh1f5fh1fe8h1ff5h209eh22d0h2336h2438h2461h2487h24d7h1155h)
X-WSS-ID: 0MZVJKM-07-6H4-02
X-M-MSG: 
Message-ID: <52E18FD0.8030800@amd.com>
Date: Thu, 23 Jan 2014 15:55:28 -0600
From: Aravind Gopalakrishnan <aravind.gopalakrishnan@amd.com>
User-Agent: Mozilla/5.0 (Windows NT 6.1; WOW64; rv:24.0) Gecko/20100101 Thunderbird/24.2.0
MIME-Version: 1.0
To: Ingo Molnar <mingo@kernel.org>
CC: <tglx@linutronix.de>, <mingo@redhat.com>, <hpa@zytor.com>,
        <x86@kernel.org>, <bp@suse.de>, <linux-kernel@vger.kernel.org>,
        <sherry.hurwitz@amd.com>, <hmh@hmh.eng.br>, <Kim.Naru@amd.com>,
        <Suravee.Suthikulpanit@amd.com>
Subject: Re: [PATCH] x86, quirks: Add workaround for AMD F16h Erratum792
References: <1389983973-3965-1-git-send-email-Aravind.Gopalakrishnan@amd.com> <20140120070724.GA31940@gmail.com> <52DECB5A.6030004@amd.com>
In-Reply-To: <52DECB5A.6030004@amd.com>
Content-Type: text/plain; charset="ISO-8859-1"; format=flowed
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.180.168.240]
X-OriginatorOrg: amd.com
X-FOPE-CONNECTOR: Id%0$Dn%*$RO%0$TLS%0$FQDN%$TlsDn%
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 1/21/2014 1:32 PM, Aravind Gopalakrishnan wrote:
> On 1/20/2014 1:07 AM, Ingo Molnar wrote:
>> * Aravind Gopalakrishnan <Aravind.Gopalakrishnan@amd.com> wrote:
>>
>>> +
>>> +#if defined(CONFIG_PCI)
>>> +/*
>>> + * Apply AMD Fam16h Erratum792
>>> + * see Revision Guide for AMD F16h models 00h-0fh,
>>> + * document 51810 rev. 3.04, Nov 2013
>>> + */
>>> +static void quirk_amd_dram_scrub(struct pci_dev *dev)
>> The reference to the erratum is useful for people who want to see more
>> details, but at least a short description of the problem being fixed
>> and systems affected by the quirk is needed. 'DRAM scrub' is not very
>> informative.
>>
>>
> Ok, I'll reword the comment in a V2.
> But there's an internal discussion going on about the erratum, so I'll 
> hold off spinning a V2 until that's over..
>
> Thanks,
> -Aravind.

Addressing hpa and Boris' earlier concern 
(http://marc.info/?l=linux-kernel&m=138998314409664&w=2)
I can say with better certainty now that there is a coverage hole:
Initial production parts shipped last year, while fix will be in BIOS 
only from now onwards; (at least server platforms..)

I have also reworded the comment and function name per Ingo's suggestion..
Sending V2 of patch (rebased off latest tip/master)

Thanks,
-Aravind





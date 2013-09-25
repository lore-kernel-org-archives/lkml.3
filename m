Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752836Ab3IYHhB (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Sep 2013 03:37:01 -0400
Received: from [65.55.88.15] ([65.55.88.15]:52651 "EHLO
	tx2outboundpool.messaging.microsoft.com" rhost-flags-FAIL-FAIL-OK-OK)
	by vger.kernel.org with ESMTP id S1750783Ab3IYHhA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Sep 2013 03:37:00 -0400
X-Forefront-Antispam-Report: CIP:70.37.183.190;KIP:(null);UIP:(null);IPV:NLI;H:mail.freescale.net;RD:none;EFVD:NLI
X-SpamScore: -4
X-BigFish: VS-4(zzbb2dI98dI9371I1432I1453Izz1f42h208ch1ee6h1de0h1fdah2073h1202h1e76h1d1ah1d2ah1fc6hzz1de098h1de097h8275bhz2dh2a8h839h947he5bhf0ah1288h12a5h12a9h12bdh137ah13b6h1441h1504h1537h153bh162dh1631h1758h18e1h190ch1946h19b4h19c3h1ad9h1b0ah1b2fh1fb3h1d0ch1d2eh1d3fh1dfeh1dffh1fe8h1ff5h209eh1889i1155h)
Message-ID: <52429252.10009@freescale.com>
Date: Wed, 25 Sep 2013 15:35:46 +0800
From: Hongbo Zhang <hongbo.zhang@freescale.com>
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:17.0) Gecko/20130510 Thunderbird/17.0.6
MIME-Version: 1.0
To: Stephen Warren <swarren@wwwdotorg.org>
CC: <rob.herring@calxeda.com>, <pawel.moll@arm.com>, <mark.rutland@arm.com>,
        <ian.campbell@citrix.com>, <vinod.koul@intel.com>, <djbw@fb.com>,
        <devicetree@vger.kernel.org>, <linuxppc-dev@lists.ozlabs.org>,
        <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH v10 2/3] DMA: Freescale: Add new 8-channel DMA engine
 device tree nodes
References: <1379499333-4745-1-git-send-email-hongbo.zhang@freescale.com> <1379499333-4745-3-git-send-email-hongbo.zhang@freescale.com> <524074A7.7000001@wwwdotorg.org> <524169E3.7030408@freescale.com> <5241CC60.5070204@wwwdotorg.org>
In-Reply-To: <5241CC60.5070204@wwwdotorg.org>
Content-Type: text/plain; charset="ISO-8859-1"; format=flowed
Content-Transfer-Encoding: 7bit
X-OriginatorOrg: freescale.com
X-FOPE-CONNECTOR: Id%0$Dn%*$RO%0$TLS%0$FQDN%$TlsDn%
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 09/25/2013 01:31 AM, Stephen Warren wrote:
> On 09/24/2013 04:30 AM, Hongbo Zhang wrote:
>> On 09/24/2013 01:04 AM, Stephen Warren wrote:
>>> On 09/18/2013 04:15 AM, hongbo.zhang@freescale.com wrote:
>>>> From: Hongbo Zhang <hongbo.zhang@freescale.com>
>>>>
>>>> Freescale QorIQ T4 and B4 introduce new 8-channel DMA engines, this
>>>> patch adds
>>>> the device tree nodes for them.
>>>> diff --git a/Documentation/devicetree/bindings/powerpc/fsl/dma.txt
>>>> b/Documentation/devicetree/bindings/powerpc/fsl/dma.txt
>>>> +Required properties:
>>>> +
>>>> +- compatible        : must include "fsl,elo3-dma"
>>>> +- reg               : DMA General Status Registers, i.e. DGSR0 which
>>>> contains
>>>> +                      status for channel 1~4, and DGSR1 for channel 5~8
>>> Is that a single entry, which is large enough to cover both registers,
>>> or a pair of entries, one per register? Reading the text, I might assume
>>> the former, but looking at the examples, it's the latter.
>> My impression is that I cannot tell it is one larger entry or two
>> entries by reading the description text, but the example gives the answer.
>> Is it so important to specify it is only one entry or entries list?
>> I prefer language as concise as possible, especially for the common
>> properties such as reg and interrupt (eg the reg is implicitly offset
>> and length of registers, can be continuous or not), it is difficult or
>> unnecessary or impossible to describe much details, the example can also
>> work as a complementary description, otherwise no need to put an example
>> in the binding document.
> The description of the properties should fully describe them. The
> example is just an example, not a specification of the properties.
>
It is OK for me to update the description like this:
reg:    containing two entries for DMA General Status Registers, i.e. 
DGSR0 which contains + status for channel 1~4, and DGSR1 for channel 5~8

and let me wait one or more days to see if other reviewers/maintainers 
have further comments before I send our another iteration.

By the way, I know maybe it is difficult, but why not introduce a 
document of maintaining rules for the dt binding docs? we have dedicated 
maintainers for this part now. Description language from one submitter 
cannot satisfy every reviewer/maintainer, for a reg property, is it 
necessary to say "offset and length", to say "how many entries", to say 
"register functions and even names"? If there is specific rules (even 
with good examples), it will be convenient for both submitter and 
reviewers. Without rules/guidelines, new submitter would like to follow 
old bad samples.




Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754552Ab3C3Fkt (ORCPT <rfc822;w@1wt.eu>);
	Sat, 30 Mar 2013 01:40:49 -0400
Received: from mail-db8lp0185.outbound.messaging.microsoft.com ([213.199.154.185]:51902
	"EHLO db8outboundpool.messaging.microsoft.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753713Ab3C3Fks (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 30 Mar 2013 01:40:48 -0400
X-Forefront-Antispam-Report: CIP:132.245.2.69;KIP:(null);UIP:(null);IPV:NLI;H:BN1PRD0712HT004.namprd07.prod.outlook.com;RD:none;EFVD:NLI
X-SpamScore: -19
X-BigFish: PS-19(z551bizbb2dI98dI9371I1432Ibf3W14ffIzz1f42h1fc6h1ee6h1de0h1202h1e76h1d1ah1d2ahzzz2dh2a8h668h839h947hd25he5bhf0ah1288h12a5h12a9h12bdh137ah13b6h1441h14ddh1504h1537h153bh162dh1631h1758h1765h18e1h190ch1946h19b4h19c3h19ceh1ad9h1b0ah1155h)
Message-ID: <51567AD3.5030704@caviumnetworks.com>
Date: Fri, 29 Mar 2013 22:40:35 -0700
From: Aaron Williams <Aaron.Williams@caviumnetworks.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130307 Thunderbird/17.0.4
MIME-Version: 1.0
To: Ivan Djelic <ivan.djelic@parrot.com>
CC: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        <linux-mtd@lists.infradead.org>
Subject: Re: MTD NAND BCH support for 24 bits/1K of ECC correction?
References: <5154C2C5.5000903@caviumnetworks.com> <20130329090219.GB6928@parrot.com>
In-Reply-To: <20130329090219.GB6928@parrot.com>
Content-Type: text/plain; charset="ISO-8859-1"; format=flowed
Content-Transfer-Encoding: 7bit
X-Originating-IP: [64.2.3.195]
X-OriginatorOrg: caviumnetworks.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 03/29/2013 02:02 AM, Ivan Djelic wrote:
> On Thu, Mar 28, 2013 at 10:23:01PM +0000, Aaron Williams wrote:
>> Hi all,
>>
>> I am trying to clean up our OCTEON NAND flash driver in the Linux kernel
>> and enable support for multi-bit ECC using BCH and am having some
>> issues. I am able to successfully work with NAND flash that requires 4
>> bits ECC per 512 bytes but I am having issues with one of our boards
>> that has a NAND device that requires 24 bits of ECC per 1024 bytes.
>>
>> I was wondering if ECC of this magnitude has been successfully tested in
>> the past. By my calculations I should have 42 bytes of ECC per 1K block
>> (m=14, t=24 for 336 bits of ECC data). My problem is that when decoding
>> an encoded block I am seeing that nroots != err in decode_bch() after
>> find_poly_roots(). I am seeing this for all of the blocks I attempt to
>> read. As far as I can tell the data being sent to BCH is good, though it
>> might have a few bad bits but nowhere near 24.
>>
>> I am also seeing this same behavior in my U-Boot code which uses the
>> identical bch and nand_bch code.
>>
> Hi Aaron,
>
> CC-ing your message to linux-mtd which is the place to go for such questions :-)
>
> Your configuration (m=14 t=24 with 1024 bytes of data) has been tested, and should work
> with the BCH library. Could you give some details about your ECC setup:
>
> 1. Are you trying to locate and correct errors from hardware-computed syndromes ?
>
> 2. If yes, did you provide the BCH lib with the specific primitive polynomial used by
>     your hardware ? What is this polynomial ?
>
> 3. Could you provide the ECC bytes generated for the following block patterns:
>    - a 0xff-filled 1024 bytes block
>    - a 0xff-filled 1024 bytes block, except for the first byte set to 0xfe
>    This would help me find out how to setup the library to match your hardware.
>
> Regards,

We are doing the BCH support entirely in software due to limitations of 
our hardware to 1 bit ECC.

I may have to get back to you. I may have found the problem and will try 
and look at it some more next week. It looks like I now have it working 
in U-Boot and the same bug exists in our Linux driver. It wouldn't be 
the first one... our NAND drivers haven't been updated in ages.

-Aaron

-- 
Aaron Williams
Software Engineer
Cavium, Inc.
(408) 943-7198  (510) 789-8988 (cell)



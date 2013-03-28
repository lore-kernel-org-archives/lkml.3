Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753437Ab3C1WXR (ORCPT <rfc822;w@1wt.eu>);
	Thu, 28 Mar 2013 18:23:17 -0400
Received: from co9ehsobe005.messaging.microsoft.com ([207.46.163.28]:26613
	"EHLO co9outboundpool.messaging.microsoft.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752529Ab3C1WXQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 28 Mar 2013 18:23:16 -0400
X-Forefront-Antispam-Report: CIP:157.56.242.245;KIP:(null);UIP:(null);IPV:NLI;H:BL2PRD0712HT001.namprd07.prod.outlook.com;RD:none;EFVD:NLI
X-SpamScore: -15
X-BigFish: PS-15(z551bizbf3W14ffIzz1f42h1fc6h1ee6h1de0h1202h1e76h1d1ah1d2ahzzz2dh2a8h668h839h947hd25he5bhf0ah1288h12a5h12a9h12bdh137ah13b6h1441h14ddh1504h1537h153bh162dh1631h1758h1765h18e1h190ch1946h19b4h19c3h19ceh1ad9h1b0ah1155h)
Message-ID: <5154C2C5.5000903@caviumnetworks.com>
Date: Thu, 28 Mar 2013 15:23:01 -0700
From: Aaron Williams <Aaron.Williams@caviumnetworks.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130307 Thunderbird/17.0.4
MIME-Version: 1.0
To: <linux-kernel@vger.kernel.org>
CC: Ivan Djelic <ivan.djelic@parrot.com>
Subject: MTD NAND BCH support for 24 bits/1K of ECC correction?
Content-Type: text/plain; charset="ISO-8859-1"; format=flowed
Content-Transfer-Encoding: 7bit
X-Originating-IP: [64.2.3.195]
X-OriginatorOrg: caviumnetworks.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi all,

I am trying to clean up our OCTEON NAND flash driver in the Linux kernel 
and enable support for multi-bit ECC using BCH and am having some 
issues. I am able to successfully work with NAND flash that requires 4 
bits ECC per 512 bytes but I am having issues with one of our boards 
that has a NAND device that requires 24 bits of ECC per 1024 bytes.

I was wondering if ECC of this magnitude has been successfully tested in 
the past. By my calculations I should have 42 bytes of ECC per 1K block 
(m=14, t=24 for 336 bits of ECC data). My problem is that when decoding 
an encoded block I am seeing that nroots != err in decode_bch() after 
find_poly_roots(). I am seeing this for all of the blocks I attempt to 
read. As far as I can tell the data being sent to BCH is good, though it 
might have a few bad bits but nowhere near 24.

I am also seeing this same behavior in my U-Boot code which uses the 
identical bch and nand_bch code.

Cheers,

Aaron Williams

-- 
Aaron Williams
Software Engineer
Cavium, Inc.
(408) 943-7198  (510) 789-8988 (cell)



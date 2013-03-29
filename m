Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756171Ab3C2JCX (ORCPT <rfc822;w@1wt.eu>);
	Fri, 29 Mar 2013 05:02:23 -0400
Received: from co202.xi-lite.net ([149.6.83.202]:48790 "EHLO co202.xi-lite.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755652Ab3C2JCV (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 29 Mar 2013 05:02:21 -0400
Date: Fri, 29 Mar 2013 10:02:19 +0100
From: Ivan Djelic <ivan.djelic@parrot.com>
To: Aaron Williams <Aaron.Williams@caviumnetworks.com>
CC: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        <linux-mtd@lists.infradead.org>
Subject: Re: MTD NAND BCH support for 24 bits/1K of ECC correction?
Message-ID: <20130329090219.GB6928@parrot.com>
References: <5154C2C5.5000903@caviumnetworks.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <5154C2C5.5000903@caviumnetworks.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Mar 28, 2013 at 10:23:01PM +0000, Aaron Williams wrote:
> Hi all,
> 
> I am trying to clean up our OCTEON NAND flash driver in the Linux kernel 
> and enable support for multi-bit ECC using BCH and am having some 
> issues. I am able to successfully work with NAND flash that requires 4 
> bits ECC per 512 bytes but I am having issues with one of our boards 
> that has a NAND device that requires 24 bits of ECC per 1024 bytes.
> 
> I was wondering if ECC of this magnitude has been successfully tested in 
> the past. By my calculations I should have 42 bytes of ECC per 1K block 
> (m=14, t=24 for 336 bits of ECC data). My problem is that when decoding 
> an encoded block I am seeing that nroots != err in decode_bch() after 
> find_poly_roots(). I am seeing this for all of the blocks I attempt to 
> read. As far as I can tell the data being sent to BCH is good, though it 
> might have a few bad bits but nowhere near 24.
> 
> I am also seeing this same behavior in my U-Boot code which uses the 
> identical bch and nand_bch code.
> 

Hi Aaron,

CC-ing your message to linux-mtd which is the place to go for such questions :-)

Your configuration (m=14 t=24 with 1024 bytes of data) has been tested, and should work
with the BCH library. Could you give some details about your ECC setup:

1. Are you trying to locate and correct errors from hardware-computed syndromes ?

2. If yes, did you provide the BCH lib with the specific primitive polynomial used by
   your hardware ? What is this polynomial ?

3. Could you provide the ECC bytes generated for the following block patterns:
  - a 0xff-filled 1024 bytes block
  - a 0xff-filled 1024 bytes block, except for the first byte set to 0xfe
  This would help me find out how to setup the library to match your hardware.

Regards,
-- 
Ivan

Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752873Ab3F1XrJ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 28 Jun 2013 19:47:09 -0400
Received: from mail1.bemta8.messagelabs.com ([216.82.243.198]:18691 "EHLO
	mail1.bemta8.messagelabs.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750818Ab3F1XrI convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 28 Jun 2013 19:47:08 -0400
X-Env-Sender: hartleys@visionengravers.com
X-Msg-Ref: server-4.tower-132.messagelabs.com!1372463224!11555205!7
X-Originating-IP: [216.166.12.31]
X-StarScan-Received: 
X-StarScan-Version: 6.9.9; banners=-,-,-
X-VirusChecked: Checked
From: H Hartley Sweeten <hartleys@visionengravers.com>
To: <linux-mmc@vger.kernel.org>
Subject: Q: mmc au size
Date: Fri, 28 Jun 2013 16:46:21 -0700
User-Agent: KMail/1.9.9
CC: Linux Kernel <linux-kernel@vger.kernel.org>, <cjb@laptop.org>,
        <hsweeten@visionengravers.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8BIT
Content-Disposition: inline
Message-ID: <201306281646.21319.hartleys@visionengravers.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello all,

I have a question concerning the "au" size of a SD Card.

I have an old Kingston 64MB SD-Card and lately I have noticed this
kernel message when I use the card:

mmc0: SD Status: Invalid Allocation Unit size.

This is due to the following commit:

commit b63b5e819d5b21ae493c17c356018ffa98d3ee1c
Author: Alan Cox <alan@linux.intel.com>
Date:   Mon Jul 2 18:55:13 2012 +0100

    mmc: core: correct invalid error checking


>From the "SD Specifications, Part 1, Physical Layer Specification",

* AU_SIZE
This 4-bit field indicates AU Size and the value can be selected from
16 KB.
        
  AU_SIZE  Value Definition
  -------  ----------------
    0h     Not Defined
    1h     16 KB
    2h     32 KB
    3h     64 KB
    4h     128 KB
    5h     256 KB
    6h     512 KB
    7h     1 MB
    8h     2 MB
    9h     4 MB
    Ah     8 MB
    Bh     12 MB
    Ch     16 MB
    Dh     24 MB
    Eh     32 MB
    Fh     64 MB

Also in the specification is this note:

Sector: is the unit that is related to the erase commands. Its size
is the number of blocks that will be erased in one portion. The size
of a sector is fixed for each device. The information about the sector
size (in blocks) is stored in the CSD. Note that if the card specifies
AU size, sector size should be ignored.

And this:

* SECTOR_SIZE
This field is fixed to 7Fh, which indicates 64 KBytes. This value does
not relate to erase operations. High Capacity and Extended Capacity
cards indicate memory boundary by AU size and this field should not
be used.


So, if an au size of 0 is reported wouldn't the erase size be the
sector size? If nothing else I think the test needs to be adjusted to
not report the error for an au size of 0.

Regards,
Hartley

Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752637AbaG2CpE (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Jul 2014 22:45:04 -0400
Received: from mail-oa0-f49.google.com ([209.85.219.49]:59656 "EHLO
	mail-oa0-f49.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751702AbaG2Co7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Jul 2014 22:44:59 -0400
MIME-Version: 1.0
In-Reply-To: <53D6EB53.2000209@infradead.org>
References: <1406561500-18264-1-git-send-email-punnaia@xilinx.com>
	<b37e0e96-e91d-496c-a530-df72898798a1@BY2FFO11FD057.protection.gbl>
	<53D6EB53.2000209@infradead.org>
Date: Tue, 29 Jul 2014 08:14:59 +0530
Message-ID: <CAHLkNHLhN1WLU0HH5XKQuGG1O2-TEhTfQgLFMqbGiWQTPmVe1g@mail.gmail.com>
Subject: Re: [PATCH RFC v4 4/4] Documentation: nand: pl353: Add documentation
 for controller and driver
From: Punnaiah Choudary <kpc528@gmail.com>
To: Randy Dunlap <rdunlap@infradead.org>
Cc: Punnaiah Choudary Kalluri <punnaiah.choudary.kalluri@xilinx.com>,
        Rob Herring <robh+dt@kernel.org>, Pawel Moll <pawel.moll@arm.com>,
        Mark Rutland <mark.rutland@arm.com>,
        Ian Campbell <ijc+devicetree@hellion.org.uk>,
        Kumar Gala <galak@codeaurora.org>, Rob Landley <rob@landley.net>,
        Michal Simek <michal.simek@xilinx.com>, grant.likely@linaro.org,
        gregkh@linuxfoundation.org, jason@lakedaemon.net,
        ezequiel.garcia@free-electrons.com, arnd@arndb.de, dwmw2@infradead.org,
        computersforpeace@gmail.com, artem.bityutskiy@linux.intel.com,
        pekon@ti.com, jussi.kivilinna@iki.fi, acourbot@nvidia.com,
        ivan.khoronzhuk@ti.com, joern@logfs.org,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        "linux-doc@vger.kernel.org" <linux-doc@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        linux-mtd@lists.infradead.org,
        punnaiah choudary kalluri <kalluripunnaiahchoudary@gmail.com>,
        anirudh@xilinx.com, svemula@xilinx.com,
        Punnaiah Choudary Kalluri <punnaia@xilinx.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Randy,

  Thanks for the review. I will fix the below review comments in my
next submission.

Regards,
Punnaiah

On Tue, Jul 29, 2014 at 6:01 AM, Randy Dunlap <rdunlap@infradead.org> wrote:
> On 07/28/14 08:31, Punnaiah Choudary Kalluri wrote:
>> Added notes about the controller and driver
>>
>> Signed-off-by: Punnaiah Choudary Kalluri <punnaia@xilinx.com>
>> ---
>> Changes in v4:
>> - None
>> ---
>>  Documentation/mtd/nand/pl353-nand.txt |   92 +++++++++++++++++++++++++++++++++
>>  1 files changed, 92 insertions(+), 0 deletions(-)
>>  create mode 100644 Documentation/mtd/nand/pl353-nand.txt
>>
>> diff --git a/Documentation/mtd/nand/pl353-nand.txt b/Documentation/mtd/nand/pl353-nand.txt
>> new file mode 100644
>> index 0000000..4deac94
>> --- /dev/null
>> +++ b/Documentation/mtd/nand/pl353-nand.txt
>> @@ -0,0 +1,92 @@
>> +This documents provides some notes about the ARM pl353 smc controller used in
>
>                                                     PL353 SMC
>
>> +Zynq SOC and confined to NAND specific details.
>
>             and is confined to
>
>> +
>> +Overview of the controller
>> +==========================
>> +     The SMC (PL353) supports two memory interfaces:
>> +     Interface 0 type SRAM.
>> +     Interface 1 type NAND.
>> +     This configuration supports the following configurable options:
>> +        . 32-bit or 64-bit AXI data width
>> +        . 8-bit, 16-bit, or 32-bit memory data width for interface 0
>> +        . 8-bit, or 16-bit memory data width for interface 1
>> +        . 1-4 chip selects on each interface
>> +        . SLC ECC block for interface 1
>> +
>> +For more information, refer the below link for TRM
>
>                          refer to the below link for TRM.
>
>> +http://infocenter.arm.com/help/topic/com.arm.doc.ddi0380g/
>> +DDI0380G_smc_pl350_series_r2p1_trm.pdf
>> +
>> +NAND memory accesses
>> +====================
>> +     . Two phase NAND accesses
>> +     . NAND command phase transfers
>> +     . NAND data phase transfers
>> +
>> +Two phase NAND accesses
>> +     The SMC defines two phases of commands when transferring data to or from
>> +NAND flash.
>> +
>> +Command phase
>> +     Commands and optional address information are written to the NAND flash.
>> +The command and address can be associated with either a data phase operation to
>> +write to or read from the array, or a status/ID register transfer.
>> +
>> +Data phase
>> + Data is either written to or read from the NAND flash. This data can be either
>> +data transferred to or from the array, or status/ID register information.
>> +
>> +NAND AXI address setup
>> +       AXI address      Command phase      Data phase
>> +     [31:24]         Chip address       Chip address
>> +     [23]            NoOfAddCycles_2    Reserved
>> +     [22]            NoOfAddCycles_1    Reserved
>> +     [21]            NoOfAddCycles_0    ClearCS
>> +     [20]            End command valid  End command valid
>> +     [19]            0                  1
>> +     [18:11]         End command        End command
>> +     [10:3]          Start command      [10] ECC Last
>> +                                        [9:3] Reserved
>> +     [2:0]           Reserved           Reserved
>> +
>> +ECC
>> +===
>> +    It operates on a number of 512 byte blocks of NAND memory and can be
>
>                                   512-byte blocks
>
>> +programmed to store the ECC codes after the data in memory. For writes,
>> +the ECC is written to the spare area of the page. For reads, the result of
>> +a block ECC check are made available to the device driver.
>> +
>> +------------------------------------------------------------------------
>> +|               n * 512 blocks                  | extra  | ecc    |     |
>
>                                                               ECC
>
>> +|                                               | block  | codes  |     |
>> +------------------------------------------------------------------------
>> +
>> +The ECC calculation uses a simple Hamming code, using 1-bit correction 2-bit
>> +detection. It starts when a valid read or write command with a 512 byte aligned
>
>                                                                   512-byte
>
>> +address is detected on the memory interface.
>> +
>> +Driver details
>> +==============
>> +     The NAND driver has dependancy with the pl353_smc memory controller
>
>                             dependency          PL353 SMC
>
>> +driver for intializing the nand timing parameters, bus width, ECC modes,
>
>               initializing the NAND
>
>> +control and status information.
>> +
>> +Since the controller expects that the chipselect bit should be cleared for the
>> +last data transfer i.e last 4 data bytes, the existing nandbase page
>
>              transfer,
>
>> +read/write routines for soft ecc and ecc none modes will not work. So, inorder
>
>                                 ECC and ECC                               in order
>
>> +to make this driver work, it always updates the ecc mode as HW ECC and
>
>                                                    ECC
>
>> +implemented the page read/write functions for supporting the SW ECC.
>
>    implements
>
>> +
>> +HW ECC mode:
>> +     Upto 2K page size is supported and beyond that it retuns
>
>         Up to                                             returns
>
>> +-ENOSUPPORT error. If the flsh has ONDIE ecc controller then the
>
>                              flash          ECC
>
>> +priority has given to the ONDIE ecc controller. Also the current
>
>             is given               ECC
>
>> +implementation has support for upto 64 byte oob area
>
>                                   up to 64-byte OOB area.
>
>> +
>> +SW ECC mode:
>> +     It supports all the pgae sizes. But since, zynq soc bootrom uses
>
>                             page sizes, but since Zynq SOC boot ROM
>
>> +HW ECC for the devices that have pgae size <=2K so, to avoid any ecc related
>
>                                     page size <= 2K, to avoid any ECC-related
>
>> +issues during boot, prefer HW ECC over SW ECC.
>> +
>> +For devicetree binding information please refer the below dt binding file
>
>                                              refer to the below
>
>> +Documentation/devicetree/bindings/memory-controllers/pl353-smc.txt
>>
>
>
> --
> ~Randy

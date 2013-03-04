Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755661Ab3CDIhK (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 Mar 2013 03:37:10 -0500
Received: from mga01.intel.com ([192.55.52.88]:50259 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755350Ab3CDIhJ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 Mar 2013 03:37:09 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.84,778,1355126400"; 
   d="scan'208";a="294391166"
Message-ID: <1362386260.2943.9.camel@sauron>
Subject: Re: [PATCH V3 1/3] mtd: add new fields to nand_flash_dev{}
From: Artem Bityutskiy <dedekind1@gmail.com>
Reply-To: dedekind1@gmail.com
To: Huang Shijie <b32955@freescale.com>
Cc: Huang Shijie <shijie8@gmail.com>, dwmw2@infradead.org,
        computersforpeace@gmail.com, linux-mtd@lists.infradead.org,
        linux-kernel@vger.kernel.org
Date: Mon, 04 Mar 2013 10:37:40 +0200
In-Reply-To: <5134566C.2090405@freescale.com>
References: <1359349039-11510-1-git-send-email-b32955@freescale.com>
			 <1359349039-11510-2-git-send-email-b32955@freescale.com>
			 <1360684037.12703.117.camel@sauron.fi.intel.com>
			 <CAMiH66ExMK8rPMw3kvs9M2b-0ZSkfxBYteTi8QTZf+XCzJw5Dw@mail.gmail.com>
		 <1362234094.2745.9.camel@sauron> <513437DF.2030505@freescale.com>
	 <1362383434.2943.5.camel@sauron> <5134566C.2090405@freescale.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.6.3 (3.6.3-2.fc18) 
Mime-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2013-03-04 at 16:08 +0800, Huang Shijie wrote:
> 于 2013年03月04日 15:50, Artem Bityutskiy 写道:
> > On Mon, 2013-03-04 at 13:57 +0800, Huang Shijie wrote:
> >> The current code uses the @id to store the device id(byte 1).
> >> But if we use the 8 bytes id data as the keyword, and expand the @id
> >> field to 8byte array,
> >> the device id is the second byte now. All the added zeros are for the
> > I do not think you need to store the full array of ID's. Device ID's for
> > all the 4 of above chips are different, which is enough to distinguish
> > between them.
> >
> > The only thing you need to add is the OOB size field to 'struct
> > nand_flash_dev'.
> >
> If i only add the oob size field. There will be two items with the same 
> Device ID in nand_flash_ids table,
> one has oob_size, one does not have. such as:
> 
>     {"NAND 8GIB 3,3V 8-bit", 0xDE, 0, 8192, 0, LP_OPTIONS},

OK, I guess for this one:

{"NAND 8GIB 3,3V 8-bit", 0xDE, 0, 8192, 0, LP_OPTIONS, 0},

nand_decode_ext_id() will calculate the OOB size.

>     {"NAND 8GIB 3,3V 8-bit", 0xDE, 0, 8192, 0, LP_OPTIONS, 640},   //OOB 
> size is 640.

And for this one 'nand_decode_ext_id()' will calculate it too, but
_afterwards_ we change OOB size to 640.

Does this sound sane?

-- 
Best Regards,
Artem Bityutskiy


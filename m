Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932822Ab3CMNMd (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Mar 2013 09:12:33 -0400
Received: from mga14.intel.com ([143.182.124.37]:59710 "EHLO mga14.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932295Ab3CMNMc (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Mar 2013 09:12:32 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.84,837,1355126400"; 
   d="scan'208";a="269912713"
Message-ID: <1363180395.11441.57.camel@sauron.fi.intel.com>
Subject: Re: [PATCH V4 1/3] mtd: add new fields to nand_flash_dev{}
From: Artem Bityutskiy <artem.bityutskiy@linux.intel.com>
Reply-To: artem.bityutskiy@linux.intel.com
To: Huang Shijie <shijie8@gmail.com>
Cc: Huang Shijie <b32955@freescale.com>, dwmw2@infradead.org,
        computersforpeace@gmail.com, linux-mtd@lists.infradead.org,
        linux-kernel@vger.kernel.org
Date: Wed, 13 Mar 2013 15:13:15 +0200
In-Reply-To: <CAMiH66HyH7tQG96UMKed6prpqBa=sgyntdO1pf0yG+=qyigY0Q@mail.gmail.com>
References: <1362653364-29993-1-git-send-email-b32955@freescale.com>
	 <1362653364-29993-2-git-send-email-b32955@freescale.com>
	 <1363172096.11441.11.camel@sauron.fi.intel.com>
	 <CAMiH66HyH7tQG96UMKed6prpqBa=sgyntdO1pf0yG+=qyigY0Q@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.6.3 (3.6.3-2.fc18) 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2013-03-13 at 21:04 +0800, Huang Shijie wrote:
> On Wed, Mar 13, 2013 at 6:54 PM, Artem Bityutskiy
> <artem.bityutskiy@linux.intel.com> wrote:
> > On Thu, 2013-03-07 at 18:49 +0800, Huang Shijie wrote:
> >> diff --git a/include/linux/mtd/nand.h b/include/linux/mtd/nand.h
> >> index 591eeeb..f0a9d93 100644
> >> --- a/include/linux/mtd/nand.h
> >> +++ b/include/linux/mtd/nand.h
> >> @@ -578,6 +578,8 @@ struct nand_chip {
> >>   * @erasesize: eraseblock size in bytes (determined from the extended ID if 0)
> >>   * @chipsize: total chip size in MiB
> >>   * @options: stores various chip bit options
> >> + * @id_len: The valid length of the @id.
> >> + * @oobsize: OOB size
> >>   */
> >>  struct nand_flash_dev {
> >>       char *name;
> >> @@ -592,6 +594,8 @@ struct nand_flash_dev {
> >>       unsigned long chipsize;
> >>       unsigned long erasesize;
> >>       unsigned long options;
> >> +     unsigned long id_len;
> >> +     unsigned long oobsize;
> >>  };
> >
> > Why are these of type 'long', which is 64 bits in 64-bit architectures,
> > which seems to be unnecessarily big. Wouldn't 'unsigned int' be enough?
> >
> Frankly speaking, "uint16_t" is enough.
> "unsigned int" is too long for both the fields.

Adding a single uint16_t is useless because GCC will pad it to 32 bits
anyway. I send a patch which turns all the longs to ints. Just add
another int. And yes, do not add id_len unless you need it. Thanks!

-- 
Best Regards,
Artem Bityutskiy


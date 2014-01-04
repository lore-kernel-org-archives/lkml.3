Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754554AbaADGQz (ORCPT <rfc822;w@1wt.eu>);
	Sat, 4 Jan 2014 01:16:55 -0500
Received: from mail-pd0-f181.google.com ([209.85.192.181]:44107 "EHLO
	mail-pd0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751240AbaADGQx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 4 Jan 2014 01:16:53 -0500
Date: Fri, 3 Jan 2014 22:16:50 -0800
From: Dmitry Torokhov <dmitry.torokhov@gmail.com>
To: Andrey Smirnov <andrew.smirnov@gmail.com>
Cc: linux-input@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] Input: ims-pcu - remove unneeded get_unaligned_xxx
Message-ID: <20140104061650.GB20272@core.coreip.homeip.net>
References: <20140104052756.GA32561@core.coreip.homeip.net>
 <CAHQ1cqG2=CX6ypONUgVgzjG_3nVJOBLq5LPYwN0BrzwOLCTxzQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAHQ1cqG2=CX6ypONUgVgzjG_3nVJOBLq5LPYwN0BrzwOLCTxzQ@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jan 03, 2014 at 09:52:25PM -0800, Andrey Smirnov wrote:
> On Fri, Jan 3, 2014 at 9:28 PM, Dmitry Torokhov
> <dmitry.torokhov@gmail.com> wrote:
> > pcu->cmd_buf[IMS_PCU_DATA_OFFSET] is word aligned so we do not need to use
> > get_unaligned_le16 to access it.
> >
> > Also let's add build time check to make sure it stays aligned.
> 
> - AFAIK, there's no guarantee the "pcu" itself is aligned

Yes. kmalloc returns aligned pointer, otherwise every access to members
other than u8 would risk unaligned exception.

> - This change assumes that aligning data on the 2-byte boundary is
> sufficient for all architectures that do not allow unaligned data
> access, which I don't think is a good assumption to make

What arches require word access be double-word aligned?

> - On x86 or any other architecture that allows unaligned access
> get_unaligned_le16() is actually results to call to le16_to_cpup(), so
> this change doesn't really save anything while imposing restrictions
> on the arrangement of the fields in struct ims_pcu and causing
> unnecessary build errors.

Unless somebody changes the layout there won't be any new build errors,
will there?

Thanks.

-- 
Dmitry

Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754647AbaADFlh (ORCPT <rfc822;w@1wt.eu>);
	Sat, 4 Jan 2014 00:41:37 -0500
Received: from mail-pa0-f48.google.com ([209.85.220.48]:61586 "EHLO
	mail-pa0-f48.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752536AbaADFlg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 4 Jan 2014 00:41:36 -0500
Date: Fri, 3 Jan 2014 21:41:33 -0800
From: Dmitry Torokhov <dmitry.torokhov@gmail.com>
To: Andrey Smirnov <andrew.smirnov@gmail.com>
Cc: linux-input@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2] ims-pcu: Add commands supported by the new version of
 the FW
Message-ID: <20140104054133.GC32576@core.coreip.homeip.net>
References: <1388623621-32245-1-git-send-email-andrew.smirnov@gmail.com>
 <20140104013957.GA19702@core.coreip.homeip.net>
 <CAHQ1cqEvXn3u2joA7dNaiz6fmHELnKjZTWF2F-7vvvBAx+9Drw@mail.gmail.com>
 <20140104044433.GA20272@core.coreip.homeip.net>
 <CAHQ1cqHJOi5mLptHSTw3W8dpdyJrUp8QnmCTtYdNX4YCTTNoaA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAHQ1cqHJOi5mLptHSTw3W8dpdyJrUp8QnmCTtYdNX4YCTTNoaA@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jan 03, 2014 at 09:03:11PM -0800, Andrey Smirnov wrote:
> On Fri, Jan 3, 2014 at 8:44 PM, Dmitry Torokhov
> <dmitry.torokhov@gmail.com> wrote:
> > On Fri, Jan 03, 2014 at 08:24:17PM -0800, Andrey Smirnov wrote:
> >> On Fri, Jan 3, 2014 at 5:39 PM, Dmitry Torokhov
> >> <dmitry.torokhov@gmail.com> wrote:
> >> > Hi Andrey,
> >> >
> >> > On Wed, Jan 01, 2014 at 04:47:01PM -0800, Andrey Smirnov wrote:
> >> >> New version of the PCU firmware supports two new commands:
> >> >>   - IMS_PCU_CMD_OFN_SET_CONFIG which allows to write data to the
> >> >>   registers of one finger navigation(OFN) chip present on the device
> >> >>   - IMS_PCU_CMD_OFN_GET_CONFIG which allows to read data form the
> >> >>   registers of said chip.
> >> >>
> >> >> This commit adds two helper functions to use those commands and sysfs
> >> >> attributes to use them. It also exposes some OFN configuration
> >> >> parameters via sysfs.
> >> >
> >> > Thank you for making the changes. I do not still quite like the games we
> >> > play with the OFN attributes, how about the patch below (on top of
> >> > yours)?
> >> >
> >>
> >> Yeah, I agree I like it the "two separate sysfs groups" group approach
> >> better. The only small nitpick about your patch is that I think we
> >> should use "get_unaligned_le16" instead of "le16_to_cpup"(In case
> >> anyone decides to run the driver on SuperH or C6x DSPs from TI :-)).
> >> Let me test it and if everything works as expected I'll apply you
> >> patch, convert it to "get_unaligned_le16", squash and send v3 of the
> >> patch.
> >
> > Why do we need get_unaligned_le16()? As far as I can see pcu->cmd_buf is
> > aligned and therefore pcu->cmd_buf[2] is also aligned on word boundary.
> 
> * The "pcu" structure is allocated with kmalloc which doesn't give any
> guarantees about address alignment.
> * I am not sure if the cmd_buf field in that structure is aligned, and
> even if it is, any future changes to that structure may shift its
> offset.
> * Also even if the data we are interested in is aligned on 2-byte
> border, I think all those architectures require 4-byte border
> alignment.

As far as I know word access only requires word alignment. Please see
the other patch I just posted that adds alignment check in balcklight
handling code.

Thanks.

-- 
Dmitry

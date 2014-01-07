Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753627AbaAGTOO (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Jan 2014 14:14:14 -0500
Received: from mail-pb0-f49.google.com ([209.85.160.49]:65055 "EHLO
	mail-pb0-f49.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750867AbaAGTOI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Jan 2014 14:14:08 -0500
MIME-Version: 1.0
In-Reply-To: <20140107071436.GB20074@core.coreip.homeip.net>
References: <1388623621-32245-1-git-send-email-andrew.smirnov@gmail.com>
	<20140104013957.GA19702@core.coreip.homeip.net>
	<CAHQ1cqEvXn3u2joA7dNaiz6fmHELnKjZTWF2F-7vvvBAx+9Drw@mail.gmail.com>
	<20140104044433.GA20272@core.coreip.homeip.net>
	<CAHQ1cqHJOi5mLptHSTw3W8dpdyJrUp8QnmCTtYdNX4YCTTNoaA@mail.gmail.com>
	<20140104054133.GC32576@core.coreip.homeip.net>
	<20140107071436.GB20074@core.coreip.homeip.net>
Date: Tue, 7 Jan 2014 11:14:07 -0800
Message-ID: <CAHQ1cqEBAYCFjmN4qPyNwXLrocQ+BE3WMeg0_A2zxz_N4r6h3w@mail.gmail.com>
Subject: Re: [PATCH v2] ims-pcu: Add commands supported by the new version of
 the FW
From: Andrey Smirnov <andrew.smirnov@gmail.com>
To: Dmitry Torokhov <dmitry.torokhov@gmail.com>
Cc: linux-input@vger.kernel.org, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Sorry, haven't had the chance yet. I'll try to do this and hopefully
send v3 of the patch by the end of this week

On Mon, Jan 6, 2014 at 11:14 PM, Dmitry Torokhov
<dmitry.torokhov@gmail.com> wrote:
> On Fri, Jan 03, 2014 at 09:41:33PM -0800, Dmitry Torokhov wrote:
>> On Fri, Jan 03, 2014 at 09:03:11PM -0800, Andrey Smirnov wrote:
>> > On Fri, Jan 3, 2014 at 8:44 PM, Dmitry Torokhov
>> > <dmitry.torokhov@gmail.com> wrote:
>> > > On Fri, Jan 03, 2014 at 08:24:17PM -0800, Andrey Smirnov wrote:
>> > >> On Fri, Jan 3, 2014 at 5:39 PM, Dmitry Torokhov
>> > >> <dmitry.torokhov@gmail.com> wrote:
>> > >> > Hi Andrey,
>> > >> >
>> > >> > On Wed, Jan 01, 2014 at 04:47:01PM -0800, Andrey Smirnov wrote:
>> > >> >> New version of the PCU firmware supports two new commands:
>> > >> >>   - IMS_PCU_CMD_OFN_SET_CONFIG which allows to write data to the
>> > >> >>   registers of one finger navigation(OFN) chip present on the device
>> > >> >>   - IMS_PCU_CMD_OFN_GET_CONFIG which allows to read data form the
>> > >> >>   registers of said chip.
>> > >> >>
>> > >> >> This commit adds two helper functions to use those commands and sysfs
>> > >> >> attributes to use them. It also exposes some OFN configuration
>> > >> >> parameters via sysfs.
>> > >> >
>> > >> > Thank you for making the changes. I do not still quite like the games we
>> > >> > play with the OFN attributes, how about the patch below (on top of
>> > >> > yours)?
>> > >> >
>> > >>
>> > >> Yeah, I agree I like it the "two separate sysfs groups" group approach
>> > >> better. The only small nitpick about your patch is that I think we
>> > >> should use "get_unaligned_le16" instead of "le16_to_cpup"(In case
>> > >> anyone decides to run the driver on SuperH or C6x DSPs from TI :-)).
>> > >> Let me test it and if everything works as expected I'll apply you
>> > >> patch, convert it to "get_unaligned_le16", squash and send v3 of the
>> > >> patch.
>> > >
>> > > Why do we need get_unaligned_le16()? As far as I can see pcu->cmd_buf is
>> > > aligned and therefore pcu->cmd_buf[2] is also aligned on word boundary.
>> >
>> > * The "pcu" structure is allocated with kmalloc which doesn't give any
>> > guarantees about address alignment.
>> > * I am not sure if the cmd_buf field in that structure is aligned, and
>> > even if it is, any future changes to that structure may shift its
>> > offset.
>> > * Also even if the data we are interested in is aligned on 2-byte
>> > border, I think all those architectures require 4-byte border
>> > alignment.
>>
>> As far as I know word access only requires word alignment. Please see
>> the other patch I just posted that adds alignment check in balcklight
>> handling code.
>
> Andrey, were you able to test the patch?
>
> Thanks.
>
> --
> Dmitry

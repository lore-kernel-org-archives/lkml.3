Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754706AbaADEoi (ORCPT <rfc822;w@1wt.eu>);
	Fri, 3 Jan 2014 23:44:38 -0500
Received: from mail-pb0-f46.google.com ([209.85.160.46]:42322 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754052AbaADEog (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 3 Jan 2014 23:44:36 -0500
Date: Fri, 3 Jan 2014 20:44:33 -0800
From: Dmitry Torokhov <dmitry.torokhov@gmail.com>
To: Andrey Smirnov <andrew.smirnov@gmail.com>
Cc: linux-input@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2] ims-pcu: Add commands supported by the new version of
 the FW
Message-ID: <20140104044433.GA20272@core.coreip.homeip.net>
References: <1388623621-32245-1-git-send-email-andrew.smirnov@gmail.com>
 <20140104013957.GA19702@core.coreip.homeip.net>
 <CAHQ1cqEvXn3u2joA7dNaiz6fmHELnKjZTWF2F-7vvvBAx+9Drw@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAHQ1cqEvXn3u2joA7dNaiz6fmHELnKjZTWF2F-7vvvBAx+9Drw@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jan 03, 2014 at 08:24:17PM -0800, Andrey Smirnov wrote:
> On Fri, Jan 3, 2014 at 5:39 PM, Dmitry Torokhov
> <dmitry.torokhov@gmail.com> wrote:
> > Hi Andrey,
> >
> > On Wed, Jan 01, 2014 at 04:47:01PM -0800, Andrey Smirnov wrote:
> >> New version of the PCU firmware supports two new commands:
> >>   - IMS_PCU_CMD_OFN_SET_CONFIG which allows to write data to the
> >>   registers of one finger navigation(OFN) chip present on the device
> >>   - IMS_PCU_CMD_OFN_GET_CONFIG which allows to read data form the
> >>   registers of said chip.
> >>
> >> This commit adds two helper functions to use those commands and sysfs
> >> attributes to use them. It also exposes some OFN configuration
> >> parameters via sysfs.
> >
> > Thank you for making the changes. I do not still quite like the games we
> > play with the OFN attributes, how about the patch below (on top of
> > yours)?
> >
> 
> Yeah, I agree I like it the "two separate sysfs groups" group approach
> better. The only small nitpick about your patch is that I think we
> should use "get_unaligned_le16" instead of "le16_to_cpup"(In case
> anyone decides to run the driver on SuperH or C6x DSPs from TI :-)).
> Let me test it and if everything works as expected I'll apply you
> patch, convert it to "get_unaligned_le16", squash and send v3 of the
> patch.

Why do we need get_unaligned_le16()? As far as I can see pcu->cmd_buf is
aligned and therefore pcu->cmd_buf[2] is also aligned on word boundary.

Thanks.

-- 
Dmitry

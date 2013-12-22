Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756375Ab3LVAkO (ORCPT <rfc822;w@1wt.eu>);
	Sat, 21 Dec 2013 19:40:14 -0500
Received: from mail.linuxfoundation.org ([140.211.169.12]:33776 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755141Ab3LVAkL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 21 Dec 2013 19:40:11 -0500
Date: Sat, 21 Dec 2013 16:40:23 -0800
From: Greg KH <gregkh@linuxfoundation.org>
To: Ravi Patel <rapatel@apm.com>
Cc: Arnd Bergmann <arnd@arndb.de>, davem@davemloft.net, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, devicetree@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, jcm@redhat.com,
        "patches@apm.com" <patches@apm.com>, Keyur Chudgar <kchudgar@apm.com>
Subject: Re: [PATCH 2/4] misc: xgene: Add base driver for APM X-Gene SoC
 Queue Manager/Traffic Manager
Message-ID: <20131222004023.GA15645@kroah.com>
References: <1387507503-7565-1-git-send-email-rapatel@apm.com>
 <1387507503-7565-3-git-send-email-rapatel@apm.com>
 <20131220032002.GA32310@kroah.com>
 <CAN1v_PtWrRQ6i0HAOACGP4ahgMB1393GnZS-OG6LTyPcsnpvhg@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAN1v_PtWrRQ6i0HAOACGP4ahgMB1393GnZS-OG6LTyPcsnpvhg@mail.gmail.com>
User-Agent: Mutt/1.5.22 (2013-10-16)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Dec 21, 2013 at 04:20:04PM -0800, Ravi Patel wrote:
> On Thu, Dec 19, 2013 at 7:20 PM, Greg KH <gregkh@linuxfoundation.org> wrote:
> > On Thu, Dec 19, 2013 at 06:45:01PM -0800, Ravi Patel wrote:
> >> --- /dev/null
> >> +++ b/drivers/misc/xgene/qmtm/Kconfig
> >> @@ -0,0 +1,8 @@
> >> +config XGENE_QMTM
> >> +     tristate "APM X-Gene QMTM driver"
> >> +     depends on ARCH_XGENE
> >
> > What does it need from this arch in order to build?  What would be
> > needed to get it to build on other arches so that it gets some actualy
> > build testing?
> 
> In patch v2 added, depends on ARM64 || COMPILE_TEST in order to
> support build testing for other arches.
> If you think we should have no dependency at all, let us know.

That's fine, but it's pretty obvious you didn't check this as your v2
version can't build on non XGENE systems :(

> > u64 for a bitfield?  Is that even valid C?  This is pretty scary from a
> > bitfield perspective, what about different endian and addressing modes?
> 
> Currently the patch is supporting only ARM64 LE mode.
> We will fix u64 bit-field with multiple u32 bit-fields for supporting
> ARM32 LE Mode.

Don't use bitfields, use bit shifts, that way it doesn't matter what
endian the system is that it is running on at all.

> > Any chance to just use shifts to access the fields properly, like most
> > drivers do, in a endian-neutral way to get the data out and into the
> > structures?
> >
> > Same goes for the other structures in this file.
> 
> I agree with you that code with bit-mask and bit-shift takes care for
> endian-neutral mode.
> But QMTM in BE Mode, behaves differently by expecting message format
> in memory as follow:
> Swapping at 128 bits level.
> a. For each 16 bytes, group of 4 bytes needs be swapped Higher to
> lower <-> lower to higher,
> b. As well as each bytes/bit fields in the group of 4 bytes also needs
> to be swapped.
> So because of 128 bit level swap, there will be complete different
> code for bit-mask, bit-shift for BE and LE
> So to support ARM64 BE and ARM32 BE, we are planning to just
> re-arrange bit-fields reversely in the structures for BE and LE.

I'll hold off and wait to see what you create, but I think it will be
more complex than just using a bit shift...

good luck,

greg k-h

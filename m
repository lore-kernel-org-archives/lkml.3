Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754879Ab3CSKOH (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Mar 2013 06:14:07 -0400
Received: from mail-we0-f181.google.com ([74.125.82.181]:57840 "EHLO
	mail-we0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754588Ab3CSKOE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Mar 2013 06:14:04 -0400
MIME-Version: 1.0
In-Reply-To: <Pine.LNX.4.44L0.1303181010540.1922-100000@iolanthe.rowland.org>
References: <20130318101854.GQ17135@arwen.pp.htv.fi>
	<Pine.LNX.4.44L0.1303181010540.1922-100000@iolanthe.rowland.org>
Date: Tue, 19 Mar 2013 18:14:02 +0800
Message-ID: <CADB-GoLzX-G5j92oEsLeUq6PRpKwb15U6LL_jw4zh6Nhh+ZHLg@mail.gmail.com>
Subject: Re: [PATCH] usb host: Faraday FUSBH200 HCD driver.
From: Yuan-Hsin Chen <yuanlmm@gmail.com>
To: Alan Stern <stern@rowland.harvard.edu>
Cc: Felipe Balbi <balbi@ti.com>, gregkh@linuxfoundation.org,
        sarah.a.sharp@linux.intel.com, Julia.Lawall@lip6.fr,
        linux-usb@vger.kernel.org, linux-kernel@vger.kernel.org,
        Yuan-Hsin Chen <yhchen@faraday-tech.com>, john453@faraday-tech.com
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

On Mon, Mar 18, 2013 at 10:16 PM, Alan Stern <stern@rowland.harvard.edu> wrote:
> On Mon, 18 Mar 2013, Felipe Balbi wrote:
>
>> On Mon, Mar 18, 2013 at 06:06:18PM +0800, Yuan-Hsin Chen wrote:
>> > Hi,
>> >
>> > I tried to modify fusbh200 hcd driver following ehci-platform.c.
>> > However, the register definition of fusbh200 is partially incompatible
>> > to ehci. For fusbh200, only the elements between "command" and
>> > "async_next" in struct ehci_regs are consistent with ehci which means
>
> What about the port_status registers?  They're not between command and
> async_next.  If they aren't consistent with EHCI, it makes things a lot
> more complicated.

fusbh200 has only one port_status register with different offset,
0x30, and the position of some bits are different from EHCI.

>
>> > it would cause copious modification and duplication of ehci hcd
>> > driver. For example, there is no "configured_flag" register in
>> > fusbh200 controller, yet, ehci hcd driver accesses "configured_flag"
>> > in function ehci_run which would cause compile errors. Therefore,
>> > maybe my first patch which refers to oxu210hp-hcd is a better
>> > solution?
>>
>> why don't you just add a quirk flag to ehci struct so that it knows it
>> shouldn't access CONFIGFLAG register when that's non-existent ?

Also, usbmode_ex, hostpc, and txfill_tuning other than configured_flag
are non-existent in fusbh200. They are used in both ehci-hcd.c and
ehci-hub.c for several times.

>>
>> There are only 5 uses of configured_flag in ehci-hcd.c, so it should be
>> easy to wrap that around a flag check.
>
> Two of those uses turn configured_flag on and two of them turn it off.
> However, one of the uses tests its value (the first one in
> ehci_resume).  How would that be handled if configured_flag doesn't
> exist?
>
>> Alan, would you have a better idea ? Looks like this is a non-standard
>> EHCI implementation.
>
> Yes, it does.  If all we need is to protect four or five accesses with
> a quirk flag, that's okay with me.

Thanks for your time.

>
> Alan Stern
>

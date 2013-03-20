Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933807Ab3CTFuR (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Mar 2013 01:50:17 -0400
Received: from mail-wi0-f172.google.com ([209.85.212.172]:44635 "EHLO
	mail-wi0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751246Ab3CTFuP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Mar 2013 01:50:15 -0400
MIME-Version: 1.0
In-Reply-To: <Pine.LNX.4.44L0.1303191142330.15684-100000@netrider.rowland.org>
References: <CADB-GoLzX-G5j92oEsLeUq6PRpKwb15U6LL_jw4zh6Nhh+ZHLg@mail.gmail.com>
	<Pine.LNX.4.44L0.1303191142330.15684-100000@netrider.rowland.org>
Date: Wed, 20 Mar 2013 13:50:13 +0800
Message-ID: <CADB-GoL_ZMqtzdyyzaUQRn0S9vbgamsjWP5tEjq09S8PLsaKvQ@mail.gmail.com>
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

On Tue, Mar 19, 2013 at 11:48 PM, Alan Stern <stern@rowland.harvard.edu> wrote:
> On Tue, 19 Mar 2013, Yuan-Hsin Chen wrote:
>
>> > What about the port_status registers?  They're not between command and
>> > async_next.  If they aren't consistent with EHCI, it makes things a lot
>> > more complicated.
>>
>> fusbh200 has only one port_status register with different offset,
>> 0x30, and the position of some bits are different from EHCI.
>
> That's pretty nasty.  Integrating that with the standard EHCI driver
> would be considerably more difficult.
>
> Why was the FUSBH200 designed in this strange way?  Why doesn't it use
> the standard EHCI register layout?  Were the engineers at Faraday
> deliberately trying to make life harder for driver writers?

Since FUSBH200 was designed more than eight years ago, the engineers
responsible for FUSBH200 are no longer working for Faraday. I have the
same question as you, but no one here could answer it. The strange
register layout and other implementation incompatible with EHCI are
the reasons why the FUSBH200 driver was not tried to submit to
mainline in the past.

>
>> Also, usbmode_ex, hostpc, and txfill_tuning other than configured_flag
>> are non-existent in fusbh200. They are used in both ehci-hcd.c and
>> ehci-hub.c for several times.
>
> They are used only if the hardware supports them, that is, only if the
> ehci->has_hostpc flag is set.
>
> Alan Stern
>

Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932172Ab3CUGf6 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 Mar 2013 02:35:58 -0400
Received: from mail-wg0-f51.google.com ([74.125.82.51]:34056 "EHLO
	mail-wg0-f51.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754067Ab3CUGf4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 Mar 2013 02:35:56 -0400
MIME-Version: 1.0
In-Reply-To: <Pine.LNX.4.44L0.1303201024190.1701-100000@iolanthe.rowland.org>
References: <CADB-GoLncGoXmJsxXPUZocz1fJe9uUBX+mtgBVkuUR1SqbOBEQ@mail.gmail.com>
	<Pine.LNX.4.44L0.1303201024190.1701-100000@iolanthe.rowland.org>
Date: Thu, 21 Mar 2013 14:35:54 +0800
Message-ID: <CADB-GoKACxJCNqj3OsQdgmWoK3y-hgbiLoCBzA7kbcJ3rMoheA@mail.gmail.com>
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

On Wed, Mar 20, 2013 at 10:26 PM, Alan Stern <stern@rowland.harvard.edu> wrote:
> On Wed, 20 Mar 2013, Yuan-Hsin Chen wrote:
>
>> Hi,
>>
>> On Tue, Mar 19, 2013 at 11:48 PM, Alan Stern <stern@rowland.harvard.edu> wrote:
>> > On Tue, 19 Mar 2013, Yuan-Hsin Chen wrote:
>> >
>> >> > What about the port_status registers?  They're not between command and
>> >> > async_next.  If they aren't consistent with EHCI, it makes things a lot
>> >> > more complicated.
>> >>
>> >> fusbh200 has only one port_status register with different offset,
>> >> 0x30, and the position of some bits are different from EHCI.
>>
>> How about adding kernel configuration to adjust offset for FUSBH200 in
>> ehci_def.h? So port_status would be in offset 0x20 from ehci_regs.
>>
>> For example,
>>
>>         /* ASYNCLISTADDR: offset 0x18 */
>>         u32             async_next;     /* address of next async queue head */
>>
>> #ifndef CONFIG_USB_EHCI_HCD_FUSBH200
>>         u32             reserved1[2];
>>
>>         /* TXFILLTUNING: offset 0x24 */
>>         u32             txfill_tuning;  /* TX FIFO Tuning register */
>> #define TXFIFO_DEFAULT  (8<<16)         /* FIFO burst threshold 8 */
>>
>>         u32             reserved2[6];
>>
>>         /* CONFIGFLAG: offset 0x40 */
>>         u32             configured_flag;
>> #define FLAG_CF         (1<<0)          /* true: we'll support "high speed" */
>>
>> #else
>>         u32             reserved1;
>> #endif
>>         /* PORTSC: offset 0x44 */
>>         u32             port_status[0]; /* up to N_PORTS */
>
> This is acceptable _only_ if it is not possible to use an FUSBH200
> controller in the same computer as a normal EHCI controller.
>
>> Furthermore, there are PORT_POWER, PORT_OWNER, PORT_LED_XXX,
>> PORT_TEST, PORT_WKCONN_E, PORT_WKDISC_E, PORT_WKOC_E absent in
>> port_status of FUSBH200. Also PORT_OC and PORT_OCC are in another
>> register. Is it ok to use quirk flag also?
>
> Yes, those can be handled by a quirk flag.  Does the FUSBH200 have a
> built-in Transaction Translator?

Yes, the FUSBH200 has built-in Transaction Translator.

I will modify the driver based on what we discussed before and re-submit it.
Thank you for your time.

>
> Alan Stern
>

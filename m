Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754110Ab3CRKGX (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Mar 2013 06:06:23 -0400
Received: from mail-wg0-f53.google.com ([74.125.82.53]:36225 "EHLO
	mail-wg0-f53.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752247Ab3CRKGT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Mar 2013 06:06:19 -0400
MIME-Version: 1.0
In-Reply-To: <CADB-GoJJbV10YGtBU-qWT7XK9SvkgPXkg3x-7oKq9RjSsODuEA@mail.gmail.com>
References: <1360149841-2392-1-git-send-email-yuanlmm@gmail.com>
	<20130206163759.GB9952@arwen.pp.htv.fi>
	<CADB-GoJJbV10YGtBU-qWT7XK9SvkgPXkg3x-7oKq9RjSsODuEA@mail.gmail.com>
Date: Mon, 18 Mar 2013 18:06:18 +0800
Message-ID: <CADB-GoJMKJ_ed+K4_du5nXo54ZfGBy3s42uca1-vcQzm6Fdzyw@mail.gmail.com>
Subject: Re: [PATCH] usb host: Faraday FUSBH200 HCD driver.
From: Yuan-Hsin Chen <yuanlmm@gmail.com>
To: balbi@ti.com
Cc: gregkh@linuxfoundation.org, stern@rowland.harvard.edu,
        sarah.a.sharp@linux.intel.com, Julia.Lawall@lip6.fr,
        linux-usb@vger.kernel.org, linux-kernel@vger.kernel.org,
        Yuan-Hsin Chen <yhchen@faraday-tech.com>, john453@faraday-tech.com
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

I tried to modify fusbh200 hcd driver following ehci-platform.c.
However, the register definition of fusbh200 is partially incompatible
to ehci. For fusbh200, only the elements between "command" and
"async_next" in struct ehci_regs are consistent with ehci which means
it would cause copious modification and duplication of ehci hcd
driver. For example, there is no "configured_flag" register in
fusbh200 controller, yet, ehci hcd driver accesses "configured_flag"
in function ehci_run which would cause compile errors. Therefore,
maybe my first patch which refers to oxu210hp-hcd is a better
solution?

Thanks for your time.

Yuan-Hsin


On Thu, Feb 7, 2013 at 11:03 AM, Yuan-Hsin Chen <yuanlmm@gmail.com> wrote:
> On Thu, Feb 7, 2013 at 12:38 AM, Felipe Balbi <balbi@ti.com> wrote:
>> On Wed, Feb 06, 2013 at 07:24:01PM +0800, Yuan-Hsin Chen wrote:
>>> From: Yuan-Hsin Chen <yhchen@faraday-tech.com>
>>>
>>> USB2.0 HCD driver for Faraday FUSBH200
>>>
>>> Signed-off-by: Yuan-Hsin Chen <yhchen@faraday-tech.com>
>>
>> just use ehci-platform.c and avoid the duplication
>>
>> --
>> balbi
>
> Thanks for your advice. I will modify and re-submit it later.
>
> Yuan-Hsin

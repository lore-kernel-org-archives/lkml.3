Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760142Ab3HNSVN (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Aug 2013 14:21:13 -0400
Received: from prod-mail-xrelay02.akamai.com ([72.246.2.14]:56251 "EHLO
	prod-mail-xrelay02.akamai.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1758263Ab3HNSVL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Aug 2013 14:21:11 -0400
Message-ID: <520BCA96.5020106@akamai.com>
Date: Wed, 14 Aug 2013 14:21:10 -0400
From: Jason Baron <jbaron@akamai.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130330 Thunderbird/17.0.5
MIME-Version: 1.0
To: Joe Perches <joe@perches.com>
CC: Sarah Sharp <sarah.a.sharp@linux.intel.com>,
        Xenia Ragiadakou <burzalodowa@gmail.com>,
        Greg KH <gregkh@linuxfoundation.org>,
        "linux-usb@vger.kernel.org" <linux-usb@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: Dynamic debug on by default?
References: <20130814164022.GA22934@xanatos> <1376499114.1949.81.camel@joe-AO722>
In-Reply-To: <1376499114.1949.81.camel@joe-AO722>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 08/14/2013 12:51 PM, Joe Perches wrote:
> On Wed, 2013-08-14 at 09:40 -0700, Sarah Sharp wrote:
>> Hi Xenia,
>>
>> I'm a bit confused.  I thought that debugging messages would be turned
>> off by default for a module if CONFIG_DYNAMIC_DEBUG was turned on.  When
>> I tested your patch to remove the CONFIG_USB_XHCI_HCD_DEBUGGING and just
>> use dev_dbg, the messages from the xHCI driver appeared in dmesg by
>> default.
>>
>> That generates a lot of log spew.  We can have distros add a boot
>> parameter option to turn off debug messages, but that boot parameter is
>> limited to 1023 characters.  I'm concerned that if more drivers add
>> dynamic debugging, the distros will eventually run out of space in the
>> dynamic debugging boot parameter.  I know Greg was ripping out debugging
>> config options in other USB drivers, so this is a bit concerning.
>>
>> Jason, is there a way within the xHCI driver to say that dynamic
>> debugging should be off by default?  I've looked through the
>> documentation, and I can't find anything like that documented.
> #undefine DEBUG
>
>> I've attached my .config file, in case I have something misconfigured.
> Because of:
>
> drivers/usb/host/Makefile:ccflags-$(CONFIG_USB_DEBUG) := -DDEBUG
>
> you probably want to turn this off
>
> CONFIG_USB_DEBUG=y
>
> when dynamic_debug is on.

They should also be emitted in the case that dynamic_debug is off, but
we have set -DDEBUG, right? That was the whole point of enabling them
for dynamic debug too - to mirror the behavior of !CONFIG_DYNAMIC_DEBUG
case.

-Jason


> CONFIG_DYNAMIC_DEBUG=y
>
> This will cause all pr_debug/dev_dbg statements to be
> emitted without specific enabling via the dynamic_debug
> control file.
>
> (from include/linux/dynamic_debug.h)
>
> #if defined DEBUG
> #define _DPRINTK_FLAGS_DEFAULT _DPRINTK_FLAGS_PRINT
> #else
> #define _DPRINTK_FLAGS_DEFAULT 0
> #endif
>
>


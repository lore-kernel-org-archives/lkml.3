Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932919Ab3HNQv4 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Aug 2013 12:51:56 -0400
Received: from perches-mx.perches.com ([206.117.179.246]:33630 "EHLO
	labridge.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S932815Ab3HNQvz (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Aug 2013 12:51:55 -0400
Message-ID: <1376499114.1949.81.camel@joe-AO722>
Subject: Re: Dynamic debug on by default?
From: Joe Perches <joe@perches.com>
To: Sarah Sharp <sarah.a.sharp@linux.intel.com>
Cc: Xenia Ragiadakou <burzalodowa@gmail.com>, Jason Baron <jbaron@akamai.com>,
        Greg KH <gregkh@linuxfoundation.org>, linux-usb@vger.kernel.org,
        linux-kernel@vger.kernel.org
Date: Wed, 14 Aug 2013 09:51:54 -0700
In-Reply-To: <20130814164022.GA22934@xanatos>
References: <20130814164022.GA22934@xanatos>
Content-Type: text/plain; charset="ISO-8859-1"
X-Mailer: Evolution 3.6.4-0ubuntu1 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2013-08-14 at 09:40 -0700, Sarah Sharp wrote:
> Hi Xenia,
> 
> I'm a bit confused.  I thought that debugging messages would be turned
> off by default for a module if CONFIG_DYNAMIC_DEBUG was turned on.  When
> I tested your patch to remove the CONFIG_USB_XHCI_HCD_DEBUGGING and just
> use dev_dbg, the messages from the xHCI driver appeared in dmesg by
> default.
> 
> That generates a lot of log spew.  We can have distros add a boot
> parameter option to turn off debug messages, but that boot parameter is
> limited to 1023 characters.  I'm concerned that if more drivers add
> dynamic debugging, the distros will eventually run out of space in the
> dynamic debugging boot parameter.  I know Greg was ripping out debugging
> config options in other USB drivers, so this is a bit concerning.
> 
> Jason, is there a way within the xHCI driver to say that dynamic
> debugging should be off by default?  I've looked through the
> documentation, and I can't find anything like that documented.

#undefine DEBUG

> I've attached my .config file, in case I have something misconfigured.

Because of:

drivers/usb/host/Makefile:ccflags-$(CONFIG_USB_DEBUG) := -DDEBUG

you probably want to turn this off

CONFIG_USB_DEBUG=y

when dynamic_debug is on.

CONFIG_DYNAMIC_DEBUG=y

This will cause all pr_debug/dev_dbg statements to be
emitted without specific enabling via the dynamic_debug
control file.

(from include/linux/dynamic_debug.h)

#if defined DEBUG
#define _DPRINTK_FLAGS_DEFAULT _DPRINTK_FLAGS_PRINT
#else
#define _DPRINTK_FLAGS_DEFAULT 0
#endif



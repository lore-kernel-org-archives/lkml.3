Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760089Ab3DCMLe (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Apr 2013 08:11:34 -0400
Received: from mail-ea0-f177.google.com ([209.85.215.177]:54611 "EHLO
	mail-ea0-f177.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758607Ab3DCMLc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Apr 2013 08:11:32 -0400
Message-ID: <515C1C61.50301@openwrt.org>
Date: Wed, 03 Apr 2013 14:11:13 +0200
From: Florian Fainelli <florian@openwrt.org>
Organization: OpenWrt
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130308 Thunderbird/17.0.4
MIME-Version: 1.0
To: Alan Stern <stern@rowland.harvard.edu>
CC: Felipe Balbi <balbi@ti.com>,
        Kernel development list <linux-kernel@vger.kernel.org>, arnd@arndb.de,
        gregkh@linuxfoundation.org, USB list <linux-usb@vger.kernel.org>
Subject: Re: [PATCH 1/5 v2] USB: regroup all depends on USB within an if USB
 block
References: <Pine.LNX.4.44L0.1304021359130.1314-100000@iolanthe.rowland.org>
In-Reply-To: <Pine.LNX.4.44L0.1304021359130.1314-100000@iolanthe.rowland.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Le 04/02/13 20:06, Alan Stern a écrit :
> On Tue, 2 Apr 2013, Florian Fainelli wrote:
>
>> This patch removes the depends on USB from all config symbols in
>> drivers/usb/host/Kconfig and replace that with an if USB / endif block
>> as suggested by Alan Stern. Some source ... Kconfig lines have been
>> shuffled around to permit a better regroupment of the Kconfig files
>> depending on "config USB" item. No functionnal change is introduced.
>
> This looks almost right.  The only problem I see is in
> drivers/usb/core/Kconfig.  The USB_OTG_WHITELIST and
> USB_OTG_BLACKLIST_HUB symbols don't have to depend on USB or USB_OTG,
> because they can be set if EXPERT is enabled.
>
> To avoid these issues, I think the best approach is to move all the
> USB_OTG* entries over to drivers/usb/otg/Kconfig, where by rights they
> should have been all along.
>
> Felipe, do you agree?

Make sense, I will make this a sixth patch to this serie if this sounds 
right with you?
--
Florian

Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752954Ab3DWTrA (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Apr 2013 15:47:00 -0400
Received: from moutng.kundenserver.de ([212.227.126.171]:63824 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752621Ab3DWTq7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Apr 2013 15:46:59 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: balbi@ti.com
Subject: Re: [PATCH v2] usb: phy: don't mark usb_bind_phy as __init
Date: Tue, 23 Apr 2013 21:46:19 +0200
User-Agent: KMail/1.12.2 (Linux/3.8.0-18-generic; KDE/4.3.2; x86_64; ; )
Cc: "Greg Kroah-Hartman" <gregkh@linuxfoundation.org>,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        Alan Stern <stern@rowland.harvard.edu>, linux-usb@vger.kernel.org
References: <1366734653-488286-1-git-send-email-arnd@arndb.de> <201304232107.22084.arnd@arndb.de> <20130423193046.GC13453@arwen.pp.htv.fi>
In-Reply-To: <20130423193046.GC13453@arwen.pp.htv.fi>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-15"
Content-Transfer-Encoding: 7bit
Message-Id: <201304232146.20011.arnd@arndb.de>
X-Provags-ID: V02:K0:hrsKQga5acx0yrWIyke/UNUdQiFkqaKtTOrShVJlhQA
 jHp1hihuf6uB/zIFMx8Q1HpMHgRi5IbMBavuDtU81PzE0eXDcN
 kv37bTTb79w32rxcDjQFAgHNPybIQEeV7fid73itDAzGOGuzWl
 xrjxW0ZVfzCXK8Ilx/JGu3rRuEKC+SO6BE5nhLNzqhjelZo9wh
 xMqCqzHDSMOKZKHOPKe1HNKjEm9+dFzJJlLGrJJvrxm7GUSBze
 GE9RRgnil7mW8IWyveVtIlcXSWl253PT6TRjdx9Zb+7XMiYLt3
 K4MqdB+3hQnQaVajsuo+hYlvSPif61HYFMOAvqQZbkxmpsWY7M
 +YuNWRg8uy5rO0y7kXHQ=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday 23 April 2013, Felipe Balbi wrote:
> On Tue, Apr 23, 2013 at 09:07:21PM +0200, Arnd Bergmann wrote:
> > It makes no sense for a symbol to be both exported and marked __init,
> > because any users in modules would be calling this function after
> > it gets discarded. Further, this patch revolves a section mismatch
> > warning from usbhs_init_phys(), which is intentionally not marked
> > __init:
> > 
> > WARNING: vmlinux.o(.text+0x413f8): Section mismatch in reference from
> > the function usbhs_init_phys() to the function .init.text:usb_bind_phy()
> > 
> > Signed-off-by: Arnd Bergmann <arnd@arndb.de>
> > Cc: Alan Stern <stern@rowland.harvard.edu>
> > Cc: Felipe Balbi <balbi@ti.com>
> > Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
> > Cc: linux-usb@vger.kernel.org
> > ---
> > 
> > v2: rebased on linux-next
> 
> not needed, Greg already has a patch doing exactly this in usb-next.

Right, I see it now. I had checked today's linux-next but not usb-next
or any of the other trees for stuff that was just applied today.

	Arnd

Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934236Ab3FSDXE (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Jun 2013 23:23:04 -0400
Received: from mail-ob0-f179.google.com ([209.85.214.179]:48714 "EHLO
	mail-ob0-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933990Ab3FSDXB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Jun 2013 23:23:01 -0400
MIME-Version: 1.0
In-Reply-To: <20130619024839.GA1987@kroah.com>
References: <1371609080-30595-1-git-send-email-chao.xie@marvell.com>
	<20130619024839.GA1987@kroah.com>
Date: Wed, 19 Jun 2013 11:23:00 +0800
Message-ID: <CADApbeikx1yrjVKOREHq45qZDmxF872FY2tN7WBkhPYY=Uxkcw@mail.gmail.com>
Subject: Re: [PATCH V2] USB: initialize or shutdown PHY when add or remove
 host controller
From: Chao Xie <xiechao.mail@gmail.com>
To: Greg KH <gregkh@linuxfoundation.org>
Cc: Chao Xie <chao.xie@marvell.com>, Alan Stern <stern@rowland.harvard.edu>,
        "balbi@ti.com" <balbi@ti.com>, Roger Quadros <rogerq@ti.com>,
        "linux-usb@vger.kernel.org" <linux-usb@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jun 19, 2013 at 10:48 AM, Greg KH <gregkh@linuxfoundation.org> wrote:
> On Tue, Jun 18, 2013 at 10:31:20PM -0400, Chao Xie wrote:
>> Some controller need software to initialize PHY before add
>> host controller, and shut down PHY after remove host controller.
>> Add the generic code for these controllers so they do not need
>> do it in its own host controller driver.
>
> Why?  What breaks if we add this patch, and what gets fixed?  I'm
> guessing you can then remove code?
>
> What out-of-tree code now works properly?  Or gets broken?
>
> we need more info here please...
>
The patch does not fix any bug.
Some echi-xxx driver will need initialize the phy before it do
usb_add_hcd, and shut down phy after
do usb_remove_hcd, and i did a patch for ehci-mv.c to do above thing.
Alan and Felipe comments on my patch, and they think it is a peice of
generic code, and it can be
moved to hcd to handle it, so other ehci-xxx will not do the same thing again.
So i add the patch to add the generic code in hcd to handle phy
initialization and shut down.

> thanks,
>
> greg k-h

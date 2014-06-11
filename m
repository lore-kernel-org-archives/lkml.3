Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755827AbaFKPYN (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Jun 2014 11:24:13 -0400
Received: from iolanthe.rowland.org ([192.131.102.54]:42518 "HELO
	iolanthe.rowland.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1751905AbaFKPYL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Jun 2014 11:24:11 -0400
Date: Wed, 11 Jun 2014 11:24:10 -0400 (EDT)
From: Alan Stern <stern@rowland.harvard.edu>
X-X-Sender: stern@iolanthe.rowland.org
To: Himangi Saraogi <himangi774@gmail.com>
cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        <linux-usb@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        Jan Andersson <jan@gaisler.com>, <julia.lawall@lip6.fr>
Subject: Re: [PATCH v2] usb: host: uhci-grlib.c : use devm_ functions
In-Reply-To: <20140610164548.GA5567@himangi-Dell>
Message-ID: <Pine.LNX.4.44L0.1406111123071.890-100000@iolanthe.rowland.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 10 Jun 2014, Himangi Saraogi wrote:

> The various devm_ functions allocate memory that is released when a
> driver detaches. This patch uses devm_ioremap_resource for data
> that is allocated in the probe function of a platform device and
> is only freed in the remove function. The corresponding free functions
> are removed and two labels are done away with. Also, linux/device.h
> is added to make sure the devm_*() routine declarations are
> unambiguously available.
> 
> Signed-off-by: Himangi Saraogi <himangi774@gmail.com>
> Acked-by: Julia Lawall <julia.lawall@lip6.fr>
> ---
> v2: fix error of devm_ioremap_resource and change label names.


> +	hcd->regs = devm_ioremap_resource(&op->dev, hcd);

Obviously you haven't tried to compile this.

Alan Stern


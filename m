Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752856AbaCBRNO (ORCPT <rfc822;w@1wt.eu>);
	Sun, 2 Mar 2014 12:13:14 -0500
Received: from lxorguk.ukuu.org.uk ([81.2.110.251]:47863 "EHLO
	lxorguk.ukuu.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751114AbaCBRNM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 2 Mar 2014 12:13:12 -0500
Date: Sun, 2 Mar 2014 17:12:06 +0000
From: One Thousand Gnomes <gnomes@lxorguk.ukuu.org.uk>
To: Santosh Shilimkar <santosh.shilimkar@ti.com>
Cc: <linux-kernel@vger.kernel.org>, <linux-arm-kernel@lists.infradead.org>,
        <devicetree@vger.kernel.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Kumar Gala <galak@codeaurora.org>, Paul Walmsley <paul@pwsan.com>,
        Olof Johansson <olof@lixom.net>, Arnd Bergmann <arnd@arndb.de>,
        Sandeep Nair <sandeep_n@ti.com>
Subject: Re: [PATCH 1/3] soc: Introduce drivers/soc place-holder for SOC
 specific drivers
Message-ID: <20140302171206.6adbea6f@alan.etchedpixels.co.uk>
In-Reply-To: <1393629520-12713-2-git-send-email-santosh.shilimkar@ti.com>
References: <1393629520-12713-1-git-send-email-santosh.shilimkar@ti.com>
	<1393629520-12713-2-git-send-email-santosh.shilimkar@ti.com>
Organization: Intel Corporation
X-Mailer: Claws Mail 3.8.1 (GTK+ 2.24.20; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 28 Feb 2014 18:18:38 -0500
Santosh Shilimkar <santosh.shilimkar@ti.com> wrote:

> Based on earlier thread "https://lkml.org/lkml/2013/10/7/662" and
> further discussion at Kernel Summit'2013, it was agreed to create
> 'driver/soc' for drivers which are quite SOC specific.
> 
> Lets take the discussion forward with this patch.

So what happens if you put something in say soc/banana and 3 months later
the same IP block shows up in two other devices both of which have their
own soc/ directory already ?

What happens when the same blocks shows up on both a SoC and
later externally ?

Where does a soc specifc gpio driver go ?

It seems to me we've got a lot of confusion here because drivers/ is
split by type, and we've also got arch/* machine specific drivers and
we've got drivers/platform which is intended as far as I can see for
everything you'd put in drivers/soc except for that which goes in arch/*
anyway.

If QMSS is arm specific why isn't it in arch/arm, if it's not why isn't
it in drivers/platform ?

Just trying to understand the point of drivers/soc. 

Alan

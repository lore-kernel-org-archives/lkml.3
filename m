Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757865Ab3EaWfB (ORCPT <rfc822;w@1wt.eu>);
	Fri, 31 May 2013 18:35:01 -0400
Received: from mail-ob0-f169.google.com ([209.85.214.169]:34228 "EHLO
	mail-ob0-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757514Ab3EaWez (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 31 May 2013 18:34:55 -0400
MIME-Version: 1.0
In-Reply-To: <1370031778-25965-1-git-send-email-emilgoode@gmail.com>
References: <1370031778-25965-1-git-send-email-emilgoode@gmail.com>
Date: Sat, 1 Jun 2013 01:34:54 +0300
Message-ID: <CAHp75VciHQKcyj-ANLdg=mg2C71zn=09Eentf22q+otGu=rp3w@mail.gmail.com>
Subject: Re: [PATCH] usb: musb: Fix format specifier warning
From: Andy Shevchenko <andy.shevchenko@gmail.com>
To: Emil Goode <emilgoode@gmail.com>
Cc: balbi@ti.com, Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        USB <linux-usb@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        kernel-janitors@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, May 31, 2013 at 11:22 PM, Emil Goode <emilgoode@gmail.com> wrote:
> This patch fixes a format specifier warning. dma_addr_t can be either
> u32 or u64 so we should cast to the largest type and change the format
> specifier to %llx.

dma_addr_t is derived from phys_addr_t, thus you may use %pa specifier
which is available from v3.8(?).

Something like this:
dma_addr_t src_addr;
dev_dbg(dev, "DMA addr: %pa\n", src_addr);

--
With Best Regards,
Andy Shevchenko

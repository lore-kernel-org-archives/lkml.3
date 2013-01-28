Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754414Ab3A1IZe (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Jan 2013 03:25:34 -0500
Received: from mail-bk0-f43.google.com ([209.85.214.43]:55370 "EHLO
	mail-bk0-f43.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753671Ab3A1IZb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Jan 2013 03:25:31 -0500
Date: Mon, 28 Jan 2013 08:25:23 +0000
From: Lee Jones <lee.jones@linaro.org>
To: Samuel Ortiz <sameo@linux.intel.com>
Cc: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        arnd@arndb.de, linus.walleij@stericsson.com
Subject: Re: [PATCH 09/26] mfd: ab8500-debugfs: Provide a means for a user
 subscribe to IRQs
Message-ID: <20130128082523.GY15873@gmail.com>
References: <1358254566-12419-1-git-send-email-lee.jones@linaro.org>
 <1358254566-12419-10-git-send-email-lee.jones@linaro.org>
 <20130127235259.GO1174@sortiz-mobl>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20130127235259.GO1174@sortiz-mobl>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 28 Jan 2013, Samuel Ortiz wrote:

> Hi Lee,
> 
> On Tue, Jan 15, 2013 at 12:55:49PM +0000, Lee Jones wrote:
> > Allow users to subscribe to and view IRQ events live from debugfs.
> I seem to remember that I got a similar patch some time ago for the same
> purpose and my answer was: Please use a UIO driver for this. There already is
> such driver, it's uio_pdrv_genirq. What your debugfs registration entry could
> do is adding a platform device for the specific interrupt number. This would
> avoid the irq handler registration and the sysfs entry creation, both things I
> believe are not very elegant and open coded. It also gives you an IRQ count
> implementation.
> Ideally, the UIO framework could be improved to support IRQ ranges (through
> IRQ domains) instead of the current single interrupt number.
> 
> Have you considered going through that path ?

I haven't looked into re-writing any of the MFD stuff yet. Instead I
have a plan of action:

1. Upstream as many of the 100 patches from the internal kernel up
into Mainline.

2. Mark any patches which are unsuitable for Mainlining and re-work
them after the remainder have been accepted. Not withstanding small
fixups, as these can be done on the fly without too much disruption.

3. Upstream the remainder once re-worked.

If I don't follow this work-flow and fix-up/re-work as I go, not only
will it take forever, but I'm also likely to encounter too many
complications in the way of conflicts in the latter stages.

I'm also following the same work-flow for 'drivers/power' and
'drivers/regulator'.

-- 
Lee Jones
Linaro ST-Ericsson Landing Team Lead
Linaro.org │ Open source software for ARM SoCs
Follow Linaro: Facebook | Twitter | Blog

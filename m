Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932098AbaE1HZX (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 May 2014 03:25:23 -0400
Received: from mail-pb0-f44.google.com ([209.85.160.44]:47071 "EHLO
	mail-pb0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751397AbaE1HZW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 May 2014 03:25:22 -0400
Date: Wed, 28 May 2014 00:25:13 -0700
From: Brian Norris <computersforpeace@gmail.com>
To: Alexander Holler <holler@ahsoftware.de>
Cc: Alexander Shiyan <shc_work@mail.ru>, David Woodhouse <dwmw2@infradead.org>,
        linux-mtd@lists.infradead.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 09/27] mtd: nand: pxa3xx: show device structure in sysfs
Message-ID: <20140528072513.GA4285@norris-Latitude-E6410>
References: <1401142372-14148-1-git-send-email-holler@ahsoftware.de>
 <1401142372-14148-10-git-send-email-holler@ahsoftware.de>
 <1401160341.192042842@f271.i.mail.ru>
 <53842A53.1060404@ahsoftware.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <53842A53.1060404@ahsoftware.de>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, May 27, 2014 at 08:01:55AM +0200, Alexander Holler wrote:
> Am 27.05.2014 05:12, schrieb Alexander Shiyan:
> >Should we add "driver.owner = THIS_MODULE" field for struct platform_driver in this case?
> 
> Yes. I assumed all drivers/modules already had an owner. I will
> check them all and will send a v2 for those which don't have one. I
> wonder what this field is used for if it works without. ;)

Looks like the mtd->owner essentially filters down to a try_module_get()
(called in the get_mtd_device() API) which ensures that MTD users (e.g.,
mtdblock, UBI, etc.) hold a refcount on the driver module. If the owner
is not set properly by a driver, then try_module_get() just does a
silent no-op, so the user is none the wiser... until they try to rmmod
their MTD driver while it's being used by UBI/UBIFS!

Regards,
Brian

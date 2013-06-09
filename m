Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751284Ab3FIRPW (ORCPT <rfc822;w@1wt.eu>);
	Sun, 9 Jun 2013 13:15:22 -0400
Received: from mail-oa0-f44.google.com ([209.85.219.44]:53938 "EHLO
	mail-oa0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751144Ab3FIRPU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 9 Jun 2013 13:15:20 -0400
MIME-Version: 1.0
In-Reply-To: <1370768902-20239-1-git-send-email-emilgoode@gmail.com>
References: <1370768902-20239-1-git-send-email-emilgoode@gmail.com>
Date: Sun, 9 Jun 2013 20:15:20 +0300
Message-ID: <CAHp75VftwuS4ZTFP5D90PhyzrAMoHVxDiSCg0jrMGp+r0eRfzA@mail.gmail.com>
Subject: Re: [PATCH] mtd: orion_nand: Improve error handling in orion_nand_probe
From: Andy Shevchenko <andy.shevchenko@gmail.com>
To: Emil Goode <emilgoode@gmail.com>
Cc: David Woodhouse <dwmw2@infradead.org>, artem.bityutskiy@linux.intel.com,
        andrew@lunn.ch, Bill Pemberton <wfp5p@virginia.edu>,
        Jingoo Han <jg1.han@samsung.com>, linux-mtd@lists.infradead.org,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        kernel-janitors@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Jun 9, 2013 at 12:08 PM, Emil Goode <emilgoode@gmail.com> wrote:
> This patch fixes some issues in the error handling and simplifies
> the code by converting to devm* functions.
>
> If the kzalloc call fails it is unnecessary to use the label no_res
> and pass a NULL pointer to kfree. If the devm_kzalloc call fails on
> line 110 we forgett to call iounmap for the previous ioremap call.

"forget" (typo here)

> The following changes are introduced:
> - Convert to devm_kzalloc and remove calls to kfree.
> - Convert to devm_ioremap_resource that adds a missing call to
>   *request_mem_region and remove calls to iounmap.
> - The devm_ioremap_resource function checks the passed resource so
>   we can remove the NULL check after the platform_get_resource call.

What about another patch (that I guess should go first)  that converts
printk to dev_* or pr_*?

--
With Best Regards,
Andy Shevchenko

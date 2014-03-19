Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759109AbaCSDtj (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Mar 2014 23:49:39 -0400
Received: from mail-wg0-f49.google.com ([74.125.82.49]:63816 "EHLO
	mail-wg0-f49.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759086AbaCSDth (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Mar 2014 23:49:37 -0400
MIME-Version: 1.0
In-Reply-To: <1395140208.2812.15.camel@joe-AO722>
References: <1395057839-23871-1-git-send-email-ks.giri@samsung.com>
	<1395057839-23871-2-git-send-email-ks.giri@samsung.com>
	<CAKrE-KcA6VUUwUjAGuW+nYsFg0qknfZwECtdVS8ZtZb4GYoCvA@mail.gmail.com>
	<1395140208.2812.15.camel@joe-AO722>
Date: Wed, 19 Mar 2014 09:19:36 +0530
Message-ID: <CAKrE-KcMMtFT-aL8wFeKiFkr1LCnsvcewHGK1WYSP+HnynO61A@mail.gmail.com>
Subject: Re: [PATCH 1/2] mailbox: samsung: added support for samsung mailbox
From: Girish KS <girishks2000@gmail.com>
To: Joe Perches <joe@perches.com>
Cc: Girish K S <ks.giri@samsung.com>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        devicetree@vger.kernel.org,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Jassi Singh <jassisinghbrar@gmail.com>, "Anna, Suman" <s-anna@ti.com>,
        Ilho Lee <ilho215.lee@samsung.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Mar 18, 2014 at 4:26 PM, Joe Perches <joe@perches.com> wrote:
> On Tue, 2014-03-18 at 15:52 +0530, Girish KS wrote:
>> On Mon, Mar 17, 2014 at 5:33 PM, Girish K S <ks.giri@samsung.com> wrote:
>
> Hi, just some trivial notes about the patch
>
>> > diff --git a/drivers/mailbox/mailbox-samsung.c b/drivers/mailbox/mailbox-samsung.c
> []
>> > @@ -0,0 +1,354 @@
>> > +/*
>> > + * Copyright 2013 Samsung Electronics Co. Ltd.
>> > + *
>> > + * This program is free software; you can redistribute it and/or modify it
>> > + * under the terms and conditions of the GNU General Public License,
>> > + * version 2, as published by the Free Software Foundation.
>> > + *
>> > + * This program is distributed in the hope it will be useful, but WITHOUT
>> > + * ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or
>> > + * FITNESS FOR A PARTICULAR PURPOSE.  See the GNU General Public License for
>> > + * more details.
>> > + *
>> > + * You should have received a copy of the GNU General Public License along with
>> > + * this program.  If not, see <http://www.gnu.org/licenses/>.
>> > + */
>
> Please add
>
> #define pr_fmt(fmt) KBUILD_MODNAME ": " fmt
>
> before any #include so that error messages are
> prefixed in the output with "samsung-mailbox: "
> and the reader of the log has an idea what subsystem
> is emitting messages.
>
Sure will do it

>> > +#include <linux/err.h>
>> > +#include <linux/module.h>
>> > +#include <linux/slab.h>
> []
>> > +static int samsung_mbox_send_data(struct ipc_link *link, void *msg)
>> > +{
> []
>> > +       /* Lock the mailbox for this transaction with the client id */
>> > +       writel(val, ipc_base + MBOX_REG_TXLOCK);
>> > +       do {
>> > +               if (time_after(jiffies, timeout)) {
>> > +                       pr_err("cannot aquire the lock\n");
>
> This would be prefixed appropriately via pr_fmt.
> Also, there's a typo of aquire here: acquire

OK

>
>> > +static int samsung_mbox_startup(struct ipc_link *link, void *ignored)
>> > +{
> []
>> > +       ret = devm_request_irq(dev, samsung_link->irq, samsung_ipc_handler,
>> > +                                       IRQF_SHARED, link->link_name,
>> > +                                       samsung_link);
>> > +       if (unlikely(ret)) {
>> > +               pr_err("failed to register mailbox interrupt:%d\n", ret);
>
> Here too it would be prefixed

ok

>
>> > +static int samsung_mbox_probe(struct platform_device *pdev)
>> > +{
>> > +       struct samsung_mbox *samsung_mbox;
>> > +       struct samsung_mlink *mbox_link;
>> > +       struct resource res;
>> > +       struct ipc_link **link;
>> > +       int loop, count, ret = 0;
>> > +       struct device_node *node = pdev->dev.of_node;
>> > +
>> > +       if (!node) {
>> > +               dev_err(&pdev->dev, "driver doesnt support"
>> > +                               "non-dt devices\n");
>
> Please coalesce the format fragments.
>
> You would notice the missing space between
> "support" and "non-dt"

ok

>
>                 dev_err(&pdev->dev, "driver does not support non-dt devices\n");
>
> It's OK to exceed 80 columns for these format strings.
>
>> > diff --git a/include/linux/mailbox-samsung.h b/include/linux/mailbox-samsung.h
> []
>> > +static inline unsigned long get_alligned_buffer(void)
>
> Typo: There's one l in aligned

will do it

>
>> > +{
>> > +       return __get_free_pages(GFP_KERNEL, REQUEST_PAGE_ORDER);
>> > +}
>> > +
>> > +static inline void put_alligned_buffer(unsigned long addr)
>> > +{
>
> here too
>
>> > +       free_pages(addr, REQUEST_PAGE_ORDER);
>> > +}
>> > +
>
>

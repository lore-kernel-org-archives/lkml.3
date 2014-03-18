Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755148AbaCRK4x (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Mar 2014 06:56:53 -0400
Received: from smtprelay0033.hostedemail.com ([216.40.44.33]:59861 "EHLO
	smtprelay.hostedemail.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1755118AbaCRK4v (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Mar 2014 06:56:51 -0400
X-Session-Marker: 6A6F6540706572636865732E636F6D
X-Spam-Summary: 50,0,0,,d41d8cd98f00b204,joe@perches.com,:::::::::::::::,RULES_HIT:41:355:379:541:599:800:960:966:967:973:988:989:1042:1260:1261:1277:1311:1313:1314:1345:1359:1373:1437:1515:1516:1518:1534:1543:1593:1594:1605:1711:1730:1747:1777:1792:1801:2196:2198:2199:2200:2393:2525:2538:2553:2560:2563:2682:2685:2693:2828:2859:2902:2904:2933:2937:2939:2942:2945:2947:2951:2954:3022:3138:3139:3140:3141:3142:3622:3855:3865:3866:3867:3868:3870:3871:3872:3873:3874:3934:3936:3938:3941:3944:3947:3950:3953:3956:3959:4250:4321:4385:4605:5007:6119:6239:6755:7652:7903:7904:8599:9025:9388:9855:10004:10400:10848:10920:11026:11232:11233:11473:11658:11914:12043:12
X-HE-Tag: cow95_1e78a7ef66605
X-Filterd-Recvd-Size: 4651
Message-ID: <1395140208.2812.15.camel@joe-AO722>
Subject: Re: [PATCH 1/2] mailbox: samsung: added support for samsung mailbox
From: Joe Perches <joe@perches.com>
To: Girish KS <girishks2000@gmail.com>
Cc: Girish K S <ks.giri@samsung.com>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        devicetree@vger.kernel.org,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Jassi Singh <jassisinghbrar@gmail.com>, "Anna, Suman" <s-anna@ti.com>,
        Ilho Lee <ilho215.lee@samsung.com>
Date: Tue, 18 Mar 2014 03:56:48 -0700
In-Reply-To: <CAKrE-KcA6VUUwUjAGuW+nYsFg0qknfZwECtdVS8ZtZb4GYoCvA@mail.gmail.com>
References: <1395057839-23871-1-git-send-email-ks.giri@samsung.com>
	 <1395057839-23871-2-git-send-email-ks.giri@samsung.com>
	 <CAKrE-KcA6VUUwUjAGuW+nYsFg0qknfZwECtdVS8ZtZb4GYoCvA@mail.gmail.com>
Content-Type: text/plain; charset="ISO-8859-1"
X-Mailer: Evolution 3.8.4-0ubuntu1 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2014-03-18 at 15:52 +0530, Girish KS wrote:
> On Mon, Mar 17, 2014 at 5:33 PM, Girish K S <ks.giri@samsung.com> wrote:

Hi, just some trivial notes about the patch

> > diff --git a/drivers/mailbox/mailbox-samsung.c b/drivers/mailbox/mailbox-samsung.c
[]
> > @@ -0,0 +1,354 @@
> > +/*
> > + * Copyright 2013 Samsung Electronics Co. Ltd.
> > + *
> > + * This program is free software; you can redistribute it and/or modify it
> > + * under the terms and conditions of the GNU General Public License,
> > + * version 2, as published by the Free Software Foundation.
> > + *
> > + * This program is distributed in the hope it will be useful, but WITHOUT
> > + * ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or
> > + * FITNESS FOR A PARTICULAR PURPOSE.  See the GNU General Public License for
> > + * more details.
> > + *
> > + * You should have received a copy of the GNU General Public License along with
> > + * this program.  If not, see <http://www.gnu.org/licenses/>.
> > + */

Please add

#define pr_fmt(fmt) KBUILD_MODNAME ": " fmt

before any #include so that error messages are
prefixed in the output with "samsung-mailbox: "
and the reader of the log has an idea what subsystem
is emitting messages.

> > +#include <linux/err.h>
> > +#include <linux/module.h>
> > +#include <linux/slab.h>
[]
> > +static int samsung_mbox_send_data(struct ipc_link *link, void *msg)
> > +{
[]
> > +       /* Lock the mailbox for this transaction with the client id */
> > +       writel(val, ipc_base + MBOX_REG_TXLOCK);
> > +       do {
> > +               if (time_after(jiffies, timeout)) {
> > +                       pr_err("cannot aquire the lock\n");

This would be prefixed appropriately via pr_fmt.
Also, there's a typo of aquire here: acquire

> > +static int samsung_mbox_startup(struct ipc_link *link, void *ignored)
> > +{
[]
> > +       ret = devm_request_irq(dev, samsung_link->irq, samsung_ipc_handler,
> > +                                       IRQF_SHARED, link->link_name,
> > +                                       samsung_link);
> > +       if (unlikely(ret)) {
> > +               pr_err("failed to register mailbox interrupt:%d\n", ret);

Here too it would be prefixed

> > +static int samsung_mbox_probe(struct platform_device *pdev)
> > +{
> > +       struct samsung_mbox *samsung_mbox;
> > +       struct samsung_mlink *mbox_link;
> > +       struct resource res;
> > +       struct ipc_link **link;
> > +       int loop, count, ret = 0;
> > +       struct device_node *node = pdev->dev.of_node;
> > +
> > +       if (!node) {
> > +               dev_err(&pdev->dev, "driver doesnt support"
> > +                               "non-dt devices\n");

Please coalesce the format fragments.

You would notice the missing space between
"support" and "non-dt"

		dev_err(&pdev->dev, "driver does not support non-dt devices\n");

It's OK to exceed 80 columns for these format strings.

> > diff --git a/include/linux/mailbox-samsung.h b/include/linux/mailbox-samsung.h
[]
> > +static inline unsigned long get_alligned_buffer(void)

Typo: There's one l in aligned

> > +{
> > +       return __get_free_pages(GFP_KERNEL, REQUEST_PAGE_ORDER);
> > +}
> > +
> > +static inline void put_alligned_buffer(unsigned long addr)
> > +{

here too

> > +       free_pages(addr, REQUEST_PAGE_ORDER);
> > +}
> > +



Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757432AbaGAMtX (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 Jul 2014 08:49:23 -0400
Received: from mail-lb0-f176.google.com ([209.85.217.176]:63137 "EHLO
	mail-lb0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751605AbaGAMtV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 Jul 2014 08:49:21 -0400
MIME-Version: 1.0
X-Originating-IP: [89.139.36.201]
In-Reply-To: <1398904476-26200-6-git-send-email-s-anna@ti.com>
References: <1398904476-26200-1-git-send-email-s-anna@ti.com> <1398904476-26200-6-git-send-email-s-anna@ti.com>
From: Ohad Ben-Cohen <ohad@wizery.com>
Date: Tue, 1 Jul 2014 15:48:59 +0300
Message-ID: <CAK=WgbamDPN9EmKUu3+c3RbsQn1uhz5MGGvpWSSUJSUKyoH8Cw@mail.gmail.com>
Subject: Re: [PATCHv5 05/15] hwspinlock/omap: add support for dt nodes
To: Suman Anna <s-anna@ti.com>
Cc: Mark Rutland <mark.rutland@arm.com>, Kumar Gala <galak@codeaurora.org>,
        Tony Lindgren <tony@atomide.com>,
        Josh Cartwright <joshc@codeaurora.org>,
        Bjorn Andersson <bjorn@kryo.se>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-omap@vger.kernel.org" <linux-omap@vger.kernel.org>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        linux-arm <linux-arm-kernel@lists.infradead.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Suman,

On Thu, May 1, 2014 at 3:34 AM, Suman Anna <s-anna@ti.com> wrote:
>  static int omap_hwspinlock_probe(struct platform_device *pdev)
>  {
> -       struct hwspinlock_pdata *pdata = pdev->dev.platform_data;
> +       struct device_node *node = pdev->dev.of_node;
>         struct hwspinlock_device *bank;
>         struct hwspinlock *hwlock;
>         struct resource *res;
>         void __iomem *io_base;
>         int num_locks, i, ret;
> +       int base_id = 0;

We shouldn't implicitly assume base_id is zero: let's explicitly
protect against potential subsequent invocations of
omap_hwspinlock_probe.

Thanks,
Ohad.

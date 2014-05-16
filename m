Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932520AbaEPNfv (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 May 2014 09:35:51 -0400
Received: from mail-ob0-f178.google.com ([209.85.214.178]:54052 "EHLO
	mail-ob0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932470AbaEPNfs convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 May 2014 09:35:48 -0400
MIME-Version: 1.0
In-Reply-To: <1399267649-20218-7-git-send-email-antoine.tenart@free-electrons.com>
References: <1399267649-20218-1-git-send-email-antoine.tenart@free-electrons.com>
	<1399267649-20218-7-git-send-email-antoine.tenart@free-electrons.com>
Date: Fri, 16 May 2014 15:35:48 +0200
Message-ID: <CACRpkdaL9tzfUrY=wLjSR3dcD7JC1mUX3kdG+Wh5gDyxGY2Yqw@mail.gmail.com>
Subject: Re: [PATCH v3 6/7] Documentation: add the Marvell Berlin pinctrl documentation
From: Linus Walleij <linus.walleij@linaro.org>
To: =?UTF-8?Q?Antoine_T=C3=A9nart?= <antoine.tenart@free-electrons.com>
Cc: Sebastian Hesselbarth <sebastian.hesselbarth@gmail.com>,
        Alexandre Belloni <alexandre.belloni@free-electrons.com>,
        Thomas Petazzoni <thomas.petazzoni@free-electrons.com>,
        zhiming Xu <zmxu@marvell.com>, Jisheng Zhang <jszhang@marvell.com>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, May 5, 2014 at 7:27 AM, Antoine Ténart
<antoine.tenart@free-electrons.com> wrote:

> Add the documentation related to the Berlin pin-controller driver and
> explain how to configure this group based controller.
>
> Signed-off-by: Antoine Ténart <antoine.tenart@free-electrons.com>
> Acked-by: Sebastian Hesselbarth <sebastian.hesselbarth@gmail.com>
(...)

When I see this:

> +Required subnode-properties:
> +- marvell,groups: a list of strings describing the group names.
> +- marvell,function: a string describing the function used to mux the groups.
> +
> +Example:
> +
> +sm_pinctrl: pin-controller@0 {
> +       compatible = "marvell,berlin2q-sysmgr-pinctrl";
> +       reg = <0xfc0000 0x44>;
> +
> +       uart0_pmux: uart0-pmux {
> +               marvell,groups = "GSM12", "GSM13";
> +               marvell,function = "uart0";
> +       };
> +}

I feel like ... can't we just standardize that and make it a common
pinctrl binding, and name the properties "groups" and "function"
for a family of pin controllers just mapping N groups to 1 function?

I will merge the patches as are, but maybe we can make it generic
on top of this before the merge window?

Yours,
Linus Walleij

Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932200AbaAaKNy (ORCPT <rfc822;w@1wt.eu>);
	Fri, 31 Jan 2014 05:13:54 -0500
Received: from mail-ob0-f172.google.com ([209.85.214.172]:39575 "EHLO
	mail-ob0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932072AbaAaKNw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 31 Jan 2014 05:13:52 -0500
MIME-Version: 1.0
In-Reply-To: <1390869573-27624-10-git-send-email-sebastian.hesselbarth@gmail.com>
References: <1390674856-4993-1-git-send-email-sebastian.hesselbarth@gmail.com>
	<1390869573-27624-1-git-send-email-sebastian.hesselbarth@gmail.com>
	<1390869573-27624-10-git-send-email-sebastian.hesselbarth@gmail.com>
Date: Fri, 31 Jan 2014 11:13:51 +0100
Message-ID: <CACRpkdYpGm-KAFqU5cpzbhrM1NaZJYtQa86wP7qJFrai2bDYbw@mail.gmail.com>
Subject: Re: [PATCH v2 09/21] pinctrl: mvebu: dove: provide generic mpp callbacks
From: Linus Walleij <linus.walleij@linaro.org>
To: Sebastian Hesselbarth <sebastian.hesselbarth@gmail.com>
Cc: Jason Cooper <jason@lakedaemon.net>, Andrew Lunn <andrew@lunn.ch>,
        Gregory Clement <gregory.clement@free-electrons.com>,
        Thomas Petazzoni <thomas.petazzoni@free-electrons.com>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jan 28, 2014 at 1:39 AM, Sebastian Hesselbarth
<sebastian.hesselbarth@gmail.com> wrote:

> We want to get rid of passing register addresses to common pinctrl
> driver, so provide set/get callbacks for generic mpp pins.
>
> Signed-off-by: Sebastian Hesselbarth <sebastian.hesselbarth@gmail.com>

OK...

> +static int dove_mpp_ctrl_get(struct mvebu_mpp_ctrl *ctrl,
> +                            unsigned long *config)
> +{


(...)

This is fine.

> @@ -374,7 +398,7 @@ static struct mvebu_mpp_ctrl dove_mpp_controls[] = {
>         MPP_FUNC_CTRL(13, 13, "mpp13", dove_pmu_mpp_ctrl),
>         MPP_FUNC_CTRL(14, 14, "mpp14", dove_pmu_mpp_ctrl),
>         MPP_FUNC_CTRL(15, 15, "mpp15", dove_pmu_mpp_ctrl),
> -       MPP_REG_CTRL(16, 23),
> +       MPP_FUNC_CTRL(16, 23, NULL, dove_mpp_ctrl),

What does this have to do with the rest of the patch?

(Maybe I'm stupid, beware I'm just glancing over this stuff as I
see the patch set is still in development.)

Yours,
Linus Walleij

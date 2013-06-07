Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754733Ab3FGNNV (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Jun 2013 09:13:21 -0400
Received: from mail-oa0-f42.google.com ([209.85.219.42]:49766 "EHLO
	mail-oa0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752382Ab3FGNNU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Jun 2013 09:13:20 -0400
MIME-Version: 1.0
In-Reply-To: <1370517676-10909-3-git-send-email-lee.jones@linaro.org>
References: <1370517676-10909-1-git-send-email-lee.jones@linaro.org>
	<1370517676-10909-3-git-send-email-lee.jones@linaro.org>
Date: Fri, 7 Jun 2013 15:13:19 +0200
Message-ID: <CACRpkdYLB-_JjEd69vVub_Z3L+avQRrFBt1fGuyR0D_owcLWvA@mail.gmail.com>
Subject: Re: [PATCH 2/4] mfd: dbx500-prcmu: Correctly reorder PRCMU clock identifiers
From: Linus Walleij <linus.walleij@linaro.org>
To: Lee Jones <lee.jones@linaro.org>, Ulf Hansson <ulf.hansson@linaro.org>,
        Loic PALLARDY <loic.pallardy@st.com>
Cc: "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Arnd Bergmann <arnd@arndb.de>,
        Linus WALLEIJ <linus.walleij@stericsson.com>,
        Srinidhi KASAGAR <srinidhi.kasagar@stericsson.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jun 6, 2013 at 1:21 PM, Lee Jones <lee.jones@linaro.org> wrote:

> ... as stipulated by the Hardware Specification document.
>
> Signed-off-by: Lee Jones <lee.jones@linaro.org>

I think you need Ulf (as ux500 clock author) and Loic (as PRCMU
developer) to have a look at this.

> -enum prcmu_clock {
> -       PRCMU_SGACLK,
(...)
> +#define ARMCLK                 0
> +#define PRCMU_ACLK             1
(...)

It seems the enum and the defines want to do two different things?

The first is a kernel-internal representation of the clocks, whereas
the latter is a HW-centric representation for a certain PRCMU
variant (I guess?)

Does one actually exclude the other?

Yours,
Linus Walleij

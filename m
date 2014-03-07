Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753197AbaCGDKq (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Mar 2014 22:10:46 -0500
Received: from mail-oa0-f51.google.com ([209.85.219.51]:46990 "EHLO
	mail-oa0-f51.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751986AbaCGDKo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Mar 2014 22:10:44 -0500
MIME-Version: 1.0
In-Reply-To: <1393589841-6634-4-git-send-email-maxime.coquelin@st.com>
References: <1393589841-6634-1-git-send-email-maxime.coquelin@st.com>
	<1393589841-6634-4-git-send-email-maxime.coquelin@st.com>
Date: Fri, 7 Mar 2014 11:10:43 +0800
Message-ID: <CACRpkdYczgJiDQEfkiiJdXVtm-42_rRSedf6HGd7Eoq0ttWJ3A@mail.gmail.com>
Subject: Re: [PATCH 3/5] pinctrl: st: Enhance the controller to manage
 unavailable registers
From: Linus Walleij <linus.walleij@linaro.org>
To: Maxime COQUELIN <maxime.coquelin@st.com>
Cc: Rob Landley <rob@landley.net>, Rob Herring <robh+dt@kernel.org>,
        Pawel Moll <pawel.moll@arm.com>, Mark Rutland <mark.rutland@arm.com>,
        Ian Campbell <ijc+devicetree@hellion.org.uk>,
        Kumar Gala <galak@codeaurora.org>,
        Russell King <linux@arm.linux.org.uk>,
        Srinivas Kandagatla <srinivas.kandagatla@st.com>,
        Stuart Menefy <stuart.menefy@st.com>,
        Giuseppe Cavallaro <peppe.cavallaro@st.com>,
        "linux-doc@vger.kernel.org" <linux-doc@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        kernel@stlinux.com, Lee Jones <lee.jones@linaro.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Feb 28, 2014 at 8:17 PM, Maxime COQUELIN <maxime.coquelin@st.com> wrote:

> From: Giuseppe Cavallaro <peppe.cavallaro@st.com>
>
> This patch adds a new logic inside the st pinctrl to manage
> an unsupported scenario: some sysconfig are not available!
>
> This is the case of STiH407 where, although documented, the
> following registers from SYSCFG_FLASH have been removed from the SoC.
>
> SYSTEM_CONFIG3040
>    Output Enable pad control for all PIO Alternate Functions
> and
> SYSTEM_ CONFIG3050
>    Pull Up pad control for all PIO Alternate Functions
>
> Without managing this condition an imprecise external abort
> will be detect.
>
> To do this the patch also reviews the st_parse_syscfgs
> and other routines to manipulate the registers only if
> actually available.
> In any case, for example the st_parse_syscfgs detected
> an error condition but no action was made in the
> st_pctl_probe_dt.
>
> Signed-off-by: Maxime Coquelin <maxime.coquelin@st.com>
> Signed-off-by: Giuseppe Cavallaro <peppe.cavallaro@st.com>

Hm this does not apply to my tree at all. It appears this is not
a stand-alone, patch, so it depends on some other patch to
pinctrl-sti?

Yours,
Linus Walleij

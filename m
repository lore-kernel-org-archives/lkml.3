Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753821AbaA3SjR (ORCPT <rfc822;w@1wt.eu>);
	Thu, 30 Jan 2014 13:39:17 -0500
Received: from moutng.kundenserver.de ([212.227.126.171]:62957 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752950AbaA3SjP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 30 Jan 2014 13:39:15 -0500
From: Arnd Bergmann <arnd@arndb.de>
To: linux-arm-kernel@lists.infradead.org
Subject: Re: [PATCH 1/4] ARM: STi: add stid127 soc support
Date: Thu, 30 Jan 2014 19:39:08 +0100
User-Agent: KMail/1.12.2 (Linux/3.8.0-22-generic; KDE/4.3.2; x86_64; ; )
Cc: devicetree@vger.kernel.org, Russell King <linux@arm.linux.org.uk>,
        kernel@stlinux.com, Srinivas Kandagatla <srinivas.kandagatla@st.com>,
        Linus Walleij <linus.walleij@linaro.org>,
        Patrice CHOTARD <patrice.chotard@st.com>, linux-kernel@vger.kernel.org,
        Stuart Menefy <stuart.menefy@st.com>, Rob Herring <robh+dt@kernel.org>,
        Grant Likely <grant.likely@linaro.org>,
        Giuseppe Cavallaro <peppe.cavallaro@st.com>, maxime.coquelin@st.com,
        alexandre.torgue@st.com
References: <1391093744-19905-1-git-send-email-patrice.chotard@st.com> <1391093744-19905-2-git-send-email-patrice.chotard@st.com> <201401301935.16463.arnd@arndb.de>
In-Reply-To: <201401301935.16463.arnd@arndb.de>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201401301939.08302.arnd@arndb.de>
X-Provags-ID: V02:K0:oqFowLCocQDu3f18+rxz6V1BjhOIlTjUCfwFYVlDWzO
 EU2WKs+l63TPaSzmST5YV3eYOwzGSzq9R6VaFbvlkAMFMzVHtn
 lFN4wDlOtcP5Qf0rkP2bmnxV8zkbJQHi23kw+K0NO3eR25nnil
 MvzqjT/c0UuTE5LAD4LP/w6WChI/6Ow2QKCdN6Kw0eB/xdQhdh
 dB1y2PLvm1IFh/2k0L5eO3F+0K13UZnjFgzx1eZBpjO2vixPQy
 95kx2NyQAGFNK64tq5OG2hkNhYbJNgvo3vfWGGXJn0bsZZieXs
 RASgCJNZWFAv4O4MOt64q8S+jrTpKF5XDVpq/V0udin26kg92j
 AI/MZ3F3kQCiU0uF9/JU+XHnEpPGRLKHQUx47aJKj
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thursday 30 January 2014, Arnd Bergmann wrote:
> On Thursday 30 January 2014, Patrice CHOTARD wrote:
> > From: Alexandre TORGUE <alexandre.torgue@st.com>
> > 
> > This patch adds support to STiD127 SoC.
> > The main adaptation is the L2 cache way size compare to STiH41x SoCs.
> > 
> > Signed-off-by: alexandre torgue <alexandre.torgue@st.com>
> > Signed-off-by: Patrice Chotard <patrice.chotard@st.com>
> > ---
> >  arch/arm/mach-sti/board-dt.c |    6 ++++++
> >  1 file changed, 6 insertions(+)
> 
> Wouldn't it be better to read this value from the l2 cache
> controller node? I'd assume there might be more SoCs that
> will need a similar change, so it's better to come up with
> a solution that doesn't involve changing the kernel every
> time.

Actually reading the code in this file shows that the L2 cache
initialization is the only nonstandard thing in there. We should
really find a way to get rid of the entire function.

Sorry if I missed the initial review, but can you explain
why this is needed to start with?

	Arnd

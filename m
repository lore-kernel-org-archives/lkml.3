Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752864Ab3JAJPc (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 Oct 2013 05:15:32 -0400
Received: from mail-la0-f43.google.com ([209.85.215.43]:42990 "EHLO
	mail-la0-f43.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752180Ab3JAJP3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 Oct 2013 05:15:29 -0400
MIME-Version: 1.0
In-Reply-To: <20130924131542.f865fad4dec98e024c0d4676@ops.dti.ne.jp>
References: <52410F86.4040301@renesas.com>
	<20130924131542.f865fad4dec98e024c0d4676@ops.dti.ne.jp>
Date: Tue, 1 Oct 2013 18:15:26 +0900
Message-ID: <CANqRtoRD35Ei31PK8a_TOp=2uiYPCoaJuDb6tyZtQL8s0PavNw@mail.gmail.com>
Subject: Re: [PATCH 5/6] clk: emev2: Add support for emev2 SMU clocks with DT
From: Magnus Damm <magnus.damm@gmail.com>
To: takasi-y@ops.dti.ne.jp
Cc: SH-Linux <linux-sh@vger.kernel.org>, Ben Dooks <ben.dooks@codethink.co.uk>,
        Shinya Kuribayashi <shinya.kuribayashi.px@renesas.com>,
        devicetree@vger.kernel.org, linux-serial@vger.kernel.org,
        Simon Horman <horms@verge.net.au>, Paul Mundt <lethal@linux-sh.org>,
        Mike Turquette <mturquette@linaro.org>,
        linux-kernel <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Sep 24, 2013 at 1:15 PM,  <takasi-y@ops.dti.ne.jp> wrote:
> Common clock framework version of emev2 clock support.
> smu_clkdiv and smu_gclk are handled.
> So far, reparent is not implemented, and is fixed to index #0.
> SMU and small numbers of clocks are described in emev2.dtsi.
>
> That function and numbers of clocks are equivalent to current
> sh-clkfwk version. It is just enough to run kzm9d-reference.
>
> Signed-off-by: Takashi Yoshii <takashi.yoshii.zj@renesas.com>
> ---
>  arch/arm/boot/dts/emev2.dtsi     |  84 +++++++++++++++++++++++++++++++
>  drivers/clk/Makefile             |   2 +
>  drivers/clk/shmobile/Makefile    |   5 ++
>  drivers/clk/shmobile/clk-emev2.c | 104 +++++++++++++++++++++++++++++++++++++++
>  4 files changed, 195 insertions(+)
>  create mode 100644 drivers/clk/shmobile/Makefile
>  create mode 100644 drivers/clk/shmobile/clk-emev2.c

Hi Yoshii-san,

Thanks for your efforts on this. I'm very pleased to see that you
describe the clock topology using DT. In general I think your patch
looks fine, but I have some comment related to the multiplatform
integration, please see below.

> diff --git a/drivers/clk/Makefile b/drivers/clk/Makefile
> index 7b11106..3e64ac4 100644
> --- a/drivers/clk/Makefile
> +++ b/drivers/clk/Makefile
> @@ -32,6 +32,8 @@ obj-$(CONFIG_ARCH_VT8500)     += clk-vt8500.o
>  obj-$(CONFIG_ARCH_ZYNQ)                += zynq/
>  obj-$(CONFIG_ARCH_TEGRA)       += tegra/
>  obj-$(CONFIG_PLAT_SAMSUNG)     += samsung/
> +obj-$(CONFIG_ARCH_SHMOBILE)    += shmobile/
> +obj-$(CONFIG_ARCH_SHMOBILE_MULTI)      += shmobile/

Here I believe it is enough that you only use
CONFIG_ARCH_SHMOBILE_MULTI. Building common clocks to coexist with the
old legacy board code does not make any sense IMO. If you think it
makes sense for some reason, please explain why. =)

> diff --git a/drivers/clk/shmobile/Makefile b/drivers/clk/shmobile/Makefile
> new file mode 100644
> index 0000000..6a26eb6
> --- /dev/null
> +++ b/drivers/clk/shmobile/Makefile
> @@ -0,0 +1,5 @@
> +ifeq ($(CONFIG_COMMON_CLK), y)
> +obj-$(CONFIG_ARCH_EMEV2)       += clk-emev2.o
> +endif

I don't think you would need the above ifeq/endif wrapper if you only
used CONFIG_ARCH_SHMOBILE_MULTI above.

Apart from that it looks good to me. And, yes, I have tested this on
my KZM9D board together with multiplatform and it works very well!

Cheers,

/ magnus

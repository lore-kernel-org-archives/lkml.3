Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754917Ab3FLFdU (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Jun 2013 01:33:20 -0400
Received: from mail-la0-f48.google.com ([209.85.215.48]:50519 "EHLO
	mail-la0-f48.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754475Ab3FLFdS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Jun 2013 01:33:18 -0400
MIME-Version: 1.0
In-Reply-To: <1370958344-19470-4-git-send-email-laurent.pinchart+renesas@ideasonboard.com>
References: <1370958344-19470-1-git-send-email-laurent.pinchart+renesas@ideasonboard.com>
	<1370958344-19470-4-git-send-email-laurent.pinchart+renesas@ideasonboard.com>
Date: Wed, 12 Jun 2013 14:33:16 +0900
Message-ID: <CANqRtoR=anJ+2RWWxSw-YwiczfTD1jwz=odX8n1U1FrJtYT_zA@mail.gmail.com>
Subject: Re: [PATCH v3 3/5] ARM: mach-shmobile: kota2: Use leds-pwm + pwm-rmob
From: Magnus Damm <magnus.damm@gmail.com>
To: Laurent Pinchart <laurent.pinchart+renesas@ideasonboard.com>
Cc: SH-Linux <linux-sh@vger.kernel.org>,
        linux-kernel <linux-kernel@vger.kernel.org>,
        linux-leds@vger.kernel.org,
        Thierry Reding <thierry.reding@avionic-design.de>,
        Paul Mundt <lethal@linux-sh.org>,
        "Simon Horman [Horms]" <horms@verge.net.au>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Laurent,

[Added Simon to CC]

Thanks for your work on converting the TPU driver. I found one issue, see below:

On Tue, Jun 11, 2013 at 10:45 PM, Laurent Pinchart
<laurent.pinchart+renesas@ideasonboard.com> wrote:
> Instead of using the LED-specific TPU PWM driver, switch to the generic
> TPU PWM driver with leds-pwm.
>
> Signed-off-by: Laurent Pinchart <laurent.pinchart+renesas@ideasonboard.com>
> Signed-off-by: Simon Horman <horms+renesas@verge.net.au>
> ---
>  arch/arm/mach-shmobile/board-kota2.c  | 183 ++++++++++++++++++++--------------
>  arch/arm/mach-shmobile/clock-sh73a0.c |   8 +-
>  2 files changed, 114 insertions(+), 77 deletions(-)
>

[snip]

> diff --git a/arch/arm/mach-shmobile/clock-sh73a0.c b/arch/arm/mach-shmobile/clock-sh73a0.c
> index d9fd033..6c04348 100644
> --- a/arch/arm/mach-shmobile/clock-sh73a0.c
> +++ b/arch/arm/mach-shmobile/clock-sh73a0.c
> @@ -669,10 +669,10 @@ static struct clk_lookup lookups[] = {
>         CLKDEV_DEV_ID("e6bd0000.mmcif", &mstp_clks[MSTP312]), /* MMCIF0 */
>         CLKDEV_DEV_ID("sh_mobile_sdhi.2", &mstp_clks[MSTP311]), /* SDHI2 */
>         CLKDEV_DEV_ID("ee140000.sdhi", &mstp_clks[MSTP311]), /* SDHI2 */
> -       CLKDEV_DEV_ID("leds-renesas-tpu.12", &mstp_clks[MSTP303]), /* TPU1 */
> -       CLKDEV_DEV_ID("leds-renesas-tpu.21", &mstp_clks[MSTP302]), /* TPU2 */
> -       CLKDEV_DEV_ID("leds-renesas-tpu.30", &mstp_clks[MSTP301]), /* TPU3 */
> -       CLKDEV_DEV_ID("leds-renesas-tpu.41", &mstp_clks[MSTP300]), /* TPU4 */
> +       CLKDEV_DEV_ID("rmob_tpu_pwm.1", &mstp_clks[MSTP303]), /* TPU1 */
> +       CLKDEV_DEV_ID("rmob_tpu_pwm.2", &mstp_clks[MSTP302]), /* TPU2 */
> +       CLKDEV_DEV_ID("rmob_tpu_pwm.3", &mstp_clks[MSTP301]), /* TPU3 */
> +       CLKDEV_DEV_ID("rmob_tpu_pwm.4", &mstp_clks[MSTP300]), /* TPU4 */
>         CLKDEV_DEV_ID("i2c-sh_mobile.3", &mstp_clks[MSTP411]), /* I2C3 */
>         CLKDEV_DEV_ID("e6826000.i2c", &mstp_clks[MSTP411]), /* I2C3 */
>         CLKDEV_DEV_ID("i2c-sh_mobile.4", &mstp_clks[MSTP410]), /* I2C4 */
> --
> 1.8.1.5
>

I believe you are using the old "rmob" device name in the hunk above.
Apart from that it looks fine.

I left my Kota2 board at Simon's place some time ago so I'm afraind
that I can't test. Given the complexity with multiple subsystems and
also recent name changes, perhaps testing this would make sense?

Simon, can you please test this series on Kota2?

Cheers,

/ magnus

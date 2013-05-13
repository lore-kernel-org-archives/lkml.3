Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754003Ab3EMO3c (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 May 2013 10:29:32 -0400
Received: from mail-da0-f43.google.com ([209.85.210.43]:51632 "EHLO
	mail-da0-f43.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752272Ab3EMO3a (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 May 2013 10:29:30 -0400
MIME-Version: 1.0
In-Reply-To: <1368044622-25645-2-git-send-email-geert@linux-m68k.org>
References: <1368044622-25645-1-git-send-email-geert@linux-m68k.org>
	<1368044622-25645-2-git-send-email-geert@linux-m68k.org>
Date: Mon, 13 May 2013 07:29:30 -0700
Message-ID: <CAHQ1cqFL4WNq5QfdCk3jWmr0ATEukdrxG0qArn5Zwkj_ZVOxvA@mail.gmail.com>
Subject: Re: [PATCH 2/2] mfd: si476x: Do not use binary constants
From: Andrey Smirnov <andrew.smirnov@gmail.com>
To: Geert Uytterhoeven <geert@linux-m68k.org>
Cc: linux-kernel@vger.kernel.org, Samuel Ortiz <sameo@linux.intel.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, May 8, 2013 at 1:23 PM, Geert Uytterhoeven <geert@linux-m68k.org> wrote:
> Gcc < 4.3 doesn't understand binary constanrs (0b*):
>
> drivers/mfd/si476x-cmd.c:153:22: error: invalid suffix "b11111" on integer constant
> drivers/mfd/si476x-cmd.c:775:20: error: invalid suffix "b00001000" on integer constant
> drivers/mfd/si476x-cmd.c:776:20: error: invalid suffix "b00000100" on integer constant
> drivers/mfd/si476x-cmd.c:777:21: error: invalid suffix "b00000010" on integer constant
> drivers/mfd/si476x-cmd.c:778:21: error: invalid suffix "b00000001" on integer constant
> drivers/mfd/si476x-cmd.c:780:17: error: invalid suffix "b10000000" on integer constant
> drivers/mfd/si476x-cmd.c:781:22: error: invalid suffix "b00100000" on integer constant
> ...
>
> Hence use hexadecimal constants (0x*) instead.
>
> Signed-off-by: Geert Uytterhoeven <geert@linux-m68k.org>
> Cc: Samuel Ortiz <sameo@linux.intel.com>

Acked-by: Andrey Smirnov <andrew.smirnov@gmail.com>

I really begin to regret my decision to use those constants in place
instead of defining a corresponding symbol in a header file. Because
now that those binary constants are replaced the code looks a little
bit more cryptic. Currently I am doing some additional work on the
driver(adding the support of a different chip) and I'll try to make
patches to address the issue.


> ---
>  drivers/mfd/si476x-cmd.c |  122 +++++++++++++++++++++++-----------------------
>  1 files changed, 61 insertions(+), 61 deletions(-)
>
> diff --git a/drivers/mfd/si476x-cmd.c b/drivers/mfd/si476x-cmd.c
> index de48b4e..f12f016 100644
> --- a/drivers/mfd/si476x-cmd.c
> +++ b/drivers/mfd/si476x-cmd.c
> @@ -150,7 +150,7 @@ enum si476x_acf_status_report_bits {
>         SI476X_ACF_SOFTMUTE_INT = (1 << 0),
>
>         SI476X_ACF_SMUTE        = (1 << 0),
> -       SI476X_ACF_SMATTN       = 0b11111,
> +       SI476X_ACF_SMATTN       = 0x1f,
>         SI476X_ACF_PILOT        = (1 << 7),
>         SI476X_ACF_STBLEND      = ~SI476X_ACF_PILOT,
>  };
> @@ -772,16 +772,16 @@ int si476x_core_cmd_am_rsq_status(struct si476x_core *core,
>         if (!report)
>                 return err;
>
> -       report->snrhint         = 0b00001000 & resp[1];
> -       report->snrlint         = 0b00000100 & resp[1];
> -       report->rssihint        = 0b00000010 & resp[1];
> -       report->rssilint        = 0b00000001 & resp[1];
> +       report->snrhint         = 0x08 & resp[1];
> +       report->snrlint         = 0x04 & resp[1];
> +       report->rssihint        = 0x02 & resp[1];
> +       report->rssilint        = 0x01 & resp[1];
>
> -       report->bltf            = 0b10000000 & resp[2];
> -       report->snr_ready       = 0b00100000 & resp[2];
> -       report->rssiready       = 0b00001000 & resp[2];
> -       report->afcrl           = 0b00000010 & resp[2];
> -       report->valid           = 0b00000001 & resp[2];
> +       report->bltf            = 0x80 & resp[2];
> +       report->snr_ready       = 0x20 & resp[2];
> +       report->rssiready       = 0x08 & resp[2];
> +       report->afcrl           = 0x02 & resp[2];
> +       report->valid           = 0x01 & resp[2];
>
>         report->readfreq        = be16_to_cpup((__be16 *)(resp + 3));
>         report->freqoff         = resp[5];
> @@ -931,26 +931,26 @@ int si476x_core_cmd_fm_rds_status(struct si476x_core *core,
>         if (err < 0 || report == NULL)
>                 return err;
>
> -       report->rdstpptyint     = 0b00010000 & resp[1];
> -       report->rdspiint        = 0b00001000 & resp[1];
> -       report->rdssyncint      = 0b00000010 & resp[1];
> -       report->rdsfifoint      = 0b00000001 & resp[1];
> +       report->rdstpptyint     = 0x10 & resp[1];
> +       report->rdspiint        = 0x08 & resp[1];
> +       report->rdssyncint      = 0x02 & resp[1];
> +       report->rdsfifoint      = 0x01 & resp[1];
>
> -       report->tpptyvalid      = 0b00010000 & resp[2];
> -       report->pivalid         = 0b00001000 & resp[2];
> -       report->rdssync         = 0b00000010 & resp[2];
> -       report->rdsfifolost     = 0b00000001 & resp[2];
> +       report->tpptyvalid      = 0x10 & resp[2];
> +       report->pivalid         = 0x08 & resp[2];
> +       report->rdssync         = 0x02 & resp[2];
> +       report->rdsfifolost     = 0x01 & resp[2];
>
> -       report->tp              = 0b00100000 & resp[3];
> -       report->pty             = 0b00011111 & resp[3];
> +       report->tp              = 0x20 & resp[3];
> +       report->pty             = 0x1f & resp[3];
>
>         report->pi              = be16_to_cpup((__be16 *)(resp + 4));
>         report->rdsfifoused     = resp[6];
>
> -       report->ble[V4L2_RDS_BLOCK_A]   = 0b11000000 & resp[7];
> -       report->ble[V4L2_RDS_BLOCK_B]   = 0b00110000 & resp[7];
> -       report->ble[V4L2_RDS_BLOCK_C]   = 0b00001100 & resp[7];
> -       report->ble[V4L2_RDS_BLOCK_D]   = 0b00000011 & resp[7];
> +       report->ble[V4L2_RDS_BLOCK_A]   = 0xc0 & resp[7];
> +       report->ble[V4L2_RDS_BLOCK_B]   = 0x30 & resp[7];
> +       report->ble[V4L2_RDS_BLOCK_C]   = 0x0c & resp[7];
> +       report->ble[V4L2_RDS_BLOCK_D]   = 0x03 & resp[7];
>
>         report->rds[V4L2_RDS_BLOCK_A].block = V4L2_RDS_BLOCK_A;
>         report->rds[V4L2_RDS_BLOCK_A].msb = resp[8];
> @@ -1005,7 +1005,7 @@ int si476x_core_cmd_fm_phase_diversity(struct si476x_core *core,
>  {
>         u8       resp[CMD_FM_PHASE_DIVERSITY_NRESP];
>         const u8 args[CMD_FM_PHASE_DIVERSITY_NARGS] = {
> -               mode & 0b111,
> +               mode & 0x07,
>         };
>
>         return si476x_core_send_command(core, CMD_FM_PHASE_DIVERSITY,
> @@ -1162,7 +1162,7 @@ static int si476x_core_cmd_am_tune_freq_a20(struct si476x_core *core,
>         const int am_freq = tuneargs->freq;
>         u8       resp[CMD_AM_TUNE_FREQ_NRESP];
>         const u8 args[CMD_AM_TUNE_FREQ_NARGS] = {
> -               (tuneargs->zifsr << 6) | (tuneargs->injside & 0b11),
> +               (tuneargs->zifsr << 6) | (tuneargs->injside & 0x03),
>                 msb(am_freq),
>                 lsb(am_freq),
>         };
> @@ -1197,18 +1197,18 @@ static int si476x_core_cmd_fm_rsq_status_a10(struct si476x_core *core,
>         if (err < 0 || report == NULL)
>                 return err;
>
> -       report->multhint        = 0b10000000 & resp[1];
> -       report->multlint        = 0b01000000 & resp[1];
> -       report->snrhint         = 0b00001000 & resp[1];
> -       report->snrlint         = 0b00000100 & resp[1];
> -       report->rssihint        = 0b00000010 & resp[1];
> -       report->rssilint        = 0b00000001 & resp[1];
> +       report->multhint        = 0x80 & resp[1];
> +       report->multlint        = 0x40 & resp[1];
> +       report->snrhint         = 0x08 & resp[1];
> +       report->snrlint         = 0x04 & resp[1];
> +       report->rssihint        = 0x02 & resp[1];
> +       report->rssilint        = 0x01 & resp[1];
>
> -       report->bltf            = 0b10000000 & resp[2];
> -       report->snr_ready       = 0b00100000 & resp[2];
> -       report->rssiready       = 0b00001000 & resp[2];
> -       report->afcrl           = 0b00000010 & resp[2];
> -       report->valid           = 0b00000001 & resp[2];
> +       report->bltf            = 0x80 & resp[2];
> +       report->snr_ready       = 0x20 & resp[2];
> +       report->rssiready       = 0x08 & resp[2];
> +       report->afcrl           = 0x02 & resp[2];
> +       report->valid           = 0x01 & resp[2];
>
>         report->readfreq        = be16_to_cpup((__be16 *)(resp + 3));
>         report->freqoff         = resp[5];
> @@ -1251,18 +1251,18 @@ static int si476x_core_cmd_fm_rsq_status_a20(struct si476x_core *core,
>         if (err < 0 || report == NULL)
>                 return err;
>
> -       report->multhint        = 0b10000000 & resp[1];
> -       report->multlint        = 0b01000000 & resp[1];
> -       report->snrhint         = 0b00001000 & resp[1];
> -       report->snrlint         = 0b00000100 & resp[1];
> -       report->rssihint        = 0b00000010 & resp[1];
> -       report->rssilint        = 0b00000001 & resp[1];
> +       report->multhint        = 0x80 & resp[1];
> +       report->multlint        = 0x40 & resp[1];
> +       report->snrhint         = 0x08 & resp[1];
> +       report->snrlint         = 0x04 & resp[1];
> +       report->rssihint        = 0x02 & resp[1];
> +       report->rssilint        = 0x01 & resp[1];
>
> -       report->bltf            = 0b10000000 & resp[2];
> -       report->snr_ready       = 0b00100000 & resp[2];
> -       report->rssiready       = 0b00001000 & resp[2];
> -       report->afcrl           = 0b00000010 & resp[2];
> -       report->valid           = 0b00000001 & resp[2];
> +       report->bltf            = 0x80 & resp[2];
> +       report->snr_ready       = 0x20 & resp[2];
> +       report->rssiready       = 0x08 & resp[2];
> +       report->afcrl           = 0x02 & resp[2];
> +       report->valid           = 0x01 & resp[2];
>
>         report->readfreq        = be16_to_cpup((__be16 *)(resp + 3));
>         report->freqoff         = resp[5];
> @@ -1306,19 +1306,19 @@ static int si476x_core_cmd_fm_rsq_status_a30(struct si476x_core *core,
>         if (err < 0 || report == NULL)
>                 return err;
>
> -       report->multhint        = 0b10000000 & resp[1];
> -       report->multlint        = 0b01000000 & resp[1];
> -       report->snrhint         = 0b00001000 & resp[1];
> -       report->snrlint         = 0b00000100 & resp[1];
> -       report->rssihint        = 0b00000010 & resp[1];
> -       report->rssilint        = 0b00000001 & resp[1];
> -
> -       report->bltf            = 0b10000000 & resp[2];
> -       report->snr_ready       = 0b00100000 & resp[2];
> -       report->rssiready       = 0b00001000 & resp[2];
> -       report->injside         = 0b00000100 & resp[2];
> -       report->afcrl           = 0b00000010 & resp[2];
> -       report->valid           = 0b00000001 & resp[2];
> +       report->multhint        = 0x80 & resp[1];
> +       report->multlint        = 0x40 & resp[1];
> +       report->snrhint         = 0x08 & resp[1];
> +       report->snrlint         = 0x04 & resp[1];
> +       report->rssihint        = 0x02 & resp[1];
> +       report->rssilint        = 0x01 & resp[1];
> +
> +       report->bltf            = 0x80 & resp[2];
> +       report->snr_ready       = 0x20 & resp[2];
> +       report->rssiready       = 0x08 & resp[2];
> +       report->injside         = 0x04 & resp[2];
> +       report->afcrl           = 0x02 & resp[2];
> +       report->valid           = 0x01 & resp[2];
>
>         report->readfreq        = be16_to_cpup((__be16 *)(resp + 3));
>         report->freqoff         = resp[5];
> --
> 1.7.0.4
>

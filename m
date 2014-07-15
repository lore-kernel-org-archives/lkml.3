Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758905AbaGOMPR (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Jul 2014 08:15:17 -0400
Received: from mail-we0-f170.google.com ([74.125.82.170]:60167 "EHLO
	mail-we0-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758652AbaGOMPP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Jul 2014 08:15:15 -0400
MIME-Version: 1.0
In-Reply-To: <1404743641-16847-2-git-send-email-sviau@codeaurora.org>
References: <1404743641-16847-1-git-send-email-sviau@codeaurora.org>
	<1404743641-16847-2-git-send-email-sviau@codeaurora.org>
Date: Tue, 15 Jul 2014 17:45:14 +0530
Message-ID: <CADsdr6MCnqCwt8623sB=rpuip4cw7LysT1_1KYzBc7yOahcmZA@mail.gmail.com>
Subject: Re: [PATCH] drm/msm/mdp5: add support for MDP5 v1.3
From: divya ojha <odivya77@gmail.com>
To: Stephane Viau <sviau@codeaurora.org>
Cc: dri-devel@lists.freedesktop.org, linux-arm-msm@vger.kernel.org,
        linux-kernel@vger.kernel.org, robdclark@gmail.com
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Stephane,

On Mon, Jul 7, 2014 at 8:04 PM, Stephane Viau <sviau@codeaurora.org> wrote:
>
> MDP5 has several functional blocks (ie: VIG/RGB pipes, LMs, ...).
> From one revision to another, these blocks' base addresses might
> change due to the number of instances present in the MDP5 hw.
..
> -static inline uint32_t REG_MDP5_PIPE(enum mdp5_pipe i0) { return 0x00001200 + 0x400*i0; }
> +static inline uint32_t __offset_PIPE(enum mdp5_pipe idx)
> +{

ERROR: switch and case should be at the same indent

> +       switch (idx) {
> +               case SSPP_VIG0: return (mdp5_cfg->pipe_vig.base[0]);
> +               case SSPP_VIG1: return (mdp5_cfg->pipe_vig.base[1]);
> +               case SSPP_VIG2: return (mdp5_cfg->pipe_vig.base[2]);
..
> -static inline uint32_t REG_MDP5_LM(uint32_t i0) { return 0x00003200 + 0x400*i0; }
> +static inline uint32_t __offset_LM(uint32_t idx)
> +{

ERROR: switch and case should be at the same indent

> +       switch (idx) {
> +               case 0: return (mdp5_cfg->lm.base[0]);
> +               case 1: return (mdp5_cfg->lm.base[1]);
> +               case 2: return (mdp5_cfg->lm.base[2]);
..

> -static inline uint32_t REG_MDP5_DSPP(uint32_t i0) { return 0x00004600 + 0x400*i0; }
> +static inline uint32_t __offset_DSPP(uint32_t idx)
> +{

ERROR: switch and case should be at the same indent

> +       switch (idx) {
> +               case 0: return (mdp5_cfg->dspp.base[0]);
> +               case 1: return (mdp5_cfg->dspp.base[1]);
> +               case 2: return (mdp5_cfg->dspp.base[2]);
> +               case 3: return (mdp5_cfg->dspp.base[3]);
..
> -static inline uint32_t REG_MDP5_INTF(uint32_t i0) { return 0x00012500 + 0x200*i0; }
> +static inline uint32_t __offset_INTF(uint32_t idx)
> +{

ERROR: switch and case should be at the same indent

> +       switch (idx) {
> +               case 0: return (mdp5_cfg->intf.base[0]);
> +               case 1: return (mdp5_cfg->intf.base[1]);
> +               case 2: return (mdp5_cfg->intf.base[2]);
..
> -static inline uint32_t REG_MDP5_AD(uint32_t i0) { return 0x00013100 + 0x200*i0; }
> +static inline uint32_t __offset_AD(uint32_t idx)
> +{

ERROR: switch and case should be at the same indent

> +       switch (idx) {
> +               case 0: return (mdp5_cfg->ad.base[0]);
> +               case 1: return (mdp5_cfg->ad.base[1]);
> +               default: return INVALID_IDX(idx);
> +       }
> +}
..
>  }
> --
> The Qualcomm Innovation Center, Inc. is a member of the Code Aurora Forum,
> hosted by The Linux Foundation

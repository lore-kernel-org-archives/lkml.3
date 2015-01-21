Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753914AbbAUSxf (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 Jan 2015 13:53:35 -0500
Received: from mail-pa0-f42.google.com ([209.85.220.42]:41512 "EHLO
	mail-pa0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752466AbbAUSx2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 Jan 2015 13:53:28 -0500
Date: Wed, 21 Jan 2015 10:53:20 -0800
From: Nicolin Chen <nicoleotsuka@gmail.com>
To: Zidan Wang <zidan.wang@freescale.com>
Cc: timur@tabi.org, Xiubo.Lee@gmail.com, lgirdwood@gmail.com,
        broonie@kernel.org, perex@perex.cz, tiwai@suse.de,
        alsa-devel@alsa-project.org, linuxppc-dev@lists.ozlabs.org,
        linux-kernel@vger.kernel.org
Subject: Re: [alsa-devel][PATCH 3/3] ASoC: fsl_sai: Add support for Right-J
 mode
Message-ID: <20150121185319.GA4238@Alpha>
References: <1421756480-7055-1-git-send-email-zidan.wang@freescale.com>
 <1421756480-7055-4-git-send-email-zidan.wang@freescale.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1421756480-7055-4-git-send-email-zidan.wang@freescale.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jan 20, 2015 at 08:21:20PM +0800, Zidan Wang wrote:
> Add Right-J mode and set TCR5 FBT bit to let data right justify.
> 
> Signed-off-by: Zidan Wang <zidan.wang@freescale.com>

> -	if (sai->is_lsb_first)
> +	if (sai->is_lsb_first && sai->is_right_j_mode)
>  		val_cr5 |= FSL_SAI_CR5_FBT(0);

Are you sure that FBT(0) is correct for right justified mode?
Because the original code is using FBT(0) for the lsb_first
situation and it shouldn't be right justified mode as default.

Nicolin

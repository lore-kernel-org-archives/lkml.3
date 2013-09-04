Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760032Ab3IDSkF (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Sep 2013 14:40:05 -0400
Received: from avon.wwwdotorg.org ([70.85.31.133]:49323 "EHLO
	avon.wwwdotorg.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752574Ab3IDSkC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Sep 2013 14:40:02 -0400
Message-ID: <52277E7F.5050609@wwwdotorg.org>
Date: Wed, 04 Sep 2013 12:39:59 -0600
From: Stephen Warren <swarren@wwwdotorg.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130803 Thunderbird/17.0.8
MIME-Version: 1.0
To: Mikko Perttunen <mperttunen@nvidia.com>
CC: thierry.reding@gmail.com, tbergstrom@nvidia.com,
        dri-devel@lists.freedesktop.org, linux-tegra@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2 1/6] host1x: hdmi: Add Tegra114 support
References: <1377704922-2824-1-git-send-email-mperttunen@nvidia.com> <1377704922-2824-2-git-send-email-mperttunen@nvidia.com>
In-Reply-To: <1377704922-2824-2-git-send-email-mperttunen@nvidia.com>
X-Enigmail-Version: 1.4.6
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 08/28/2013 09:48 AM, Mikko Perttunen wrote:
> Add Tegra114 TMDS configuration, add new peak_current field and
> use new place for drive current override bit on Tegra114 platform.

> diff --git a/drivers/gpu/host1x/dev.c b/drivers/gpu/host1x/dev.c

>  static struct of_device_id host1x_of_match[] = {
> +	{ .compatible = "nvidia,tegra114-host1x", .data = &host1x01_info, },

We should add that value to the host1x DT binding documentation.

> diff --git a/drivers/gpu/host1x/drm/hdmi.c b/drivers/gpu/host1x/drm/hdmi.c

>  static const struct tegra_hdmi_audio_config *
>  tegra_hdmi_get_audio_config(unsigned int audio_freq, unsigned int pclk)
>  {
> @@ -593,8 +673,20 @@ static void tegra_hdmi_setup_tmds(struct tegra_hdmi *hdmi,
>  	tegra_hdmi_writel(hdmi, tmds->pll1, HDMI_NV_PDISP_SOR_PLL1);
>  	tegra_hdmi_writel(hdmi, tmds->pe_current, HDMI_NV_PDISP_PE_CURRENT);
>  
> -	value = tmds->drive_current | DRIVE_CURRENT_FUSE_OVERRIDE;
> -	tegra_hdmi_writel(hdmi, value, HDMI_NV_PDISP_SOR_LANE_DRIVE_CURRENT);
> +	if (of_device_is_compatible(hdmi->dev->of_node,
> +		"nvidia,tegra114-hdmi")) {

We shouldn't do this at run-time. Rather, set tegra_hdmi_of_match[]'s
.data field to a structure that represents the various features of the
HW, and then make this code conditional upon a feature flag in that
structure.

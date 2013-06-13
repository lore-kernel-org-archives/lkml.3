Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758713Ab3FMTJk (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Jun 2013 15:09:40 -0400
Received: from avon.wwwdotorg.org ([70.85.31.133]:43205 "EHLO
	avon.wwwdotorg.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756785Ab3FMTJj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Jun 2013 15:09:39 -0400
Message-ID: <51BA18EF.4090302@wwwdotorg.org>
Date: Thu, 13 Jun 2013 13:09:35 -0600
From: Stephen Warren <swarren@wwwdotorg.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130510 Thunderbird/17.0.6
MIME-Version: 1.0
To: Thierry Reding <thierry.reding@gmail.com>
CC: Mayuresh Kulkarni <mkulkarni@nvidia.com>, tbergstrom@nvidia.com,
        amerilainen@nvidia.com, thierry.reding@avionic-design.de,
        airlied@redhat.com, dri-devel@lists.freedesktop.org,
        linux-tegra@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2 3/4] gpu: host1x: add runtime pm support for dc
References: <1371117218-2326-1-git-send-email-mkulkarni@nvidia.com> <1371117218-2326-4-git-send-email-mkulkarni@nvidia.com> <20130613184938.GE32574@mithrandir>
In-Reply-To: <20130613184938.GE32574@mithrandir>
X-Enigmail-Version: 1.4.6
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 06/13/2013 12:49 PM, Thierry Reding wrote:
> On Thu, Jun 13, 2013 at 03:23:37PM +0530, Mayuresh Kulkarni wrote: 
> [...]
>> diff --git a/drivers/gpu/host1x/drm/dc.c
>> b/drivers/gpu/host1x/drm/dc.c
> [...]
>> @@ -1128,9 +1129,7 @@ static int tegra_dc_probe(struct
>> platform_device *pdev) return PTR_ERR(dc->clk); }
>> 
>> -	err = clk_prepare_enable(dc->clk); -	if (err < 0) -		return
>> err; +	platform_set_drvdata(pdev, dc);
> 
> Why do you move the call to platform_set_drvdata() up here?

Presumably the suspend/resume functions need to get the value out of
the device they're passed, so it needs to be set up early?


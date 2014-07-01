Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756332AbaGAXsS (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 Jul 2014 19:48:18 -0400
Received: from mail-lb0-f177.google.com ([209.85.217.177]:54833 "EHLO
	mail-lb0-f177.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751751AbaGAXsQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 Jul 2014 19:48:16 -0400
Message-ID: <53B348AE.20605@iki.fi>
Date: Wed, 02 Jul 2014 02:47:58 +0300
From: Tuomas Tynkkynen <tuomas.tynkkynen@iki.fi>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.6.0
MIME-Version: 1.0
To: Mikko Perttunen <mperttunen@nvidia.com>, rui.zhang@intel.com,
        edubezval@gmail.com, swarren@wwwdotorg.org, thierry.reding@gmail.com,
        pdeschrijver@nvidia.com, mlongnecker@nvidia.com
CC: linux-pm@vger.kernel.org, linux-tegra@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org
Subject: Re: [PATCH 6/6] thermal: Add Tegra SOCTHERM thermal management driver
References: <1403856699-2140-1-git-send-email-mperttunen@nvidia.com> <1403856699-2140-7-git-send-email-mperttunen@nvidia.com>
In-Reply-To: <1403856699-2140-7-git-send-email-mperttunen@nvidia.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 27/06/14 11:11, Mikko Perttunen wrote:
> +	/* Sign extend from 6 bits to 32 bits */
> +	shifted_cp = (s32)((val & 0x1f) | ((val & 0x20) ? 0xffffffe0 : 0x0));
> +	val = ((val & (0x1f << 21)) >> 21);
> +	/* Sign extend from 5 bits to 32 bits */
> +	shifted_ft = (s32)((val & 0xf) | ((val & 0x10) ? 0xfffffff0 : 0x0));

There's sign_extend32 in bitops.h

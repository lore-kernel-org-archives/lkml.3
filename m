Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753528AbaAVUoB (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 Jan 2014 15:44:01 -0500
Received: from avon.wwwdotorg.org ([70.85.31.133]:41122 "EHLO
	avon.wwwdotorg.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751379AbaAVUn7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 Jan 2014 15:43:59 -0500
Message-ID: <52E02D8C.7090309@wwwdotorg.org>
Date: Wed, 22 Jan 2014 13:43:56 -0700
From: Stephen Warren <swarren@wwwdotorg.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.2.0
MIME-Version: 1.0
To: Alexandre Courbot <acourbot@nvidia.com>,
        Thierry Reding <thierry.reding@gmail.com>,
        Russell King <linux@arm.linux.org.uk>
CC: Olof Johansson <olof@lixom.net>, linux-arm-kernel@lists.infradead.org,
        linux-tegra@vger.kernel.org, linux-kernel@vger.kernel.org,
        gnurou@gmail.com
Subject: Re: [PATCH 4/5] ARM: trusted_foundations: implement do_idle()
References: <1390299016-14105-1-git-send-email-acourbot@nvidia.com> <1390299016-14105-5-git-send-email-acourbot@nvidia.com>
In-Reply-To: <1390299016-14105-5-git-send-email-acourbot@nvidia.com>
X-Enigmail-Version: 1.5.2
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 01/21/2014 03:10 AM, Alexandre Courbot wrote:
> Support the do_idle() firmware call, which is necessary to properly
> support cpuidle.

> diff --git a/arch/arm/firmware/trusted_foundations.c b/arch/arm/firmware/trusted_foundations.c

> +#define TF_CPU_PM		 0xfffffffc
> +#define TF_CPU_PM_LP0		 0xffffffe3
> +#define TF_CPU_PM_LP1		 0xffffffe6
> +#define TF_CPU_PM_LP1_NO_MC_CLK	 0xffffffe5
> +#define TF_CPU_PM_LP2		 0xffffffe4
> +#define TF_CPU_PM_LP2_NOFLUSH_L2 0xffffffe7

Hmm. This must be Tegra-specific, not generic to any TF client, since
aren't the names of the suspend states (LP0, LP1, LP2) entirely specific
to Tegra?

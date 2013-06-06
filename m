Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933452Ab3FFM04 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Jun 2013 08:26:56 -0400
Received: from mail-pb0-f44.google.com ([209.85.160.44]:48104 "EHLO
	mail-pb0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933344Ab3FFM0y (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Jun 2013 08:26:54 -0400
MIME-Version: 1.0
In-Reply-To: <1370503687-17767-1-git-send-email-acourbot@nvidia.com>
References: <1370503687-17767-1-git-send-email-acourbot@nvidia.com>
Date: Thu, 6 Jun 2013 17:56:53 +0530
Message-ID: <CABb+yY2SFfejMbbYOebMCUuMtAZF3u-yc+6z_MJTG2oOeSwL_g@mail.gmail.com>
Subject: Re: [PATCH] ARM: tegra: add basic SecureOS support
From: Jassi Brar <jassisinghbrar@gmail.com>
To: Alexandre Courbot <acourbot@nvidia.com>
Cc: Stephen Warren <swarren@wwwdotorg.org>, Joseph Lo <josephl@nvidia.com>,
        Karan Jhavar <kjhavar@nvidia.com>, Varun Wadekar <vwadekar@nvidia.com>,
        Chris Johnson <CJohnson@nvidia.com>,
        Matthew Longnecker <MLongnecker@nvidia.com>, gnurou@gmail.com,
        devicetree-discuss@lists.ozlabs.org,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        linux-tegra@vger.kernel.org,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jun 6, 2013 at 12:58 PM, Alexandre Courbot <acourbot@nvidia.com> wrote:
> Boot loaders on some Tegra devices can be unlocked but do not let the
> system operate without SecureOS. SecureOS prevents access to some
> registers and requires the operating system to perform certain
> operations through Secure Monitor Calls instead of directly accessing
> the hardware.
>
IOW, some critical h/w controls on Tegra are accessible only from
Secure mode (not unusual). So if we(Linux) run in NS mode we need to
make calls to the SecureOS, over SMC, to do things for us?

> This patch introduces basic SecureOS support for Tegra. SecureOS support
> can be enabled by adding a "nvidia,secure-os" property to the "chosen"
> node of the device tree.
>
Probably just a nit, but shouldn't it be "nvidia,nonsecure-os"
instead, denoting the mode Linux is going to run?  (and then I wonder
if we could detect the mode (S or NS) at runtime and avoid this flag
at all).

Cheers,
-Jassi

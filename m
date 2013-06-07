Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752401Ab3FGHOV (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Jun 2013 03:14:21 -0400
Received: from mail-ie0-f181.google.com ([209.85.223.181]:48302 "EHLO
	mail-ie0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750838Ab3FGHOT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Jun 2013 03:14:19 -0400
MIME-Version: 1.0
In-Reply-To: <CABb+yY2SFfejMbbYOebMCUuMtAZF3u-yc+6z_MJTG2oOeSwL_g@mail.gmail.com>
References: <1370503687-17767-1-git-send-email-acourbot@nvidia.com> <CABb+yY2SFfejMbbYOebMCUuMtAZF3u-yc+6z_MJTG2oOeSwL_g@mail.gmail.com>
From: Alexandre Courbot <gnurou@gmail.com>
Date: Fri, 7 Jun 2013 16:13:58 +0900
Message-ID: <CAAVeFuKxRuLdhO+-+YHG=c-TNGUUJbDj5AHj+K5e8y1JDEDksg@mail.gmail.com>
Subject: Re: [PATCH] ARM: tegra: add basic SecureOS support
To: Jassi Brar <jassisinghbrar@gmail.com>
Cc: Alexandre Courbot <acourbot@nvidia.com>,
        Stephen Warren <swarren@wwwdotorg.org>, Joseph Lo <josephl@nvidia.com>,
        Karan Jhavar <kjhavar@nvidia.com>, Varun Wadekar <vwadekar@nvidia.com>,
        Chris Johnson <CJohnson@nvidia.com>,
        Matthew Longnecker <MLongnecker@nvidia.com>,
        "devicetree-discuss@lists.ozlabs.org" 
	<devicetree-discuss@lists.ozlabs.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        "linux-tegra@vger.kernel.org" <linux-tegra@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jun 6, 2013 at 9:26 PM, Jassi Brar <jassisinghbrar@gmail.com> wrote:
> On Thu, Jun 6, 2013 at 12:58 PM, Alexandre Courbot <acourbot@nvidia.com> wrote:
>> Boot loaders on some Tegra devices can be unlocked but do not let the
>> system operate without SecureOS. SecureOS prevents access to some
>> registers and requires the operating system to perform certain
>> operations through Secure Monitor Calls instead of directly accessing
>> the hardware.
>>
> IOW, some critical h/w controls on Tegra are accessible only from
> Secure mode (not unusual). So if we(Linux) run in NS mode we need to
> make calls to the SecureOS, over SMC, to do things for us?

Exactly.

>> This patch introduces basic SecureOS support for Tegra. SecureOS support
>> can be enabled by adding a "nvidia,secure-os" property to the "chosen"
>> node of the device tree.
>>
> Probably just a nit, but shouldn't it be "nvidia,nonsecure-os"
> instead, denoting the mode Linux is going to run?  (and then I wonder
> if we could detect the mode (S or NS) at runtime and avoid this flag
> at all).

Detection of the secure mode at runtime would only solve half of the
issue: we would know that we are running in non-secure mode, but we
would still not know what monitor is operating. Detecting that part is
impossible AFAIK, so I'm afraid we need to pass that information
through the DT here.

Alex.

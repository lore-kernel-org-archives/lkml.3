Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932185AbaAWHj1 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 23 Jan 2014 02:39:27 -0500
Received: from mail-vb0-f54.google.com ([209.85.212.54]:42974 "EHLO
	mail-vb0-f54.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932153AbaAWHjZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 23 Jan 2014 02:39:25 -0500
MIME-Version: 1.0
In-Reply-To: <52E02D8C.7090309@wwwdotorg.org>
References: <1390299016-14105-1-git-send-email-acourbot@nvidia.com>
 <1390299016-14105-5-git-send-email-acourbot@nvidia.com> <52E02D8C.7090309@wwwdotorg.org>
From: Alexandre Courbot <gnurou@gmail.com>
Date: Thu, 23 Jan 2014 16:39:04 +0900
Message-ID: <CAAVeFu+Jie10YvL5e5od_ABM_-e=a328iZO_GESGfP6yzznLTQ@mail.gmail.com>
Subject: Re: [PATCH 4/5] ARM: trusted_foundations: implement do_idle()
To: Stephen Warren <swarren@wwwdotorg.org>
Cc: Alexandre Courbot <acourbot@nvidia.com>,
        Thierry Reding <thierry.reding@gmail.com>,
        Russell King <linux@arm.linux.org.uk>, Olof Johansson <olof@lixom.net>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "linux-tegra@vger.kernel.org" <linux-tegra@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jan 23, 2014 at 5:43 AM, Stephen Warren <swarren@wwwdotorg.org> wrote:
> On 01/21/2014 03:10 AM, Alexandre Courbot wrote:
>> Support the do_idle() firmware call, which is necessary to properly
>> support cpuidle.
>
>> diff --git a/arch/arm/firmware/trusted_foundations.c b/arch/arm/firmware/trusted_foundations.c
>
>> +#define TF_CPU_PM             0xfffffffc
>> +#define TF_CPU_PM_LP0                 0xffffffe3
>> +#define TF_CPU_PM_LP1                 0xffffffe6
>> +#define TF_CPU_PM_LP1_NO_MC_CLK       0xffffffe5
>> +#define TF_CPU_PM_LP2                 0xffffffe4
>> +#define TF_CPU_PM_LP2_NOFLUSH_L2 0xffffffe7
>
> Hmm. This must be Tegra-specific, not generic to any TF client, since
> aren't the names of the suspend states (LP0, LP1, LP2) entirely specific
> to Tegra?

The names are negligence on my part, actually. I arbitrarily named
them that way without thinking this was Tegra-only denomination. The
downstream kernel does not even use these, they hardcode the values
directly. Will fix that, thanks for spotting it.

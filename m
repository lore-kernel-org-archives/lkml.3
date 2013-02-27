Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760035Ab3B0PVz (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Feb 2013 10:21:55 -0500
Received: from mail-la0-f47.google.com ([209.85.215.47]:32952 "EHLO
	mail-la0-f47.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752883Ab3B0PVy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Feb 2013 10:21:54 -0500
MIME-Version: 1.0
In-Reply-To: <87621dygvw.fsf@linaro.org>
References: <1361389302-11968-1-git-send-email-khilman@linaro.org>
	<1361389302-11968-2-git-send-email-khilman@linaro.org>
	<20130222132750.GE17948@somewhere.redhat.com>
	<87fw0izxe4.fsf@linaro.org>
	<1361916782.1740.2.camel@leonhard>
	<87621dygvw.fsf@linaro.org>
Date: Wed, 27 Feb 2013 16:21:52 +0100
Message-ID: <CAFTL4hzFBgT-hKHEdGshoGnWwbfrANaEQonXe3O03Oe6L2=_nQ@mail.gmail.com>
Subject: Re: [RFC/PATCH 1/5] context tracking: conditionalize guest support
 based on CONFIG_KVM
From: Frederic Weisbecker <fweisbec@gmail.com>
To: Kevin Hilman <khilman@linaro.org>
Cc: Namhyung Kim <namhyung@kernel.org>,
        Mats Liljegren <mats.liljegren@enea.com>, linaro-dev@lists.linaro.org,
        linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2013/2/27 Kevin Hilman <khilman@linaro.org>:
> From 61e35f069a64c03a2bce348487d41072aeb9f36b Mon Sep 17 00:00:00 2001
> From: Kevin Hilman <khilman@linaro.org>
> Date: Thu, 14 Feb 2013 10:17:37 -0800
> Subject: [PATCH] context tracking: conditionalize guest support based on
>  CONFIG_KVM
>
> So that it can build on !KVM systems too.
>
> Signed-off-by: Kevin Hilman <khilman@linaro.org>
> ---
>  kernel/context_tracking.c | 4 ++++
>  1 file changed, 4 insertions(+)
>
> diff --git a/kernel/context_tracking.c b/kernel/context_tracking.c
> index 74f68f4..fda6cd6 100644
> --- a/kernel/context_tracking.c
> +++ b/kernel/context_tracking.c
> @@ -1,5 +1,7 @@
>  #include <linux/context_tracking.h>
> +#if IS_ENABLED(CONFIG_KVM)
>  #include <linux/kvm_host.h>
> +#endif

Please fix the header rather than its inclusion.
General purpose headers like this must be able to handle the off-cases.

Thanks.

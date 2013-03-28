Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756555Ab3C1Hgm (ORCPT <rfc822;w@1wt.eu>);
	Thu, 28 Mar 2013 03:36:42 -0400
Received: from mail-oa0-f50.google.com ([209.85.219.50]:50959 "EHLO
	mail-oa0-f50.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752125Ab3C1Hgk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 28 Mar 2013 03:36:40 -0400
MIME-Version: 1.0
In-Reply-To: <1364423841-6920-2-git-send-email-jacob.shin@amd.com>
References: <1364423841-6920-1-git-send-email-jacob.shin@amd.com>
	<1364423841-6920-2-git-send-email-jacob.shin@amd.com>
Date: Thu, 28 Mar 2013 13:06:39 +0530
Message-ID: <CAKohpokNNOfawOuvYFnFacMwKQV9gLnhD370UU4-BiVMnft87g@mail.gmail.com>
Subject: Re: [PATCH 1/2] cpufreq: ondemand: allow custom od_ops to be registered
From: Viresh Kumar <viresh.kumar@linaro.org>
To: Jacob Shin <jacob.shin@amd.com>
Cc: "Rafael J. Wysocki" <rjw@sisk.pl>, cpufreq@vger.kernel.org,
        linux-pm@vger.kernel.org, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 28 March 2013 04:07, Jacob Shin <jacob.shin@amd.com> wrote:
> diff --git a/drivers/cpufreq/cpufreq_ondemand.c b/drivers/cpufreq/cpufreq_ondemand.c
> +void od_register_ops(struct od_ops *ops)
> +{
> +       if (ops->powersave_bias_init_cpu)
> +               od_ops.powersave_bias_init_cpu = ops->powersave_bias_init_cpu;
> +       if (ops->powersave_bias_target)
> +               od_ops.powersave_bias_target = ops->powersave_bias_target;
> +       if (ops->freq_increase)
> +               od_ops.freq_increase = ops->freq_increase;
> +}

We don't need to support all the three. First and last ones strictly belong
to ondemand governor.

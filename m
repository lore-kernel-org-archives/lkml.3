Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932292AbaGASAh (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 Jul 2014 14:00:37 -0400
Received: from smtp.codeaurora.org ([198.145.11.231]:55646 "EHLO
	smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755099AbaGASAf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 Jul 2014 14:00:35 -0400
Message-ID: <53B2F741.2000501@codeaurora.org>
Date: Tue, 01 Jul 2014 11:00:33 -0700
From: Stephen Boyd <sboyd@codeaurora.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130329 Thunderbird/17.0.5
MIME-Version: 1.0
To: Viresh Kumar <viresh.kumar@linaro.org>
CC: rjw@rjwysocki.net, shawn.guo@linaro.org, linaro-kernel@lists.linaro.org,
        linux-pm@vger.kernel.org, linux-kernel@vger.kernel.org,
        arvind.chauhan@arm.com, linux-arm-msm@vger.kernel.org,
        spk.linux@gmail.com, thomas.ab@samsung.com, nm@ti.com,
        t.figa@samsung.com, Mike Turquette <mturquette@linaro.org>
Subject: Re: [PATCH 02/14] clk: Create of_clk_shared_by_cpus()
References: <cover.1404231535.git.viresh.kumar@linaro.org> <5f7164d789e87c62d722b575980c92dfd0504334.1404231535.git.viresh.kumar@linaro.org>
In-Reply-To: <5f7164d789e87c62d722b575980c92dfd0504334.1404231535.git.viresh.kumar@linaro.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 07/01/14 09:32, Viresh Kumar wrote:
> Create a new routine of_clk_shared_by_cpus() that finds if clock lines are
> shared between two CPUs. This is verified by comparing "clocks" property from
> CPU's DT node.
>
> Returns 1 if clock line is shared between them, 0 if clock isn't shared and
> return appropriate errors in case nodes/properties are missing.
>
> Cc: Mike Turquette <mturquette@linaro.org>
> Signed-off-by: Viresh Kumar <viresh.kumar@linaro.org>
> ---
>  drivers/clk/clk.c   | 56 +++++++++++++++++++++++++++++++++++++++++++++++++++++
>  include/linux/clk.h |  6 ++++++

This doesn't make much sense to me. This function doesn't deal with
struct clk pointers or any of the internals of the common clock
framework so why put it in clk.c? It looks more like an internal
function that the cpufreq-generic driver should have.

-- 
Qualcomm Innovation Center, Inc. is a member of Code Aurora Forum,
hosted by The Linux Foundation


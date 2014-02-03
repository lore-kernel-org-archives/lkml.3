Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752907AbaBCGWL (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 Feb 2014 01:22:11 -0500
Received: from mail-ob0-f174.google.com ([209.85.214.174]:47302 "EHLO
	mail-ob0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752843AbaBCGWJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 Feb 2014 01:22:09 -0500
MIME-Version: 1.0
In-Reply-To: <1390881491-18998-1-git-send-email-konrad.wilk@oracle.com>
References: <1390881491-18998-1-git-send-email-konrad.wilk@oracle.com>
Date: Mon, 3 Feb 2014 11:52:08 +0530
Message-ID: <CAKohponazqo1O9Z+yF9uKZDAZS8V+iSjn+NnQ6eSp2hMc2-rZA@mail.gmail.com>
Subject: Re: [PATCH] acpi-cpufreq: De-register cpu notifier and free struct
 msr on error.
From: Viresh Kumar <viresh.kumar@linaro.org>
To: Konrad Rzeszutek Wilk <konrad@kernel.org>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        "Rafael J. Wysocki" <rafael.j.wysocki@intel.com>,
        "cpufreq@vger.kernel.org" <cpufreq@vger.kernel.org>,
        "linux-pm@vger.kernel.org" <linux-pm@vger.kernel.org>,
        Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>,
        Lukasz Majewski <l.majewski@samsung.com>,
        Myungjoo Ham <myungjoo.ham@samsung.com>,
        Boris Ostrovsky <boris.ostrovsky@oracle.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 28 January 2014 09:28, Konrad Rzeszutek Wilk <konrad@kernel.org> wrote:
> If cpufreq_register_driver() fails we would free the acpi driver
> related structures but not free the ones allocated
> by acpi_cpufreq_boost_init() function. This meant that as
> the driver error-ed out and a CPU online/offline event came
> we would crash and burn as one of the CPU notifiers would point
> to garbage.
>
> This fixes a regression that commit cfc9c8ed03e4d908f2388af8815f44c87b503aaf
> "acpi-cpufreq: Adjust the code to use the common boost attribute"
> introduced.
>
> CC: Lukasz Majewski <l.majewski@samsung.com>
> CC: Myungjoo Ham <myungjoo.ham@samsung.com>
> CC: Viresh Kumar <viresh.kumar@linaro.org>
> CC: Rafael J. Wysocki <rafael.j.wysocki@intel.com>
> CC: Boris Ostrovsky <boris.ostrovsky@oracle.com>
> Signed-off-by: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
> ---
>  drivers/cpufreq/acpi-cpufreq.c |    5 +++--
>  1 files changed, 3 insertions(+), 2 deletions(-)

Acked-by: Viresh Kumar <viresh.kumar@linaro.org>

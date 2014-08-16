Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751403AbaHPGfa (ORCPT <rfc822;w@1wt.eu>);
	Sat, 16 Aug 2014 02:35:30 -0400
Received: from atrey.karlin.mff.cuni.cz ([195.113.26.193]:35841 "EHLO
	atrey.karlin.mff.cuni.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751004AbaHPGf2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 16 Aug 2014 02:35:28 -0400
Date: Sat, 16 Aug 2014 08:35:17 +0200
From: Pavel Machek <pavel@ucw.cz>
To: Tomeu Vizoso <tomeu.vizoso@collabora.com>
Cc: linux-pm@vger.kernel.org, Thierry Reding <thierry.reding@gmail.com>,
        Terje Bergstr?m <tbergstrom@nvidia.com>,
        Stephen Warren <swarren@wwwdotorg.org>,
        "Rafael J. Wysocki" <rjw@rjwysocki.net>,
        Len Brown <len.brown@intel.com>, linux-tegra@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        Javier Martinez Canillas <javier.martinez@collabora.co.uk>,
        Mikko Perttunen <mperttunen@nvidia.com>
Subject: Re: [RFC v2 1/3] PM / QoS: Add PM_QOS_MEMORY_BANDWIDTH class
Message-ID: <20140816063517.GB13884@Nokia-N900>
References: <1408107129-29516-1-git-send-email-tomeu.vizoso@collabora.com>
 <1408107129-29516-2-git-send-email-tomeu.vizoso@collabora.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1408107129-29516-2-git-send-email-tomeu.vizoso@collabora.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi!

> Also adds a class type PM_QOS_SUM that aggregates the values by summing them.
> 
> It can be used by memory controllers to calculate the optimum clock frequency
> based on the bandwidth needs of the different memory clients.
> 
> Signed-off-by: Tomeu Vizoso <tomeu.vizoso@collabora.com>
> ---
>  Documentation/power/pm_qos_interface.txt |  4 +++-
>  include/linux/pm_qos.h                   |  5 ++++-
>  kernel/power/qos.c                       | 27 ++++++++++++++++++++++++++-
>  3 files changed, 33 insertions(+), 3 deletions(-)
> 
> diff --git a/Documentation/power/pm_qos_interface.txt b/Documentation/power/pm_qos_interface.txt
> index a5da5c7..57782e8 100644
> --- a/Documentation/power/pm_qos_interface.txt
> +++ b/Documentation/power/pm_qos_interface.txt
> @@ -5,7 +5,8 @@ performance expectations by drivers, subsystems and user space applications on
>  one of the parameters.
>  
>  Two different PM QoS frameworks are available:
> -1. PM QoS classes for cpu_dma_latency, network_latency, network_throughput.
> +1. PM QoS classes for cpu_dma_latency, network_latency, network_throughput,
> +memory_bandwidth.
>  2. the per-device PM QoS framework provides the API to manage the per-device latency
>  constraints and PM QoS flags.
>  
> @@ -13,6 +14,7 @@ Each parameters have defined units:
>   * latency: usec
>   * timeout: usec
>   * throughput: kbs (kilo bit / sec)
> + * memory bandwidth: kbs (kilo bit / sec)

Would mega bits per second make sense here?

I suppose some many-core systems would have memory bandwith
in > 10 terabit/sec, overflowing u32.

Plus, if driver in 3/3 is just an example, perhaps comment
should explain that clearly?

Otherwise looks good,

Acked-by: Pavel Machek <pavel@ucw.cz>

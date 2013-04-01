Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756546Ab3DAGoH (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Apr 2013 02:44:07 -0400
Received: from mail-db8lp0188.outbound.messaging.microsoft.com ([213.199.154.188]:48476
	"EHLO db8outboundpool.messaging.microsoft.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751591Ab3DAGoF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Apr 2013 02:44:05 -0400
X-Forefront-Antispam-Report: CIP:70.37.183.190;KIP:(null);UIP:(null);IPV:NLI;H:mail.freescale.net;RD:none;EFVD:NLI
X-SpamScore: -2
X-BigFish: VS-2(zz98dI1432Izz1f42h1fc6h1ee6h1de0h1202h1e76h1d1ah1d2ahzz8275dhz2dh87h2a8h668h839h944hd25hf0ah1220h1288h12a5h12a9h12bdh137ah13b6h1441h1504h1537h153bh162dh1631h1758h18e1h1946h19b5h1ad9h1b0ah1155h)
X-FB-DOMAIN-IP-MATCH: fail
Date: Mon, 1 Apr 2013 14:44:20 +0800
From: Shawn Guo <shawn.guo@linaro.org>
To: Viresh Kumar <viresh.kumar@linaro.org>
CC: <rjw@sisk.pl>, <cpufreq@vger.kernel.org>, <linux-pm@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>, <linaro-kernel@lists.linaro.org>,
        <patches@linaro.org>, <robin.randhawa@arm.com>,
        <Steve.Bannister@arm.com>, <Liviu.Dudau@arm.com>,
        <charles.garcia-tobin@arm.com>, <arvind.chauhan@arm.com>
Subject: Re: [PATCH] cpufreq: cpufreq-cpu0: No need to check cpu number in
 init()
Message-ID: <20130401064418.GE1693@S2101-09.ap.freescale.net>
References: <3f6e2ec11acfe89c192735f357c830d968daa0fd.1364648083.git.viresh.kumar@linaro.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <3f6e2ec11acfe89c192735f357c830d968daa0fd.1364648083.git.viresh.kumar@linaro.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-OriginatorOrg: sigmatel.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Mar 30, 2013 at 06:26:29PM +0530, Viresh Kumar wrote:
> It is not possible for init() to be called for any cpu other than cpu0. During
> bootup whatever cpu is used to boot system will be assigned as cpu0. And later
> on policy->cpu can only change if we hotunplug all cpus first and then hotplug
> them back in different order, which isn't possible (system requires atleast one
> cpu to be up always :)).
> 
> Though I can see one situation where policy->cpu can be different then zero.
> - Hot-unplug cpu 0.
> - rmmod cpufreq-cpu0 module
> - insmod it back
> - hotplug cpu 0 again.
> 
> Here, policy->cpu would be different. But the driver doesn't have any dependency
> on cpu0 as such. We don't mind which cpu of a system is policy->cpu and so this
> check is just not required.
> 
> Remove it.
> 
> Signed-off-by: Viresh Kumar <viresh.kumar@linaro.org>

Acked-by: Shawn Guo <shawn.guo@linaro.org>


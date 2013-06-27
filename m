Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752810Ab3F0QWS (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 Jun 2013 12:22:18 -0400
Received: from va3ehsobe006.messaging.microsoft.com ([216.32.180.16]:14935
	"EHLO va3outboundpool.messaging.microsoft.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751353Ab3F0QWP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 Jun 2013 12:22:15 -0400
X-Forefront-Antispam-Report: CIP:163.181.249.109;KIP:(null);UIP:(null);IPV:NLI;H:ausb3twp02.amd.com;RD:none;EFVD:NLI
X-SpamScore: -4
X-BigFish: VPS-4(zz98dI103dKzz1f42h1ee6h1de0h1fdah1202h1e76h1d1ah1d2ah1fc6hzz8275bh8275dhz2dh668h839h944hd25hd2bhf0ah1220h1288h12a5h12a9h12bdh137ah13b6h1441h1504h1537h153bh162dh1631h1758h18e1h1946h19b5h1ad9h1b0ah1d0ch1d2eh1d3fh1dfeh1dffh1e1dh1155h)
X-WSS-ID: 0MP284T-02-0CW-02
X-M-MSG: 
Date: Thu, 27 Jun 2013 11:22:03 -0500
From: Jacob Shin <jacob.shin@amd.com>
To: Viresh Kumar <viresh.kumar@linaro.org>
CC: Tim Gardner <tim.gardner@canonical.com>, "Rafael J. Wysocki" <rjw@sisk.pl>,
        LKML <linux-kernel@vger.kernel.org>, <cpufreq@vger.kernel.org>,
        <linux-pm@vger.kernel.org>
Subject: Re: od_set_powersave_bias: NULL pointer dereference
Message-ID: <20130627162203.GB5324@jshin-Toonie>
References: <CAKohponCrC93D88Fgg_3LKsLG0KMeCVKsTEoy-N3jsdUQdgWvA@mail.gmail.com>
 <20130625161935.GA10208@jshin-Toonie>
 <CAKohpomSa0FRviZHkkJOeUUxubbzueVb3yyP5G8ASwpRB6wANQ@mail.gmail.com>
 <20130626142852.GA2326@jshin-Toonie>
 <CAKohpom_jHQeR2FKFS3-RkxpPrJvekw8pDb-qnApnzu-VqreBQ@mail.gmail.com>
 <20130626175722.GA20226@jshin-Toonie>
 <CAKohpo=UTmpLmyQs5+xLNnCLMCeZHNQT3USjmK1NTaFJLNQg-Q@mail.gmail.com>
 <20130627145505.GA3076@jshin-Toonie>
 <CAKohpomSNGn1wTzbCxpHN5fu2L6mJ1fnhvt2uLBWLgQE8fS6Rg@mail.gmail.com>
 <CAKohpokQcL0iq6Oyt3zLGGTh4k_PoCpCzHFrgqWUmpUA3-2O3w@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <CAKohpokQcL0iq6Oyt3zLGGTh4k_PoCpCzHFrgqWUmpUA3-2O3w@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-OriginatorOrg: amd.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jun 27, 2013 at 08:50:44PM +0530, Viresh Kumar wrote:
> BTW, your v1 is already applied and sent to Linus. So,
> you need to send only fixup now.

Here is the fixup delta patch, thanks! :

---8<---

>From 133f670aa1dc450fd37ba39081d046bf238c507b Mon Sep 17 00:00:00 2001
From: Jacob Shin <jacob.shin@amd.com>
Date: Thu, 27 Jun 2013 10:44:42 -0500
Subject: [PATCH 1/1] cpufreq: don't leave stale policy pointer in
 cdbs->cur_policy

Set ->cur_policy to NULL when stopping a governor. Otherwise, the
->cur_policy pointer may be stale on systems that
have_governor_per_policy when a new policy is allocated due to CPU
hotplug offline/online.

Suggested-by: Viresh Kumar <viresh.kumar@linaro.org>
Signed-off-by: Jacob Shin <jacob.shin@amd.com>
---
 drivers/cpufreq/cpufreq_governor.c |    1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/cpufreq/cpufreq_governor.c b/drivers/cpufreq/cpufreq_governor.c
index dc9b72e..320474e 100644
--- a/drivers/cpufreq/cpufreq_governor.c
+++ b/drivers/cpufreq/cpufreq_governor.c
@@ -404,6 +404,7 @@ int cpufreq_governor_dbs(struct cpufreq_policy *policy,
 
 		mutex_lock(&dbs_data->mutex);
 		mutex_destroy(&cpu_cdbs->timer_mutex);
+		cpu_cdbs->cur_policy = NULL;
 
 		mutex_unlock(&dbs_data->mutex);
 
-- 
1.7.10.4



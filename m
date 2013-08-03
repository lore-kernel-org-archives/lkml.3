Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753190Ab3HCV42 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 3 Aug 2013 17:56:28 -0400
Received: from hydra.sisk.pl ([212.160.235.94]:54258 "EHLO hydra.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752586Ab3HCV40 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 3 Aug 2013 17:56:26 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Viresh Kumar <viresh.kumar@linaro.org>
Cc: linaro-kernel@lists.linaro.org, patches@linaro.org,
        cpufreq@vger.kernel.org, linux-pm@vger.kernel.org,
        linux-kernel@vger.kernel.org, srivatsa.bhat@linux.vnet.ibm.com,
        l.majewski@samsung.com
Subject: Re: [PATCH 08/10] cpufreq: Fix broken usage of governor->owner's refcount
Date: Sun, 04 Aug 2013 00:06:40 +0200
Message-ID: <2637835.0QndCQ8FcY@vostro.rjw.lan>
User-Agent: KMail/4.9.5 (Linux/3.10.0+; KDE/4.9.5; x86_64; ; )
In-Reply-To: <CAKohpokdWMjeZ=GKt4SaJDaA4Dn-WODpE_Mn+VEBpxB=VNAuyw@mail.gmail.com>
References: <cover.1375530162.git.viresh.kumar@linaro.org> <4846602.3FgvAM66Ta@vostro.rjw.lan> <CAKohpokdWMjeZ=GKt4SaJDaA4Dn-WODpE_Mn+VEBpxB=VNAuyw@mail.gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="utf-8"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Saturday, August 03, 2013 06:57:11 PM Viresh Kumar wrote:
> On 3 August 2013 17:38, Rafael J. Wysocki <rjw@sisk.pl> wrote:
> > On Saturday, August 03, 2013 05:19:26 PM Viresh Kumar wrote:
> >> Governor's owner refcount usage was broken. We should increment refcount only
> >> when CPUFREQ_GOV_POLICY_INIT event has come and should decrement only if
> >> CPUFREQ_GOV_POLICY_EXIT has come.
> >>
> >> Lets fix it.
> >
> > OK, and what happens if we don't fix it?
> 
> What about this changelog:
> 
> Subject: [PATCH 08/10] cpufreq: Fix broken usage of governor->owner's
>  refcount
> 
> Governor's owner refcount usage was broken. We should increment refcount only
> when CPUFREQ_GOV_POLICY_INIT event has come and should decrement only if
> CPUFREQ_GOV_POLICY_EXIT has come.
> 
> Currently there can be situations where governor is in use but we have allowed
> it to be unloaded. And that may cause in undefined behavior.

"it to be unloaded which may result in undefined behavior."

> 
> Lets fix it.
> 
> Signed-off-by: Viresh Kumar <viresh.kumar@linaro.org>

Apart from the above looks good.

Thanks,
Rafael


-- 
I speak only for myself.
Rafael J. Wysocki, Intel Open Source Technology Center.

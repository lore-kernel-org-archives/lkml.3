Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934521Ab3CZOa6 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Mar 2013 10:30:58 -0400
Received: from mail-oa0-f48.google.com ([209.85.219.48]:48530 "EHLO
	mail-oa0-f48.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759796Ab3CZOaz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Mar 2013 10:30:55 -0400
MIME-Version: 1.0
In-Reply-To: <51519FD3.5000402@gmail.com>
References: <1f864ec505cae7c5daea3810a3c26e0f5cda38ea.1364290815.git.viresh.kumar@linaro.org>
	<51519FD3.5000402@gmail.com>
Date: Tue, 26 Mar 2013 20:00:55 +0530
Message-ID: <CAKohpomRYXaKPoMX-3+SknSQsWiP_sMndPb4WsnLaw0Pa0k2xQ@mail.gmail.com>
Subject: Re: [PATCH V2] cpufreq: ARM big LITTLE: Add generic cpufreq driver
 and its DT glue
From: Viresh Kumar <viresh.kumar@linaro.org>
To: Rob Herring <robherring2@gmail.com>
Cc: "Rafael J. Wysocki" <rjw@sisk.pl>, nicolas.pitre@linaro.org,
        robin.randhawa@arm.com, linux@arm.linux.org.uk,
        mark.hambleton@broadcom.com, linux-pm@vger.kernel.org,
        Sudeep KarkadaNagesha <sudeep.karkadanagesha@arm.com>,
        devicetree-discuss@lists.ozlabs.org, Liviu.Dudau@arm.com,
        linux-kernel@vger.kernel.org, cpufreq@vger.kernel.org,
        linaro-kernel@lists.linaro.org, Steve.Bannister@arm.com,
        arvind.chauhan@arm.com, linux-arm-kernel@lists.infradead.org,
        charles.garcia-tobin@arm.com,
        Mark Langsdorf <mark.langsdorf@calxeda.com>,
        Shawn Guo <shawn.guo@linaro.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 26 March 2013 18:47, Rob Herring <robherring2@gmail.com> wrote:
> On 03/26/2013 04:51 AM, Viresh Kumar wrote:
> I fail to see anything bL specific here. This is just multi-cluster, but
> even for that I don't see anything new other than simply allowing per
> cpu or per cluster opp's. The fact that we have one opp for a cluster is
> simply an implementation decision in CortexA cores.

For now it is a very simple driver and yes probably multi-cluster only. It
will be updated with In Kernel Switcher support as soon as Linaro makes
a decision to opensource that (likely to happen soon).

Yes, there can be implementations, like krait, which can have per cpu
control of opp, but we will wait for any such platform before making this
driver complex.

>> +NOTE: Cpus should boot in the order specified in DT and all cpus for a cluster
>> +must be present contiguously. Generic DT driver will check only node 'x' for
>> +cpu:x.
>
> The OS cannot necessarily control the order. The OS should be able to
> boot on which ever core comes up first.

This should be a FIXME instead (will update it). I am waiting for
final DT bindings
from ARM guys before this can be written on stone.

For now this is the limitation and it should go away as soon as DT bindings are
finalized.

>> +Optional properties:
>> +- clock-latency: Specify the possible maximum transition latency for clock,
>> +  in unit of nanoseconds.
>
> Don't we already have "transition-latency" defined?

No, its clock-latency.

$ git grep "clock-latency" Documentation/devicetree/bindings/
Documentation/devicetree/bindings/cpufreq/cpufreq-cpu0.txt:-
clock-latency: Specify the possible maximum transition latency for
clock,
Documentation/devicetree/bindings/cpufreq/cpufreq-spear.txt:-
clock-latency: Specify the possible maximum transition latency for
clock, in

Though transition-latency is mentioned by the example of cpufreq-cpu0.
I will fix it.

> Don't create
> something new. Ideally, this should have had "-ns" appended, but the
> binding is already defined.

I had the same intention.

>> diff --git a/drivers/cpufreq/arm_big_little.c b/drivers/cpufreq/arm_big_little.c
> What is specific to bL? This looks like just a multi-cluster cpufreq
> driver and should be generalized to that. Also, why can't the existing
> cpufreq-cpu0 driver be extended to support this?

With IKS code in, it will be a complete big LITTLE driver.

>> +/* Currently we support only two clusters */
>> +#define MAX_CLUSTERS 2
>
> Why? Because that is what the define is or there are other limitations?
> Seems like this could and should be dynamically discovered with DT.

To keep it simple, as for now as all early systems (atleast which are announced)
have dual cluster systems only.

We will update it once we have some real systems breaking this law.

--
viresh

Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751392AbaJOOHX (ORCPT <rfc822;w@1wt.eu>);
	Wed, 15 Oct 2014 10:07:23 -0400
Received: from service87.mimecast.com ([91.220.42.44]:56138 "EHLO
	service87.mimecast.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751268AbaJOOHU convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 15 Oct 2014 10:07:20 -0400
Date: Wed, 15 Oct 2014 15:07:59 +0100
From: Lorenzo Pieralisi <lorenzo.pieralisi@arm.com>
To: Mark Rutland <mark.rutland@arm.com>
Cc: Chander Kashyap <k.chander@samsung.com>,
        "linux-pm@vger.kernel.org" <linux-pm@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-samsung-soc@vger.kernel.org" 
	<linux-samsung-soc@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "daniel.lezcano@linaro.org" <daniel.lezcano@linaro.org>,
        Catalin Marinas <Catalin.Marinas@arm.com>,
        "rjw@rjwysocki.net" <rjw@rjwysocki.net>,
        "kgene.kim@samsung.com" <kgene.kim@samsung.com>
Subject: Re: [PATCH] arm64: dts: exynos7: add support for cpuidle core power
 down
Message-ID: <20141015140759.GB26484@red-moon>
References: <1413354920-20165-1-git-send-email-k.chander@samsung.com>
 <20141015090047.GA26484@red-moon>
 <20141015130218.GB20034@leverpostej>
MIME-Version: 1.0
In-Reply-To: <20141015130218.GB20034@leverpostej>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-OriginalArrivalTime: 15 Oct 2014 14:07:14.0506 (UTC) FILETIME=[523B0AA0:01CFE881]
X-MC-Unique: 114101515071605601
Content-Type: text/plain; charset=WINDOWS-1252
Content-Transfer-Encoding: 8BIT
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Oct 15, 2014 at 02:02:18PM +0100, Mark Rutland wrote:
> > > +			CPU_SLEEP: cpu-sleep {
> > > +				compatible = "arm,idle-state";
> > > +				local-timer-stop;
> > > +				arm,psci-suspend-param = <0x0010000>;
> > > +				entry-latency-us = <20>;
> > > +				exit-latency-us = <150>;
> > > +				min-residency-us = <2100>;
> > > +				status = "enabled";
> 
> While status is a relatively standard property, it's absence implies
> everything is OK. There no need for it here as-is.
> 
> Additionally, the canonical value is "okay", not "enabled", so this
> would fail were we to use of_device_is_available in the idle states
> parsing.

Good point. I still want it documented in the bindings, keeping in mind
your remark above.

> > status ? This is not a documented property. If you need it please explain
> > why, define its bindings and we can see how to accommodate it.
> 
> Do we expect that some idle states won't be available on some boards
> built from the same platform?

I think it is something we should expect and be able to cope with that.

I will add status to idle-states bindings updates for this cycle and patch DT
parsing code accordingly.

Lorenzo


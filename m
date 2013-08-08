Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965451Ab3HHOhF (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 Aug 2013 10:37:05 -0400
Received: from mail-ob0-f178.google.com ([209.85.214.178]:47946 "EHLO
	mail-ob0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S965243Ab3HHOhC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 Aug 2013 10:37:02 -0400
MIME-Version: 1.0
In-Reply-To: <1375971749.4276.61.camel@weser.hi.pengutronix.de>
References: <cover.1375886595.git.viresh.kumar@linaro.org>
	<d4cd498d9b63d761039b025216e65278dc8e0e37.1375886595.git.viresh.kumar@linaro.org>
	<52028719.8070908@wwwdotorg.org>
	<CAKohpo=MpOyMGFTGeZWmoCRwmZ7+nQtP_yCGokPanEVYL0xbMw@mail.gmail.com>
	<52029811.9080704@wwwdotorg.org>
	<1375970318.4276.52.camel@weser.hi.pengutronix.de>
	<CAKohpon=GGn5-8ucTrrf6TyPMn3+1Oh6Sd5bAj_ztpVDONZ3QA@mail.gmail.com>
	<1375971749.4276.61.camel@weser.hi.pengutronix.de>
Date: Thu, 8 Aug 2013 20:07:01 +0530
Message-ID: <CAKohpo=zYBVha_L7D+FWUEO=a6byeiuGtNBmh-CRhSmfkT=QrQ@mail.gmail.com>
Subject: Re: [PATCH 2/6] ARM: Tegra: Add CPU's OPPs for using cpufreq-cpu0 driver
From: Viresh Kumar <viresh.kumar@linaro.org>
To: Lucas Stach <l.stach@pengutronix.de>
Cc: Stephen Warren <swarren@wwwdotorg.org>,
        Mark Rutland <Mark.Rutland@arm.com>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        linaro-kernel@lists.linaro.org, swarren@nvidia.com,
        Ian Campbell <ian.campbell@citrix.com>,
        Pawel Moll <pawel.moll@arm.com>, linux-pm@vger.kernel.org,
        patches@linaro.org, linux-kernel@vger.kernel.org,
        cpufreq@vger.kernel.org, rjw@sisk.pl,
        Rob Herring <rob.herring@calxeda.com>, mturquette@linaro.org,
        linux-arm-kernel@lists.infradead.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 8 August 2013 19:52, Lucas Stach <l.stach@pengutronix.de> wrote:
> You can certainly define the mapping table in DT where a specialized
> Tegra cpufreq driver could read it in and then map frequency to voltage.
> But that's a runtime decision, as Speedo and process ID are fuse values
> and can not be represented in DT.

> The problem with this is that the hardware description now associates
> voltages with certain frequencies and even if they are not used by the
> Linux driver they are plain wrong.

Hmm. I understand.
Then we probably need mach-tegra/opp.c to call opp_add() for all such
OPPs.. Neither DT nor cpufreq driver are the right place for this.

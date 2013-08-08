Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965930Ab3HHPxR (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 Aug 2013 11:53:17 -0400
Received: from mail-wi0-f174.google.com ([209.85.212.174]:57182 "EHLO
	mail-wi0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S965376Ab3HHPw7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 Aug 2013 11:52:59 -0400
MIME-Version: 1.0
In-Reply-To: <CAKohpo=zYBVha_L7D+FWUEO=a6byeiuGtNBmh-CRhSmfkT=QrQ@mail.gmail.com>
References: <cover.1375886595.git.viresh.kumar@linaro.org>
	<d4cd498d9b63d761039b025216e65278dc8e0e37.1375886595.git.viresh.kumar@linaro.org>
	<52028719.8070908@wwwdotorg.org>
	<CAKohpo=MpOyMGFTGeZWmoCRwmZ7+nQtP_yCGokPanEVYL0xbMw@mail.gmail.com>
	<52029811.9080704@wwwdotorg.org>
	<1375970318.4276.52.camel@weser.hi.pengutronix.de>
	<CAKohpon=GGn5-8ucTrrf6TyPMn3+1Oh6Sd5bAj_ztpVDONZ3QA@mail.gmail.com>
	<1375971749.4276.61.camel@weser.hi.pengutronix.de>
	<CAKohpo=zYBVha_L7D+FWUEO=a6byeiuGtNBmh-CRhSmfkT=QrQ@mail.gmail.com>
Date: Thu, 8 Aug 2013 10:52:57 -0500
X-Google-Sender-Auth: _ew_B8FrZa-sI_14bAWtqVcNbYA
Message-ID: <CAGo_u6oArfcA3Ek_zKaWgkJm9G8U1NNGvhHSBU8Dg3L00NpGiQ@mail.gmail.com>
Subject: Re: [PATCH 2/6] ARM: Tegra: Add CPU's OPPs for using cpufreq-cpu0 driver
From: Nishanth Menon <nm@ti.com>
To: Viresh Kumar <viresh.kumar@linaro.org>
Cc: Lucas Stach <l.stach@pengutronix.de>, Mark Rutland <Mark.Rutland@arm.com>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        linaro-kernel@lists.linaro.org, swarren@nvidia.com,
        Ian Campbell <ian.campbell@citrix.com>,
        Pawel Moll <pawel.moll@arm.com>,
        Stephen Warren <swarren@wwwdotorg.org>, linux-pm@vger.kernel.org,
        linux-kernel@vger.kernel.org, cpufreq@vger.kernel.org, rjw@sisk.pl,
        Rob Herring <rob.herring@calxeda.com>, patches@linaro.org,
        mturquette@linaro.org, linux-arm-kernel@lists.infradead.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Aug 8, 2013 at 9:37 AM, Viresh Kumar <viresh.kumar@linaro.org> wrote:
> On 8 August 2013 19:52, Lucas Stach <l.stach@pengutronix.de> wrote:
>> You can certainly define the mapping table in DT where a specialized
>> Tegra cpufreq driver could read it in and then map frequency to voltage.
>> But that's a runtime decision, as Speedo and process ID are fuse values
>> and can not be represented in DT.
>
>> The problem with this is that the hardware description now associates
>> voltages with certain frequencies and even if they are not used by the
>> Linux driver they are plain wrong.
>
> Hmm. I understand.
> Then we probably need mach-tegra/opp.c to call opp_add() for all such
> OPPs.. Neither DT nor cpufreq driver are the right place for this.

This is similar to what I suspected might be the case on other
platforms (in addition to known iMx and OMAP). Could you see/comment
on [1] to see if it meets your needs.

We should like to avoid dealing custom SoC specific OPP, if we are
able to generalize the need.  ofcourse, I am yet to submit a official
proposal, but more SoCs the current proposal can handle, the better it
will be for all of us.

[1] http://marc.info/?l=linux-pm&m=137589225305971&w=2
--
Regards,
Nishanth Menon

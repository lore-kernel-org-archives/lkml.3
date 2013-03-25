Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933735Ab3CYWoX (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 Mar 2013 18:44:23 -0400
Received: from avon.wwwdotorg.org ([70.85.31.133]:39516 "EHLO
	avon.wwwdotorg.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932517Ab3CYWoV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 Mar 2013 18:44:21 -0400
Message-ID: <5150D33F.1000206@wwwdotorg.org>
Date: Mon, 25 Mar 2013 16:44:15 -0600
From: Stephen Warren <swarren@wwwdotorg.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130106 Thunderbird/17.0.2
MIME-Version: 1.0
To: Peter De Schrijver <pdeschrijver@nvidia.com>
CC: linux-arm-kernel@lists.infradead.org,
        Grant Likely <grant.likely@secretlab.ca>,
        Rob Herring <rob.herring@calxeda.com>, Rob Landley <rob@landley.net>,
        Russell King <linux@arm.linux.org.uk>,
        Prashant Gaikwad <pgaikwad@nvidia.com>, Simon Glass <sjg@chromium.org>,
        Rhyland Klein <rklein@nvidia.com>,
        Pritesh Raithatha <praithatha@nvidia.com>,
        Linus Walleij <linus.walleij@linaro.org>,
        Hiroshi Doyu <hdoyu@nvidia.com>,
        Laxman Dewangan <ldewangan@nvidia.com>, Andrew Chew <achew@nvidia.com>,
        Mike Turquette <mturquette@linaro.org>,
        Thierry Reding <thierry.reding@avionic-design.de>,
        devicetree-discuss@lists.ozlabs.org, linux-doc@vger.kernel.org,
        linux-tegra@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v8 00/14] Tegra114 clockframework
References: <1363956029-31873-1-git-send-email-pdeschrijver@nvidia.com> <514CAB71.7020005@wwwdotorg.org>
In-Reply-To: <514CAB71.7020005@wwwdotorg.org>
X-Enigmail-Version: 1.4.6
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 03/22/2013 01:05 PM, Stephen Warren wrote:
> On 03/22/2013 06:39 AM, Peter De Schrijver wrote:
>> This is the eight version of the Tegra114 clockframework. It is based on the
>> next-20130320-fixed branch of
>> git://nv-tegra.nvidia.com/user/swarren/linux-2.6.git,
> 
> Hmmm. Basing this on v3.9-rcX would be better, since when I apply it to
> the Tegra tree, that's what it will be based on. Luckily, it applies
> there with trivial conflicts.
> 
>> http://patchwork.ozlabs.org/patch/229972/ and
>> http://patchwork.ozlabs.org/patch/229978/
> 
> The series,
> 
> Tested-by: Stephen Warren <swarren@nvidia.com>
> 
> (based on my personal next-20130318-fixed branch, without
> http://patchwork.ozlabs.org/patch/229972/ applied, but instead with the
> audio clocks initialized per the patch I posted yesterday to do this).
> 
> I tested: serial console, eMMC for the root filesystem, audio playback
> using different pll_a rates, reboot, and shutdown.
> 
> This version also solves the hard hang I was seeing with V7 during
> shutdown or reboot. Now I don't have to rely on my filesystem journal:-)

Hmm. I retract that Tested-by now.

If I apply the series on top of Tegra's for-next branch (which is
currently entirely based on v3.9-rc1) then it works fine. (Similarly, it
works fine on top of next-20130318, as I reported above).

If I merge in v3.9-rc3, it's still fine. If I merge in v3.9-rc4, I see a
hard hang during boot. I believe that "hard hang" here means that some
module's registers are being touched with the clock turned off, which
locks up the CPU/bus. Certainly, sysrq doesn't work once it's hung.

I tracked this down to some interaction with commit f7db706 "ARM:
7674/1: smp: Avoid dummy clockevent being preferred over real hardware
clock-event". So says a "git bisect" between v3.9-rc3 and v3.9-rc4,
applying this CCF V8 series at each point.

If I revert that commit, the problem is solved/hidden. I tested this in
my local dev branch that's based on next-20130325 plus this CCF V8
series, plus a bunch of other cruft.

Can you please investigate what the problem is? Thanks.

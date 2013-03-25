Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758570Ab3CYQMu (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 Mar 2013 12:12:50 -0400
Received: from avon.wwwdotorg.org ([70.85.31.133]:54062 "EHLO
	avon.wwwdotorg.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932094Ab3CYQMs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 Mar 2013 12:12:48 -0400
Message-ID: <5150777B.8030304@wwwdotorg.org>
Date: Mon, 25 Mar 2013 10:12:43 -0600
From: Stephen Warren <swarren@wwwdotorg.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130106 Thunderbird/17.0.2
MIME-Version: 1.0
To: Russell King - ARM Linux <linux@arm.linux.org.uk>
CC: Peter De Schrijver <pdeschrijver@nvidia.com>,
        Prashant Gaikwad <pgaikwad@nvidia.com>,
        Mike Turquette <mturquette@linaro.org>,
        Thierry Reding <thierry.reding@avionic-design.de>,
        linux-kernel@vger.kernel.org, linux-tegra@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org
Subject: Re: [PATCH] clk: tegra: Don't enable PLLs during early boot
References: <1363953308-28828-1-git-send-email-pdeschrijver@nvidia.com> <514C7D3B.40602@wwwdotorg.org> <20130325110236.GP4977@n2100.arm.linux.org.uk>
In-Reply-To: <20130325110236.GP4977@n2100.arm.linux.org.uk>
X-Enigmail-Version: 1.4.6
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 03/25/2013 05:02 AM, Russell King - ARM Linux wrote:
> On Fri, Mar 22, 2013 at 09:48:11AM -0600, Stephen Warren wrote:
>> This assumption was made long ago. I know drivers are supposed to assume
>> that clocks are disabled when they're probed, but historically that
>> wasn't always the case, so if the audio drivers assumed that, and then
>> did clk_enable() as the first thing, they got a warning due to the
>> enabling an already enabled clock and/or later attempts to disable the
>> clocks wouldn't actually disable them.
> 
> No.  clocks have always been able to be enabled multiple times.  You
> should only get a warning if you try and disable it more times than you
> enabled it, because that's a violation of the API.

That may have been the issue; the clock may have been on at boot, and
hence the driver attempted to disable it without ever enabling it
itself, and this triggered an error/warning.

Equally, it's plausible this issue is long gone; the audio clocks were
set up this way due to issues over 2 years ago when the audio code was
upstreamed. At that time, Tegra's clock code was using very little
standard infra-structure, whereas now it's been cleaned up to use the
common clock framework etc.

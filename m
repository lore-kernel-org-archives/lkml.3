Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754461Ab3HPQsT (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 Aug 2013 12:48:19 -0400
Received: from avon.wwwdotorg.org ([70.85.31.133]:59003 "EHLO
	avon.wwwdotorg.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752765Ab3HPQsN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 Aug 2013 12:48:13 -0400
Message-ID: <520E5583.2080604@wwwdotorg.org>
Date: Fri, 16 Aug 2013 10:38:27 -0600
From: Stephen Warren <swarren@wwwdotorg.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130803 Thunderbird/17.0.8
MIME-Version: 1.0
To: Tuomas Tynkkynen <ttynkkynen@nvidia.com>
CC: mturquette@linaro.org, linux-tegra@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-usb@vger.kernel.org,
        pgaikwad@nvidia.com, pdeschrijver@nvidia.com
Subject: Re: [PATCH RESEND] clk: tegra30: Don't wait for PLL_U lock bit
References: <1376510979-21562-1-git-send-email-ttynkkynen@nvidia.com> <1376510979-21562-2-git-send-email-ttynkkynen@nvidia.com>
In-Reply-To: <1376510979-21562-2-git-send-email-ttynkkynen@nvidia.com>
X-Enigmail-Version: 1.4.6
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 08/14/2013 02:09 PM, Tuomas Tynkkynen wrote:
> The lock bit on PLL_U does not seem to be working correctly and
> sometimes never gets set when waiting for the PLL to come up.
> Remove the TEGRA_PLL_USE_LOCK flag to use a constant delay.

Tested-by: Stephen Warren <swarren@nvidia.com>
Acked-by: Stephen Warren <swarren@nvidia.com>

(Mike I assume you'll take this through the clock tree)

I do suspect there's some underlying issue that needs fixing so that
PLL_U does report lock as expected. However, this fix does enable USB to
work correctly on Tegra30 right now (so I assume it is locking, but just
isn't reporting it), and should have zero negative fallout since nothing
else uses PLL_U. I'm following up internally to work out why the PLL
isn't reporting that it's locking as expected.

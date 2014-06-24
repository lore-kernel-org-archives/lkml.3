Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932336AbaFXPxz (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Jun 2014 11:53:55 -0400
Received: from avon.wwwdotorg.org ([70.85.31.133]:40573 "EHLO
	avon.wwwdotorg.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932280AbaFXPxs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Jun 2014 11:53:48 -0400
Message-ID: <53A99F09.1070504@wwwdotorg.org>
Date: Tue, 24 Jun 2014 09:53:45 -0600
From: Stephen Warren <swarren@wwwdotorg.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.5.0
MIME-Version: 1.0
To: Alexandre Courbot <acourbot@nvidia.com>
CC: Thierry Reding <thierry.reding@gmail.com>,
        "linux-tegra@vger.kernel.org" <linux-tegra@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "gnurou@gmail.com" <gnurou@gmail.com>
Subject: Re: [PATCH 2/2] ARM: tegra: roth: enable input on mmc clock pins
References: <1403508779-25896-1-git-send-email-acourbot@nvidia.com> <1403508779-25896-3-git-send-email-acourbot@nvidia.com> <53A87979.6000104@wwwdotorg.org> <53A91026.7040506@nvidia.com>
In-Reply-To: <53A91026.7040506@nvidia.com>
X-Enigmail-Version: 1.5.2
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 06/23/2014 11:44 PM, Alexandre Courbot wrote:
> On 06/24/2014 04:01 AM, Stephen Warren wrote:
>> On 06/23/2014 01:32 AM, Alexandre Courbot wrote:
>>> Input had been disabled by mistake on these pins, leading to issues with
>>> SDIO devices like the Wifi module not being probed or random errors
>>> occuring on the SD card.
>>
>> I thought the host controller always drove the clock, so there should be
>> no need for the pin's input path to be enabled. Perhaps it depends on
>> the transfer mode (e.g. UHS)?
> 
> That's what I thought too, so I went against what was done downstream
> and disabled input mode. Eventually noticed various issues with MMC
> devices, reverted to the downstream settings and noticed my problems
> were solved by this single change.

Hmm. That's odd. Can you talk to one of the HW engineers behind the
SDHCI controller and get a definitive answer. Thanks.

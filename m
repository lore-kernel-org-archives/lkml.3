Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752004AbaFLTid (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Jun 2014 15:38:33 -0400
Received: from avon.wwwdotorg.org ([70.85.31.133]:47828 "EHLO
	avon.wwwdotorg.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751314AbaFLTib (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Jun 2014 15:38:31 -0400
Message-ID: <539A01B4.3050503@wwwdotorg.org>
Date: Thu, 12 Jun 2014 13:38:28 -0600
From: Stephen Warren <swarren@wwwdotorg.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.5.0
MIME-Version: 1.0
To: Peter De Schrijver <pdeschrijver@nvidia.com>,
        Russell King <linux@arm.linux.org.uk>,
        Paul Gortmaker <paul.gortmaker@windriver.com>
CC: Daniel Lezcano <daniel.lezcano@linaro.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Thierry Reding <thierry.reding@gmail.com>,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        linux-tegra@vger.kernel.org
Subject: Re: [PATCH 0/3] Use Tegra's microsecond counter for udelay()
References: <1402588713-18766-1-git-send-email-pdeschrijver@nvidia.com>
In-Reply-To: <1402588713-18766-1-git-send-email-pdeschrijver@nvidia.com>
X-Enigmail-Version: 1.5.2
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 06/12/2014 09:58 AM, Peter De Schrijver wrote:
> This patchset introduces support for Tegra's microsecond counter as the
> udelay() timer. This is useful on Tegra SoCs which do not have an arch timer
> such as Tegra20 and Tegra30. Using the microsecond counter instead of a delay
> based loop avoids potential problems during cpu frequency changes.
> 
> The set consists of 3 patches:
> 
> Patch 1 introduces a new call which is used by the ARM architecture delay
> timer code to prevent changing the delay timer after calibration is finished
> and thus can be in use.
> 
> Patch 2 adds logic to choose the delay timer with the highest resolution. This
> allows the same registration code to be used on all Tegra SoCs and yet use the
> higher resolution arch timer when available (eg on Tegra114 or Tegra124).
> 
> Patch 3 adds the actual delay timer code.
> 
> Patch set has been verified on ventana (Tegra20), beaver (Tegra30),
> dalmore (Tegra114) and jetson TK1 (Tegra124).

Russell, Paul, do patches 1 and 2 look good to you? If so, if you can
ack them, I'd be happy to queue this series in the Tegra git tree. If
that doesn't work for you, please let me know who will apply these
patches. Thanks.

> Changes since v1:
> * Address review comments

That's not a very useful description of the changes, and there's no "V2"
in the subject...

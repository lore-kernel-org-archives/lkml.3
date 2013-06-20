Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757998Ab3FTQYq (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Jun 2013 12:24:46 -0400
Received: from avon.wwwdotorg.org ([70.85.31.133]:47574 "EHLO
	avon.wwwdotorg.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757030Ab3FTQYn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Jun 2013 12:24:43 -0400
Message-ID: <51C32CC7.5010109@wwwdotorg.org>
Date: Thu, 20 Jun 2013 10:24:39 -0600
From: Stephen Warren <swarren@wwwdotorg.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130510 Thunderbird/17.0.6
MIME-Version: 1.0
To: Jay Agarwal <jagarwal@nvidia.com>
CC: linux@arm.linux.org.uk, thierry.reding@avionic-design.de,
        bhelgaas@google.com, ldewangan@nvidia.com, olof@lixom.net,
        hdoyu@nvidia.com, pgaikwad@nvidia.com, mturquette@linaro.org,
        pdeschrijver@nvidia.com, linux-arm-kernel@lists.infradead.org,
        linux-tegra@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-pci@vger.kernel.org, jtukkinen@nvidia.com, kthota@nvidia.com
Subject: Re: [PATCH V1] ARM: dts: tegra: Modify pcie memory space size
References: <1371712491-31070-1-git-send-email-jagarwal@nvidia.com>
In-Reply-To: <1371712491-31070-1-git-send-email-jagarwal@nvidia.com>
X-Enigmail-Version: 1.4.6
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 06/20/2013 01:14 AM, Jay Agarwal wrote:
> - decrease non-prefetch memory size to 128 MB
> - increase prefetch memory size to 384 MB
> - above change is done because most pcie devices
>   prefetch memory size requirement is quite higher
>   compared to non-prefetch memory space.

It's possible this change won't be suitable for all applications. People
may simply need to adjust their DT based on what they want to connect.
Still, this patch probably biases things in the correct way for now.
Longer term, we might want to investigate dynamically sizing the windows
in order to support arbitrary attached devices, in much the same way as
the Marvell code does/will in order to conserve physical/bus address
space for their multiple controllers.

However, this change allows me to correctly enumerate a particular GPU I
have plugged into my Harmony board, and assign all the BARs, so:

Tested-by: Stephen Warren <swarren@nvidia.com>


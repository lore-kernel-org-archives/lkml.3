Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754732Ab3KUUa0 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 Nov 2013 15:30:26 -0500
Received: from avon.wwwdotorg.org ([70.85.31.133]:60502 "EHLO
	avon.wwwdotorg.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754548Ab3KUUaU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 Nov 2013 15:30:20 -0500
Message-ID: <528E6D58.6050503@wwwdotorg.org>
Date: Thu, 21 Nov 2013 13:30:16 -0700
From: Stephen Warren <swarren@wwwdotorg.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.1.0
MIME-Version: 1.0
To: Alexandre Courbot <acourbot@nvidia.com>,
        Thierry Reding <thierry.reding@gmail.com>,
        Peter De Schrijver <pdeschrijver@nvidia.com>,
        Prashant Gaikwad <pgaikwad@nvidia.com>
CC: linux-arm-kernel@lists.infradead.org, linux-tegra@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2] ARM: tegra: switch FUSE clock on before usage
References: <1385001613-19098-1-git-send-email-acourbot@nvidia.com>
In-Reply-To: <1385001613-19098-1-git-send-email-acourbot@nvidia.com>
X-Enigmail-Version: 1.5.2
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 11/20/2013 07:40 PM, Alexandre Courbot wrote:
> FUSE clock is enabled by most bootloaders, but we cannot expect it to be
> on in all contexts (e.g. kexec).
> 
> Ensure the FUSE clock is enabled before any of its registers is touched.
> Since FUSE is touched very early during system boot (before the clock
> devices are registered), directly manipulate the clock register bit in
> case the clock device cannot be acquired.

This looks reasonable to me. I'll apply it soon after -rc1.

Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759870Ab3CHRFe (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 Mar 2013 12:05:34 -0500
Received: from avon.wwwdotorg.org ([70.85.31.133]:40239 "EHLO
	avon.wwwdotorg.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757848Ab3CHRFc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 Mar 2013 12:05:32 -0500
Message-ID: <513A1A58.9060102@wwwdotorg.org>
Date: Fri, 08 Mar 2013 10:05:28 -0700
From: Stephen Warren <swarren@wwwdotorg.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130106 Thunderbird/17.0.2
MIME-Version: 1.0
To: Laxman Dewangan <ldewangan@nvidia.com>
CC: grant.likely@secretlab.ca, broonie@opensource.wolfsonmicro.com,
        spi-devel-general@lists.sourceforge.net, linux-tegra@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] spi: slink-tegra20: move runtime pm calls to transfer_one_message
References: <1362723679-1155-1-git-send-email-ldewangan@nvidia.com>
In-Reply-To: <1362723679-1155-1-git-send-email-ldewangan@nvidia.com>
X-Enigmail-Version: 1.4.6
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 03/07/2013 11:21 PM, Laxman Dewangan wrote:
> The prepare_transfer_hardware() is called in atomic context and
> calling synchronous runtime pm calls can create scheduling deadlock.
> 
> Therefore, in place of calling runtime PM calls from prepare/unprepare
> message transfer, calling this in transfer_one_message().

Tested-by: Stephen Warren <swarren@nvidia.com>

This does fix some slightly intermittent lockups/crashes for me when
erasing and re-writing the SPI flash on Cardhu.

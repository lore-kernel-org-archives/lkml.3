Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1946889Ab3BHR6i (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 Feb 2013 12:58:38 -0500
Received: from avon.wwwdotorg.org ([70.85.31.133]:55498 "EHLO
	avon.wwwdotorg.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1946702Ab3BHR6g (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 Feb 2013 12:58:36 -0500
Message-ID: <51153CC9.4090906@wwwdotorg.org>
Date: Fri, 08 Feb 2013 10:58:33 -0700
From: Stephen Warren <swarren@wwwdotorg.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130106 Thunderbird/17.0.2
MIME-Version: 1.0
To: Hiroshi Doyu <hdoyu@nvidia.com>
CC: linux-tegra@vger.kernel.org, arnd@arndb.de,
        Russell King <linux@arm.linux.org.uk>,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 4/4] ARM: tegra: Restore USB/PCIE info in new DT board
 file
References: <1360308574-19658-1-git-send-email-hdoyu@nvidia.com> <1360308574-19658-5-git-send-email-hdoyu@nvidia.com>
In-Reply-To: <1360308574-19658-5-git-send-email-hdoyu@nvidia.com>
X-Enigmail-Version: 1.4.6
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 02/08/2013 12:29 AM, Hiroshi Doyu wrote:
> Mainly for the compatibility for the existing driver.
> This would be removed once new USB/PCIE DT supports come.

This series makes Tegra20 broken between commit 3/4 and 4/4. Why not do
the following instead:

1) Patch 1/4 as-is.

2) Rename board-dt-tegra20.c to tegra.c with no code changes to it.

3) Add Tegra30/114 compatible values into tegra.c, and delete the old
Tegra30/114-specific board files.

Fewer patches, and each patch builds and runs on all systems without any
issue.

Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932845AbaEGQjJ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 May 2014 12:39:09 -0400
Received: from avon.wwwdotorg.org ([70.85.31.133]:59037 "EHLO
	avon.wwwdotorg.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756439AbaEGQjC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 May 2014 12:39:02 -0400
Message-ID: <536A61A3.3050601@wwwdotorg.org>
Date: Wed, 07 May 2014 10:38:59 -0600
From: Stephen Warren <swarren@wwwdotorg.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.2.0
MIME-Version: 1.0
To: Christopher Freeman <cfreeman@nvidia.com>, ldewangan@nvidia.com,
        swarren@nvidia.com, vinod.koul@intel.com, dan.j.williams@intel.com
CC: dmaengine@vger.kernel.org, linux-tegra@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH v1 3/3] dma: tegra: avoid int overflow for transferred
 count
References: <1399411343-12222-1-git-send-email-cfreeman@nvidia.com> <1399411343-12222-4-git-send-email-cfreeman@nvidia.com>
In-Reply-To: <1399411343-12222-4-git-send-email-cfreeman@nvidia.com>
X-Enigmail-Version: 1.5.2
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 05/06/2014 03:22 PM, Christopher Freeman wrote:
> bytes_transferred will overflow during long audio playbacks.  Since
> the driver only ever consults this value modulo bytes_requested, store the
> value modulo bytes_requested.

The audio driver may only interpret the value modulo bytes_requested,
but what about other drivers such as the high-speed UART (and SPI?) drivers?

What is the dmaengine API's design requirement here, and what do other
dmaengine drivers do. If it's to store the modulo, then I'm fine with
this change.

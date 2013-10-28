Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754847Ab3J1IfZ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Oct 2013 04:35:25 -0400
Received: from hqemgate16.nvidia.com ([216.228.121.65]:4299 "EHLO
	hqemgate16.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750998Ab3J1IfX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Oct 2013 04:35:23 -0400
X-PGP-Universal: processed;
	by hqnvupgp08.nvidia.com on Mon, 28 Oct 2013 01:30:28 -0700
Message-ID: <526E2233.3020304@nvidia.com>
Date: Mon, 28 Oct 2013 10:37:07 +0200
From: =?ISO-8859-1?Q?Terje_Bergstr=F6m?= <tbergstrom@nvidia.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.0
MIME-Version: 1.0
To: Arto Merilainen <amerilainen@nvidia.com>,
        "thierry.reding@gmail.com" <thierry.reding@gmail.com>
CC: "dri-devel@lists.freedesktop.org" <dri-devel@lists.freedesktop.org>,
        "linux-tegra@vger.kernel.org" <linux-tegra@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCHv2 0/4] gpu: host1x: Add syncpoint base support
References: <1381753315-21778-1-git-send-email-amerilainen@nvidia.com>
In-Reply-To: <1381753315-21778-1-git-send-email-amerilainen@nvidia.com>
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 14.10.2013 15:21, Arto Merilainen wrote:
> The host1x driver uses currently syncpoints statically from host1x point of
> view. If we do a wait inside a job, it always has a constant value to wait.
> host1x supports also doing relative syncpoint waits with respect to syncpoint
> bases. This allows doing multiple operations inside a single submit and
> waiting an operation to complete before moving to next one.
> 
> This set of patches adds support for syncpoint bases to host1x driver and
> enables the support for gr2d client.
> 
> I have tested the series using the host1x test application (available at [0],
> function test_wait_base() in tests/tegra/host1x/tegra_host1x_test.c) on cardhu.
> I would appreciate help in reviewing the series and testing the patches
> on other boards.
> 
> Changes in v2:
> - Reordered various code blocks to improve code consistency
> - Functions host1x_syncpt_alloc() and host1x_syncpt_request() take now a single
> bitfield argument instead of separate boolean arguments
> - Added a separate ioctl call for querying the base associated with some
> syncpoint
> 
> [0] https://gitorious.org/linux-host1x/libdrm-host1x
> 
> Arto Merilainen (4):
>   gpu: host1x: Add 'flags' field to syncpt request
>   gpu: host1x: Add syncpoint base support
>   drm/tegra: Deliver syncpoint base to user space
>   drm/tegra: Reserve base for gr2d
> 
>  drivers/gpu/host1x/dev.h                   |  2 ++
>  drivers/gpu/host1x/drm/drm.c               | 25 +++++++++++++
>  drivers/gpu/host1x/drm/gr2d.c              |  2 +-
>  drivers/gpu/host1x/hw/channel_hw.c         | 19 ++++++++++
>  drivers/gpu/host1x/hw/hw_host1x01_uclass.h |  6 ++++
>  drivers/gpu/host1x/syncpt.c                | 58 +++++++++++++++++++++++++-----
>  drivers/gpu/host1x/syncpt.h                | 10 +++++-
>  include/uapi/drm/tegra_drm.h               | 26 +++++++++-----
>  8 files changed, 128 insertions(+), 20 deletions(-)
> 

The series,

Reviewed-by: Terje Bergstrom <tbergstrom@nvidia.com>

Terje

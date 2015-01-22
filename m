Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754665AbbAVVxP (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 Jan 2015 16:53:15 -0500
Received: from arroyo.ext.ti.com ([192.94.94.40]:48469 "EHLO arroyo.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753289AbbAVVxM (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 Jan 2015 16:53:12 -0500
Message-ID: <54C17130.5060002@ti.com>
Date: Thu, 22 Jan 2015 15:52:48 -0600
From: Suman Anna <s-anna@ti.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Thunderbird/31.4.0
MIME-Version: 1.0
To: Ohad Ben-Cohen <ohad@wizery.com>
CC: Dave Gerlach <d-gerlach@ti.com>, Robert Tivy <rtivy@ti.com>,
        <linux-kernel@vger.kernel.org>, <linux-omap@vger.kernel.org>,
        <linux-arm-kernel@lists.infradead.org>
Subject: Re: [PATCH v3 0/2] couple of generic remoteproc enhancements
References: <1420838519-15669-1-git-send-email-s-anna@ti.com>
In-Reply-To: <1420838519-15669-1-git-send-email-s-anna@ti.com>
Content-Type: text/plain; charset="windows-1252"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Ohad,

On 01/09/2015 03:21 PM, Suman Anna wrote:
> Hi Ohad,
> 
> The following is an updated patchset addressing the previous pending comments
> from v1 & v2, and are rebased onto the latest 3.19-rc3 (are rc independent
> actually). 
> 
> The patches are mainly developed to support the WkupM3 remote processor driver
> on TI AM335x/AM437x SoCs, and I have verified the loading using the latest
> version of Dave's WkupM3 remoteproc work [1]
> 
> The only change in v3 is on the second patch, it mainly leverages the
> memcpy_toio and memset_io functions for copying/loading code into the
> internal memory sections. An additional argument has to be added to the
> rproc_da_to_va function to make this distinction.

Any comments on this series, or can I assume that this will make it to
v3.20?

regards
Suman

> 
> [1] http://marc.info/?l=linux-omap&m=142022842323885&w=2
> 
> v2:
> http://marc.info/?l=linux-omap&m=141089879412807&w=2
> - Add explicit setting of the .has_iommu field in each of the existing
>   remoteproc platform drivers
> - Update patch description to add the usecase details for the change
>   summary
> - Fixed a minor checkpatch warning.
> 
> v1:
> http://marc.info/?l=linux-omap&m=140483657604924&w=2
> 
> Suman Anna (2):
>   remoteproc: use a flag to detect the presence of IOMMU
>   remoteproc: add support to handle internal memories
> 
>  drivers/remoteproc/da8xx_remoteproc.c      |   1 +
>  drivers/remoteproc/omap_remoteproc.c       |   5 ++
>  drivers/remoteproc/remoteproc_core.c       | 104 ++++++++++++++++++++++++-----
>  drivers/remoteproc/remoteproc_elf_loader.c |  23 +++++--
>  drivers/remoteproc/remoteproc_internal.h   |   6 +-
>  drivers/remoteproc/ste_modem_rproc.c       |   1 +
>  include/linux/remoteproc.h                 |  45 ++++++++++++-
>  7 files changed, 161 insertions(+), 24 deletions(-)
> 


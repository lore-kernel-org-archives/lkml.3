Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753621AbbAUM75 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 Jan 2015 07:59:57 -0500
Received: from mail-qc0-f177.google.com ([209.85.216.177]:38847 "EHLO
	mail-qc0-f177.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752609AbbAUM7r (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 Jan 2015 07:59:47 -0500
MIME-Version: 1.0
In-Reply-To: <cover.1421204431.git.micky_ching@realsil.com.cn>
References: <cover.1421204431.git.micky_ching@realsil.com.cn>
Date: Wed, 21 Jan 2015 13:59:46 +0100
Message-ID: <CAPDyKFqH3HLccQhiLC9PSZLf1ZfbBnmtSUt-W2J7QO=Fw4JiRw@mail.gmail.com>
Subject: Re: [PATCH 0/2] mmc: rtsx: add check before sending request
From: Ulf Hansson <ulf.hansson@linaro.org>
To: micky <micky_ching@realsil.com.cn>
Cc: Chris Ball <chris@printf.net>, Samuel Ortiz <sameo@linux.intel.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Dan Carpenter <dan.carpenter@oracle.com>,
        "driverdev-devel@linuxdriverproject.org" 
	<devel@linuxdriverproject.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        linux-mmc <linux-mmc@vger.kernel.org>, Roger <rogerable@realtek.com>,
        Wei WANG <wei_wang@realsil.com.cn>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 14 January 2015 at 04:09,  <micky_ching@realsil.com.cn> wrote:
> From: Micky Ching <micky_ching@realsil.com.cn>
>
> Add check before sending request can make request return faster.
> - finish request if no card exist
>   This can make request finish faster, especial for some sdio card,
>   when card removed, there still a lot of command pending,
>   if we check card exist and stop request, the card will disappear
>   faster in user space.
>
> - check sg_count before long data xfer
>   modify sg_count type unsigned -> int, because dma_map_sg() return
>   int, and this value can be negative to indicate some error occurs.
>
> Micky Ching (2):
>   mmc: rtsx: finish request if no card exist
>   mmc: rtsx: check sg_count before long data xfer
>
>  drivers/mmc/host/rtsx_pci_sdmmc.c | 20 ++++++++++++++++----
>  1 file changed, 16 insertions(+), 4 deletions(-)
>
> --
> 1.9.1
>

Thanks! Applied for next.

Kind regards
Uffe

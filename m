Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755562Ab3BDTh4 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 Feb 2013 14:37:56 -0500
Received: from filtteri2.pp.htv.fi ([213.243.153.185]:48418 "EHLO
	filtteri2.pp.htv.fi" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754782Ab3BDThz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 Feb 2013 14:37:55 -0500
Date: Mon, 4 Feb 2013 21:37:49 +0200
From: Aaro Koskinen <aaro.koskinen@iki.fi>
To: Peter Huewe <peterhuewe@gmx.de>
Cc: Arnaud Patard <arnaud.patard@rtp-net.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Miguel =?iso-8859-1?Q?G=F3mez?= <magomez@igalia.com>,
        Sam Hansen <solid.se7en@gmail.com>, devel@driverdev.osuosl.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 01/10] staging/xgifb: Simplify XGI_GetRatePtrCRT2
Message-ID: <20130204193749.GA27411@blackmetal.musicnaut.iki.fi>
References: <1359928479-8484-1-git-send-email-peterhuewe@gmx.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1359928479-8484-1-git-send-email-peterhuewe@gmx.de>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

On Sun, Feb 03, 2013 at 10:54:30PM +0100, Peter Huewe wrote:
> Since the smaller LCDRefreshIndex is contained identically in LCDARefreshIndex
> we can simply use LCDARefreshIndex and skip the if/else.
> 
> Since LCDARefreshIndex is only used readonly and contains only small
> unsigned values we also change its declaration to const u8.
> 
> In order to prevent an out-of-bounds access I changed the mask from 0x0F
> to 0x07 and added a dummy value.
> 
> Signed-off-by: Peter Huewe <peterhuewe@gmx.de>
> ---
> Please apply this series after my previous one 
>  [PATCH 1/6] staging/xgifb: Remove unused variables and dead assignments
>  [PATCH 2/6] staging/xgifb: Remove unused variable
>  [PATCH 3/6] staging/xgifb: Remove unused variable and dead assignment
>  [PATCH 4/6] staging/xgifb: Remove unused variables
>  [PATCH 5/6] staging/xgifb: Remove redundant if statement
>  [PATCH 6/6] staging/xgifb: remove unused variables

I think both of these series are good. I boot tested them with Z9/XG21,
and at least fb console seems to work fine. I also checked compilation
for warnings with GCC+sparse and could not see any. So:

Tested-by: Aaro Koskinen <aaro.koskinen@iki.fi>

for all of the patches.

Thanks,

A.

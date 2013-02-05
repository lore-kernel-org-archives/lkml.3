Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756645Ab3BETQM (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Feb 2013 14:16:12 -0500
Received: from mail-da0-f42.google.com ([209.85.210.42]:61500 "EHLO
	mail-da0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756280Ab3BETQH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Feb 2013 14:16:07 -0500
Date: Tue, 5 Feb 2013 11:18:02 -0800
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: Peter Huewe <peterhuewe@gmx.de>
Cc: Arnaud Patard <arnaud.patard@rtp-net.org>,
        Miguel =?iso-8859-1?Q?G=F3mez?= <magomez@igalia.com>,
        Aaro Koskinen <aaro.koskinen@iki.fi>,
        Sam Hansen <solid.se7en@gmail.com>, devel@driverdev.osuosl.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/5] staging/xgifb: Replace XGI340_CR6B table with simple
 if/else
Message-ID: <20130205191802.GA24182@kroah.com>
References: <1360020587-8399-1-git-send-email-peterhuewe@gmx.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <1360020587-8399-1-git-send-email-peterhuewe@gmx.de>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Feb 05, 2013 at 12:29:43AM +0100, Peter Huewe wrote:
> The XGI340_CR6B lookup table consists of the entries
> {0xaa, 0xaa, 0xaa, 0xaa} for an index <= 2 and
> {0x00, 0x00, 0x00, 0x00} for all other indices.
> 
> The only user XGINew_SetDRAMDefaultRegister340 loops over these 4 values
> of a line with a for loop and since all entries are the same for each line
> we can simply replace the whole lookup table with a simple if/else assignment.
> 
> Tested-by: Aaro Koskinen <aaro.koskinen@iki.fi>
> Signed-off-by: Peter Huewe <peterhuewe@gmx.de>
> ---
>  drivers/staging/xgifb/vb_init.c  |    2 +-
>  drivers/staging/xgifb/vb_table.h |   11 -----------
>  2 files changed, 1 insertions(+), 12 deletions(-)

With this series applied, I now get the following warning when building:

driverrs/staging/xgifb/vb_init.c: In function ‘XGINew_SetDRAMDefaultRegister340’:
drivers/staging/xgifb/vb_init.c:433:43: warning: unused variable ‘i’ [-Wunused-variable]

Care to send a follow-on patch to fix this up?

thanks,

greg k-h

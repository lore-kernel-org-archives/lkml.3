Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754106AbaIHTuf (ORCPT <rfc822;w@1wt.eu>);
	Mon, 8 Sep 2014 15:50:35 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:34542 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752665AbaIHTud (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 8 Sep 2014 15:50:33 -0400
Date: Mon, 8 Sep 2014 12:50:33 -0700
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: Julia Lawall <Julia.Lawall@lip6.fr>
Cc: devel@driverdev.osuosl.org, "Dilger, Andreas" <andreas.dilger@intel.com>,
        Peng Tao <bergwolf@gmail.com>, kernel-janitors@vger.kernel.org,
        linux-kernel@vger.kernel.org, "Drokin, Oleg" <oleg.drokin@intel.com>
Subject: Re: [PATCH 3/7] staging: lustre: lov: expand the GOTO macro
Message-ID: <20140908195033.GA7006@kroah.com>
References: <1410106715-9573-3-git-send-email-Julia.Lawall@lip6.fr>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1410106715-9573-3-git-send-email-Julia.Lawall@lip6.fr>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Sep 07, 2014 at 06:18:31PM +0200, Julia Lawall wrote:
> From: Julia Lawall <Julia.Lawall@lip6.fr>
> 
> The semantic patch that makes this change is as follows:
> (http://coccinelle.lip6.fr/)
> 
> // <smpl>
> @@
> identifier lbl;
> identifier rc;
> constant c;
> @@
> 
> - GOTO(lbl,\(rc\|c\));
> + goto lbl;
> 
> @@
> identifier lbl;
> expression rc;
> @@
> 
> - GOTO(lbl,rc);
> + rc;
> + goto lbl;
> // </smpl>
> 
> Signed-off-by: Julia Lawall <Julia.Lawall@lip6.fr>
> 
> ---
>  drivers/staging/lustre/lustre/lov/lov_obd.c     |  154 ++++++++++------
>  drivers/staging/lustre/lustre/lov/lov_object.c  |   13 -
>  drivers/staging/lustre/lustre/lov/lov_pack.c    |   23 +-
>  drivers/staging/lustre/lustre/lov/lov_page.c    |   12 -
>  drivers/staging/lustre/lustre/lov/lov_pool.c    |   38 ++--
>  drivers/staging/lustre/lustre/lov/lov_request.c |  226 +++++++++++++++---------
>  6 files changed, 304 insertions(+), 162 deletions(-)

There were some patches ahead of yours in this area that prevented this
patch from applying.

Can you refresh this against my latest tree (staging-next branch of
staging.git on git.kernel.org) and resend?

thanks,

greg k-h

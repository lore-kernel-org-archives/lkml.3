Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752331AbaKERyU (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Nov 2014 12:54:20 -0500
Received: from casper.infradead.org ([85.118.1.10]:47246 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751070AbaKERyT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Nov 2014 12:54:19 -0500
Message-ID: <1415210053.12884.11.camel@smoke>
Subject: Re: [PATCH] [SCSI] ps3rom: fix error return code
From: Geoff Levand <geoff@infradead.org>
To: JBottomley@parallels.com
Cc: Michael Ellerman <mpe@ellerman.id.au>, linux-kernel@vger.kernel.org,
        trivial@kernel.org
Date: Wed, 05 Nov 2014 09:54:13 -0800
In-Reply-To: <1415182270-25237-1-git-send-email-mpe@ellerman.id.au>
References: <1415182270-25237-1-git-send-email-mpe@ellerman.id.au>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.10.4-0ubuntu2 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2014-11-05 at 21:11 +1100, Michael Ellerman wrote:
> From: Julia Lawall <Julia.Lawall@lip6.fr>
> 
> Set the return variable to an error code as done elsewhere in the function.
> 
> Signed-off-by: Julia Lawall <Julia.Lawall@lip6.fr>
> Signed-off-by: Michael Ellerman <mpe@ellerman.id.au>
> ---
>  drivers/scsi/ps3rom.c | 1 +
>  1 file changed, 1 insertion(+)
> 
> diff --git a/drivers/scsi/ps3rom.c b/drivers/scsi/ps3rom.c
> index ef23fabe3924..619caf1acc9c 100644
> --- a/drivers/scsi/ps3rom.c
> +++ b/drivers/scsi/ps3rom.c
> @@ -387,6 +387,7 @@ static int ps3rom_probe(struct ps3_system_bus_device *_dev)
>  	if (!host) {
>  		dev_err(&dev->sbd.core, "%s:%u: scsi_host_alloc failed\n",
>  			__func__, __LINE__);
> +		error = -ENOMEM;
>  		goto fail_teardown;
>  	}
>  

Looks OK.  James, please apply.

Acked-By: Geoff Levand <geoff@infradead.org>


Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752233Ab3J2SxJ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Oct 2013 14:53:09 -0400
Received: from mail-qa0-f46.google.com ([209.85.216.46]:62026 "EHLO
	mail-qa0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751337Ab3J2SxH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Oct 2013 14:53:07 -0400
Date: Tue, 29 Oct 2013 14:53:02 -0400
From: Tejun Heo <tj@kernel.org>
To: Levente Kurusa <levex@linux.com>
Cc: Linux IDE/ATA Dev <linux-ide@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH trivial] ata: libata-eh: Remove unnecessary snprintf
 arithmetic
Message-ID: <20131029185302.GA22261@mtj.dyndns.org>
References: <527000AE.8060506@linux.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <527000AE.8060506@linux.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

On Tue, Oct 29, 2013 at 07:38:38PM +0100, Levente Kurusa wrote:
> Remove an unnecessary arithmetic operation from a call to snprintf, because
> the size parameter of snprintf includes the trailing null byte.
> 
> Signed-off-by: Levente Kurusa <levex@linux.com>
> ---
> diff --git a/drivers/ata/libata-eh.c b/drivers/ata/libata-eh.c
> index f9476fb..b7c4146 100644
> --- a/drivers/ata/libata-eh.c
> +++ b/drivers/ata/libata-eh.c
> @@ -2427,7 +2434,7 @@ static void ata_eh_link_report(struct ata_link *link)
> 
>  	memset(tries_buf, 0, sizeof(tries_buf));

While at it, can you please remove the above and just initialize the
buffer to "" on definition?

Thanks.

-- 
tejun

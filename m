Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752573AbaESBNW (ORCPT <rfc822;w@1wt.eu>);
	Sun, 18 May 2014 21:13:22 -0400
Received: from shards.monkeyblade.net ([149.20.54.216]:44279 "EHLO
	shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752447AbaESBNV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 18 May 2014 21:13:21 -0400
Date: Sun, 18 May 2014 21:13:19 -0400 (EDT)
Message-Id: <20140518.211319.776876380782689458.davem@davemloft.net>
To: rickard_strandqvist@spectrumdigital.se
Cc: isdn@linux-pingi.de, netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] isdn: hisax: l3ni1.c: Fix for possible null pointer
 dereference
From: David Miller <davem@davemloft.net>
In-Reply-To: <1400347180-25553-1-git-send-email-rickard_strandqvist@spectrumdigital.se>
References: <1400347180-25553-1-git-send-email-rickard_strandqvist@spectrumdigital.se>
X-Mailer: Mew version 6.5 on Emacs 24.3 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.7 (shards.monkeyblade.net [149.20.54.216]); Sun, 18 May 2014 18:13:20 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Rickard Strandqvist <rickard_strandqvist@spectrumdigital.se>
Date: Sat, 17 May 2014 19:19:40 +0200

> @@ -2064,8 +2064,12 @@ static int l3ni1_cmd_global(struct PStack *st, isdn_ctrl *ic)
>  				{ free_invoke_id(st, id);
>  					return (-2);
>  				}
> -			pc->prot.ni1.ll_id = ic->parm.ni1_io.ll_id; /* remember id */
> -			pc->prot.ni1.proc = ic->parm.ni1_io.proc; /* and procedure */
> +
> +			if (pc)
> +			{
> +				pc->prot.ni1.ll_id = ic->parm.ni1_io.ll_id; /* remember id */
> +				pc->prot.ni1.proc = ic->parm.ni1_io.proc; /* and procedure */
> +			}

Like I said for your other patch, you should fix this by putting these
assignments in the timeout > 0 code block.

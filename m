Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752507AbaESBMl (ORCPT <rfc822;w@1wt.eu>);
	Sun, 18 May 2014 21:12:41 -0400
Received: from shards.monkeyblade.net ([149.20.54.216]:44272 "EHLO
	shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752461AbaESBMj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 18 May 2014 21:12:39 -0400
Date: Sun, 18 May 2014 21:12:37 -0400 (EDT)
Message-Id: <20140518.211237.1637671513066247487.davem@davemloft.net>
To: rickard_strandqvist@spectrumdigital.se
Cc: isdn@linux-pingi.de, netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] isdn: hisax: l3dss1.c: Fix for possible null pointer
 dereference
From: David Miller <davem@davemloft.net>
In-Reply-To: <1400347101-25476-1-git-send-email-rickard_strandqvist@spectrumdigital.se>
References: <1400347101-25476-1-git-send-email-rickard_strandqvist@spectrumdigital.se>
X-Mailer: Mew version 6.5 on Emacs 24.3 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.7 (shards.monkeyblade.net [149.20.54.216]); Sun, 18 May 2014 18:12:39 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Rickard Strandqvist <rickard_strandqvist@spectrumdigital.se>
Date: Sat, 17 May 2014 19:18:21 +0200

> There is otherwise a risk of a possible null pointer dereference.
> 
> Was largely found by using a static code analysis program called cppcheck.
> 
> Signed-off-by: Rickard Strandqvist <rickard_strandqvist@spectrumdigital.se>
 ...

> @@ -2208,8 +2208,12 @@ static int l3dss1_cmd_global(struct PStack *st, isdn_ctrl *ic)
>  				{ free_invoke_id(st, id);
>  					return (-2);
>  				}
> -			pc->prot.dss1.ll_id = ic->parm.dss1_io.ll_id; /* remember id */
> -			pc->prot.dss1.proc = ic->parm.dss1_io.proc; /* and procedure */
> +
> +			if (pc)
> +			{
> +				pc->prot.dss1.ll_id = ic->parm.dss1_io.ll_id; /* remember id */
> +				pc->prot.dss1.proc = ic->parm.dss1_io.proc; /* and procedure */
> +			}

I think rather the intention was to put these pc-> assignments in the
timeout > 0 code block.

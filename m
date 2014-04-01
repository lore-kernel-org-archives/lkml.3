Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753364AbaDAL3D (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 Apr 2014 07:29:03 -0400
Received: from 94.43.138.210.xn.2iij.net ([210.138.43.94]:35958 "EHLO
	mail.st-paulia.net" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1753333AbaDAL3A (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 Apr 2014 07:29:00 -0400
X-Greylist: delayed 313 seconds by postgrey-1.27 at vger.kernel.org; Tue, 01 Apr 2014 07:29:00 EDT
Message-ID: <533AA1C0.8030609@yoshifuji.org>
Date: Tue, 01 Apr 2014 20:23:44 +0900
From: YOSHIFUJI Hideaki <hideaki@yoshifuji.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.4.0
MIME-Version: 1.0
To: Vegard Nossum <vegard.nossum@oracle.com>, netdev@vger.kernel.org
CC: linux-kernel@vger.kernel.org, Dan Carpenter <dan.carpenter@oracle.com>,
        "David S. Miller" <davem@davemloft.net>, stable@vger.kernel.org,
        YOSHIFUJI Hideaki <yoshfuji@linux-ipv6.org>
Subject: Re: [PATCH] isdnloop: NUL-terminate strings from userspace
References: <1396346898-8950-1-git-send-email-vegard.nossum@oracle.com>
In-Reply-To: <1396346898-8950-1-git-send-email-vegard.nossum@oracle.com>
X-Enigmail-Version: 1.6
Content-Type: text/plain; charset=ISO-2022-JP
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Vegard Nossum wrote:
> Both the in-kernel and BSD strlcpy() require that the source string is
> NUL terminated. We could use strncpy() + explicitly terminate the result,
> but this relies on src and dest having the same size, so the safest thing
> to do seems to explicitly terminate the source string before doing the
> strlcpy().
:
> diff --git a/drivers/isdn/isdnloop/isdnloop.c b/drivers/isdn/isdnloop/isdnloop.c
> index 02125e6..50cd348 100644
> --- a/drivers/isdn/isdnloop/isdnloop.c
> +++ b/drivers/isdn/isdnloop/isdnloop.c
> @@ -1070,6 +1070,14 @@ isdnloop_start(isdnloop_card *card, isdnloop_sdef *sdefp)
>  		return -EBUSY;
>  	if (copy_from_user((char *) &sdef, (char *) sdefp, sizeof(sdef)))
>  		return -EFAULT;
> +
> +	/*
> +	 * Null terminate strings from userspace so we don't have to worry
> +	 * about this later on.
> +	 */
> +	for (i = 0; i < 3; i++)
> +		sdef.num[i][sizeof(sdef.num[0]) - 1] = '\0';
> +

Why don't we return -EINVAL if it is not correctly terminated by NUL?

--yoshfuji


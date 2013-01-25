Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757634Ab3AYRzZ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 Jan 2013 12:55:25 -0500
Received: from smtp.eu.citrix.com ([46.33.159.39]:43832 "EHLO
	SMTP.EU.CITRIX.COM" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756392Ab3AYRzU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 Jan 2013 12:55:20 -0500
X-Greylist: delayed 588 seconds by postgrey-1.27 at vger.kernel.org; Fri, 25 Jan 2013 12:55:20 EST
X-IronPort-AV: E=Sophos;i="4.84,540,1355097600"; 
   d="scan'208";a="898572"
Message-ID: <5102C4B9.8050801@citrix.com>
Date: Fri, 25 Jan 2013 18:45:29 +0100
From: =?ISO-8859-1?Q?Roger_Pau_Monn=E9?= <roger.pau@citrix.com>
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.7; rv:17.0) Gecko/20130107 Thunderbird/17.0.2
MIME-Version: 1.0
To: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
CC: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "xen-devel@lists.xensource.com" <xen-devel@lists.xensource.com>,
        Konrad Rzeszutek Wilk <konrad@kernel.org>,
        "stable@vger.kernel.org" <stable@vger.kernel.org>
Subject: Re: [Xen-devel] [PATCH 2/3] xen/ring: Add a new macro to detect whether
 there is an overflow in requests and response.
References: <1359135152-30688-1-git-send-email-konrad.wilk@oracle.com> <1359135152-30688-3-git-send-email-konrad.wilk@oracle.com>
In-Reply-To: <1359135152-30688-3-git-send-email-konrad.wilk@oracle.com>
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 25/01/13 18:32, Konrad Rzeszutek Wilk wrote:
> We want to be able to exit if the difference between the request
> produced (what the frontend tells us) and the requests consumed
> (what we have so far processed) is greater than the ring size.
> 
> If so, we should terminate the loop as the request produced
> is not trusted and it means it is bogus.
> 
> Cc: stable@vger.kernel.org
> Signed-off-by: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
> ---
>  include/xen/interface/io/ring.h | 6 ++++++
>  1 file changed, 6 insertions(+)
> 
> diff --git a/include/xen/interface/io/ring.h b/include/xen/interface/io/ring.h
> index 75271b9..1114dde 100644
> --- a/include/xen/interface/io/ring.h
> +++ b/include/xen/interface/io/ring.h
> @@ -188,6 +188,12 @@ struct __name##_back_ring {						\
>  #define RING_REQUEST_CONS_OVERFLOW(_r, _cons)				\
>      (((_cons) - (_r)->rsp_prod_pvt) >= RING_SIZE(_r))
>  
> +/* Loop termination condition: Is the difference between request produced
> + * and request consumed greater than the ring size. If so, terminate the
> + * loop. */
> +#define RING_REQUEST_PROD_OVERFLOW(_r, _cons, _prod)                     \
> +    (((_prod) - (_prod)) > RING_SIZE(_r))

Shouldn't the second _prod be _cons?

> +
>  #define RING_PUSH_REQUESTS(_r) do {					\
>      wmb(); /* back sees requests /before/ updated producer index */	\
>      (_r)->sring->req_prod = (_r)->req_prod_pvt;				\
> 


Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755757AbaGIPAy (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Jul 2014 11:00:54 -0400
Received: from smtp.citrix.com ([66.165.176.89]:6290 "EHLO SMTP.CITRIX.COM"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755658AbaGIPAw (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Jul 2014 11:00:52 -0400
X-IronPort-AV: E=Sophos;i="5.01,631,1400025600"; 
   d="scan'208";a="150988633"
Message-ID: <53BD5921.4050405@citrix.com>
Date: Wed, 9 Jul 2014 16:00:49 +0100
From: Zoltan Kiss <zoltan.kiss@citrix.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.6.0
MIME-Version: 1.0
To: Joe Perches <joe@perches.com>, Andy Whitcroft <apw@canonical.com>
CC: David Miller <davem@davemloft.net>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: checkpatch minor issue
References: <20140708.112838.2087453949565741801.davem@davemloft.net>
In-Reply-To: <20140708.112838.2087453949565741801.davem@davemloft.net>
X-Forwarded-Message-Id: <20140708.112838.2087453949565741801.davem@davemloft.net>
Content-Type: text/plain; charset="ISO-8859-1"; format=flowed
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.80.2.133]
X-DLP: MIA1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

In one of my posted patch David spotted an indentation error, I thought 
these trivial mistakes are catched by checkpatch. Maybe it shouldn't, 
but otherwise you should check this issue, see it in the mail below.

Regards,

Zoli

-------- Original Message --------
Subject: Re: [PATCH net-next 1/3 v4] pktgen: Fill the payload optionally 
with a pattern
Date: Tue, 8 Jul 2014 11:28:38 -0700
From: David Miller <davem@davemloft.net>
To: <zoltan.kiss@citrix.com>
CC: <steffen.klassert@secunet.com>, <minipli@googlemail.com>, 
<dborkman@redhat.com>, <tgraf@suug.ch>, <joe@perches.com>, 
<netdev@vger.kernel.org>, <linux-kernel@vger.kernel.org>, 
<xen-devel@lists.xenproject.org>

From: Zoltan Kiss <zoltan.kiss@citrix.com>
Date: Wed, 2 Jul 2014 20:54:13 +0100

> @@ -1129,11 +1133,13 @@ static ssize_t pktgen_if_write(struct file *file,
>  		i += len;
>
>  		if (node_possible(value)) {
> +			int j;
>  			pkt_dev->node = value;
>  			sprintf(pg_result, "OK: node=%d", pkt_dev->node);
> -			if (pkt_dev->page) {
> -				put_page(pkt_dev->page);
> -				pkt_dev->page = NULL;
> +			for (j = 0; j < MAX_SKB_FRAGS; ++j)
> +				if (pkt_dev->pages[j]) {
> +					put_page(pkt_dev->pages[j]);
> +					pkt_dev->pages[j] = NULL;
>  			}
>  		}

I'm scratching my head with the bracing created here, and it's because
the indentation is wrong:

	for () /* <-- no openning curly brace */
		if () {
			x;
			y;
	} /* <-- thus, wrong indentation */

Please resubmit this series with this fixed and #3 adjusted as per the
feedback you've received.

Thanks.
--
To unsubscribe from this list: send the line "unsubscribe netdev" in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html



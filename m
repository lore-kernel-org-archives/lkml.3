Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965021AbaD3Svb (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Apr 2014 14:51:31 -0400
Received: from userp1040.oracle.com ([156.151.31.81]:32446 "EHLO
	userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751498AbaD3Sva (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Apr 2014 14:51:30 -0400
Date: Wed, 30 Apr 2014 21:51:17 +0300
From: Dan Carpenter <dan.carpenter@oracle.com>
To: "K. Y. Srinivasan" <kys@microsoft.com>
Cc: davem@davemloft.net, netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        devel@linuxdriverproject.org, olaf@aepfle.de, apw@canonical.com,
        jasowang@redhat.com
Subject: Re: [PATCH V1 net-next 1/1] hyperv: Enable sendbuf mechanism on the
 send path
Message-ID: <20140430185116.GH26890@mwanda>
References: <1398878071-21307-1-git-send-email-kys@microsoft.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1398878071-21307-1-git-send-email-kys@microsoft.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Source-IP: ucsinet21.oracle.com [156.151.31.93]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Apr 30, 2014 at 10:14:31AM -0700, K. Y. Srinivasan wrote:
> +	/* Setup state for managing the send buffer. */
> +	net_device->map_words = DIV_ROUND_UP(net_device->send_section_cnt,
> +					     BITS_PER_LONG);
> +
> +	net_device->send_section_map =
> +		kzalloc(net_device->map_words * sizeof(ulong), GFP_KERNEL);
> +	if (net_device->send_section_map == NULL)
> +		goto cleanup;

I told you about this returning success bug if kmalloc() fails but you
didn't fix it.

> +
>  	goto exit;
>  
>  cleanup:
> -	netvsc_destroy_recv_buf(net_device);
> +	netvsc_destroy_buf(net_device);
>  
>  exit:
>  	return ret;

regards,
dan carpenter

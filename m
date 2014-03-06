Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753033AbaCFThW (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Mar 2014 14:37:22 -0500
Received: from aserp1040.oracle.com ([141.146.126.69]:22132 "EHLO
	aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751015AbaCFThU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Mar 2014 14:37:20 -0500
Date: Thu, 6 Mar 2014 22:36:55 +0300
From: Dan Carpenter <dan.carpenter@oracle.com>
To: "K. Y. Srinivasan" <kys@microsoft.com>
Cc: davem@davemloft.net, netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        devel@linuxdriverproject.org, olaf@aepfle.de, apw@canonical.com,
        jasowang@redhat.com
Subject: Re: [PATCH 3/6] Drivers: net: hyperv: Enable offloads on the host
Message-ID: <20140306193655.GL26722@mwanda>
References: <1394104358-23438-1-git-send-email-kys@microsoft.com>
 <1394104390-23477-1-git-send-email-kys@microsoft.com>
 <1394104390-23477-3-git-send-email-kys@microsoft.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1394104390-23477-3-git-send-email-kys@microsoft.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Source-IP: ucsinet21.oracle.com [156.151.31.93]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Mar 06, 2014 at 03:13:07AM -0800, K. Y. Srinivasan wrote:
> +	offload_params = (struct ndis_offload_params *)((ulong)set +
> +				set->info_buf_offset);

It's a bit simpler to do pointer math like this:

	offload_params = (void *)set + set->info_buf_offset;

regards,
dan carpenter


Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755321Ab3EURdn (ORCPT <rfc822;w@1wt.eu>);
	Tue, 21 May 2013 13:33:43 -0400
Received: from webmail.solarflare.com ([12.187.104.25]:60153 "EHLO
	webmail.solarflare.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754929Ab3EURdl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 21 May 2013 13:33:41 -0400
Message-ID: <1369157617.2615.32.camel@bwh-desktop.uk.solarflarecom.com>
Subject: Re: [PATCH v4 net-next 3/4] ixgbe: Add support for ndo_ll_poll
From: Ben Hutchings <bhutchings@solarflare.com>
To: Eliezer Tamir <eliezer.tamir@linux.intel.com>
CC: Dave Miller <davem@davemloft.net>, <linux-kernel@vger.kernel.org>,
        <netdev@vger.kernel.org>,
        Jesse Brandeburg <jesse.brandeburg@intel.com>,
        Don Skidmore <donald.c.skidmore@intel.com>,
        <e1000-devel@lists.sourceforge.net>,
        Willem de Bruijn <willemb@google.com>,
        Andi Kleen <andi@firstfloor.org>, HPA <hpa@zytor.com>,
        Or Gerlitz <or.gerlitz@gmail.com>,
        Eilon Greenstien <eilong@broadcom.com>,
        Eliezer Tamir <eliezer@tamir.org.il>
Date: Tue, 21 May 2013 18:33:37 +0100
In-Reply-To: <20130521142709.18498.28270.stgit@ladj378.jer.intel.com>
References: <20130521142641.18498.52856.stgit@ladj378.jer.intel.com>
	 <20130521142709.18498.28270.stgit@ladj378.jer.intel.com>
Organization: Solarflare
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.3 (3.2.3-3.fc16) 
Content-Transfer-Encoding: 7bit
MIME-Version: 1.0
X-Originating-IP: [10.17.20.137]
X-TM-AS-Product-Ver: SMEX-10.0.0.1412-7.000.1014-19882.005
X-TM-AS-Result: No--7.823200-0.000000-31
X-TM-AS-User-Approved-Sender: Yes
X-TM-AS-User-Blocked-Sender: No
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2013-05-21 at 17:27 +0300, Eliezer Tamir wrote:
> Add the ixgbe driver code implementing ndo_ll_poll.
> It should be easy for other drivers to do something similar
> in order to enable support for CONFIG_INET_LL_RX_POLL
[...]
> --- a/drivers/net/ethernet/intel/ixgbe/ixgbe_lib.c
> +++ b/drivers/net/ethernet/intel/ixgbe/ixgbe_lib.c
> @@ -1019,6 +1019,8 @@ static void ixgbe_free_q_vectors(struct ixgbe_adapter *adapter)
>  	adapter->num_rx_queues = 0;
>  	adapter->num_q_vectors = 0;
>  
> +	inc_ll_gen_id();

I think that should be handled by the networking core (somewhere) and
not by drivers.

Ben.

>  	while (v_idx--)
>  		ixgbe_free_q_vector(adapter, v_idx);
>  }
[...]

-- 
Ben Hutchings, Staff Engineer, Solarflare
Not speaking for my employer; that's the marketing department's job.
They asked us to note that Solarflare product names are trademarked.


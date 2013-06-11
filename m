Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757276Ab3FKUYm (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Jun 2013 16:24:42 -0400
Received: from webmail.solarflare.com ([12.187.104.25]:47871 "EHLO
	webmail.solarflare.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756484Ab3FKUYj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Jun 2013 16:24:39 -0400
Message-ID: <1370982272.1954.8.camel@bwh-desktop.uk.level5networks.com>
Subject: Re: [PATCH net-next 2/2] net:add socket option for low latency
 polling
From: Ben Hutchings <bhutchings@solarflare.com>
To: Eliezer Tamir <eliezer.tamir@linux.intel.com>
CC: David Miller <davem@davemloft.net>, <linux-kernel@vger.kernel.org>,
        <netdev@vger.kernel.org>,
        Jesse Brandeburg <jesse.brandeburg@intel.com>,
        Don Skidmore <donald.c.skidmore@intel.com>,
        <e1000-devel@lists.sourceforge.net>,
        Willem de Bruijn <willemb@google.com>,
        Eric Dumazet <erdnetdev@gmail.com>, Andi Kleen <andi@firstfloor.org>,
        HPA <hpa@zytor.com>, Eilon Greenstien <eilong@broadcom.com>,
        Or Gerlitz <or.gerlitz@gmail.com>, Amir Vadai <amirv@mellanox.com>,
        Eliezer Tamir <eliezer@tamir.org.il>
Date: Tue, 11 Jun 2013 21:24:32 +0100
In-Reply-To: <20130611142438.17879.6389.stgit@ladj378.jer.intel.com>
References: <20130611142415.17879.75569.stgit@ladj378.jer.intel.com>
	 <20130611142438.17879.6389.stgit@ladj378.jer.intel.com>
Organization: Solarflare
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.6.4 (3.6.4-3.fc18) 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.17.20.137]
X-TM-AS-Product-Ver: SMEX-10.0.0.1412-7.000.1014-19934.000
X-TM-AS-Result: No--3.596000-0.000000-31
X-TM-AS-User-Approved-Sender: Yes
X-TM-AS-User-Blocked-Sender: No
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2013-06-11 at 17:24 +0300, Eliezer Tamir wrote:
> adds a socket option for low latency polling.
> This allows overriding the global sysctl value with a per-socket one.
[...]
> --- a/net/core/sock.c
> +++ b/net/core/sock.c
> @@ -913,6 +913,23 @@ set_rcvbuf:
>  		sock_valbool_flag(sk, SOCK_SELECT_ERR_QUEUE, valbool);
>  		break;
>  
> +#ifdef CONFIG_NET_LL_RX_POLL
> +	case SO_LL:
> +		if (!capable(CAP_NET_ADMIN))
> +			ret = -EACCES;
[...]

Failed capability checks normally result in EPERM whereas EACCES usually
results from a file permission/ACL/label check.

Perhaps unprivileged users should be allowed to set a value as long as
it's less than or equal to the global value?

Ben.

-- 
Ben Hutchings, Staff Engineer, Solarflare
Not speaking for my employer; that's the marketing department's job.
They asked us to note that Solarflare product names are trademarked.


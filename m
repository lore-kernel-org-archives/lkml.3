Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756770Ab3CERPg (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Mar 2013 12:15:36 -0500
Received: from mga14.intel.com ([143.182.124.37]:13223 "EHLO mga14.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752580Ab3CERPf (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Mar 2013 12:15:35 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.84,787,1355126400"; 
   d="scan'208";a="209126275"
Message-ID: <5136282E.9080307@linux.intel.com>
Date: Tue, 05 Mar 2013 19:15:26 +0200
From: Eliezer Tamir <eliezer.tamir@linux.intel.com>
User-Agent: Mozilla/5.0 (Windows NT 6.1; WOW64; rv:17.0) Gecko/20130215 Thunderbird/17.0.3
MIME-Version: 1.0
To: Ben Hutchings <bhutchings@solarflare.com>
CC: Eliezer Tamir <eliezer.tamir@linux.jf.intel.com>,
        linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
        Dave Miller <davem@davemloft.net>,
        Jesse Brandeburg <jesse.brandeburg@intel.com>,
        e1000-devel@lists.sourceforge.net,
        Willem de Bruijn <willemb@google.com>,
        Andi Kleen <andi@firstfloor.org>, HPA <hpa@zytor.com>,
        Eliezer Tamir <eliezer@tamir.org.il>
Subject: Re: [RFC PATCH 1/5] net: implement support for low latency socket
 polling
References: <20130227175549.10611.82188.stgit@gitlad.jf.intel.com>  <20130227175555.10611.42794.stgit@gitlad.jf.intel.com> <1362501781.2791.19.camel@bwh-desktop.uk.solarflarecom.com>
In-Reply-To: <1362501781.2791.19.camel@bwh-desktop.uk.solarflarecom.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 05/03/2013 18:43, Ben Hutchings wrote:
> On Wed, 2013-02-27 at 09:55 -0800, Eliezer Tamir wrote:
>
> Should the units really be cycles or, say, microseconds?  I assume that
> a sysctl setter can do a conversion to cycles so that there's no need to
> multiply every time the value is used.  (If the CPU doesn't have
> constant_tsc or equivalent then this conversion doesn't quite work, but
> then low-latency tunng usually includes disabling frequency scaling.)

We are not very sensitive to this setting, anything on the order of your 
half round time trip plus a few standard deviations works well.
We are busy waiting, so setting a higher value does not change the 
results much.

It does make sense to have this in ms, and it might not matter if the 
dynamic cycles mess with the value too much.

BTW on my machines enabling frequency scaling improves performance in 
many cases.

> Also, this should be a per-device (or even per-NAPI-context?) setting.

Again, I would expect this to depend more on your workload than on the 
NIC, so I would keep this global.
User knobs should be as simple as possible.

 >>+int sysctl_net_ll_poll __read_mostly = 150000;
> Nicely tuned for your specific test system, no doubt. :-)

why don't you try this on your NIC and see ;-)

Thanks for the input,
Eliezer

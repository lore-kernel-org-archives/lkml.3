Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753414Ab3JWWIL (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Oct 2013 18:08:11 -0400
Received: from mga14.intel.com ([143.182.124.37]:31431 "EHLO mga14.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751501Ab3JWWII (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Oct 2013 18:08:08 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.93,557,1378882800"; 
   d="scan'208";a="416023212"
Date: Wed, 23 Oct 2013 23:07:43 +0100
From: Fengguang Wu <fengguang.wu@intel.com>
To: Christoph Paasch <christoph.paasch@uclouvain.be>
Cc: "Eric W. Biederman" <ebiederm@xmission.com>,
        David Miller <davem@davemloft.net>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: -27% netperf TCP_STREAM regression by "tcp_memcontrol: Kill
 struct tcp_memcontrol"
Message-ID: <20131023220743.GA5226@localhost>
References: <20131022214129.GB2715@localhost>
 <20131022.180023.1141845387743361648.davem@davemloft.net>
 <87k3h461ql.fsf@tw-ebiederman.twitter.com>
 <20131023122543.GH5132@cpaasch-mac>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20131023122543.GH5132@cpaasch-mac>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> -       return !!sk->sk_prot->memory_pressure;
> +       return !!*sk->sk_prot->memory_pressure;

Good catch, Christoph! With no surprise, it restores the performance:

    a4fe34bf902b8f709c63      2e685cad57906e19add7      a235435d612680e595ea  
------------------------  ------------------------  ------------------------  
                  707.40       -41.0%       417.50        -8.8%       645.00  lkp-nex04/micro/netperf/120s-200%-TCP_STREAM
                 2775.60       -23.7%      2116.50        +2.1%      2834.00  lkp-sb03/micro/netperf/120s-200%-TCP_STREAM
                 3483.00       -27.2%      2534.00        -0.1%      3479.00  TOTAL netperf.Throughput_Mbps

It's a bit late, but

Tested-by: Fengguang Wu <fengguang.wu@intel.com>

Thanks,
Fengguang

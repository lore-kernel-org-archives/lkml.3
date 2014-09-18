Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932704AbaIRV5m (ORCPT <rfc822;w@1wt.eu>);
	Thu, 18 Sep 2014 17:57:42 -0400
Received: from www.sr71.net ([198.145.64.142]:46569 "EHLO blackbird.sr71.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932212AbaIRV5l (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Sep 2014 17:57:41 -0400
Message-ID: <541B5553.8070206@sr71.net>
Date: Thu, 18 Sep 2014 14:57:39 -0700
From: Dave Hansen <dave@sr71.net>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.6.0
MIME-Version: 1.0
To: linux-kernel@vger.kernel.org
CC: dave.hansen@linux.intel.com, a.p.zijlstra@chello.nl, mingo@kernel.org,
        hpa@linux.intel.com, brice.goglin@gmail.com, bp@alien8.de
Subject: Re: [PATCH] x86: new topology for multi-NUMA-node CPUs
References: <20140918193334.C065EBCE@viggo.jf.intel.com>
In-Reply-To: <20140918193334.C065EBCE@viggo.jf.intel.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 09/18/2014 12:33 PM, Dave Hansen wrote:
> @@ -410,6 +442,8 @@ void set_cpu_sibling_map(int cpu)
>  			} else if (i != cpu && !c->booted_cores)
>  				c->booted_cores = cpu_data(i).booted_cores;
>  		}
> +		if (match_mc(c, o) == !topology_same_node(c, o))
> +			primarily_use_numa_for_topology();
>  	}
>  }

I went to test this on some more systems.  The "== !" above should be a
"!=".  The test is meant to see if a CPU pair is in the same mc group,
but not in the same node.

I'll fix it in the next version.

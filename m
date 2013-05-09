Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754154Ab3EIWTx (ORCPT <rfc822;w@1wt.eu>);
	Thu, 9 May 2013 18:19:53 -0400
Received: from www.sr71.net ([198.145.64.142]:32965 "EHLO blackbird.sr71.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753947Ab3EIWTw (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 9 May 2013 18:19:52 -0400
Message-ID: <518C2106.3030402@sr71.net>
Date: Thu, 09 May 2013 15:19:50 -0700
From: Dave Hansen <dave@sr71.net>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130329 Thunderbird/17.0.5
MIME-Version: 1.0
To: Seth Jennings <sjenning@linux.vnet.ibm.com>
CC: linux-mm@kvack.org, linux-kernel@vger.kernel.org,
        akpm@linux-foundation.org, mgorman@suse.de, tim.c.chen@linux.intel.com
Subject: Re: [RFC][PATCH 1/7] defer clearing of page_private() for swap cache
 pages
References: <20130507211954.9815F9D1@viggo.jf.intel.com> <20130507211955.7DF88A4F@viggo.jf.intel.com> <20130509220739.GA14840@cerebellum>
In-Reply-To: <20130509220739.GA14840@cerebellum>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 05/09/2013 03:07 PM, Seth Jennings wrote:
> mm/memcontrol:4111
> VM_BUG_ON(PageSwapCache(page));
> 
> Seems that mem_cgroup_uncharge_swapcache, somewhat ironically expects the
> SwapCache flag to be unset already.
> 
> Fix might be a simple as removing that VM_BUG_ON() but there might be more to
> it.  There usually is :)

Yeah, I wasn't testing with cgroups around.  I'll go do that and see
what I come up with.

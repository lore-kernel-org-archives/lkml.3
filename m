Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757664Ab3JQQMe (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Oct 2013 12:12:34 -0400
Received: from www.sr71.net ([198.145.64.142]:49153 "EHLO blackbird.sr71.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756377Ab3JQQMc (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Oct 2013 12:12:32 -0400
Message-ID: <52600C49.7070306@sr71.net>
Date: Thu, 17 Oct 2013 09:11:53 -0700
From: Dave Hansen <dave@sr71.net>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.0
MIME-Version: 1.0
To: David Rientjes <rientjes@google.com>
CC: linux-mm@kvack.org, linux-kernel@vger.kernel.org,
        Cody P Schafer <cody@linux.vnet.ibm.com>,
        Andi Kleen <ak@linux.intel.com>, cl@gentwo.org,
        Andrew Morton <akpm@linux-foundation.org>, Mel Gorman <mel@csn.ul.ie>
Subject: Re: [RFC][PATCH 1/8] mm: pcp: rename percpu pageset functions
References: <20131015203536.1475C2BE@viggo.jf.intel.com> <20131015203538.35606A47@viggo.jf.intel.com> <alpine.DEB.2.02.1310161831090.15575@chino.kir.corp.google.com>
In-Reply-To: <alpine.DEB.2.02.1310161831090.15575@chino.kir.corp.google.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 10/16/2013 06:32 PM, David Rientjes wrote:
>> > +static void pageset_setup_from_batch_size(struct per_cpu_pageset *p,
>> > +					unsigned long batch)
>> >  {
>> > -	pageset_update(&p->pcp, 6 * batch, max(1UL, 1 * batch));
>> > +	unsigned long high;
>> > +	high = 6 * batch;
>> > +	if (!batch)
>> > +		batch = 1;
> high = 6 * batch should be here?

Ahh, nice catch, thanks.  I'll fix that up and resend.




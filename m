Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932529Ab3GKPv3 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Jul 2013 11:51:29 -0400
Received: from mga09.intel.com ([134.134.136.24]:9117 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932246Ab3GKPv2 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Jul 2013 11:51:28 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.87,1043,1363158000"; 
   d="scan'208";a="368531397"
Message-ID: <51DED47A.8090008@intel.com>
Date: Thu, 11 Jul 2013 08:51:22 -0700
From: Dave Hansen <dave.hansen@intel.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130623 Thunderbird/17.0.7
MIME-Version: 1.0
To: Joonsoo Kim <iamjoonsoo.kim@lge.com>
CC: Dave Hansen <dave@sr71.net>, Andrew Morton <akpm@linux-foundation.org>,
        Mel Gorman <mgorman@suse.de>, David Rientjes <rientjes@google.com>,
        Glauber Costa <glommer@gmail.com>,
        Johannes Weiner <hannes@cmpxchg.org>,
        KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
        Rik van Riel <riel@redhat.com>, Hugh Dickins <hughd@google.com>,
        Minchan Kim <minchan@kernel.org>, Jiang Liu <jiang.liu@huawei.com>,
        linux-mm@kvack.org, linux-kernel@vger.kernel.org
Subject: Re: [RFC PATCH 1/5] mm, page_alloc: support multiple pages allocation
References: <1372840460-5571-1-git-send-email-iamjoonsoo.kim@lge.com> <1372840460-5571-2-git-send-email-iamjoonsoo.kim@lge.com> <51DDE5BA.9020800@intel.com> <20130711010248.GB7756@lge.com> <51DE44CC.2070700@sr71.net> <20130711061201.GA2400@lge.com>
In-Reply-To: <20130711061201.GA2400@lge.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 07/10/2013 11:12 PM, Joonsoo Kim wrote:
>> > I'd also like to see some scalability numbers on this.  How do your
>> > tests look when all the CPUs on the system are hammering away?
> What test do you mean?
> Please elaborate on this more

Your existing tests looked single-threaded.  That's certainly part of
the problem.  Will your patches have implications for larger systems,
though?  How much do your patches speed up or slow things down if we
have many allocations proceeding on many CPUs in parallel?

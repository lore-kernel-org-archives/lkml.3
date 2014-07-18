Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761925AbaGRPAr (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Jul 2014 11:00:47 -0400
Received: from mga11.intel.com ([192.55.52.93]:62922 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1760878AbaGRPAp (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Jul 2014 11:00:45 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.01,685,1400050800"; 
   d="scan'208";a="571879235"
Message-ID: <53C9369B.4070608@intel.com>
Date: Fri, 18 Jul 2014 08:00:43 -0700
From: Dave Hansen <dave.hansen@intel.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.6.0
MIME-Version: 1.0
To: Wang Nan <wangnan0@huawei.com>, Ingo Molnar <mingo@redhat.com>,
        Yinghai Lu <yinghai@kernel.org>, Mel Gorman <mgorman@suse.de>,
        Andrew Morton <akpm@linux-foundation.org>
CC: Pei Feiyue <peifeiyue@huawei.com>, linux-mm@kvack.org, x86@kernel.org,
        linux-ia64@vger.kernel.org, linuxppc-dev@lists.ozlabs.org,
        linux-sh@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/5] memory-hotplug: x86_64: suitable memory should go
 to ZONE_MOVABLE
References: <1405670163-53747-1-git-send-email-wangnan0@huawei.com> <1405670163-53747-2-git-send-email-wangnan0@huawei.com>
In-Reply-To: <1405670163-53747-2-git-send-email-wangnan0@huawei.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 07/18/2014 12:55 AM, Wang Nan wrote:
> +	if (!zone_is_empty(movable_zone))
> +		if (zone_spans_pfn(movable_zone, start_pfn) ||
> +				(zone_end_pfn(movable_zone) <= start_pfn))
> +			zone = movable_zone;
> +

It's nice that you hit so many architectures, but is there a way to do
this that doesn't involve copying and pasting the same bit of code in to
each architecture?

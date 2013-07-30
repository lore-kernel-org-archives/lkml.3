Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753259Ab3G3Ora (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Jul 2013 10:47:30 -0400
Received: from mga14.intel.com ([143.182.124.37]:61459 "EHLO mga14.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752719Ab3G3Or2 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Jul 2013 10:47:28 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.89,778,1367996400"; 
   d="scan'208";a="275317770"
Message-ID: <51F7D1F0.20309@intel.com>
Date: Tue, 30 Jul 2013 07:47:12 -0700
From: Dave Hansen <dave.hansen@intel.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130623 Thunderbird/17.0.7
MIME-Version: 1.0
To: Michal Hocko <mhocko@suse.cz>
CC: Andrew Morton <akpm@linux-foundation.org>, linux-mm@kvack.org,
        linux-kernel@vger.kernel.org, kosaki.motohiro@jp.fujitsu.com,
        kamezawa.hiroyu@jp.fujitsu.com, bp@suse.de,
        Dave Hansen <dave@linux.vnet.ibm.com>
Subject: Re: [PATCH resend] drop_caches: add some documentation and info message
References: <1374842669-22844-1-git-send-email-mhocko@suse.cz> <20130729135743.c04224fb5d8e64b2730d8263@linux-foundation.org> <20130730074531.GA10584@dhcp22.suse.cz> <20130730012544.2f33ebf6.akpm@linux-foundation.org> <20130730125525.GB15847@dhcp22.suse.cz>
In-Reply-To: <20130730125525.GB15847@dhcp22.suse.cz>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 07/30/2013 05:55 AM, Michal Hocko wrote:
>> > If we add another flag in the future it can use bit 3?
> What if we get crazy and need more of them?

I really hate using bits for these kinds of interfaces.  I'm forgetful
and never remember which bit is which, and they're possible to run out of.

I'm not saying do it now, but we can switch over to:

	echo 'slab|pagecache' > drop_caches
or
	echo 'quiet|slab' > drop_caches

any time we want and still have compatibility with the existing bitwise
interface.

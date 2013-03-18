Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752796Ab3CRONI (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Mar 2013 10:13:08 -0400
Received: from cantor2.suse.de ([195.135.220.15]:44822 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752054Ab3CRONF (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Mar 2013 10:13:05 -0400
Date: Mon, 18 Mar 2013 15:13:02 +0100
From: Michal Hocko <mhocko@suse.cz>
To: KY Srinivasan <kys@microsoft.com>
Cc: "gregkh@linuxfoundation.org" <gregkh@linuxfoundation.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "devel@linuxdriverproject.org" <devel@linuxdriverproject.org>,
        "olaf@aepfle.de" <olaf@aepfle.de>,
        "apw@canonical.com" <apw@canonical.com>,
        "andi@firstfloor.org" <andi@firstfloor.org>,
        "akpm@linux-foundation.org" <akpm@linux-foundation.org>,
        "linux-mm@kvack.org" <linux-mm@kvack.org>,
        "kamezawa.hiroyuki@gmail.com" <kamezawa.hiroyuki@gmail.com>,
        "hannes@cmpxchg.org" <hannes@cmpxchg.org>,
        "yinghan@google.com" <yinghan@google.com>
Subject: Re: [PATCH 2/2] Drivers: hv: balloon: Support 2M page allocations
 for ballooning
Message-ID: <20130318141302.GO10192@dhcp22.suse.cz>
References: <1363470088-24565-1-git-send-email-kys@microsoft.com>
 <1363470125-24606-1-git-send-email-kys@microsoft.com>
 <1363470125-24606-2-git-send-email-kys@microsoft.com>
 <20130318105257.GG10192@dhcp22.suse.cz>
 <1701384b10204014b53acecb006521b0@SN2PR03MB061.namprd03.prod.outlook.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1701384b10204014b53acecb006521b0@SN2PR03MB061.namprd03.prod.outlook.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon 18-03-13 13:44:05, KY Srinivasan wrote:
> 
> 
> > -----Original Message-----
> > From: Michal Hocko [mailto:mhocko@suse.cz]
> > Sent: Monday, March 18, 2013 6:53 AM
> > To: KY Srinivasan
> > Cc: gregkh@linuxfoundation.org; linux-kernel@vger.kernel.org;
> > devel@linuxdriverproject.org; olaf@aepfle.de; apw@canonical.com;
> > andi@firstfloor.org; akpm@linux-foundation.org; linux-mm@kvack.org;
> > kamezawa.hiroyuki@gmail.com; hannes@cmpxchg.org; yinghan@google.com
> > Subject: Re: [PATCH 2/2] Drivers: hv: balloon: Support 2M page allocations for
> > ballooning
> > 
> > On Sat 16-03-13 14:42:05, K. Y. Srinivasan wrote:
> > > While ballooning memory out of the guest, attempt 2M allocations first.
> > > If 2M allocations fail, then go for 4K allocations. In cases where we
> > > have performed 2M allocations, split this 2M page so that we can free this
> > > page at 4K granularity (when the host returns the memory).
> > 
> > Maybe I am missing something but what is the advantage of 2M allocation
> > when you split it up immediately so you are not using it as a huge page?
> 
> The Hyper-V ballooning protocol specifies the pages being ballooned as
> page ranges - start_pfn: number_of_pfns. So, when the guest balloon
> is inflating and I am able to allocate 2M pages, I will be able to
> represent 512 contiguous pages in one 64 bit entry and this makes the
> ballooning operation that much more efficient. The reason I split the
> page is that the host does not guarantee that when it returns the
> memory to the guest, it will return in any particular granularity and
> so I have to be able to free this memory in 4K granularity. This is
> the corner case that I will have to handle.

Thanks for the clarification. I think this information would be valuable
in the changelog.
-- 
Michal Hocko
SUSE Labs

Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754175AbaAUKX6 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 21 Jan 2014 05:23:58 -0500
Received: from cantor2.suse.de ([195.135.220.15]:41152 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753900AbaAUKXz (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 21 Jan 2014 05:23:55 -0500
Date: Tue, 21 Jan 2014 10:23:51 +0000
From: Mel Gorman <mgorman@suse.de>
To: linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>,
        Michal Hocko <mhocko@suse.cz>, linux-mm@kvack.org,
        Dave Hansen <dave.hansen@intel.com>,
        David Rientjes <rientjes@google.com>
Subject: Re: [RFC] restore user defined min_free_kbytes when disabling thp
Message-ID: <20140121102351.GD4963@suse.de>
References: <20140121093859.GA7546@localhost.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-15
Content-Disposition: inline
In-Reply-To: <20140121093859.GA7546@localhost.localdomain>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jan 21, 2014 at 05:38:59PM +0800, Han Pingtian wrote:
> The testcase 'thp04' of LTP will enable THP, do some testing, then
> disable it if it wasn't enabled. But this will leave a different value
> of min_free_kbytes if it has been set by admin. So I think it's better
> to restore the user defined value after disabling THP.
> 

Then have LTP record what min_free_kbytes was at the same time THP was
enabled by the test and restore both settings. It leaves a window where
an admin can set an alternative value during the test but that would also
invalidate the test in same cases and gets filed under "don't do that".

-- 
Mel Gorman
SUSE Labs

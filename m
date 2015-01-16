Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755795AbbAPR5v (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 Jan 2015 12:57:51 -0500
Received: from mail-we0-f171.google.com ([74.125.82.171]:39241 "EHLO
	mail-we0-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751730AbbAPR5u (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 Jan 2015 12:57:50 -0500
Date: Fri, 16 Jan 2015 18:57:45 +0100
From: Michal Hocko <mhocko@suse.cz>
To: Vinayak Menon <vinmenon@codeaurora.org>
Cc: linux-mm@kvack.org, linux-kernel@vger.kernel.org,
        akpm@linux-foundation.org, hannes@cmpxchg.org, vdavydov@parallels.com,
        mgorman@suse.de, minchan@kernel.org, Christoph Lameter <cl@gentwo.org>
Subject: Re: [PATCH v2] mm: vmscan: fix the page state calculation in
 too_many_isolated
Message-ID: <20150116175745.GA22136@dhcp22.suse.cz>
References: <1421235419-30736-1-git-send-email-vinmenon@codeaurora.org>
 <20150114165036.GI4706@dhcp22.suse.cz>
 <54B7F7C4.2070105@codeaurora.org>
 <20150116154922.GB4650@dhcp22.suse.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20150116154922.GB4650@dhcp22.suse.cz>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri 16-01-15 16:49:22, Michal Hocko wrote:
[...]
> Why cannot we simply update the global counters from vmstat_shepherd
> directly?

OK, I should have checked the updating paths... This would be racy, so
update from remote is not an option without additional trickery (like
retries etc.) :/
-- 
Michal Hocko
SUSE Labs

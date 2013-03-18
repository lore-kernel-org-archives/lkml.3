Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752886Ab3CRKxF (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Mar 2013 06:53:05 -0400
Received: from cantor2.suse.de ([195.135.220.15]:34017 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751724Ab3CRKxC (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Mar 2013 06:53:02 -0400
Date: Mon, 18 Mar 2013 11:52:57 +0100
From: Michal Hocko <mhocko@suse.cz>
To: "K. Y. Srinivasan" <kys@microsoft.com>
Cc: gregkh@linuxfoundation.org, linux-kernel@vger.kernel.org,
        devel@linuxdriverproject.org, olaf@aepfle.de, apw@canonical.com,
        andi@firstfloor.org, akpm@linux-foundation.org, linux-mm@kvack.org,
        kamezawa.hiroyuki@gmail.com, hannes@cmpxchg.org, yinghan@google.com
Subject: Re: [PATCH 2/2] Drivers: hv: balloon: Support 2M page allocations
 for ballooning
Message-ID: <20130318105257.GG10192@dhcp22.suse.cz>
References: <1363470088-24565-1-git-send-email-kys@microsoft.com>
 <1363470125-24606-1-git-send-email-kys@microsoft.com>
 <1363470125-24606-2-git-send-email-kys@microsoft.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1363470125-24606-2-git-send-email-kys@microsoft.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat 16-03-13 14:42:05, K. Y. Srinivasan wrote:
> While ballooning memory out of the guest, attempt 2M allocations first.
> If 2M allocations fail, then go for 4K allocations. In cases where we
> have performed 2M allocations, split this 2M page so that we can free this
> page at 4K granularity (when the host returns the memory).

Maybe I am missing something but what is the advantage of 2M allocation
when you split it up immediately so you are not using it as a huge page?

[...]
-- 
Michal Hocko
SUSE Labs

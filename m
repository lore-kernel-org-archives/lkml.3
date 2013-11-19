Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752705Ab3KSVt3 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Nov 2013 16:49:29 -0500
Received: from mga02.intel.com ([134.134.136.20]:48232 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751821Ab3KSVt2 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Nov 2013 16:49:28 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.93,535,1378882800"; 
   d="scan'208";a="438080597"
From: Andi Kleen <andi@firstfloor.org>
To: Michal Hocko <mhocko@suse.cz>
Cc: linux-mm@kvack.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] Expose sysctls for enabling slab/file_cache interleaving
References: <1384822222-28795-1-git-send-email-andi@firstfloor.org>
	<20131119104203.GB18872@dhcp22.suse.cz>
	<20131119184200.GD29695@two.firstfloor.org>
	<20131119191135.GA8634@dhcp22.suse.cz>
	<20131119201333.GD19762@tassilo.jf.intel.com>
	<20131119212123.GA9339@dhcp22.suse.cz>
Date: Tue, 19 Nov 2013 13:49:28 -0800
In-Reply-To: <20131119212123.GA9339@dhcp22.suse.cz> (Michal Hocko's message of
	"Tue, 19 Nov 2013 22:21:23 +0100")
Message-ID: <87y54kvz87.fsf@tassilo.jf.intel.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/24.3 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Michal Hocko <mhocko@suse.cz> writes:
>
> Another option would be to use sysctl values for the top cpuset as a
> default. But then why not just do it manually without sysctl?

I want to provide an alternative to having to use cpusets to use this,
that is actually usable for normal people.

Also this is really a global setting in my mind.

> If you create a cpuset and explicitly disable spreading then you would
> be quite surprised that your process gets pages from all nodes, no?

If I enable it globally using a sysctl I would be quite surprised 
if some cpuset can override it.

That argument is equally valid :-)

The user configured an inconsistent configuration, and the kernel
has to make a decision somehow.

In the end it is arbitary, but not having to check the cpuset
here is a lot cheaper, so I prefer the "sysctl has priority" 
option.

Could EINVAL the cpuset setting when the sysctl is set
though (but it's difficult to do the other way round).

-Andi

-- 
ak@linux.intel.com -- Speaking for myself only

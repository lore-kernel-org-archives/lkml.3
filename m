Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753658AbaFYGZu (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Jun 2014 02:25:50 -0400
Received: from mga02.intel.com ([134.134.136.20]:22750 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751415AbaFYGZt (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Jun 2014 02:25:49 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.01,543,1400050800"; 
   d="scan'208";a="563039882"
Message-ID: <1403677528.7903.103.camel@sauron.fi.intel.com>
Subject: Re: [PATCH] sysctl: Add a feature to drop caches selectively
From: Artem Bityutskiy <dedekind1@gmail.com>
Reply-To: dedekind1@gmail.com
To: David Rientjes <rientjes@google.com>
Cc: Maksym Planeta <mcsim.planeta@gmail.com>,
        Alexander Viro <viro@zeniv.linux.org.uk>,
        Thomas Knauth <thomas.knauth@gmx.de>, linux-fsdevel@vger.kernel.org,
        linux-kernel@vger.kernel.org
Date: Wed, 25 Jun 2014 09:25:28 +0300
In-Reply-To: <alpine.DEB.2.02.1406241458140.29176@chino.kir.corp.google.com>
References: <1403626213-7691-1-git-send-email-mcsim.planeta@gmail.com>
	 <alpine.DEB.2.02.1406241458140.29176@chino.kir.corp.google.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.10.4 (3.10.4-2.fc20) 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2014-06-24 at 14:59 -0700, David Rientjes wrote:
> On Tue, 24 Jun 2014, Maksym Planeta wrote:
> 
> > To clean the page cache one can use /proc/sys/vm/drop_caches. But this
> > drops the whole page cache. In contrast to that sdrop_caches enables
> > ability to drop the page cache selectively by path string.
> > 
> > Suggested-by: Thomas Knauth <thomas.knauth@gmx.de>
> > Signed-off-by: Maksym Planeta <mcsim.planeta@gmail.com>
> 
> Could you include some information in the commit message about why this is 
> useful?  Specifically, why you want to drop pagecache only from a specific 
> path.
> 
> The name of the sysctl is also quite non-descriptive.

Plus some explanations WRT why proc-based interface and what would be
the alternatives, what if tomorrow we want to extend the functionality
and drop caches only for certain file range, is this only for regular
files or also for directories, why posix_fadvice(DONTNEED) is not
sufficient.

-- 
Best Regards,
Artem Bityutskiy


Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758524AbaDJO0d (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Apr 2014 10:26:33 -0400
Received: from mga03.intel.com ([143.182.124.21]:49815 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751225AbaDJO0a (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Apr 2014 10:26:30 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.97,834,1389772800"; 
   d="scan'208";a="417362597"
Date: Thu, 10 Apr 2014 10:26:25 -0400
From: Matthew Wilcox <willy@linux.intel.com>
To: Jan Kara <jack@suse.cz>
Cc: Matthew Wilcox <matthew.r.wilcox@intel.com>, linux-fsdevel@vger.kernel.org,
        linux-mm@kvack.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v7 17/22] Get rid of most mentions of XIP in ext2
Message-ID: <20140410142625.GK5727@linux.intel.com>
References: <cover.1395591795.git.matthew.r.wilcox@intel.com>
 <0b13a744db9bfca33938bc1576f7eb7bfc9c41c2.1395591795.git.matthew.r.wilcox@intel.com>
 <20140409100435.GJ32103@quack.suse.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140409100435.GJ32103@quack.suse.cz>
User-Agent: Mutt/1.5.22 (2013-10-16)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Apr 09, 2014 at 12:04:35PM +0200, Jan Kara wrote:
> On Sun 23-03-14 15:08:43, Matthew Wilcox wrote:
> > The only remaining usage is userspace's 'xip' option.
>   Looks good. You can add:
> Reviewed-by: Jan Kara <jack@suse.cz>

I've been thinking about this patch, and I'm not happy with it any more :-)

I want to migrate people away from using 'xip' to 'dax' without breaking
anybody's scripts.  So I'm thinking about adding a new 'dax' option and
having the 'xip' option print a warning and force-enable the 'dax' option.
That way people who might have scripts to look for 'xip' in /proc/mounts
won't break.

Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753114AbbANOMm (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Jan 2015 09:12:42 -0500
Received: from mail-qa0-f52.google.com ([209.85.216.52]:33892 "EHLO
	mail-qa0-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752101AbbANOMk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Jan 2015 09:12:40 -0500
Date: Wed, 14 Jan 2015 09:12:36 -0500
From: Tejun Heo <tj@kernel.org>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Andrzej Hajda <a.hajda@samsung.com>, linux-mm@kvack.org,
        Marek Szyprowski <m.szyprowski@samsung.com>,
        Kyungmin Park <kyungmin.park@samsung.com>,
        linux-kernel@vger.kernel.org, andi@firstfloor.org, andi@lisas.de,
        Mike Turquette <mturquette@linaro.org>,
        Alexander Viro <viro@zeniv.linux.org.uk>
Subject: Re: [PATCH 0/5] kstrdup optimization
Message-ID: <20150114141236.GC3565@htj.dyndns.org>
References: <1421054323-14430-1-git-send-email-a.hajda@samsung.com>
 <20150113153731.43eefac721964d165396e5af@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20150113153731.43eefac721964d165396e5af@linux-foundation.org>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jan 13, 2015 at 03:37:31PM -0800, Andrew Morton wrote:
> What the heck does (the cheerily undocumented) KERNFS_STATIC_NAME do
> and can we remove it if this patchset is in place?

The same thing, in a narrower scope.  It's currently used to avoid
making copies of sysfs file names which are required to stay unchanged
and accessible and usually allocated in the rodata section, but the
sysfs directory and all group file names are copied.  So, yeah, once
this is in, we can remove the explicit static name handling from
kernfs.

Thanks.

-- 
tejun

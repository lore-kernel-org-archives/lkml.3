Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753390AbaJQHCc (ORCPT <rfc822;w@1wt.eu>);
	Fri, 17 Oct 2014 03:02:32 -0400
Received: from mga09.intel.com ([134.134.136.24]:8757 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753333AbaJQHCa (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 17 Oct 2014 03:02:30 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.04,737,1406617200"; 
   d="scan'208";a="620344566"
Date: Thu, 16 Oct 2014 18:21:46 -0400
From: Matthew Wilcox <willy@linux.intel.com>
To: Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
Cc: Matthew Wilcox <willy@linux.intel.com>,
        Matthew Wilcox <matthew.r.wilcox@intel.com>,
        linux-fsdevel@vger.kernel.org, linux-mm@kvack.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH v11 06/21] vfs: Add copy_to_iter(), copy_from_iter() and
 iov_iter_zero()
Message-ID: <20141016222145.GM11522@wil.cx>
References: <1411677218-29146-1-git-send-email-matthew.r.wilcox@intel.com>
 <1411677218-29146-7-git-send-email-matthew.r.wilcox@intel.com>
 <20141016133355.GT19075@thinkos.etherlink>
 <20141016135903.GA11522@wil.cx>
 <837939598.10389.1413468726146.JavaMail.zimbra@efficios.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <837939598.10389.1413468726146.JavaMail.zimbra@efficios.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Oct 16, 2014 at 02:12:06PM +0000, Mathieu Desnoyers wrote:
> > The access_ok() check is done higher up the call-chain if it's appropriate.
> > These functions can be (intentionally) called to access kernel addresses,
> > so it wouldn't be appropriate to do that here.
> 
> If the access_ok() are expected to be already done higher in the call-chain,
> we might want to rename e.g. copy_to_iter_iovec to
> __copy_to_iter_iovec(). It helps clarifying the check expectations for the
> caller.

I'm following the existing convention in this file; it already had
copy_page_to_iter() and copy_page_from_iter() as exported symbols.  I
just added copy_to_iter() and copy_from_iter().


Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752989AbaI3QIs (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Sep 2014 12:08:48 -0400
Received: from mga09.intel.com ([134.134.136.24]:44653 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751091AbaI3QIr (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Sep 2014 12:08:47 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.04,627,1406617200"; 
   d="scan'208";a="610982291"
Date: Tue, 30 Sep 2014 12:08:41 -0400
From: Matthew Wilcox <willy@linux.intel.com>
To: Valdis.Kletnieks@vt.edu
Cc: Matthew Wilcox <willy@linux.intel.com>,
        Matthew Wilcox <matthew.r.wilcox@intel.com>,
        linux-fsdevel@vger.kernel.org, linux-mm@kvack.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH v11 00/21] Add support for NV-DIMMs to ext4
Message-ID: <20140930160841.GB5098@wil.cx>
References: <1411677218-29146-1-git-send-email-matthew.r.wilcox@intel.com>
 <15705.1412070301@turing-police.cc.vt.edu>
 <20140930144854.GA5098@wil.cx>
 <123795.1412088827@turing-police.cc.vt.edu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <123795.1412088827@turing-police.cc.vt.edu>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Sep 30, 2014 at 10:53:47AM -0400, Valdis.Kletnieks@vt.edu wrote:
> On Tue, 30 Sep 2014 10:48:54 -0400, Matthew Wilcox said:
> 
> > No, it doesn't try to do that.  Wouldn't you be better served with an
> > LD_PRELOAD that forces O_DIRECT on?
> 
> Not when you don't want it on every file, and users are creating and
> deleting files once in a while.  A chattr-like command is easier and
> more scalable than rebuilding the LD_PRELOAD every time the list of
> files gets changed....

The more I think about this, the more I think this is a bad idea.
When you have a file open with O_DIRECT, your I/O has to be done in
512-byte multiples, and it has to be aligned to 512-byte boundaries
in memory.  If an unsuspecting application has O_DIRECT forced on it,
it isn't going to know to do that, and so all its I/Os will fail.
It'll also be horribly inefficient if a program has the file mmaped.

What problem are you really trying to solve?  Some big files hogging
the page cache?

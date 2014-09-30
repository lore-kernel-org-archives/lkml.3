Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753071AbaI3TYj (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Sep 2014 15:24:39 -0400
Received: from mga11.intel.com ([192.55.52.93]:44621 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750996AbaI3TYh (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Sep 2014 15:24:37 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.97,862,1389772800"; 
   d="scan'208";a="393738882"
Date: Tue, 30 Sep 2014 15:24:28 -0400
From: Matthew Wilcox <willy@linux.intel.com>
To: "Zuckerman, Boris" <borisz@hp.com>
Cc: Matthew Wilcox <willy@linux.intel.com>,
        "Valdis.Kletnieks@vt.edu" <Valdis.Kletnieks@vt.edu>,
        Matthew Wilcox <matthew.r.wilcox@intel.com>,
        "linux-fsdevel@vger.kernel.org" <linux-fsdevel@vger.kernel.org>,
        "linux-mm@kvack.org" <linux-mm@kvack.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH v11 00/21] Add support for NV-DIMMs to ext4
Message-ID: <20140930192428.GF5098@wil.cx>
References: <1411677218-29146-1-git-send-email-matthew.r.wilcox@intel.com>
 <15705.1412070301@turing-police.cc.vt.edu>
 <20140930144854.GA5098@wil.cx>
 <123795.1412088827@turing-police.cc.vt.edu>
 <20140930160841.GB5098@wil.cx>
 <4C30833E5CDF444D84D942543DF65BDA6E047B9B@G4W3303.americas.hpqcorp.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4C30833E5CDF444D84D942543DF65BDA6E047B9B@G4W3303.americas.hpqcorp.net>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Sep 30, 2014 at 05:10:26PM +0000, Zuckerman, Boris wrote:
> > 
> > The more I think about this, the more I think this is a bad idea.
> > When you have a file open with O_DIRECT, your I/O has to be done in 512-byte
> > multiples, and it has to be aligned to 512-byte boundaries in memory.  If an
> > unsuspecting application has O_DIRECT forced on it, it isn't going to know to do that,
> > and so all its I/Os will fail.
> > It'll also be horribly inefficient if a program has the file mmaped.
> > 
> > What problem are you really trying to solve?  Some big files hogging the page cache?
> > --
> 
> Page cache? As another copy in RAM? 
> NV_DIMMs may be viewed as a caching device. This caching can be implemented on the level of NV block/offset or may have some hints from FS and applications. Temporary files is one example. They may not need to hit NV domain ever. Some transactional journals or DB files is another example. They may stay in RAM until power off.

Boris, you're confused.  Valdis is trying to solve an unrelated problem
(and hopes my DAX patches will do it for him).  I'm explaining to him why
what he wants to do is a bad idea.  This tangent is unrelated to NV-DIMMs.


Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753545Ab3IERpL (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Sep 2013 13:45:11 -0400
Received: from mga09.intel.com ([134.134.136.24]:13507 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752250Ab3IERpJ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Sep 2013 13:45:09 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.90,848,1371106800"; 
   d="scan'208";a="398915906"
Date: Thu, 5 Sep 2013 10:45:08 -0700
From: Sarah Sharp <sarah.a.sharp@linux.intel.com>
To: Joe Perches <joe@perches.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,
        Wang Shilong <wangshilong1991@gmail.com>, kumargauravgupta3@gmail.com,
        kernel-janitors@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] checkpatch: Extend CamelCase types and ignore existing
 CamelCase uses in a patch
Message-ID: <20130905174508.GA5978@xanatos>
References: <5223383f.hCMXrpqEq1AlVw9b%wangshilong1991@gmail.com>
 <20130903155857.GA2657@xanatos>
 <1378229121.7347.12.camel@joe-AO722>
 <20130904155831.GB6061@xanatos>
 <1378336086.1787.48.camel@joe-AO722>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1378336086.1787.48.camel@joe-AO722>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Sep 04, 2013 at 04:08:06PM -0700, Joe Perches wrote:
> (sending for 3rd time, odd dns problems today, apologies for dupes)
> 
> On Wed, 2013-09-04 at 08:58 -0700, Sarah Sharp wrote:
> > On Tue, Sep 03, 2013 at 10:25:21AM -0700, Joe Perches wrote:
> > > Extend the CamelCase words found to include structure members.
> > > 
> > > In https://lkml.org/lkml/2013/9/3/318 Sarah Sharp (mostly) wrote: 
> > > 
> > > "In general, if checkpatch.pl complains about a variable a patch
> > > introduces that's CamelCase, you should pay attention to it.
> > > Otherwise, [] ignore it."
> > > 
> > > So, if checking a patch, scan the original patched file if it's
> > > available and add any preexisting CamelCase types so reuses do
> > > not generate CamelCase messages.
> []
> > Thanks!  Will this mean checkpatch.pl still complains on CamelCase names
> > if it's run against a file?  I think that's still valuable.
> 
> Yes.
> 
> First, checkpatch looks for all existing CamelCase #defines,
> typedefs, function names and struct/union members in the
> include path.  (it uses regexes so it's actually not at all
> close to even good at finding those).
> 
> It stores all those CamelCase uses in a hash.
> 
> If checkpatch is scanning a patch, it'll now read the file
> being patched for existing uses of CamelCase #defines, etc,
> and checkpatch adds those uses to the hash.
> 
> If checkpatch is scanning a file, it doesn't doesn't
> prescan the file.
> 
> Then, when checkpatch scans the patch or file and finds a
> CamelCase use, it looks for that use in the hash and is
> silent if it's there, noisy otherwise.
> 
> This can still report CamelCase uses in a patch if say a
> CamelCase type is defined in a .h file in the same directory
> or some other include path and that word is not already used
> by the file.

Great!  Thanks for doing this Joe.

Sarah Sharp

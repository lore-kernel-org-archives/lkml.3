Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754944Ab3GOTDI (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Jul 2013 15:03:08 -0400
Received: from perches-mx.perches.com ([206.117.179.246]:49671 "EHLO
	labridge.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1752842Ab3GOTDH (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Jul 2013 15:03:07 -0400
Message-ID: <1373914984.2062.31.camel@joe-AO722>
Subject: Re: [PATCH-v3 00/17] staging/lustre: fix various build issues
From: Joe Perches <joe@perches.com>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Andrew Morton <akpm@linux-foundation.org>
Cc: Peng Tao <bergwolf@gmail.com>, linux-kernel@vger.kernel.org,
        Fengguang Wu <fengguang.wu@intel.com>,
        Stephen Rothwell <sfr@canb.auug.org.au>,
        Andreas Dilger <andreas.dilger@intel.com>
Date: Mon, 15 Jul 2013 12:03:04 -0700
In-Reply-To: <20130715184030.GA17220@kroah.com>
References: <1373898440-14208-1-git-send-email-bergwolf@gmail.com>
	 <1373908589.2062.18.camel@joe-AO722> <20130715184030.GA17220@kroah.com>
Content-Type: text/plain; charset="ISO-8859-1"
X-Mailer: Evolution 3.6.4-0ubuntu1 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2013-07-15 at 11:40 -0700, Greg Kroah-Hartman wrote:
> On Mon, Jul 15, 2013 at 10:16:29AM -0700, Joe Perches wrote:
> > On Mon, 2013-07-15 at 22:27 +0800, Peng Tao wrote:
> > > Hi Greg,
> > > 
> > > Now that 3.11-rc1 is out, please consider queuing following patches to
> > > fix various Lustre client build issues. I've verified that we can now
> > > pass build on sparc/mips/s390/powerpc/x86, both 32bits and 64bits.
> > 
> > These patches apply to linus' current, but not to -next
> > where other lustre patches have already been applied.
> 
> What trees are those in?  I have nothing in my staging-next branch right
> now, so they didn't come from there, which is where I will be applying
> this to.
> 
> thanks,

Andrew Morton's. (added)

$ git show --summary
commit 535567f9c279c79922a3a0629aabe8cfa6423b6f
Author: Stephen Rothwell <sfr@canb.auug.org.au>
Date:   Mon Jul 15 13:37:27 2013 +1000

    Add linux-next specific files for 20130715
[]
$ git log --reverse --pretty=oneline v3.11-rc1.. -- drivers/staging/lustre/
d81f37a620988cb52ffa0468ec80c90bb003a64e staging/lustre/ldlm: convert to shrinkers to count/scan API
7abc98b89ad2797388ef9855ddf5258dfcbe79a9 staging/lustre/obdclass: convert lu_object shrinker to count/scan API
1a0bfbbda1a617e7eeaeab17750b6fe2ff521467 staging/lustre/ptlrpc: convert to new shrinker API
636e77f50994e9aa347dc4864d48786ab1e0cb37 staging/lustre/libcfs: cleanup linux-mem.h
cd27134e48276855e29e3d13dbda3eced4a78e95 staging/lustre: replace num_physpages with totalram_pages

All but the last one (cd27134e48276855e29e3d13dbda3eced4a78e95)
cherry-picks cleanly on top of these 17 patches.



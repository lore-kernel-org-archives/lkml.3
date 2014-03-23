Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752183AbaCWA6i (ORCPT <rfc822;w@1wt.eu>);
	Sat, 22 Mar 2014 20:58:38 -0400
Received: from mga02.intel.com ([134.134.136.20]:46660 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750975AbaCWA6h (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 22 Mar 2014 20:58:37 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.97,711,1389772800"; 
   d="scan'208";a="497634642"
Date: Sun, 23 Mar 2014 08:58:33 +0800
From: Fengguang Wu <fengguang.wu@intel.com>
To: Benjamin LaHaise <bcrl@kvack.org>
Cc: LKML <linux-kernel@vger.kernel.org>, lkp@01.org,
        linux-fsdevel@vger.kernel.org
Subject: Re: [aio] e52ddd946a: xfstests generic/211 fail
Message-ID: <20140323005833.GA14807@localhost>
References: <20140323004009.GA13869@localhost>
 <20140323005105.GB4173@kvack.org>
 <20140323005730.GA14629@localhost>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140323005730.GA14629@localhost>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Mar 23, 2014 at 08:57:30AM +0800, Fengguang Wu wrote:
> On Sat, Mar 22, 2014 at 08:51:05PM -0400, Benjamin LaHaise wrote:
> > On Sun, Mar 23, 2014 at 08:40:09AM +0800, Fengguang Wu wrote:
> > > Hi Benjamin,
> > > 
> > > We noticed xfstests fail and the first bad commit is
> > 
> > What is the failure?  This is awfully vague for a bug report.
> 
> In the email title: the generic/211 case of xfstests.
> 
> Here are the rough steps to reproduce the problem in KVM:
> 
> mkfs -t ext4 -q /dev/vda
> mkfs -t ext4 -q /dev/vdd
> mount -t ext4 /dev/vda /fs/vda
> mount -t ext4 /dev/vdd /fs/vdd
> export TEST_DIR=/fs/vda
> export TEST_DEV=/dev/vda
> export SCRATCH_DEV=/dev/vdd
> export SCRATCH_MNT=/fs/scratch
> mkdir /fs/scratch -p
> ./check generic/211

generic/211      [failed, exit status 1] - output mismatch (see /lkp/benchmarks/xfstests/results//generic/211.out.bad)
    --- tests/generic/211.out   2013-09-16 21:19:49.000000000 +0800
    +++ /lkp/benchmarks/xfstests/results//generic/211.out.bad   2014-03-23 02:55:53.390625000 +0800
    @@ -1,2 +1,2 @@
     QA output created by 211
    -aio-free-ring-with-bogus-nr-pages: Success!
    +aio-free-ring-with-bogus-nr-pages: Error: io_setup returned -11, expected -ENOMEM
     ...
     (Run 'diff -u tests/generic/211.out /lkp/benchmarks/xfstests/results//generic/211.out.bad' to see the entire diff)


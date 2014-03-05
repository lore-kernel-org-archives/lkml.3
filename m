Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756545AbaCECIJ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Mar 2014 21:08:09 -0500
Received: from mga14.intel.com ([143.182.124.37]:61949 "EHLO mga14.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755400AbaCECIG (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Mar 2014 21:08:06 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.97,589,1389772800"; 
   d="scan'208";a="486193022"
Date: Wed, 5 Mar 2014 10:07:46 +0800
From: Fengguang Wu <fengguang.wu@intel.com>
To: Dave Chinner <david@fromorbit.com>
Cc: Kent Overstreet <kmo@daterainc.com>, LKML <linux-kernel@vger.kernel.org>,
        lkp@01.org, linux-fsdevel@vger.kernel.org
Subject: Re: [blk-lib] 6a0608544e5: fileio -77.4% max latency, -5.7%
 throughput
Message-ID: <20140305020746.GA14711@localhost>
References: <20140304132130.GB28854@localhost>
 <20140304215225.GH11655@kmo>
 <20140305011645.GA7433@localhost>
 <20140305012352.GR13647@dastard>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140305012352.GR13647@dastard>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Mar 05, 2014 at 12:23:53PM +1100, Dave Chinner wrote:
> On Wed, Mar 05, 2014 at 09:16:45AM +0800, Fengguang Wu wrote:
> > On Tue, Mar 04, 2014 at 01:52:25PM -0800, Kent Overstreet wrote:
> > > On Tue, Mar 04, 2014 at 09:21:30PM +0800, Fengguang Wu wrote:
> > > > Hi Kent,
> > > > 
> > > > FYI, we noticed the below changes on
> > > > 
> > > > git://evilpiepirate.org/~kent/linux-bcache.git for-jens
> > > > commit 6a0608544e5672bd9a044c285119547eae41abe5 ("blk-lib.c: generic_make_request() handles large bios now")
> > > > 
> > > > test case: snb-drag/sysbench/fileio/600s-100%-1HDD-ext4-64G-1024-seqrewr-sync
> > 
> > snb-drag is the test machine, it's a SNB desktop.
> > 
> > The test command is
> > 
> >         mkfs -t ext4 -q /dev/sda2
> >         mount -t ext4 /dev/sda2 /fs/sda2
> >         cd /fs/sda2
> > 
> >         for i in $(seq 0 1023)
> >         do
> >                 fallocate -l 67108864 test_file.$i
> >         done
> > 
> >         sysbench --test=fileio --max-requests=0 --num-threads=4 --max-time=600 --file-test-mode=seqrewr --file-total-size=68719476736 --file-io-mode=sync --file-num=1024 run
> > 
> > 
> > > I'm trying to figure out how to parse this and the graphs - where do I find the
> > > test? And is there anything you can point me to for the graphs, or is that
> > > output from that test?
> > > 
> > > > 
> > > > 11541d5f5b7002b  6a0608544e5672bd9a044c285  
> > > > ---------------  -------------------------  
> > > >       1885 ~60%     -77.4%        426 ~ 7%  TOTAL fileio.request_latency_max_ms
> > 
> > The ~XX% numbers are stddev percent.
> > The [+-]XX% is change percent.
> 
> Can you put this in as column headers so that people don't have to
> this every time they see a report from you?

Good idea!

> > The below graph shows all samples collected during the bisect
> > 
> > [*] bisect-good 
> > [O] bisect-bad
> > 
> > In which you can see the stableness of the change and bisect. 
> 
> Oh, so that's what the graphs contain. :/
> 
> Again - perhaps you should include this information with the graphs
> rather than just dumping unlabelled data on people ;)

Yeah sure. I'll follow your nice suggestions!

Thanks,
Fengguang

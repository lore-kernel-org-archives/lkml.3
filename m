Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753678Ab3DMTd0 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 13 Apr 2013 15:33:26 -0400
Received: from mx1.redhat.com ([209.132.183.28]:55019 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753029Ab3DMTdZ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 13 Apr 2013 15:33:25 -0400
Date: Sat, 13 Apr 2013 15:33:20 -0400
From: Mike Snitzer <snitzer@redhat.com>
To: "Darrick J. Wong" <darrick.wong@oracle.com>
Cc: device-mapper development <dm-devel@redhat.com>,
        Kent Overstreet <koverstreet@google.com>,
        Amit Kale <akale@stec-inc.com>, linux-bcache@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: bcache/dmcache/enhanceio bake-off
Message-ID: <20130413193319.GD8156@redhat.com>
References: <20130411072239.GD8910@blackbox.djwong.org>
 <20130413160925.GA5236@debian>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20130413160925.GA5236@debian>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Apr 13 2013 at 12:09pm -0400,
Joe Thornber <thornber@redhat.com> wrote:

> Hi Darrick,
> 
> On Thu, Apr 11, 2013 at 12:22:39AM -0700, Darrick J. Wong wrote:
> > Hi all,
> > 
> > Lately I've been having some fun playing with bcache, dmcache, and enhanceio.
> 
> I pushed some tweaks to the mq policy today to my thin-dev tree.  They
> show some improvements to these fio based tests.
> 
> In addition I've written a blog post trying to explain what's going on in dm-cache:
> http://device-mapper.org/blog/2013/04/13/benchmarking-dm-cache-with-fio/

Darrick,

Joe has a few other dm-cache-target.c changes in his thin-dev branch
that are required in order to realize the gains from his mq changes.  I
haven't yet isolated which changes are important but if I just use the
3.9-rc6's dm-cache-tagret.c with thin-dev's mq changes I cannot
reproduce the improved performance Joe mentions in his blog post.

Also, even before these changes I wasn't able to reproduce your dm-cache
results (either the spike in performance or the inconsistencies you
saw across runs).

BTW, I have added 'test_fio_database_funtime' to both the cache and
bcache testsuites in my thinp-test-suite repo (master branch):
git://github.com/snitm/thinp-test-suite.git

You'd run it with somwthing like:
./run_tests --profile mix_fio --suite cache -n /test_fio_database_funtime/
or
./run_tests --profile mix_fio --suite bcache -n /test_fio_database_funtime/

I've been testing against the v3.9-rc6 kernel with Jens' for-next bcache
code merged in, see 'thin-dev-bcache' branch of my linux repo:
git://github.com/snitm/linux.git

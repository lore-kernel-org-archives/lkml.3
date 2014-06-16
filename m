Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752555AbaFPBoW (ORCPT <rfc822;w@1wt.eu>);
	Sun, 15 Jun 2014 21:44:22 -0400
Received: from imap.thunk.org ([74.207.234.97]:40068 "EHLO imap.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752309AbaFPBoV (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 15 Jun 2014 21:44:21 -0400
Date: Sun, 15 Jun 2014 21:44:15 -0400
From: "Theodore Ts'o" <tytso@mit.edu>
To: Jet Chen <jet.chen@intel.com>
Cc: Greg Price <price@mit.edu>, Fengguang Wu <fengguang.wu@intel.com>,
        Yuanhan Liu <yuanhan.liu@intel.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>, lkp@01.org
Subject: Re: [random] BUG: spinlock trylock failure on UP on CPU#0, swapper/1
Message-ID: <20140616014415.GA4887@thunk.org>
Mail-Followup-To: Theodore Ts'o <tytso@mit.edu>,
	Jet Chen <jet.chen@intel.com>, Greg Price <price@mit.edu>,
	Fengguang Wu <fengguang.wu@intel.com>,
	Yuanhan Liu <yuanhan.liu@intel.com>,
	Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
	lkp@01.org
References: <539D4776.1030804@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <539D4776.1030804@intel.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: tytso@thunk.org
X-SA-Exim-Scanned: No (on imap.thunk.org); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Jun 15, 2014 at 03:12:54PM +0800, Jet Chen wrote:
> Hi Greg,
> 
> 0day kernel testing robot got the below dmesg and the first bad commit is
> 
> git://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux.git master
> commit 0fb7a01af5b0cbe5bf365891fc4d186f2caa23f7
> Author:     Greg Price <price@MIT.EDU>
> AuthorDate: Thu Dec 5 19:32:19 2013 -0500
>
>     random: simplify accounting code

I believe I've found the problem, thanks for the report!

There was an earlier warning when this was in the random.git tree, but
I analyzed the bug report incorrectly and thought it was due to a bug
in lib/random32.c that would only show up in testing.  My bad for not
seeing the problem earlier.

The patch will be chained to this reply and sent to LKML.

  	       	     	 	  	     - Ted

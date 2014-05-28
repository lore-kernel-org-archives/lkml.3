Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754666AbaE1I6z (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 May 2014 04:58:55 -0400
Received: from e06smtp11.uk.ibm.com ([195.75.94.107]:33707 "EHLO
	e06smtp11.uk.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752074AbaE1I6s (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 May 2014 04:58:48 -0400
Date: Wed, 28 May 2014 10:58:41 +0200
From: Heiko Carstens <heiko.carstens@de.ibm.com>
To: Christoph Hellwig <hch@infradead.org>,
        Andrew Morton <akpm@linux-foundation.org>
Cc: Andrew Morton <akpm@linux-foundation.org>,
        KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
        Andrea Righi <andrea@betterlinux.com>,
        Eric Dumazet <eric.dumazet@gmail.com>, linux-kernel@vger.kernel.org,
        linux-fsdevel@vger.kernel.org,
        Hendrik Brueckner <brueckner@linux.vnet.ibm.com>,
        Thorsten Diehl <thorsten.diehl@de.ibm.com>,
        Ian Kent <raven@themaw.net>,
        "Elliott, Robert (Server Storage)" <Elliott@hp.com>
Subject: Re: /proc/stat vs. failed order-4 allocation
Message-ID: <20140528085841.GA4219@osiris>
References: <20140521122521.GB7471@osiris>
 <20140521143229.GA32011@infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140521143229.GA32011@infradead.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-TM-AS-MML: disable
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 14052808-5024-0000-0000-0000002768EA
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, May 21, 2014 at 07:32:29AM -0700, Christoph Hellwig wrote:
> On Wed, May 21, 2014 at 02:25:21PM +0200, Heiko Carstens wrote:
> > Hi all,
> > 
> > I'm just wondering why /proc/stat is a single_open() seq_file and not a
> > regular seq_file with an iterator (say 48 online cpus for each iteration
> > or something similar).
> 
> Probably because no one sent a patch for it. I'm pretty sure it used the
> even more horrible old proc ops before and was converted in batch with
> various other files.

Ok, so how about the two patches sent as reply to this mail.

(btw. if nobody objects to the modified patch from KAMEZAWA Hiroyuki the
first patch could be dropped and/or folded into the second patch)

Performance wise there doesn't seem to be too much of a difference,
however all measurements have been done a 64 cpu 2nd level guest.
It _looks_ like the new code is < 3% slower.


Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755933AbaDGSSq (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 Apr 2014 14:18:46 -0400
Received: from mx1.redhat.com ([209.132.183.28]:21126 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755566AbaDGSSp (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 Apr 2014 14:18:45 -0400
Date: Mon, 7 Apr 2014 14:18:22 -0400
From: Don Zickus <dzickus@redhat.com>
To: Jiri Olsa <jolsa@redhat.com>
Cc: acme@ghostprotocols.net, LKML <linux-kernel@vger.kernel.org>,
        jmario@redhat.com, fowles@inreach.com, Li Zefan <lizf@cn.fujitsu.com>
Subject: Re: [PATCH 2/4] perf, kmem: Utilize the new generic cpunode_map
Message-ID: <20140407181822.GE5328@redhat.com>
References: <1395689577-214654-1-git-send-email-dzickus@redhat.com>
 <1395689577-214654-3-git-send-email-dzickus@redhat.com>
 <20140329171047.GC2022@krava.redhat.com>
 <20140401024230.GR25953@redhat.com>
 <20140406122126.GE1164@krava.brq.redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140406122126.GE1164@krava.brq.redhat.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Apr 06, 2014 at 02:21:26PM +0200, Jiri Olsa wrote:
> On Mon, Mar 31, 2014 at 10:42:30PM -0400, Don Zickus wrote:
> 
> SNIP
> 
> > > > -#define PATH_SYS_NODE	"/sys/devices/system/node"
> > > > -
> > > > -static int init_cpunode_map(void)
> > > > -{
> > > > -	FILE *fp;
> > > > -	int i, err = -1;
> > > > -
> > > > -	fp = fopen("/sys/devices/system/cpu/kernel_max", "r");
> > > 
> > > so the factored code from previous patches now reads
> > > the max_cpu_num value from:
> > >   /sys/devices/system/cpu/possible
> > > 
> > > is this intentional?
> > 
> > Yeah, I was trying to save bits.  No need to allocate for 5100 cpus when
> > only 128 are used.
> > 
> > > 
> > > I think we want to have separate patches for code changes
> > > and for changing the file with some comment.
> > 
> > So you want me to split the previous patch into two.  One for code
> > movement, the other for the path change?
> 
> I think thats the proper way.. single logic change for patch

Hmm, the whole change is getting completely messy with the breakdown of
common functions, renames, use of internal functions, etc...  I'll just
break out the small change (kernel_max -> possible) from that mess.

Cheers,
Don

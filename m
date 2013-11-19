Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751582Ab3KSBsz (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Nov 2013 20:48:55 -0500
Received: from mail-qe0-f48.google.com ([209.85.128.48]:37268 "EHLO
	mail-qe0-f48.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751105Ab3KSBsx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Nov 2013 20:48:53 -0500
Date: Mon, 18 Nov 2013 20:57:16 -0500 (EST)
From: Vince Weaver <vincent.weaver@maine.edu>
To: One Thousand Gnomes <gnomes@lxorguk.ukuu.org.uk>
cc: Peter Zijlstra <peterz@infradead.org>, LKML <linux-kernel@vger.kernel.org>,
        Ingo Molnar <mingo@kernel.org>, Paul Mackerras <paulus@samba.org>,
        Arnaldo Carvalho de Melo <acme@ghostprotocols.net>, tytso@mit.edu,
        adilger.kernel@dilger.ca
Subject: Re: perf bug: bad page map
In-Reply-To: <20131118230553.32c478df@alan.etchedpixels.co.uk>
Message-ID: <alpine.DEB.2.10.1311182055490.20279@vincent-weaver-1.um.maine.edu>
References: <alpine.DEB.2.10.1311151300120.12594@vincent-weaver-1.um.maine.edu> <20131118151746.GC10022@twins.programming.kicks-ass.net> <alpine.DEB.2.10.1311181138390.18020@vincent-weaver-1.um.maine.edu> <20131118230553.32c478df@alan.etchedpixels.co.uk>
User-Agent: Alpine 2.10 (DEB 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 18 Nov 2013, One Thousand Gnomes wrote:

> On Mon, 18 Nov 2013 11:41:22 -0500 (EST)
> Vince Weaver <vincent.weaver@maine.edu> wrote:
> 
> > On Mon, 18 Nov 2013, Peter Zijlstra wrote:
> > 
> > > On Fri, Nov 15, 2013 at 01:04:23PM -0500, Vince Weaver wrote:
> > > > 
> > > > (figured out the minicom issue).
> > > > 
> > > > Anyway while trying to reproduce the last bug I instead got this with
> > > > the perf_fuzzer.
> > > > 
> > > > Is it worth continuing to run and report these issues?  I'm losing track 
> > > > of all the open bugs.
> > > 
> > > This is looks like ext4. Not entirely sure how perf ties into this.
> > 
> > It's believable the filesystem could have issues (it's a fuzzer machine, 
> > so it's had 100+ unclean shutdowns on an SSD drive in the past few months)
> > but as far as I know there shouldn't have been any filesystem accesses 
> > happening at all when the bug triggered.
> 
> Obvious question - does it pass fsck currently. If it does then
> presumably it was sane at the time it went pop ?

# e2fsck -f /dev/sda1                                                           
e2fsck 1.42.8 (20-Jun-2013)                                                     
Pass 1: Checking inodes, blocks, and sizes                                      
Pass 2: Checking directory structure                                            
Pass 3: Checking directory connectivity                                         
Pass 4: Checking reference counts                                               
Pass 5: Checking group summary information                                      
/dev/sda1: 620972/3514368 files (0.5% non-contiguous), 9796212/14047744 blocks  

so it looks clean now...

Vince

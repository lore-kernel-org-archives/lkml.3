Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752043AbaBZDMv (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Feb 2014 22:12:51 -0500
Received: from mx1.redhat.com ([209.132.183.28]:24097 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751399AbaBZDMt (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Feb 2014 22:12:49 -0500
Date: Tue, 25 Feb 2014 22:12:34 -0500
From: Don Zickus <dzickus@redhat.com>
To: Jiri Olsa <jolsa@redhat.com>
Cc: acme@ghostprotocols.net, LKML <linux-kernel@vger.kernel.org>,
        jmario@redhat.com, fowles@inreach.com, eranian@google.com
Subject: Re: [PATCH 09/21] perf, c2c: Add rbtree sorted on mmap2 data
Message-ID: <20140226031234.GR25953@redhat.com>
References: <1392053356-23024-1-git-send-email-dzickus@redhat.com>
 <1392053356-23024-10-git-send-email-dzickus@redhat.com>
 <20140218130405.GI4343@krava.brq.redhat.com>
 <20140221024553.GZ25953@redhat.com>
 <20140221165928.GB1121@krava.brq.redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140221165928.GB1121@krava.brq.redhat.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Feb 21, 2014 at 05:59:28PM +0100, Jiri Olsa wrote:
> On Thu, Feb 20, 2014 at 09:45:53PM -0500, Don Zickus wrote:
> > On Tue, Feb 18, 2014 at 02:04:05PM +0100, Jiri Olsa wrote:
> > > On Mon, Feb 10, 2014 at 12:29:04PM -0500, Don Zickus wrote:
> 
> SNIP
> 
> > > > +
> > > > +		if (l > r) return 1;
> > > > +		if (l < r) return -1;
> > > > +
> > > > +		/* sorting by iaddr makes calculations easier later */
> > > > +		if (left->mi->iaddr.al_addr > right->mi->iaddr.al_addr) return 1;
> > > > +		if (left->mi->iaddr.al_addr < right->mi->iaddr.al_addr) return -1;
> > > > +	}
> > > > +
> > > > +	return 0;
> > > > +}
> > > 
> > > there's sort object doing exatly this over hist_entry's
> > > 
> > > Is there any reason not to use hist_entries?
> > 
> > So looking over hist_entry, I realize, what do I gain?  I implemented it
> > and realized I had to add, 'cpumode', 'tid' and a 'private' field to
> > struct hist_entry.  Then because I have my own report implementation, I
> > still have to copy and paste a ton of stuff from builtin-report over to
> > here (including callchain support).
> 
> you mean new sort_entry objects?
> 
> > 
> > Not unless you are expecting me to add giant chunks of code to
> > builtin-report.c?
> 
> it can be separated object, implementing new report iterator
> 
> I think that we should go on with existing sort code we have..
> but I understand you might need some special usage.. i'll dive
> in and try to find some answer ;-)

Do things fall apart if I do not use evsel->hists to store the hist_entry
tree?  I need to combine two events (store and load) on to the same tree.

Cheers,
Don

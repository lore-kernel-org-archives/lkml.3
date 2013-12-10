Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754416Ab3LJQ0y (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Dec 2013 11:26:54 -0500
Received: from mail-wi0-f182.google.com ([209.85.212.182]:41840 "EHLO
	mail-wi0-f182.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752798Ab3LJQ0v (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Dec 2013 11:26:51 -0500
Date: Tue, 10 Dec 2013 17:26:47 +0100
From: Frederic Weisbecker <fweisbec@gmail.com>
To: Oleg Nesterov <oleg@redhat.com>
Cc: suravee.suthikulpanit@amd.com, mingo@kernel.org, mingo@redhat.com,
        jacob.w.shin@gmail.com, a.p.zijlstra@chello.nl,
        acme@ghostprotocols.net, hpa@zytor.com, tgl@domain.invalid,
        linux-kernel@vger.kernel.org, sherry.hurwitz@amd.com
Subject: Re: [PATCH 2/3] perf tools: allow user to specify hardware
 breakpoint bp_len
Message-ID: <20131210162646.GH10633@localhost.localdomain>
References: <1380730268-25807-1-git-send-email-suravee.suthikulpanit@amd.com>
 <1380730268-25807-3-git-send-email-suravee.suthikulpanit@amd.com>
 <20131210152532.GF10633@localhost.localdomain>
 <20131210162229.GB23086@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20131210162229.GB23086@redhat.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Dec 10, 2013 at 05:22:29PM +0100, Oleg Nesterov wrote:
> On 12/10, Frederic Weisbecker wrote:
> >
> > On Wed, Oct 02, 2013 at 11:11:07AM -0500, suravee.suthikulpanit@amd.com wrote:
> > > @@ -525,14 +525,11 @@ int parse_events_add_breakpoint(struct list_head *list, int *idx,
> > >  	if (parse_breakpoint_type(type, &attr))
> > >  		return -EINVAL;
> > >
> > > -	/*
> > > -	 * We should find a nice way to override the access length
> > > -	 * Provide some defaults for now
> > > -	 */
> > > -	if (attr.bp_type == HW_BREAKPOINT_X)
> > > -		attr.bp_len = sizeof(long);
> > > -	else
> > > -		attr.bp_len = HW_BREAKPOINT_LEN_4;
> > > +	/* Provide some defaults if len is not specified */
> > > +	if (!len)
> > > +		len = attr.bp_type == HW_BREAKPOINT_X ? sizeof(long) :
> > > +							HW_BREAKPOINT_LEN_4;
> >
> > Why is LEN_4 affected in the type?
> 
> Hmm, what do you mean?

I got confused (as usual) by the x = y == foo ? bar : stuff;

I suggest we avoid that kind of coding style, at least to spare repeated confused
and annoying emails from me ;-)

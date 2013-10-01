Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752482Ab3JAU2P (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 Oct 2013 16:28:15 -0400
Received: from e39.co.us.ibm.com ([32.97.110.160]:58130 "EHLO
	e39.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751444Ab3JAU2D (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 Oct 2013 16:28:03 -0400
Date: Tue, 1 Oct 2013 13:27:56 -0700
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: Tibor Billes <tbilles@gmx.com>
Cc: linux-kernel@vger.kernel.org
Subject: Re: Unusually high system CPU usage with recent kernels
Message-ID: <20131001202756.GK5790@linux.vnet.ibm.com>
Reply-To: paulmck@linux.vnet.ibm.com
References: <20130914135951.288070@gmx.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20130914135951.288070@gmx.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-TM-AS-MML: No
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 13100120-9332-0000-0000-0000019C71E4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Sep 14, 2013 at 03:59:51PM +0200, Tibor Billes wrote:
> > From: Paul E. McKenney Sent: 09/13/13 02:19 AM
> > On Wed, Sep 11, 2013 at 08:46:04AM +0200, Tibor Billes wrote:
> > > > From: Paul E. McKenney Sent: 09/09/13 10:44 PM

[ . . . ]

> > > Sure. The attached tar file contains traces of good kernels. The first is with
> > > version 3.9.7 (no patch applied) which was the last stable kernel I tried and
> > > didn't have this issue. The second is version 3.11 with your fix applied.
> > > Judging by the size of the traces, 3.11.0+ is still doing more work than
> > > 3.9.7.
> > 
> > Indeed, though quite a bit less than the problematic traces.
> > 
> > Did you have all three patches applied to 3.11.0, or just the last one?
> > If the latter, could you please try it with all three?
> 
> Only the last one was applied to 3.11.0. The attachement now contains the
> RCU trace with all thee applied. It seems to be smaller in size, but still
> not close to 3.9.7.
> 
> > > > > I'm not sure about LKML policies about attaching not-so-small files to
> > > > > emails, so I've dropped LKML from the CC list. Please CC the mailing
> > > > > list in your reply.
> > > > 
> > > > Done!
> > > > 
> > > > Another approach is to post the traces on the web and send the URL to
> > > > LKML. But whatever works for you is fine by me.
> > > 
> > > Sending directly to you won again :) Could you please CC the list in your
> > > reply?
> > 
> > Done! ;-)
> 
> Could you please CC the list in your reply again? :)

This trace is quite strange -- there are a number of processes that sleep
and then wake up almost immediately, as in within a microsecond or so.
I don't know why they would be doing that, and I also cannot think of
what RCU might be doing to make them do that.

I am unfortunately out of ideas on this one.

							Thanx, Paul


Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933464Ab3CGV0K (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Mar 2013 16:26:10 -0500
Received: from mx1.redhat.com ([209.132.183.28]:55765 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933421Ab3CGV0I (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Mar 2013 16:26:08 -0500
Date: Thu, 7 Mar 2013 18:25:52 -0300
From: Marcelo Tosatti <mtosatti@redhat.com>
To: Michael Wolf <mjw@linux.vnet.ibm.com>
Cc: Frederic Weisbecker <fweisbec@gmail.com>, linux-kernel@vger.kernel.org,
        riel@redhat.com, gleb@redhat.com, kvm@vger.kernel.org,
        peterz@infradead.org, glommer@parallels.com, mingo@redhat.com,
        anthony@codemonkey.ws
Subject: Re: [PATCH 0/4] Alter steal-time reporting in the guest
Message-ID: <20130307212552.GB22196@amt.cnet>
References: <20130205214818.4615.12937.stgit@lambeau>
 <CAFTL4hyYO7s2u-dRLExA1=TxD00O1XyPe9qFwnODrWi_p92Jqg@mail.gmail.com>
 <20130219011104.GA5785@amt.cnet>
 <1362514928.6267.16.camel@lambeau>
 <20130306014151.GB11481@amt.cnet>
 <1362587233.6373.4.camel@lambeau>
 <20130307023026.GA30310@amt.cnet>
 <1362690909.31276.27.camel@lambeau>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1362690909.31276.27.camel@lambeau>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Mar 07, 2013 at 03:15:09PM -0600, Michael Wolf wrote:
> > 
> > Makes sense?
> > 
> > Not sure what the concrete way to report stolen time relative to hard
> > capping is (probably easier inside the scheduler, where run_delay is
> > calculated).
> > 
> > Reporting the hard capping to the guest is a good idea (which saves the
> > user from having to measure it themselves), but better done separately
> > via new field.
> 
> didnt respond to this in the previous response.  I'm not sure I'm
> following you here.  I thought this is what I was doing by having a
> consigned (expected steal) field add to the /proc/stat output.  Are you
> looking for something else or a better naming convention?

Expected steal is not a good measure to use (because as mentioned in the
previous email there is no expected steal over a fixed period of time).

It is fine to report 'maximum percentage of underlying physical CPU'
(what percentage of the physical CPU time guest VM is allowed to make
use of).

And then steal time is relative to maximum percentage of underlying
physical CPU time allowed.


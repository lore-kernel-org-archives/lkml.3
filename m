Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752385AbaAXEHT (ORCPT <rfc822;w@1wt.eu>);
	Thu, 23 Jan 2014 23:07:19 -0500
Received: from out4-smtp.messagingengine.com ([66.111.4.28]:48267 "EHLO
	out4-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751916AbaAXEHR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 23 Jan 2014 23:07:17 -0500
X-Sasl-enc: aArBl9UVsXxWLyrRi8ldExFDKrgfjc2O7mZSabPcTcJH 1390536436
Date: Thu, 23 Jan 2014 20:08:08 -0800
From: Greg KH <greg@kroah.com>
To: Stephen Rothwell <sfr@canb.auug.org.au>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        "Luis R. Rodriguez" <mcgrof@do-not-panic.com>,
        David Miller <davem@davemloft.net>
Subject: Re: linux-next: build failure after merge of the staging tree
Message-ID: <20140124040808.GA25507@kroah.com>
References: <20140124130122.017195b49e852e4e42b77997@canb.auug.org.au>
 <20140124035312.GA31095@kroah.com>
 <20140124150401.c0cc951a93341b569b21f749@canb.auug.org.au>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140124150401.c0cc951a93341b569b21f749@canb.auug.org.au>
User-Agent: Mutt/1.5.22 (2013-10-16)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jan 24, 2014 at 03:04:01PM +1100, Stephen Rothwell wrote:
> Hi Greg,
> 
> On Thu, 23 Jan 2014 19:53:12 -0800 Greg KH <greg@kroah.com> wrote:
> >
> > On Fri, Jan 24, 2014 at 01:01:22PM +1100, Stephen Rothwell wrote:
> > > 
> > > After merging the staging tree, today's linux-next build (x86_64
> > > allmodconfig) failed like this:
> > > 
> > > drivers/staging/rtl8821ae/regd.c: In function '_rtl_reg_apply_beaconing_flags':
> > > drivers/staging/rtl8821ae/regd.c:200:20: error: 'IEEE80211_CHAN_NO_IBSS' undeclared (first use in this function)
> > >       ch->flags &= ~IEEE80211_CHAN_NO_IBSS;
> > 
> > Wait, I can't duplicate this at all here, either on just my staging-next
> > branch, or when merged together with Linus's tree.
> > 
> > Can you send me your .config that you used to cause this to fail
> > (allmodconfig works just fine here.)
> > 
> > Could this all be due to some wireless patches that aren't merged with
> > Linus yet but are in linux-next?
> 
> Yep, commit 8fe02e167efa ("cfg80211: consolidate passive-scan and no-ibss
> flags") from the net-next tree.

Ah, that makes more sense now, thanks.

> > If this is going to be a pain, I can easily drop it all and just wait
> > for 3.15-rc1, but it being a stand-alone driver, that works for hardware
> > I have here (and rumor has it, Linus also has this box), I figured I
> > would try to stay ahead of the curve and get it merged :)
> 
> That would require that I fix up the semantic merge conflicts on
> Tuesday (I have a long weekend).  Unless you wait just until Dave merges
> his tree and then base on top of that (or do a back merge of Linus' tree).

I'll wait till Dave merges his tree and then fix it up here before
sending it on.  After 3.14-rc1 is out is fine as well.  Don't worry
about doing any work on your end, it's a staging driver, it isn't worth
it :)

thanks,

greg k-h

Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S964784AbaFZCUH (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Jun 2014 22:20:07 -0400
Received: from out1-smtp.messagingengine.com ([66.111.4.25]:46670 "EHLO
	out1-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755213AbaFZCUF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Jun 2014 22:20:05 -0400
X-Sasl-enc: tuJ+FtMxjnR0p+P/OZc8T4F3InKCS7TyRCEqlyroGHtj 1403749203
Message-ID: <1403749201.2969.18.camel@perseus.fritz.box>
Subject: Re: [PATCH 0/2] /proc/stat vs. failed order-4 allocation
From: Ian Kent <raven@themaw.net>
To: Heiko Carstens <heiko.carstens@de.ibm.com>
Cc: David Rientjes <rientjes@google.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Hendrik Brueckner <brueckner@linux.vnet.ibm.com>,
        Thorsten Diehl <thorsten.diehl@de.ibm.com>,
        Andrea Righi <andrea@betterlinux.com>,
        Christoph Hellwig <hch@infradead.org>,
        Al Viro <viro@zeniv.linux.org.uk>,
        Stefan Bader <stefan.bader@canonical.com>,
        linux-kernel@vger.kernel.org
Date: Thu, 26 Jun 2014 10:20:01 +0800
In-Reply-To: <20140625061551.GA4260@osiris>
References: <1402909492-36486-1-git-send-email-heiko.carstens@de.ibm.com>
	 <20140618142931.857d57fe0007a361404f6cab@linux-foundation.org>
	 <20140621091058.GC3463@osiris>
	 <20140623160414.f64bcfbfc3f40b4844552427@linux-foundation.org>
	 <alpine.DEB.2.02.1406241650340.22030@chino.kir.corp.google.com>
	 <20140625061551.GA4260@osiris>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.10.4 (3.10.4-2.fc20) 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2014-06-25 at 08:15 +0200, Heiko Carstens wrote:
> On Tue, Jun 24, 2014 at 04:52:22PM -0700, David Rientjes wrote:
> > On Mon, 23 Jun 2014, Andrew Morton wrote:
> > > On Sat, 21 Jun 2014 11:10:58 +0200 Heiko Carstens <heiko.carstens@de.ibm.com> wrote:
> > > > On Wed, Jun 18, 2014 at 02:29:31PM -0700, Andrew Morton wrote:
> > > > > I'm unclear on how urgent these fixes are.  I semi-randomly tagged them
> > > > > for 3.16 with a -stable backport, but that could be changed?
> > > > 
> > > > I assume tagged for 3.16 means you intend to get it merged before 3.16
> > > > gets released?
> > > > If so, then that would be fine with me.
> > > 
> > > um, actually, no, sorry, I meant merge for 3.17-rc1 with a -stable backport.
> > > 
> > > We can do 3.16 of course, but for what reasons?
> > 
> > Heiko's patches should also fix 
> > https://bugs.launchpad.net/ubuntu/+source/linux/+bug/1319244 as reported 
> > by Stefan Bader.  I've pinged them to determine if there is any other 
> > issues with -mm.
> 
> The other distribution where this has been seen was RHEL7 (on s390).
> 
> FWIW, I thought there was a 'rule' that patches with a -stable tag shouldn't
> stay in -next for a couple of rc releases. But then again that probably was
> just a discussion somewhere.
> Anyway, if neither Stefan or Ian speak up I'm fine with post 3.16 as well.
> 

It's very much up to Andrew, of course.

I would like to see this go in sooner rather than later, if possible,
due to the potential RHEL-7 disruption it can cause. More so now the
above shows we can see this on other architectures and higher speced
machines.

Looking at the patches it appears there's no change from the original
semantics.

So the potential for regression is fairly low now since Heiko's patches
are much simpler than the original proposal and are much more straight
forward to review, so much so that they make sense even to me!

Ian


Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752733AbbAUOi3 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 Jan 2015 09:38:29 -0500
Received: from fieldses.org ([174.143.236.118]:40134 "EHLO fieldses.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752911AbbAUOiV (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 Jan 2015 09:38:21 -0500
Date: Wed, 21 Jan 2015 09:38:19 -0500
From: "J. Bruce Fields" <bfields@fieldses.org>
To: Ian Kent <ikent@redhat.com>
Cc: Kernel Mailing List <linux-kernel@vger.kernel.org>,
        David Howells <dhowells@redhat.com>,
        Oleg Nesterov <onestero@redhat.com>,
        Trond Myklebust <trond.myklebust@primarydata.com>,
        Benjamin Coddington <bcodding@redhat.com>,
        Al Viro <viro@ZenIV.linux.org.uk>,
        Jeff Layton <jeff.layton@primarydata.com>,
        "Eric W. Biederman" <ebiederm@xmission.com>
Subject: Re: [RFC PATCH 0/5] Second attempt at contained helper execution
Message-ID: <20150121143819.GA28392@fieldses.org>
References: <20150114092704.30252.60446.stgit@pluto.fritz.box>
 <20150114215525.GB7071@fieldses.org>
 <20150114221011.GC7071@fieldses.org>
 <1421281572.2688.4.camel@pluto.fritz.box>
 <20150115162741.GA14902@fieldses.org>
 <1421370073.2630.4.camel@pluto.fritz.box>
 <20150116152527.GD17315@fieldses.org>
 <1421823925.2789.3.camel@pluto.fritz.box>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1421823925.2789.3.camel@pluto.fritz.box>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jan 21, 2015 at 03:05:25PM +0800, Ian Kent wrote:
> On Fri, 2015-01-16 at 10:25 -0500, J. Bruce Fields wrote:
> > On Fri, Jan 16, 2015 at 09:01:13AM +0800, Ian Kent wrote:
> > > On Thu, 2015-01-15 at 11:27 -0500, J. Bruce Fields wrote:
> > > > On Thu, Jan 15, 2015 at 08:26:12AM +0800, Ian Kent wrote:
> > > > > On Wed, 2015-01-14 at 17:10 -0500, J. Bruce Fields wrote:
> > > > > > > On Wed, Jan 14, 2015 at 05:32:22PM +0800, Ian Kent wrote:
> > > > > > > > There are other difficulties to tackle as well, such as how to decide
> > > > > > > > if contained helper execution is needed. For example, if a mount has
> > > > > > > > been propagated to a container or bound into the container tree (such
> > > > > > > > as with the --volume option of "docker run") the root init namespace
> > > > > > > > may need to be used and not the container namespace.
> > > > > > 
> > > > > > I think you have to go through each of the existing upcall examples and
> > > > > > decide what's needed for each.
> > > > > > 
> > > > > > At least for the nfsv4 idmapper I would've thought the namespace the
> > > > > > mount was done in would be the right choice, hence my previous question.
> > > > > 
> > > > > Probably but you don't necessarily know what namespace the mount was
> > > > > done in. It may have been propagated from another namespace or (although
> > > > > I don't think it works yet) bound from another container using the
> > > > > volumes-from docker option.
> > > > 
> > > > Name-id mappings should be associated with the superblock, I guess--so
> > > > don't you store a pointer to the right thing there?
> > > 
> > > Quite possibly but my original point was, without an acceptable
> > > mechanism to execute the helper we can't know what might need to be done
> > > to use it.
> > 
> > At least for me it would be easier to review if it came with at least
> > one example user.
> 
> Haven't seen any negative responses but perhaps people are still away
> over Xmas.
> 
> In the mean time it's probably a good idea to add some use cases to the
> series in case the approach is OK.
> 
> I'll have a look at the nfsd code and see if I can spot the places.

On the nfsd side it's just the one call_usermodehelper in
fs/nfsd/nfs4recover.c.  The tricky part is figuring out where the
namespace information should come from.

--b.

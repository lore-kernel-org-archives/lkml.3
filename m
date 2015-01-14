Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754131AbbANWKO (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Jan 2015 17:10:14 -0500
Received: from fieldses.org ([174.143.236.118]:41720 "EHLO fieldses.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751850AbbANWKM (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Jan 2015 17:10:12 -0500
Date: Wed, 14 Jan 2015 17:10:11 -0500
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
Message-ID: <20150114221011.GC7071@fieldses.org>
References: <20150114092704.30252.60446.stgit@pluto.fritz.box>
 <20150114215525.GB7071@fieldses.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20150114215525.GB7071@fieldses.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> On Wed, Jan 14, 2015 at 05:32:22PM +0800, Ian Kent wrote:
> > There are other difficulties to tackle as well, such as how to decide
> > if contained helper execution is needed. For example, if a mount has
> > been propagated to a container or bound into the container tree (such
> > as with the --volume option of "docker run") the root init namespace
> > may need to be used and not the container namespace.

I think you have to go through each of the existing upcall examples and
decide what's needed for each.

At least for the nfsv4 idmapper I would've thought the namespace the
mount was done in would be the right choice, hence my previous question.

--b.

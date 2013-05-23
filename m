Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759248Ab3EWUPG (ORCPT <rfc822;w@1wt.eu>);
	Thu, 23 May 2013 16:15:06 -0400
Received: from fieldses.org ([174.143.236.118]:41776 "EHLO fieldses.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758293Ab3EWUPF (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 23 May 2013 16:15:05 -0400
Date: Thu, 23 May 2013 16:14:31 -0400
From: "J. Bruce Fields" <bfields@fieldses.org>
To: Jeff Layton <jlayton@redhat.com>
Cc: Boaz Harrosh <bharrosh@panasas.com>,
        Stanislav Kinsbursky <skinsbursky@parallels.com>,
        "Eric W. Biederman" <ebiederm@xmission.com>, viro@zeniv.linux.org.uk,
        serge.hallyn@canonical.com, lucas.demarchi@profusion.mobi,
        rusty@rustcorp.com.au, linux-kernel@vger.kernel.org, oleg@redhat.com,
        linux-fsdevel@vger.kernel.org, akpm@linux-foundation.org,
        devel@openvz.org
Subject: Re: [RFC PATCH] fs: call_usermodehelper_root helper introduced
Message-ID: <20130523201431.GB13640@fieldses.org>
References: <519DCE5D.6070204@parallels.com>
 <87k3mq9fsu.fsf@xmission.com>
 <519DF109.9010309@parallels.com>
 <20130523073108.13afafa6@tlielax.poochiereds.net>
 <519DFFA9.3010606@parallels.com>
 <20130523075620.21abf79a@tlielax.poochiereds.net>
 <519E0474.5000606@parallels.com>
 <519E0AB0.7040704@panasas.com>
 <20130523090526.63fc153e@corrin.poochiereds.net>
 <20130523195547.GA13640@fieldses.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20130523195547.GA13640@fieldses.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, May 23, 2013 at 03:55:47PM -0400, J. Bruce Fields wrote:
> On Thu, May 23, 2013 at 09:05:26AM -0400, Jeff Layton wrote:
> > What might help most here is to lay out a particular scenario for how
> > you envision setting up knfsd in a container so we can ensure that it's
> > addressed properly by whatever solution you settle on.

BTW the problem I have here is that the only case I've personally had
any interest in is using network and file namespaces to isolate nfsd's
to make them safe to migrate across nodes of a cluster.

So while the idea of making user namespaces and unprivileged knfsd and
the rest work is really interesting and I'm happy to think about it, I'm
not sure how feasible or useful it is.

I'd therefore actually prefer just to take something like Stanislav's
patch now and put off the problem of how to make it work correctly with
user namespaces until we actually turn that on.  His patch fixes a real
bug that we have now, while user-namespaced-nfsd still sounds a bit
pie-in-the-sky to me.


But maybe I don't understand why Eric thinks nfsd in usernamespaces is
imminent.  Or maybe I'm missing some security problem that Stanislav's
patch would introduce now without allowing nfsd to run in a user
namespace.

--b.

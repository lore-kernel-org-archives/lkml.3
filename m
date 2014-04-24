Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751246AbaDXEKp (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Apr 2014 00:10:45 -0400
Received: from out4-smtp.messagingengine.com ([66.111.4.28]:48718 "EHLO
	out4-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750703AbaDXEKm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Apr 2014 00:10:42 -0400
X-Sasl-enc: DTQigDx2w+FkNVfrps7pjoW30f7ALzrrtpVppCGkTqGS 1398312641
Message-ID: <1398312638.2818.4.camel@perseus.fritz.box>
Subject: Re: [PATCH] autofs - fix lockref lookup
From: Ian Kent <raven@themaw.net>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: autofs mailing list <autofs@vger.kernel.org>,
        Kernel Mailing List <linux-kernel@vger.kernel.org>
Date: Thu, 24 Apr 2014 12:10:38 +0800
In-Reply-To: <20140423144624.716f325d454f9debd97bef15@linux-foundation.org>
References: <20140423052035.5999.69412.stgit@perseus.fritz.box>
	 <20140423144624.716f325d454f9debd97bef15@linux-foundation.org>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.6.4 (3.6.4-3.fc18) 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2014-04-23 at 14:46 -0700, Andrew Morton wrote:
> On Wed, 23 Apr 2014 13:20:36 +0800 Ian Kent <raven@themaw.net> wrote:
> 
> > autofs needs to be able to see private data dentry flags for
> > its dentrys that are being created but not yet hashed and for
> > its dentys that have been rmdir()ed but not yet freed. It
> > needs to do this so it can block processes in these states
> > until a status has been returned to indicate the given
> > operation is complete.
> > 
> > It does this by keeping two lists, active and expring, of
> > dentrys in this state and uses ->d_release() to keep them
> > stable while it checks the reference count to determine
> > if they should be used.
> > 
> > But with the recent lockref changes dentrys being freed
> > sometimes don't transition to a reference count of 0 before
> > being freed so autofs can occassionally use a dentry that
> > is invalid which can lead to a panic.
> 
> What's the value of "recent"?  I assume 3.14 is OK?

I'll need to look again but from memory it's broken from 3.12 onward.

The breakage happened when lockref_mark_dead() was introduced because it
sets lockref->count = -128 instead of reducing count by one as was done
previously.

Ian
  



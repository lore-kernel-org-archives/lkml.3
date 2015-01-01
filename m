Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751543AbbAAABx (ORCPT <rfc822;w@1wt.eu>);
	Wed, 31 Dec 2014 19:01:53 -0500
Received: from zeniv.linux.org.uk ([195.92.253.2]:51458 "EHLO
	ZenIV.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751430AbbAAABw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 31 Dec 2014 19:01:52 -0500
Date: Thu, 1 Jan 2015 00:01:49 +0000
From: Al Viro <viro@ZenIV.linux.org.uk>
To: Paul Moore <paul@paul-moore.com>
Cc: Linus Torvalds <torvalds@linux-foundation.org>, linux-audit@redhat.com,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: [GIT PULL] Audit fixes for 3.19 #2
Message-ID: <20150101000149.GP22149@ZenIV.linux.org.uk>
References: <3159430.4MhUX0bhoZ@sifl>
 <CA+55aFzwqafHa6ARO-zkCDaHZozZDDvETBMmbnvNsnu1L9v2=w@mail.gmail.com>
 <3787508.5gHb8qD3XR@sifl>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <3787508.5gHb8qD3XR@sifl>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Dec 31, 2014 at 05:08:12PM -0500, Paul Moore wrote:

> The getname/putname hacks work in the normal file case, but it falls apart 
> when you start talking about AF_UNIX socket files where the filename string 
> doesn't go through the getname/putname refcount tricks.  In the past (no idea 
> how far back this goes off the top of my head) this wasn't an issue since the 
> code which recorded the filenames in the audit records was broken, but since 
> we just "fixed" that problem, the AF_UNIX socket problem is now making an 
> appearance.
> 
> At least that is how it looks to me right now, if I'm wrong about this and I'm 
> missing an obvious fix I'm all ears/eyes/etc.

Umm...  How about just adding a function that would be used instead of
all those
        struct filename filename = { .name = name };
and created an object that would be destroyed later by putname()?

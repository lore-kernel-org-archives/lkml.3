Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756683AbaJ2Tsp (ORCPT <rfc822;w@1wt.eu>);
	Wed, 29 Oct 2014 15:48:45 -0400
Received: from mx1.redhat.com ([209.132.183.28]:58075 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755698AbaJ2Tso (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 29 Oct 2014 15:48:44 -0400
Date: Wed, 29 Oct 2014 15:48:40 -0400
From: Richard Guy Briggs <rgb@redhat.com>
To: Paul Moore <pmoore@redhat.com>
Cc: Eric Paris <eparis@redhat.com>, Steve Grubb <sgrubb@redhat.com>,
        linux-audit@redhat.com, linux-kernel@vger.kernel.org, aviro@redhat.com
Subject: Re: [PATCH V5 0/5] audit by executable name
Message-ID: <20141029194840.GL20866@madcap2.tricolour.ca>
References: <cover.1412303728.git.rgb@redhat.com>
 <3623738.X9Kq6ePK5C@sifl>
 <1413929992.30946.59.camel@localhost>
 <13346524.UcV0TUOQcF@sifl>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <13346524.UcV0TUOQcF@sifl>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 14/10/21, Paul Moore wrote:
> On Tuesday, October 21, 2014 06:19:52 PM Eric Paris wrote:
> > On Tue, 2014-10-21 at 17:56 -0400, Paul Moore wrote:
> > > * Change the audit_status.version field comment in
> > > include/uapi/linux/audit.h to "/* audit functionality bitmap */", or
> > > similar.  We can't really change the structure now, but the comment is
> > > fair game.
> > 
> > Trying to think how to do things with a #define so you can rename,
> > "version" is pretty darn generic to pre-process.  You could make it a
> > union, so userspace code and use a sane name....
> 
> Yeah, I thought about suggesting the #define approach but figured that might 
> just be me worrying about the color of the paint ... okay, Richard, why don't 
> you go ahead and change the version field name and put in a #define for 
> compatibility.

The #define is a nice way to work around backward compatibility.

> > > Can anyone think of anything else that might be affected by this?
> > 
> > No one uses this stuff, just change it.
> 
> Yes, but I feel like I need to at least ask the question; how much attention I 
> pay to the answers is something else ...

I'm still skeptical this won't blow up...  Like the capabilities bitmap
did.  I suspect there isn't agreement on what constitutes a feature.  We
just added a set/get features bitmap a year ago for things to be turned
on/off and locked...  How does this features bitmap fit in with that
features config?

I don't disagree that a bitmap would be more useful for various
distributions to pick and choose that which they choose to support over
a version number that won't tell the whole story.

> paul moore

- RGB

--
Richard Guy Briggs <rbriggs@redhat.com>
Senior Software Engineer, Kernel Security, AMER ENG Base Operating Systems, Red Hat
Remote, Ottawa, Canada
Voice: +1.647.777.2635, Internal: (81) 32635, Alt: +1.613.693.0684x3545

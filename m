Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756664Ab3C1QaI (ORCPT <rfc822;w@1wt.eu>);
	Thu, 28 Mar 2013 12:30:08 -0400
Received: from claranet-outbound-smtp05.uk.clara.net ([195.8.89.38]:46136 "EHLO
	claranet-outbound-smtp05.uk.clara.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756388Ab3C1QaH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 28 Mar 2013 12:30:07 -0400
From: Tvrtko Ursulin <tvrtko.ursulin@onelan.co.uk>
To: Ram Pai <linuxram@us.ibm.com>
Cc: linux-kernel <linux-kernel@vger.kernel.org>, linux-fsdevel@vger.kernel.org,
        Al Viro <viro@zeniv.linux.org.uk>
Subject: Re: Change in behaviour when unmounting recursive bind mounts
Date: Thu, 28 Mar 2013 16:29:47 +0000
Message-ID: <1845538.MuH6UK6OzG@deuteros>
User-Agent: KMail/4.10.1 (Linux/3.8.4; KDE/4.10.1; x86_64; ; )
In-Reply-To: <20130328153549.GP6400@ram.oc3035372033.ibm.com>
References: <2987308.JNKpYDEnfV@deuteros> <1694652.5MYOe5IR6S@deuteros> <20130328153549.GP6400@ram.oc3035372033.ibm.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thursday 28 March 2013 23:35:49 Ram Pai wrote:
> On Thu, Mar 28, 2013 at 01:05:56PM +0000, Tvrtko Ursulin wrote:
> > Hi,
> > 
> > On Thursday 28 March 2013 11:03:51 Ram Pai wrote:
> > > I tried these commands on a 3.8.0-rc1+ kernel and did not find the
> > > problem. Is this on a recent kernel?
> > 
> > I am on Fedora 17 latest, but I've seen this problem with different
> > kernels. Pretty sure from 3.5 something to 3.8 something. All Fedora
> > flavoured. I will try vanilla soon.
> > 
> > What I am not sure is whether this behaviour was there from the start (on
> > Fedora 17). I *think* it started to happen later on, which would mean a
> > potential userland change somehow causes it.
> > 
> > Would that be at all possible with some mechanism?
> > 
> > > > Previously unmounting the recursive bind target would not unmount the
> > > > source, which to me looks like a more sensible outcome.
> > > 
> > > yes. it should not unless they are peer-mounts, which in your case is
> > > not.
> > 
> > What are these and how to create them?
> 
> These are mounts that are created by marking mount as shared, followed
> by bind mount, followed by submount and then unmount.
> 
> Documentation/filesystem/sharedsubtree.txt has the details.

Knowing the right keywords certainly enabled me to hunt it down, thanks!

Culprit is systemd as per following commit:  
http://cgit.freedesktop.org/systemd/systemd/commit/?id=b3ac5f8cb98757416d8660023d6564a7c411f0a0

Regards,

Tvrtko


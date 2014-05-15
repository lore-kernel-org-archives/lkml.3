Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751164AbaEOEAd (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 May 2014 00:00:33 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:50724 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750724AbaEOEAc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 May 2014 00:00:32 -0400
Date: Wed, 14 May 2014 21:00:32 -0700
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: "Michael H. Warfield" <mhw@WittsEnd.com>, linux-kernel@vger.kernel.org,
        Jens Axboe <axboe@kernel.dk>, Arnd Bergmann <arnd@arndb.de>,
        Eric Biederman <ebiederm@xmission.com>,
        Serge Hallyn <serge.hallyn@canonical.com>,
        lxc-devel@lists.linuxcontainers.org
Subject: Re: [lxc-devel] [RFC PATCH 00/11] Add support for devtmpfs in user
 namespaces
Message-ID: <20140515040032.GA6702@kroah.com>
References: <1400103299-144589-1-git-send-email-seth.forshee@canonical.com>
 <20140515013245.GA1764@kroah.com>
 <1400120251.7699.11.camel@canyon.ip6.wittsend.com>
 <20140515031527.GA146352@ubuntu-hedt>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140515031527.GA146352@ubuntu-hedt>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, May 14, 2014 at 10:15:27PM -0500, Seth Forshee wrote:
> On Wed, May 14, 2014 at 10:17:31PM -0400, Michael H. Warfield wrote:
> > > > Using devtmpfs is one possible
> > > > solution, and it would have the added benefit of making container setup
> > > > simpler. But simply letting containers mount devtmpfs isn't sufficient
> > > > since the container may need to see a different, more limited set of
> > > > devices, and because different environments making modifications to
> > > > the filesystem could lead to conflicts.
> > > > 
> > > > This series solves these problems by assigning devices to user
> > > > namespaces. Each device has an "owner" namespace which specifies which
> > > > devtmpfs mount the device should appear in as well allowing priveleged
> > > > operations on the device from that namespace. This defaults to
> > > > init_user_ns. There's also an ns_global flag to indicate a device should
> > > > appear in all devtmpfs mounts.
> > 
> > > I'd strongly argue that this isn't even a "problem" at all.  And, as I
> > > said at the Plumbers conference last year, adding namespaces to devices
> > > isn't going to happen, sorry.  Please don't continue down this path.
> > 
> > I was just mentioning that to Serge just a week or so ago reminding him
> > of what you told all of us face to face back then.  We were having a
> > discussion over loop devices into containers and this topic came up.
> 
> It was the loop device use case that got me started down this path in
> the first place, so I don't personally have any interest in physical
> devices right now (though I was sure others would).

Why do you want to give access to a loop device to a container?
Shouldn't you set up the loop devices before creating the container and
then pass those mount points into the container?  I thought that was how
things worked today, or am I missing something?

Giving the ability for a container to create a loop device at all is a
horrid idea, as you have pointed out, lots of information leakage could
easily happen.

greg k-h

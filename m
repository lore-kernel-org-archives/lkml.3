Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757157AbaFYWQS (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Jun 2014 18:16:18 -0400
Received: from atrey.karlin.mff.cuni.cz ([195.113.26.193]:43014 "EHLO
	atrey.karlin.mff.cuni.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755730AbaFYWQR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Jun 2014 18:16:17 -0400
Date: Thu, 26 Jun 2014 00:15:48 +0200
From: Pavel Machek <pavel@ucw.cz>
To: Thomas Knauth <thomas.knauth@gmx.de>
Cc: dedekind1@gmail.com, David Rientjes <rientjes@google.com>,
        Maksym Planeta <mcsim.planeta@gmail.com>,
        Alexander Viro <viro@zeniv.linux.org.uk>,
        linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] sysctl: Add a feature to drop caches selectively
Message-ID: <20140625221548.GA614@xo-6d-61-c0.localdomain>
References: <1403626213-7691-1-git-send-email-mcsim.planeta@gmail.com>
 <alpine.DEB.2.02.1406241458140.29176@chino.kir.corp.google.com>
 <1403677528.7903.103.camel@sauron.fi.intel.com>
 <CABhLV03_PNFiwsvt+yitcsKxz5TeVECCFavdNkbgQ+XzQqASaw@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CABhLV03_PNFiwsvt+yitcsKxz5TeVECCFavdNkbgQ+XzQqASaw@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed 2014-06-25 10:25:05, Thomas Knauth wrote:
> On Wed, Jun 25, 2014 at 8:25 AM, Artem Bityutskiy <dedekind1@gmail.com> wrote:
> > Plus some explanations WRT why proc-based interface and what would be
> > the alternatives, what if tomorrow we want to extend the functionality
> > and drop caches only for certain file range, is this only for regular
> > files or also for directories, why posix_fadvice(DONTNEED) is not
> > sufficient.
> 
> I suggested the idea originally. Let me address each of your questions in turn:
> 
> Why a selective drop? To have a middle ground between echo 2 >
> drop_caches and echo 3 > drop_caches. When is this interesting? My
> particular use case was benchmarking. I wanted to repeatedly measure
> the timing when things were read from disk. Dropping everything from
> the cache, also drops useful things, not just the few files your
> benchmark intends to measure.
> 
> Why /proc? Because this is where the current drop_caches mechanism is
> located. If it should go somewhere else, please do suggest so.

It sounds like this should be a new syscall.

echoing filenames in files is strange/ugly.
										Pavel
-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html

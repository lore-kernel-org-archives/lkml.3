Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756257AbaFYJ4i (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Jun 2014 05:56:38 -0400
Received: from mga01.intel.com ([192.55.52.88]:33207 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752091AbaFYJ4g (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Jun 2014 05:56:36 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.01,544,1400050800"; 
   d="scan'208";a="560674657"
Message-ID: <1403690184.20275.11.camel@sauron.fi.intel.com>
Subject: Re: [PATCH] sysctl: Add a feature to drop caches selectively
From: Artem Bityutskiy <dedekind1@gmail.com>
Reply-To: dedekind1@gmail.com
To: Thomas Knauth <thomas.knauth@gmx.de>
Cc: David Rientjes <rientjes@google.com>,
        Maksym Planeta <mcsim.planeta@gmail.com>,
        Alexander Viro <viro@zeniv.linux.org.uk>,
        linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org
Date: Wed, 25 Jun 2014 12:56:24 +0300
In-Reply-To: <CABhLV03_PNFiwsvt+yitcsKxz5TeVECCFavdNkbgQ+XzQqASaw@mail.gmail.com>
References: <1403626213-7691-1-git-send-email-mcsim.planeta@gmail.com>
	 <alpine.DEB.2.02.1406241458140.29176@chino.kir.corp.google.com>
	 <1403677528.7903.103.camel@sauron.fi.intel.com>
	 <CABhLV03_PNFiwsvt+yitcsKxz5TeVECCFavdNkbgQ+XzQqASaw@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.10.4 (3.10.4-2.fc20) 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2014-06-25 at 10:25 +0200, Thomas Knauth wrote:
> On Wed, Jun 25, 2014 at 8:25 AM, Artem Bityutskiy <dedekind1@gmail.com> wrote:
> > Plus some explanations WRT why proc-based interface and what would be
> > the alternatives, what if tomorrow we want to extend the functionality
> > and drop caches only for certain file range, is this only for regular
> > files or also for directories, why posix_fadvice(DONTNEED) is not
> > sufficient.
> 
> I suggested the idea originally. Let me address each of your questions in turn:

Thanks for the answer, although you forgot to comment on the question
about possibly extending the new interface to work with file ranges in
the future. For example, I have a 2 TiB file, and I am only interested
in dropping caches for the first couple of gigabytes. Would I extend
your interface, or would I come up with another one?

> Why a selective drop? To have a middle ground between echo 2 >
> drop_caches and echo 3 > drop_caches. When is this interesting? My
> particular use case was benchmarking. I wanted to repeatedly measure
> the timing when things were read from disk. Dropping everything from
> the cache, also drops useful things, not just the few files your
> benchmark intends to measure.

Sounds like a reasonable motivation for me.

> Why /proc? Because this is where the current drop_caches mechanism is
> located. If it should go somewhere else, please do suggest so.

I do not have particular suggestions, just pulling the information about
how much efforts were put into choosing the interface.

> Why not use posix_fadvice()? Because it is exactly this, an advice.
> The kernel is free to do whatever, i.e., also ignore the request. We
> want a mechanism that reliably drops select content from the cache.

OK, thanks.

-- 
Best Regards,
Artem Bityutskiy


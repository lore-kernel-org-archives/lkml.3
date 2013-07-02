Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751758Ab3GBN3r (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Jul 2013 09:29:47 -0400
Received: from cantor2.suse.de ([195.135.220.15]:47997 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750769Ab3GBN3q (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Jul 2013 09:29:46 -0400
Date: Tue, 2 Jul 2013 15:29:42 +0200
From: Michal Hocko <mhocko@suse.cz>
To: Anton Vorontsov <anton@enomsg.org>
Cc: Luiz Capitulino <lcapitulino@redhat.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Minchan Kim <minchan@kernel.org>, linux-mm@kvack.org,
        linux-kernel@vger.kernel.org, kmpark@infradead.org,
        hyunhee.kim@samsung.com
Subject: Re: [PATCH v2] vmpressure: implement strict mode
Message-ID: <20130702132942.GH16815@dhcp22.suse.cz>
References: <20130627181353.3d552e64.akpm@linux-foundation.org>
 <20130628043411.GA9100@teo>
 <20130628050712.GA10097@teo>
 <20130628100027.31504abe@redhat.com>
 <20130628165722.GA12271@teo>
 <20130628170917.GA12610@teo>
 <20130628144507.37d28ed9@redhat.com>
 <20130628185547.GA14520@teo>
 <20130628154402.4035f2fa@redhat.com>
 <20130629005637.GA16068@teo>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20130629005637.GA16068@teo>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri 28-06-13 17:56:37, Anton Vorontsov wrote:
> On Fri, Jun 28, 2013 at 03:44:02PM -0400, Luiz Capitulino wrote:
> > > Why can't you use poll() and demultiplex the events? Check if there is an
> > > event in the crit fd, and if there is, then just ignore all the rest.
> > 
> > This may be a valid workaround for current kernels, but application
> > behavior will be different among kernels with a different number of
> > events.
> 
> This is not a workaround, this is how poll works, and this is kinda
> expected... But not that I had this plan in mind when I was designing the
> current scheme... :)

One thing I found strict mode useful is that a poll based implementation
would be PITA without kernel help. First the timing is nothing you can
rely on. There might be arbitrary timeout between two eventfd_signal
calls. So you would see Medium while critical is waiting for being
scheduled.
Kernel might help here though and signal from the highest event down to
lower ones. The core issue would stay though. What is a tolerable period
when an event is considered separate one?

That being said I think both modes make sense and they cover different
usecases.
-- 
Michal Hocko
SUSE Labs

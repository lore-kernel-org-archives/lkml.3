Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754100AbaHYAAX (ORCPT <rfc822;w@1wt.eu>);
	Sun, 24 Aug 2014 20:00:23 -0400
Received: from mga02.intel.com ([134.134.136.20]:48399 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753515AbaHYAAW (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 24 Aug 2014 20:00:22 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.04,393,1406617200"; 
   d="scan'208";a="562864281"
Date: Sun, 24 Aug 2014 16:57:42 -0700
From: "David E. Box" <david.e.box@linux.intel.com>
To: Randy Dunlap <rdunlap@infradead.org>
Cc: Fejes =?iso-8859-1?Q?J=F3zsef?= <jozsef.fejes@gmail.com>,
        linux-kernel@vger.kernel.org, linux-stable@vger.kernel.org
Subject: Re: Problem with commit: x86, iosf: Make IOSF driver modular and
 usable by more drivers
Message-ID: <20140824235742.GA2711@pathfinder>
References: <CALU-w9-ZjjnrYW5HxRCe-HGZWSK0JMwNU_zcSbKXM4JgGyLdbw@mail.gmail.com>
 <53F8D1FE.5050205@infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <53F8D1FE.5050205@infradead.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Aug 23, 2014 at 10:40:14AM -0700, Randy Dunlap wrote:
> On 08/23/14 02:31, Fejes József wrote:
> > Hi,
> > 
> > I think there's a problem with commit
> > 6b8f0c8780c71d78624f736d7849645b64cc88b7: config IOSF_MBI is
> > automatically a module and I cannot change that.
> > 
> > I've been using 3.15.* stable kernels. I have module support enabled,
> > but I build everything into the kernel, so I don't actually have any
> > modules built. I just upgraded to 3.16.1, and found out that I now
> > have this one module. I cannot find it in the menu, so I edited the
> > .config file by hand, but it changes back from =y to =m. Could you
> > please look into fixing it, and push it to 3.16.* stable branch?
> 
> [adding David E. Box to email]
> 
> This is a mainline issue, not just a -stable issue.
> Once fixed in mainline (if ever), then that fix can be added to -stable.
> 
> Fejes, you could just disable module support and then iosf_mbi would be built
> into the kernel.  But as a loadable module, it won't waste memory if it's
> not needed.
> 
> David, any other suggestions?
> Why can't the users of IOSF_MBI just select it? That's what many other
> drivers do when they need to be sure that some functionality is present.

They could, but it's only required on SoC's. Some registers, while available
through an MSR on x86 core systems, are only available through the sideband on
x86 SoC's. So these drivers would waste space on core platforms. There is no
Kconfig option that builds exclusively for x86 SoC's.

> I'm surprised that someone else (e.g. Linus) has not complained about the
> 'default m' for this driver.

I'll just move to prompt for selection. I was advised against this early on
since the driver doesn't have a hook to userspace. Unfortunantely I didn't
question this and locked myself into pursuing the 'default m' option as a way to
make sure the IOSF_MBI was available for the drivers that will use it. That was
obviosuly a mistake.

Dave

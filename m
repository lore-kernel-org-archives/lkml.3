Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753165AbaAIWC0 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 9 Jan 2014 17:02:26 -0500
Received: from g5t0007.atlanta.hp.com ([15.192.0.44]:33989 "EHLO
	g5t0007.atlanta.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751571AbaAIWCS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 9 Jan 2014 17:02:18 -0500
X-Greylist: delayed 16318 seconds by postgrey-1.27 at vger.kernel.org; Thu, 09 Jan 2014 17:02:18 EST
Message-ID: <1389304583.1792.139.camel@misato.fc.hp.com>
Subject: Re: kdump failed because of hotplug memory adding in kdump kernel
From: Toshi Kani <toshi.kani@hp.com>
To: Vivek Goyal <vgoyal@redhat.com>
Cc: "Rafael J. Wysocki" <rjw@rjwysocki.net>, Baoquan <bhe@redhat.com>,
        linux-acpi@vger.kernel.org, zhangyanfei@cn.fujitsu.com,
        tangchen@cn.fujitsu.com, kexec@lists.infradead.org,
        linux-kernel@vger.kernel.org, dyoung@redhat.com
Date: Thu, 09 Jan 2014 14:56:23 -0700
In-Reply-To: <20140109212705.GC12111@redhat.com>
References: <52CD6E33.400@redhat.com> <20140108155829.GC13649@redhat.com>
	 <8500545.JVNPnKcyD1@vostro.rjw.lan>
	 <1389226308.1792.39.camel@misato.fc.hp.com>
	 <20140109145035.GB25897@redhat.com>
	 <1389283439.1792.66.camel@misato.fc.hp.com>
	 <20140109162427.GF25897@redhat.com>
	 <1389288265.1792.108.camel@misato.fc.hp.com>
	 <20140109182310.GG25897@redhat.com>
	 <1389292470.1792.109.camel@misato.fc.hp.com>
	 <20140109212705.GC12111@redhat.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.8.5 (3.8.5-2.fc19) 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2014-01-09 at 16:27 -0500, Vivek Goyal wrote:
> On Thu, Jan 09, 2014 at 11:34:30AM -0700, Toshi Kani wrote:
> > On Thu, 2014-01-09 at 13:23 -0500, Vivek Goyal wrote:
> > > On Thu, Jan 09, 2014 at 10:24:25AM -0700, Toshi Kani wrote:
> > > 
> > > [..]
> > > > > I think creating a new command line option is simpler as compared to
> > > > > creating a new flag in bootparam which in turn disables memory hotplug.
> > > > > More users can use that option. For example, if for some reason hotplug
> > > > > code is crashing, one can just disable it on command line as work around
> > > > > and move on.
> > > > 
> > > > I do not have a strong opinion about having such option.  However, I
> > > > think it is more user friendly to keep the exactmap option works alone
> > > > on any platforms.
> > > 
> > > I think we should create internally a variable which will disable memory
> > > hotplug. And set that variable based on memmap=exactmap, mem=X and also
> > > provide a way to disable memory hotplug directly using command line
> > > option.
> > > 
> > > Current kexec-tools can use memmap=exactmap and be happy. I am writing
> > > a new kexec syscall and will not be using memmap=exactmap and would need
> > > to use that command line option to disable memory hotplug behavior.
> > 
> > Sounds good to me.
> 
> Nobody responded to my other question, so I would ask it again.
> 
> Assume we have disabled hotplug memory in second kernel. First kernel
> saw hotplug memory and assume crash kernel reserved region came from
> there. We will pass this memory in bootparams to second kernel and it
> will show up in E820 map. It should still be accessible in second kernel,
> is that right?

Yes.

> Or there is some dependency on ACPI doing some magic before this memory
> range is available in second kernel?

No.  The 1st kernel reserves the crash kernel region, which cannot be
hot-deleted.  So, this region continues to be accessible by the 2nd
kernel without any operation.

I am more curious to know how makedumpfile decides what memory ranges to
dump.  The 1st kernel may have performed memory hot-add / delete
operations before a crash, so it needs to know the valid physical
address range at the time of crash, and may not rely on the E820 map
from BIOS (which is stale).  Am I right to assume that makedumpfile gets
it from the page tables of the 1st kernel?

Thanks,
-Toshi


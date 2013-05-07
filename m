Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757320Ab3EGF7e (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 May 2013 01:59:34 -0400
Received: from mga09.intel.com ([134.134.136.24]:16295 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751258Ab3EGF7d (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 May 2013 01:59:33 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.87,625,1363158000"; 
   d="scan'208";a="309364402"
Message-ID: <1367906476.2260.2.camel@ymzhang.sh.intel.com>
Subject: Re: Subject : [ PATCH ]
 pci-reset-error_state-to-pci_channel_io_normal-at-report_slot_reset
From: Yanmin Zhang <yanmin_zhang@linux.intel.com>
Reply-To: yanmin_zhang@linux.intel.com
To: linasvepstas@gmail.com
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        "Zhang, LongX" <longx.zhang@intel.com>,
        "linux-pci@vger.kernel.org" <linux-pci@vger.kernel.org>,
        "bhelgaas@google.com" <bhelgaas@google.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "Joseph.Liu@Emulex.Com" <Joseph.Liu@emulex.com>
Date: Tue, 07 May 2013 14:01:16 +0800
In-Reply-To: <CAHrUA34O=JEbmMSCmycNSXa1L6KXAWBCM5TfBOvzj_zSRMubHQ@mail.gmail.com>
References: <F7B8FD780A346D46A0042F5C63B06AE785E3B2@SHSMSX102.ccr.corp.intel.com>
	 <1367454625.2093.6.camel@ymzhang.sh.intel.com>
	 <CAHrUA34H_B-ffebx6ueHgV1ax-PL_3hLZr1JGaP2NJZ7bYgvtw@mail.gmail.com>
	 <1367541180.2093.10.camel@ymzhang.sh.intel.com>
	 <20130503020039.GA29087@kroah.com>
	 <1367550808.2093.14.camel@ymzhang.sh.intel.com>
	 <CAHrUA34O=JEbmMSCmycNSXa1L6KXAWBCM5TfBOvzj_zSRMubHQ@mail.gmail.com>
Organization: Intel.
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.2- 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2013-05-03 at 13:00 -0500, Linas Vepstas wrote:
> Greg,
> 
> I've been receiving (and reading!) these messages; I replied that I am
> not maintaining a tree, and have no way of testing these patches (no
> access to hardware.)  I believe it unlikely that my situation will
> change, and so I should probably be removed from the maintainers file.
> 
> No acked-by or anything; the patches are not "obviously correct" by
> visual inspection; they may be right, but would require deeper
> thinking about what is actually happening than I'm capable of at this
> time; I'm a bit rusty with this code base, and might miss something
> important
powerpc uses the similar method. See function eeh_report_reset.
We worked out the patch after checking powerpc codes.

Joseph Liu helped test the patch and the patch does work well.

> .
> 
> -- Linas
> 
> p.s. you didn't see my earlier reply because I forgot to hit 'plain text reply'
> 
> 
> On 2 May 2013 22:13, Yanmin Zhang <yanmin_zhang@linux.intel.com> wrote:
> >
> > On Thu, 2013-05-02 at 19:00 -0700, Greg Kroah-Hartman wrote:
> > > On Fri, May 03, 2013 at 08:33:00AM +0800, Yanmin Zhang wrote:
> > > > On Wed, 2013-05-01 at 20:20 -0500, Linas Vepstas wrote:
> > > > > Hi,
> > > > >
> > > > > On 1 May 2013 19:30, Yanmin Zhang <yanmin_zhang@linux.intel.com>
> > > > > wrote:
> > > > >         On Fri, 2013-04-26 at 06:28 +0000, Zhang, LongX wrote:
> > > > >         > From: Zhang Long <longx.zhang@intel.com>
> > > > >         >
> > > > >         > Specific pci device drivers might have many functions to
> > > > >         call
> > > > >         > pci_channel_offline to check device states. When slot_reset
> > > > >         happens,
> > > > >         > drivers' slot_reset callback might call such functions and
> > > > >         eventually
> > > > >         > abort the reset.
> > > > >         >
> > > > >         > The patch resets pdev->error_state to pci_channel_io_normal
> > > > >         at
> > > > >         > the begining of report_slot_reset.
> > > > >         >
> > > > >         > Thank Liu Joseph for pointing it out.
> > > > >
> > > > >         Linas, Bjorn,
> > > > >
> > > > >         Would you like to merge the patch to your testing tree?
> > > > >         The patch resolves one issue pointed out by Joseph.
> > > > >
> > > > >
> > > > > I'm not maintaining a tree at this time, and am not able to test.
> > > > > Sorry.
> > > > Thanks Linas.
> > > >
> > > > Greg,
> > > >
> > > > Would you like to merge it into your testing tree? Joseph Liu tested
> > > > the patch and it does work.
> > >
> > > You do know about the scripts/get_maintainer.pl script, right?
> > >
> > > Hint, try it out :)
> > Greg,
> >
> > Thanks. We did send to the right people, Linas and Bjorn.
> >
> > scripts/get_maintainer.pl 0001-pci-reset-error_state-to-pci_channel_io_normal-at-re.patch
> > Bjorn Helgaas <bhelgaas@google.com> (supporter:PCI SUBSYSTEM,commit_signer:7/8=88%,commit_signer:10/11=91%)
> > Linas Vepstas <linasvepstas@gmail.com> (commit_signer:2/8=25%)
> > Yijing Wang <wangyijing@huawei.com> (commit_signer:2/8=25%,commit_signer:2/11=18%)
> > Jiang Liu <jiang.liu@huawei.com> (commit_signer:2/8=25%,commit_signer:2/11=18%)
> > Stephen Hemminger <shemminger@vyatta.com> (commit_signer:1/8=12%)
> > "Rafael J. Wysocki" <rafael.j.wysocki@intel.com> (commit_signer:6/11=55%)
> > Huang Ying <ying.huang@intel.com> (commit_signer:5/11=45%)
> > linux-pci@vger.kernel.org (open list:PCI SUBSYSTEM)
> > linux-kernel@vger.kernel.org (open list)
> >
> >
> > I remember Jesse was maintaining PCI subsystem and he responded quickly.
> >
> > Yanmin
> >
> >



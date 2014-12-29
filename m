Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751875AbaL2C2S (ORCPT <rfc822;w@1wt.eu>);
	Sun, 28 Dec 2014 21:28:18 -0500
Received: from mga11.intel.com ([192.55.52.93]:37038 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751534AbaL2C2R (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 28 Dec 2014 21:28:17 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.97,862,1389772800"; 
   d="scan'208";a="434427818"
Message-ID: <1419820095.26403.77.camel@intel.com>
Subject: Re: [LKP] [ftrace] fef5aeeee9e: -27.2% boot-slabinfo.num_objs
From: Huang Ying <ying.huang@intel.com>
To: Steven Rostedt <rostedt@goodmis.org>
Cc: LKML <linux-kernel@vger.kernel.org>, LKP ML <lkp@01.org>
Date: Mon, 29 Dec 2014 10:28:15 +0800
In-Reply-To: <20141223083214.0b199465@gandalf.local.home>
References: <1419304217.26403.44.camel@intel.com>
	 <20141223083214.0b199465@gandalf.local.home>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.12.9-1 
Mime-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2014-12-23 at 08:32 -0500, Steven Rostedt wrote:
> On Tue, 23 Dec 2014 11:10:17 +0800
> Huang Ying <ying.huang@intel.com> wrote:
> 
> > FYI, we noticed the below changes on
> > 
> > commit fef5aeeee9e3717e7aea991a7ae9ff6a7a2d4c85 ("ftrace: Replace tramp_hash with old_*_hash to save space")
> > 
> > 
> > testbox/testcase/testparams: vm-kbuild-4G/boot/1
> > 
> > e1effa0144a1ddf5  fef5aeeee9e3717e7aea991a7a  
> > ----------------  --------------------------  
> >          %stddev     %change         %stddev
> >              \          |                \  
> >     437752 ±  0%     -27.2%     318545 ±  0%  boot-slabinfo.num_objs
> > 
> > vm-kbuild-4G: qemu-system-x86_64 -enable-kvm
> > Memory: 4G
> 
> I have no idea what this test does. Is this good or bad? Is that -27.2%
> a performance regression, or memory regression?

IMO, it is good.  Memory usage is reduced.

Best Regards,
Huang, Ying

> -- Steve
> 
> 
> > 
> > 
> > 
> >                                boot-slabinfo.num_objs
> > 
> >   440000 *+*--*-*-*------*----*-*-*--*--------*-*--*-*-*--*-----------------+
> >          |           *.*   *.          *.*..*                               |
> >   420000 ++                                                                 |
> >          |                                                                  |
> >   400000 ++                                                                 |
> >          |                                                                  |
> >   380000 ++                                                                 |
> >          |                                                                  |
> >   360000 ++                                                                 |
> >          |                                                                  |
> >   340000 ++                                                                 |
> >          |                                                                  |
> >   320000 O+O  O   O  O O O O  O O O  O O    O O O    O O  O O O O  O O O  O O
> >          |      O                        O         O                        |
> >   300000 ++-----------------------------------------------------------------+
> > 
> > 	[*] bisect-good sample
> > 	[O] bisect-bad  sample
> > 
> > To reproduce:
> > 
> > 	apt-get install ruby ruby-oj
> > 	git clone git://git.kernel.org/pub/scm/linux/kernel/git/wfg/lkp-tests.git
> > 	cd lkp-tests
> > 	bin/setup-local job.yaml # the job file attached in this email
> > 	bin/run-local   job.yaml
> > 
> > 
> > Disclaimer:
> > Results have been estimated based on internal Intel analysis and are provided
> > for informational purposes only. Any difference in system hardware or software
> > design or configuration may affect actual performance.
> > 
> > 
> > Thanks,
> > Huang, Ying
> > 
> 



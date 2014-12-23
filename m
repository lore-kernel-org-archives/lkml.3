Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756133AbaLWNc2 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Dec 2014 08:32:28 -0500
Received: from smtprelay0120.hostedemail.com ([216.40.44.120]:50352 "EHLO
	smtprelay.hostedemail.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1753650AbaLWNc1 convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Dec 2014 08:32:27 -0500
X-Session-Marker: 6E657665747340676F6F646D69732E6F7267
X-Spam-Summary: 2,0,0,,d41d8cd98f00b204,rostedt@goodmis.org,:::::,RULES_HIT:41:69:152:355:379:541:599:800:960:973:981:988:989:1042:1260:1277:1311:1313:1314:1345:1359:1437:1513:1515:1516:1518:1521:1534:1542:1593:1594:1711:1730:1747:1777:1792:1801:2198:2199:2393:2553:2559:2562:3138:3139:3140:3141:3142:3353:3622:3687:3865:3867:3868:3870:3871:3874:4321:4605:5007:6119:6261:7875:8784:9121:9149:10004:10026:10264:10394:10400:10450:10455:10848:10967:11232:11233:11658:11914:12043:12114:12295:12296:12438:12517:12519:12555:12683:12740:19904:19999:21067:21080,0,RBL:none,CacheIP:none,Bayesian:0.5,0.5,0.5,Netcheck:none,DomainCache:0,MSF:not bulk,SPF:fn,MSBL:0,DNSBL:none,Custom_rules:0:0:0
X-HE-Tag: waste19_4f523598ce533
X-Filterd-Recvd-Size: 3571
Date: Tue, 23 Dec 2014 08:32:14 -0500
From: Steven Rostedt <rostedt@goodmis.org>
To: Huang Ying <ying.huang@intel.com>
Cc: LKML <linux-kernel@vger.kernel.org>, LKP ML <lkp@01.org>
Subject: Re: [LKP] [ftrace] fef5aeeee9e: -27.2% boot-slabinfo.num_objs
Message-ID: <20141223083214.0b199465@gandalf.local.home>
In-Reply-To: <1419304217.26403.44.camel@intel.com>
References: <1419304217.26403.44.camel@intel.com>
X-Mailer: Claws Mail 3.11.1 (GTK+ 2.24.25; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 23 Dec 2014 11:10:17 +0800
Huang Ying <ying.huang@intel.com> wrote:

> FYI, we noticed the below changes on
> 
> commit fef5aeeee9e3717e7aea991a7ae9ff6a7a2d4c85 ("ftrace: Replace tramp_hash with old_*_hash to save space")
> 
> 
> testbox/testcase/testparams: vm-kbuild-4G/boot/1
> 
> e1effa0144a1ddf5  fef5aeeee9e3717e7aea991a7a  
> ----------------  --------------------------  
>          %stddev     %change         %stddev
>              \          |                \  
>     437752 ±  0%     -27.2%     318545 ±  0%  boot-slabinfo.num_objs
> 
> vm-kbuild-4G: qemu-system-x86_64 -enable-kvm
> Memory: 4G

I have no idea what this test does. Is this good or bad? Is that -27.2%
a performance regression, or memory regression?

-- Steve


> 
> 
> 
>                                boot-slabinfo.num_objs
> 
>   440000 *+*--*-*-*------*----*-*-*--*--------*-*--*-*-*--*-----------------+
>          |           *.*   *.          *.*..*                               |
>   420000 ++                                                                 |
>          |                                                                  |
>   400000 ++                                                                 |
>          |                                                                  |
>   380000 ++                                                                 |
>          |                                                                  |
>   360000 ++                                                                 |
>          |                                                                  |
>   340000 ++                                                                 |
>          |                                                                  |
>   320000 O+O  O   O  O O O O  O O O  O O    O O O    O O  O O O O  O O O  O O
>          |      O                        O         O                        |
>   300000 ++-----------------------------------------------------------------+
> 
> 	[*] bisect-good sample
> 	[O] bisect-bad  sample
> 
> To reproduce:
> 
> 	apt-get install ruby ruby-oj
> 	git clone git://git.kernel.org/pub/scm/linux/kernel/git/wfg/lkp-tests.git
> 	cd lkp-tests
> 	bin/setup-local job.yaml # the job file attached in this email
> 	bin/run-local   job.yaml
> 
> 
> Disclaimer:
> Results have been estimated based on internal Intel analysis and are provided
> for informational purposes only. Any difference in system hardware or software
> design or configuration may affect actual performance.
> 
> 
> Thanks,
> Huang, Ying
> 


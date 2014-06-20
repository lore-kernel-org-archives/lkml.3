Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757357AbaFTSPg (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 Jun 2014 14:15:36 -0400
Received: from e34.co.us.ibm.com ([32.97.110.152]:44991 "EHLO
	e34.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757257AbaFTSPe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 Jun 2014 14:15:34 -0400
Date: Fri, 20 Jun 2014 11:15:28 -0700
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: Dave Hansen <dave.hansen@intel.com>
Cc: Christoph Lameter <cl@gentwo.org>, josh@joshtriplett.org,
        Andi Kleen <ak@linux.intel.com>, LKML <linux-kernel@vger.kernel.org>,
        "Chen, Tim C" <tim.c.chen@intel.com>
Subject: Re: [bisected] pre-3.16 regression on open() scalability
Message-ID: <20140620181528.GA4615@linux.vnet.ibm.com>
Reply-To: paulmck@linux.vnet.ibm.com
References: <20140619204220.GJ4904@linux.vnet.ibm.com>
 <alpine.DEB.2.11.1406191612000.5484@gentwo.org>
 <alpine.DEB.2.11.1406191614270.5484@gentwo.org>
 <20140619213203.GA16747@cloud>
 <20140619230732.GX4904@linux.vnet.ibm.com>
 <alpine.DEB.2.11.1406201019430.10810@gentwo.org>
 <20140620153839.GB4904@linux.vnet.ibm.com>
 <alpine.DEB.2.11.1406201106010.11238@gentwo.org>
 <20140620163023.GE4904@linux.vnet.ibm.com>
 <53A471E6.7070209@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <53A471E6.7070209@intel.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-TM-AS-MML: disable
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 14062018-1542-0000-0000-000002B68723
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jun 20, 2014 at 10:39:50AM -0700, Dave Hansen wrote:
> On 06/20/2014 09:30 AM, Paul E. McKenney wrote:
> > On Fri, Jun 20, 2014 at 11:07:13AM -0500, Christoph Lameter wrote:
> >> On Fri, 20 Jun 2014, Paul E. McKenney wrote:
> >>
> >>> And the fraction of the small systems that care that much about latency
> >>> is also quite small.
> >>
> >> This also impacts general performance of course not only latency.
> >>
> >>> Of course, if you have performance results that show otherwise, please
> >>> share them.
> >>
> >> We are discussing a performance problem right here.
> > 
> > We are engaging in a lot of -speculation- about an -alleged- performance
> > problem.  I have posted a fix to the actual performance problem, but the
> > guy reporting the original report of that problem has not yet reported
> > the performance of the fix.  Which is fine, as I am getting ready to
> > post an updated fix, and besides which he might well have higher-priority
> > tasks requiring his attention.  But without that performance information,
> > we are all just engaging in baseless speculation.
> 
> The patch helps, but does not get us back to where we were before:
> 
> Baseline: 3c8fb5044 with ac1bea85781e9004d reverted:
> root@bigbox:~/will-it-scale# ./open1_processes -t 160 -s 30
> ...
> average:57710064
> 
> 3c8fb5044 with Paul's early version with the magic 7:
> root@bigbox:~/will-it-scale# ./open1_processes -t 160 -s 30
> ...
> average:48363361
> 
> It was down at 43M or 44M without the new patch.

Thank you for the info, Dave!

							Thanx, Paul

> full spew:
> 
> 3c8fb50445833b93f69b6b703a29aae3523cad0c
> with ac1bea85781e9004d reverted:
> root@bigbox:~/will-it-scale# ./open1_processes -t 160 -s 30
> warmup
> min:366329 max:421686 total:63727790
> min:358758 max:406036 total:62561168
> min:298435 max:340355 total:51711000
> min:343707 max:383812 total:59554601
> min:310652 max:356571 total:54016014
> min:337738 max:382557 total:59146223
> measurement
> min:317628 max:363489 total:55230696
> min:341875 max:392621 total:59910047
> min:331979 max:376582 total:58074347
> min:342835 max:388481 total:59644247
> min:327282 max:374283 total:56897588
> min:321668 max:373622 total:55799061
> min:336575 max:387027 total:58948777
> min:350269 max:397098 total:61510405
> min:336949 max:382367 total:58640224
> min:327913 max:371026 total:56833639
> min:322377 max:375011 total:56923970
> min:354508 max:399130 total:61628878
> min:319998 max:367493 total:55624467
> min:337322 max:379689 total:58425775
> min:325701 max:369950 total:56382432
> min:318423 max:364997 total:55662597
> min:332930 max:374174 total:57881582
> min:324787 max:371432 total:56881287
> min:335136 max:381850 total:58661101
> min:329253 max:377998 total:58146731
> min:353550 max:399807 total:61031126
> min:312443 max:358633 total:55092296
> min:344435 max:396344 total:61129639
> min:332426 max:394539 total:58307766
> min:322235 max:367385 total:56477056
> min:326722 max:362761 total:55421905
> min:318183 max:366510 total:56260638
> min:321812 max:372084 total:56639167
> min:328016 max:379484 total:57794343
> min:314929 max:364644 total:55440152
> average:57710064
> 
> 3c8fb50445833b93f69b6b703a29aae3523cad0c
> with paul's early version and the magic 7:
> root@bigbox:~/will-it-scale# ./open1_processes -t 160 -s 30
> testcase:Separate file open/close
> warmup
> min:310891 max:364268 total:54015547
> min:283886 max:333177 total:49992270
> min:275451 max:314699 total:47775422
> min:275164 max:316351 total:47720614
> min:283434 max:326614 total:49156206
> min:276475 max:320313 total:48469874
> measurement
> min:274589 max:323239 total:48149462
> min:280194 max:328827 total:49338289
> min:277830 max:327060 total:48962337
> min:281689 max:325917 total:49211850
> min:271332 max:308350 total:46813631
> min:275384 max:319016 total:47366390
> min:276728 max:318277 total:47752679
> min:275616 max:317111 total:47955871
> min:278882 max:319082 total:47864449
> min:267076 max:312427 total:47225886
> min:279400 max:322798 total:48561113
> min:279140 max:317367 total:47762975
> min:278772 max:325575 total:49001990
> min:271660 max:311780 total:47349871
> min:283508 max:326299 total:49516078
> min:284946 max:327525 total:49468752
> min:271924 max:316507 total:47867902
> min:279669 max:313937 total:47582153
> min:272887 max:319545 total:47725521
> min:281685 max:323791 total:48620478
> min:280714 max:324849 total:48804594
> min:283307 max:327424 total:49153787
> min:280186 max:323924 total:48618088
> min:270821 max:311985 total:47194656
> min:282145 max:327910 total:48728398
> min:276035 max:326523 total:48895232
> min:275433 max:317441 total:48054952
> min:276840 max:320486 total:48297727
> min:280297 max:320323 total:48736783
> min:286099 max:327522 total:50318962
> average:48363361
> 
> 


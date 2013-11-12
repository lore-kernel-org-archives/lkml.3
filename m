Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756093Ab3KLRPU (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 Nov 2013 12:15:20 -0500
Received: from e7.ny.us.ibm.com ([32.97.182.137]:57848 "EHLO e7.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753603Ab3KLRPQ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 Nov 2013 12:15:16 -0500
Date: Tue, 12 Nov 2013 22:45:07 +0530
From: Srikar Dronamraju <srikar@linux.vnet.ibm.com>
To: Peter Zijlstra <peterz@infradead.org>
Cc: mingo@kernel.org, hpa@zytor.com, linux-kernel@vger.kernel.org,
        tglx@linutronix.de, mikey@neuling.org,
        linux-tip-commits@vger.kernel.org
Subject: Re: [PATCH v2] sched: Check sched_domain before computing group
 power.
Message-ID: <20131112171507.GG2559@linux.vnet.ibm.com>
Reply-To: Srikar Dronamraju <srikar@linux.vnet.ibm.com>
References: <tip-db2pe0vxwunv37plc7onnugj@git.kernel.org>
 <20131112105547.GA27310@linux.vnet.ibm.com>
 <20131112115736.GO5056@laptop.programming.kicks-ass.net>
 <20131112164126.GF2559@linux.vnet.ibm.com>
 <20131112170302.GC16796@laptop.programming.kicks-ass.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
In-Reply-To: <20131112170302.GC16796@laptop.programming.kicks-ass.net>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-TM-AS-MML: disable
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 13111217-5806-0000-0000-000023650B42
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> 
> Hurm.. can you provide the actual topology of the machine that triggers
> this? My brain hurts trying to thing through the weird cases of this
> code.
> 

Hope this helps. Please do let me know if you were looking for pdf output.

Machine (251GB)



   NUMANode P#0 (63GB)



   Socket P#0


     L3 (20MB)



     L2 (256KB)         L2 (256KB)         L2 (256KB)         L2 (256KB)   L2 (256KB)   L2 (256KB)   L2 (256KB)   L2 (256KB)



     L1d (32KB)         L1d (32KB)         L1d (32KB)         L1d (32KB)   L1d (32KB)   L1d (32KB)   L1d (32KB)   L1d (32KB)



     L1i (32KB)         L1i (32KB)         L1i (32KB)         L1i (32KB)   L1i (32KB)   L1i (32KB)   L1i (32KB)   L1i (32KB)



     Core P#0           Core P#1           Core P#2           Core P#3     Core P#4     Core P#5     Core P#6     Core P#7


       PU P#0            PU P#1             PU P#2             PU P#3       PU P#4       PU P#5       PU P#6       PU P#7


       PU P#32           PU P#33            PU P#34            PU P#35      PU P#36      PU P#37      PU P#38      PU P#39




   NUMANode P#1 (63GB)



   Socket P#1


     L3 (20MB)



     L2 (256KB)         L2 (256KB)         L2 (256KB)         L2 (256KB)   L2 (256KB)   L2 (256KB)   L2 (256KB)   L2 (256KB)



     L1d (32KB)         L1d (32KB)         L1d (32KB)         L1d (32KB)   L1d (32KB)   L1d (32KB)   L1d (32KB)   L1d (32KB)



     L1i (32KB)         L1i (32KB)         L1i (32KB)         L1i (32KB)   L1i (32KB)   L1i (32KB)   L1i (32KB)   L1i (32KB)



     Core P#0           Core P#1           Core P#2           Core P#3     Core P#4     Core P#5     Core P#6     Core P#7


       PU P#8            PU P#9             PU P#10            PU P#11      PU P#12      PU P#13      PU P#14      PU P#15


       PU P#40           PU P#41            PU P#42            PU P#43      PU P#44      PU P#45      PU P#46      PU P#47




   NUMANode P#2 (63GB)



   Socket P#2


     L3 (20MB)



     L2 (256KB)         L2 (256KB)         L2 (256KB)         L2 (256KB)   L2 (256KB)   L2 (256KB)   L2 (256KB)   L2 (256KB)



     L1d (32KB)         L1d (32KB)         L1d (32KB)         L1d (32KB)   L1d (32KB)   L1d (32KB)   L1d (32KB)   L1d (32KB)



     L1i (32KB)         L1i (32KB)         L1i (32KB)         L1i (32KB)   L1i (32KB)   L1i (32KB)   L1i (32KB)   L1i (32KB)



     Core P#0           Core P#1           Core P#2           Core P#3     Core P#4     Core P#5     Core P#6     Core P#7


       PU P#16           PU P#17            PU P#18            PU P#19      PU P#20      PU P#21      PU P#22      PU P#23


       PU P#48           PU P#49            PU P#50            PU P#51      PU P#52      PU P#53      PU P#54      PU P#55




   NUMANode P#3 (62GB)



   Socket P#3


     L3 (20MB)



     L2 (256KB)         L2 (256KB)         L2 (256KB)         L2 (256KB)   L2 (256KB)   L2 (256KB)   L2 (256KB)   L2 (256KB)



     L1d (32KB)         L1d (32KB)         L1d (32KB)         L1d (32KB)   L1d (32KB)   L1d (32KB)   L1d (32KB)   L1d (32KB)



     L1i (32KB)         L1i (32KB)         L1i (32KB)         L1i (32KB)   L1i (32KB)   L1i (32KB)   L1i (32KB)   L1i (32KB)



     Core P#0           Core P#1           Core P#2           Core P#3     Core P#4     Core P#5     Core P#6     Core P#7


       PU P#24           PU P#25            PU P#26            PU P#27      PU P#28      PU P#29      PU P#30      PU P#31


       PU P#56           PU P#57            PU P#58            PU P#59      PU P#60      PU P#61      PU P#62      PU P#63




                    PCI 1000:005b


                        sda          sdb     sdc        sdd



                        sde          sdf     sdg        sdh




                    PCI 19a2:0710


                        eth0




                    PCI 19a2:0710


                        eth1




                    PCI 19a2:0710


                        eth2




                    PCI 19a2:0710


                        eth3




                                                      PCI 102b:0534



           PCI 8086:1d02



                    PCI 1000:0073



Host: kong.in.ibm.com

Indexes: physical

Date: Tuesday 12 November 2013 10:38:18 PM IST


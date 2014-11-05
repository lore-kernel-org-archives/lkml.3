Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752491AbaKEAKa (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Nov 2014 19:10:30 -0500
Received: from dovecot.logic.tuwien.ac.at ([128.130.175.61]:50860 "EHLO
	mail.logic.tuwien.ac.at" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751502AbaKEAK3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Nov 2014 19:10:29 -0500
Date: Wed, 5 Nov 2014 09:10:26 +0900
From: Norbert Preining <preining@logic.at>
To: David Rientjes <rientjes@google.com>
Cc: linux-kernel@vger.kernel.org
Subject: Re: khugepaged / firefox going wild in 3.18-rc
Message-ID: <20141105001026.GQ13232@auth.logic.tuwien.ac.at>
References: <20141104232027.GO13232@auth.logic.tuwien.ac.at>
 <alpine.DEB.2.10.1411041559170.2720@chino.kir.corp.google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.DEB.2.10.1411041559170.2720@chino.kir.corp.google.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi David,

thanks for your answer.

On Tue, 04 Nov 2014, David Rientjes wrote:
> If you have the ability to kill your X session, then you presumably are 
> able to capture /proc/pid/stack for these pids to see where it is busy.  

Yes I can do that, I can even reproduce it on *every* start of iceweasel
after it happened the first time.

There is no /proc/PID/stack, though .....

> It might also be helpful to see how the grep ^thp_ /proc/vmstat and 
> grep ^compact_ /proc/vmstat counters change over time.

I captured that over timne, as well as the contents of
	/proc/PID/stat
for iceweasel and khugepaged. There are some numbers steadily
increasing.

Here is what I got:

START
thp_fault_alloc 9092
thp_fault_fallback 87
thp_collapse_alloc 5003
thp_collapse_alloc_failed 19
thp_split 2889
thp_zero_page_alloc 2
thp_zero_page_alloc_failed 0
compact_migrate_scanned 400301
compact_free_scanned 8634053
compact_isolated 687993
compact_stall 567
compact_fail 101
compact_success 466


thp_fault_alloc 9127
thp_fault_fallback 100
thp_collapse_alloc 5008
thp_collapse_alloc_failed 19
thp_split 2892
thp_zero_page_alloc 2
thp_zero_page_alloc_failed 0
compact_migrate_scanned 430094
compact_free_scanned 10444689
compact_isolated 709843
compact_stall 603
compact_fail 130
compact_success 473
===
thp_fault_alloc 9127
thp_fault_fallback 100
thp_collapse_alloc 5008
thp_collapse_alloc_failed 19
thp_split 2892
thp_zero_page_alloc 2
thp_zero_page_alloc_failed 0
compact_migrate_scanned 430094
compact_free_scanned 10444689
compact_isolated 709843
compact_stall 603
compact_fail 130
compact_success 473
===
thp_fault_alloc 9127
thp_fault_fallback 100
thp_collapse_alloc 5008
thp_collapse_alloc_failed 19
thp_split 2892
thp_zero_page_alloc 2
thp_zero_page_alloc_failed 0
compact_migrate_scanned 430094
compact_free_scanned 10444689
compact_isolated 709843
compact_stall 603
compact_fail 130
compact_success 473
===
thp_fault_alloc 9127
thp_fault_fallback 100
thp_collapse_alloc 5008
thp_collapse_alloc_failed 19
thp_split 2892
thp_zero_page_alloc 2
thp_zero_page_alloc_failed 0
compact_migrate_scanned 430094
compact_free_scanned 10444689
compact_isolated 709843
compact_stall 603
compact_fail 130
compact_success 473
===


/proc/PID/stat for iceweasel over some time:
8927 (iceweasel) R 27016 26901 26901 0 -1 4204544 100479 2248 5 0 565 14849 1 0 20 0 47 0 38224838 1134931968 84204 18446744073709551615 139840244875264 139840244981188 140737356374240 140737356331656 139840166756100 0 0 4096 17583 18446744073709551615 0 0 17 2 0 0 1 0 0 139840247078912 139840247080712 139840278519808 140737356376815 140737356376825 140737356376825 140737356378085 0
8927 (iceweasel) R 27016 26901 26901 0 -1 4204544 100479 2248 5 0 565 15130 1 0 20 0 47 0 38224838 1134931968 84204 18446744073709551615 139840244875264 139840244981188 140737356374240 140737356331656 139840166756100 0 0 4096 17583 18446744073709551615 0 0 17 1 0 0 1 0 0 139840247078912 139840247080712 139840278519808 140737356376815 140737356376825 140737356376825 140737356378085 0
8927 (iceweasel) R 27016 26901 26901 0 -1 4204544 100479 2248 5 0 565 15460 1 0 20 0 47 0 38224838 1134931968 84204 18446744073709551615 139840244875264 139840244981188 140737356374240 140737356331656 139840166756100 0 0 4096 17583 18446744073709551615 0 0 17 1 0 0 1 0 0 139840247078912 139840247080712 139840278519808 140737356376815 140737356376825 140737356376825 140737356378085 0
8927 (iceweasel) R 27016 26901 26901 0 -1 4204544 100479 2248 5 0 565 15724 1 0 20 0 47 0 38224838 1134931968 84204 18446744073709551615 139840244875264 139840244981188 140737356374240 140737356331656 139840166756100 0 0 4096 17583 18446744073709551615 0 0 17 1 0 0 1 0 0 139840247078912 139840247080712 139840278519808 140737356376815 140737356376825 140737356376825 140737356378085 0


/proc/PID/stat for khugepaged over some time:
35 (khugepaged) R 2 0 0 0 -1 2107456 0 0 0 0 0 39779 0 0 39 19 1 0 22 0 0 18446744073709551615 0 0 0 0 0 0 0 2147483647 0 0 0 0 17 0 0 0 0 0 0 0 0 0 0 0 0 0 0
35 (khugepaged) R 2 0 0 0 -1 2107456 0 0 0 0 0 40104 0 0 39 19 1 0 22 0 0 18446744073709551615 0 0 0 0 0 0 0 2147483647 0 0 0 0 17 2 0 0 0 0 0 0 0 0 0 0 0 0 0
35 (khugepaged) R 2 0 0 0 -1 2107456 0 0 0 0 0 40516 0 0 39 19 1 0 22 0 0 18446744073709551615 0 0 0 0 0 0 0 2147483647 0 0 0 0 17 2 0 0 0 0 0 0 0 0 0 0 0 0 0
35 (khugepaged) R 2 0 0 0 -1 2107456 0 0 0 0 0 40797 0 0 39 19 1 0 22 0 0 18446744073709551615 0 0 0 0 0 0 0 2147483647 0 0 0 0 17 0 0 0 0 0 0 0 0 0 0 0 0 0 0



Hope that helps

Norbert

------------------------------------------------------------------------
PREINING, Norbert                               http://www.preining.info
JAIST, Japan                                 TeX Live & Debian Developer
GPG: 0x860CDC13   fp: F7D8 A928 26E3 16A1 9FA0  ACF0 6CAC A448 860C DC13
------------------------------------------------------------------------

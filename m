Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1750847Ab3IFSgX (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Sep 2013 14:36:23 -0400
Received: from mail-ve0-f172.google.com ([209.85.128.172]:61770 "EHLO
	mail-ve0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750708Ab3IFSgW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Sep 2013 14:36:22 -0400
MIME-Version: 1.0
In-Reply-To: <3908561D78D1C84285E8C5FCA982C28F31CDCDB2@ORSMSX106.amr.corp.intel.com>
References: <20130905131814.GA24274@osiris>
	<CA+55aFyZ8xLWiPcP3jcnVApQOqAvpo_fshSvGpdpW42iRutPcQ@mail.gmail.com>
	<3908561D78D1C84285E8C5FCA982C28F31CDC7F7@ORSMSX106.amr.corp.intel.com>
	<CA+55aFyevZQG5pEz-iJF6MFEMpwJD=biB-x852ki0spOM293Sg@mail.gmail.com>
	<3908561D78D1C84285E8C5FCA982C28F31CDCC23@ORSMSX106.amr.corp.intel.com>
	<CA+55aFw_Rovv7YTb62q5NQvucM5ks8+HXcsTOJ-oJ+kqmHop4A@mail.gmail.com>
	<3908561D78D1C84285E8C5FCA982C28F31CDCCFA@ORSMSX106.amr.corp.intel.com>
	<CA+55aFy0BZ8kL0TMgV+u1g5Rt=hBJw44+kps5RzD-s=Uo-zsLg@mail.gmail.com>
	<3908561D78D1C84285E8C5FCA982C28F31CDCDB2@ORSMSX106.amr.corp.intel.com>
Date: Fri, 6 Sep 2013 11:36:21 -0700
Message-ID: <CA+8MBbLj6B+H_f8ijR4cwWgcPobZEyZJvgZiHH9YsQS5fJ47sg@mail.gmail.com>
Subject: Re: [PATCH] lockref: remove cpu_relax() again
From: Tony Luck <tony.luck@gmail.com>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Heiko Carstens <heiko.carstens@de.ibm.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

No new Itanium numbers yet ... but I did wonder how this works
on multi-socket x86 ... so I tweaked "t.c. to increase threads to
64 to max out my 4-socket Xeon E5-4650 (8 cores/socket 2 threads/core)
and also print out the individual scores from each thread.

$ ./t /tmp 64
389827
717666
1540293
130764
681839
33357
606966
33716
33183
33230
69685
76422
352851
34940
257132
34192
34200
34098
34053
34459
234399
33678
241571
545912
620857
65818
32853
739440
33697
683655
741366
36208
385775
446198
45974
33056
403944
717415
254782
166754
702745
43661
1042180
437367
43751
503342
154223
706917
878167
43802
51667
660875
33261
522425
33627
33637
33446
33604
52963
33688
406088
551690
446474
33289
Threads = 64 Total loops: 19109114

Individual thread performance varies from 32853 to 1540293. A factor of 46.9
Sometimes it is good to sacrifice fairness for throughput. But wow!

Running for longer [ s/sleep(10)/sleep(300) ] gave things a chance to
even out - but I still see a factor of 3.5 between the fastest and the
slowest.

-Tony

Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751468AbaLRVip (ORCPT <rfc822;w@1wt.eu>);
	Thu, 18 Dec 2014 16:38:45 -0500
Received: from mx1.redhat.com ([209.132.183.28]:38132 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751150AbaLRVio (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Dec 2014 16:38:44 -0500
Date: Thu, 18 Dec 2014 16:37:58 -0500
From: Dave Jones <davej@redhat.com>
To: Andy Lutomirski <luto@amacapital.net>
Cc: Linus Torvalds <torvalds@linux-foundation.org>, Chris Mason <clm@fb.com>,
        Mike Galbraith <umgwanakikbuti@gmail.com>,
        Ingo Molnar <mingo@kernel.org>, Peter Zijlstra <peterz@infradead.org>,
        =?iso-8859-1?Q?D=E2niel?= Fraga <fragabr@gmail.com>,
        Sasha Levin <sasha.levin@oracle.com>,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Suresh Siddha <sbsiddha@gmail.com>, Oleg Nesterov <oleg@redhat.com>,
        Peter Anvin <hpa@linux.intel.com>
Subject: Re: save_xstate_sig (Re: frequent lockups in 3.18rc4)
Message-ID: <20141218213758.GA25918@redhat.com>
Mail-Followup-To: Dave Jones <davej@redhat.com>,
	Andy Lutomirski <luto@amacapital.net>,
	Linus Torvalds <torvalds@linux-foundation.org>,
	Chris Mason <clm@fb.com>, Mike Galbraith <umgwanakikbuti@gmail.com>,
	Ingo Molnar <mingo@kernel.org>,
	Peter Zijlstra <peterz@infradead.org>,
	=?iso-8859-1?Q?D=E2niel?= Fraga <fragabr@gmail.com>,
	Sasha Levin <sasha.levin@oracle.com>,
	"Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
	Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
	Suresh Siddha <sbsiddha@gmail.com>, Oleg Nesterov <oleg@redhat.com>,
	Peter Anvin <hpa@linux.intel.com>
References: <CA+55aFy1_w1NrkeopMXsxGftO5F03JzKgn-8uTQRnEAXuoiXgg@mail.gmail.com>
 <20141212185454.GB4716@redhat.com>
 <CA+55aFw7vJkuJ9RtVS3yhPsqDos+ii1kdJBZEeoxhb9c2=rStQ@mail.gmail.com>
 <20141213165915.GA12756@redhat.com>
 <20141213223616.GA22559@redhat.com>
 <CA+55aFwCa1+cBGxt-v487K-QBvxGyB9bL4u34zgMep9uFW+Mgw@mail.gmail.com>
 <20141214234654.GA396@redhat.com>
 <CA+55aFyUtZobUADgtss7e4w-yriMtz7hKVKs=Ed72KQoQ9n2nA@mail.gmail.com>
 <CA+55aFwE3gY+ChZtBpPtt_eY9nCj6pgF_wd8utRN9cOgRe2xOQ@mail.gmail.com>
 <54934487.3010608@mit.edu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <54934487.3010608@mit.edu>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Dec 18, 2014 at 01:17:59PM -0800, Andy Lutomirski wrote:

 > FWIW, if xsave traps with cr2 value, then there would indeed be an 
 > infinite loop in here.  It seems to work right on my machine.  Dave, 
 > want to run the attached little test?

XSAVE to offset 0
[OK]	xsave offset = 0, cr2 offset = 831
XSAVE to offset 64
[OK]	xsave offset = 64, cr2 offset = 895
XSAVE to offset 128
[OK]	xsave offset = 128, cr2 offset = 959
XSAVE to offset 192
[OK]	xsave offset = 192, cr2 offset = 1023
XSAVE to offset 256
[OK]	xsave offset = 256, cr2 offset = 1087
XSAVE to offset 320
[OK]	xsave offset = 320, cr2 offset = 1151
XSAVE to offset 384
[OK]	xsave offset = 384, cr2 offset = 1215
XSAVE to offset 448
[OK]	xsave offset = 448, cr2 offset = 1279
XSAVE to offset 512
[OK]	xsave offset = 512, cr2 offset = 1343
XSAVE to offset 576
[OK]	xsave offset = 576, cr2 offset = 1407
XSAVE to offset 640
[OK]	xsave offset = 640, cr2 offset = 1471
XSAVE to offset 704
[OK]	xsave offset = 704, cr2 offset = 1535
XSAVE to offset 768
[OK]	xsave offset = 768, cr2 offset = 1599
XSAVE to offset 832
[OK]	xsave offset = 832, cr2 offset = 1663
XSAVE to offset 896
[OK]	xsave offset = 896, cr2 offset = 1727
XSAVE to offset 960
[OK]	xsave offset = 960, cr2 offset = 1791
XSAVE to offset 1024
[OK]	xsave offset = 1024, cr2 offset = 1855
XSAVE to offset 1088
[OK]	xsave offset = 1088, cr2 offset = 1919
XSAVE to offset 1152
[OK]	xsave offset = 1152, cr2 offset = 1983
XSAVE to offset 1216
[OK]	xsave offset = 1216, cr2 offset = 2047
XSAVE to offset 1280
[OK]	xsave offset = 1280, cr2 offset = 2111
XSAVE to offset 1344
[OK]	xsave offset = 1344, cr2 offset = 2175
XSAVE to offset 1408
[OK]	xsave offset = 1408, cr2 offset = 2239
XSAVE to offset 1472
[OK]	xsave offset = 1472, cr2 offset = 2303
XSAVE to offset 1536
[OK]	xsave offset = 1536, cr2 offset = 2367
XSAVE to offset 1600
[OK]	xsave offset = 1600, cr2 offset = 2431
XSAVE to offset 1664
[OK]	xsave offset = 1664, cr2 offset = 2495
XSAVE to offset 1728
[OK]	xsave offset = 1728, cr2 offset = 2559
XSAVE to offset 1792
[OK]	xsave offset = 1792, cr2 offset = 2623
XSAVE to offset 1856
[OK]	xsave offset = 1856, cr2 offset = 2687
XSAVE to offset 1920
[OK]	xsave offset = 1920, cr2 offset = 2751
XSAVE to offset 1984
[OK]	xsave offset = 1984, cr2 offset = 2815
XSAVE to offset 2048
[OK]	xsave offset = 2048, cr2 offset = 2879
XSAVE to offset 2112
[OK]	xsave offset = 2112, cr2 offset = 2943
XSAVE to offset 2176
[OK]	xsave offset = 2176, cr2 offset = 3007
XSAVE to offset 2240
[OK]	xsave offset = 2240, cr2 offset = 3071
XSAVE to offset 2304
[OK]	xsave offset = 2304, cr2 offset = 3135
XSAVE to offset 2368
[OK]	xsave offset = 2368, cr2 offset = 3199
XSAVE to offset 2432
[OK]	xsave offset = 2432, cr2 offset = 3263
XSAVE to offset 2496
[OK]	xsave offset = 2496, cr2 offset = 3327
XSAVE to offset 2560
[OK]	xsave offset = 2560, cr2 offset = 3391
XSAVE to offset 2624
[OK]	xsave offset = 2624, cr2 offset = 3455
XSAVE to offset 2688
[OK]	xsave offset = 2688, cr2 offset = 3519
XSAVE to offset 2752
[OK]	xsave offset = 2752, cr2 offset = 3583
XSAVE to offset 2816
[OK]	xsave offset = 2816, cr2 offset = 3647
XSAVE to offset 2880
[OK]	xsave offset = 2880, cr2 offset = 3711
XSAVE to offset 2944
[OK]	xsave offset = 2944, cr2 offset = 3775
XSAVE to offset 3008
[OK]	xsave offset = 3008, cr2 offset = 3839
XSAVE to offset 3072
[OK]	xsave offset = 3072, cr2 offset = 3903
XSAVE to offset 3136
[OK]	xsave offset = 3136, cr2 offset = 3967
XSAVE to offset 3200
[OK]	xsave offset = 3200, cr2 offset = 4031
XSAVE to offset 3264
[OK]	xsave offset = 3264, cr2 offset = 4095
XSAVE to offset 3328
[OK]	xsave offset = 3328, cr2 offset = 3328
XSAVE to offset 3392
[OK]	xsave offset = 3392, cr2 offset = 3392
XSAVE to offset 3456
[OK]	xsave offset = 3456, cr2 offset = 3456
XSAVE to offset 3520
[OK]	xsave offset = 3520, cr2 offset = 3520
XSAVE to offset 3584
[OK]	xsave offset = 3584, cr2 offset = 3584
XSAVE to offset 3648
[OK]	xsave offset = 3648, cr2 offset = 3648
XSAVE to offset 3712
[OK]	xsave offset = 3712, cr2 offset = 3712
XSAVE to offset 3776
[OK]	xsave offset = 3776, cr2 offset = 3776
XSAVE to offset 3840
[OK]	xsave offset = 3840, cr2 offset = 3840
XSAVE to offset 3904
[OK]	xsave offset = 3904, cr2 offset = 3904
XSAVE to offset 3968
[OK]	xsave offset = 3968, cr2 offset = 3968
XSAVE to offset 4032
[OK]	xsave offset = 4032, cr2 offset = 4032
XSAVE to offset 4096
XSAVE to offset 4160
XSAVE to offset 4224
XSAVE to offset 4288
XSAVE to offset 4352
XSAVE to offset 4416
XSAVE to offset 4480
XSAVE to offset 4544
XSAVE to offset 4608
XSAVE to offset 4672
XSAVE to offset 4736
XSAVE to offset 4800
XSAVE to offset 4864
XSAVE to offset 4928
XSAVE to offset 4992
XSAVE to offset 5056
XSAVE to offset 5120
XSAVE to offset 5184
XSAVE to offset 5248
XSAVE to offset 5312
XSAVE to offset 5376
XSAVE to offset 5440
XSAVE to offset 5504
XSAVE to offset 5568
XSAVE to offset 5632
XSAVE to offset 5696
XSAVE to offset 5760
XSAVE to offset 5824
XSAVE to offset 5888
XSAVE to offset 5952
XSAVE to offset 6016
XSAVE to offset 6080
XSAVE to offset 6144
XSAVE to offset 6208
XSAVE to offset 6272
XSAVE to offset 6336
XSAVE to offset 6400
XSAVE to offset 6464
XSAVE to offset 6528
XSAVE to offset 6592
XSAVE to offset 6656
XSAVE to offset 6720
XSAVE to offset 6784
XSAVE to offset 6848
XSAVE to offset 6912
XSAVE to offset 6976
XSAVE to offset 7040
XSAVE to offset 7104
XSAVE to offset 7168
XSAVE to offset 7232
XSAVE to offset 7296
XSAVE to offset 7360
XSAVE to offset 7424
[OK]	xsave offset = 7424, cr2 offset = 8255
XSAVE to offset 7488
[OK]	xsave offset = 7488, cr2 offset = 8319
XSAVE to offset 7552
[OK]	xsave offset = 7552, cr2 offset = 8383
XSAVE to offset 7616
[OK]	xsave offset = 7616, cr2 offset = 8447
XSAVE to offset 7680
[OK]	xsave offset = 7680, cr2 offset = 8511
XSAVE to offset 7744
[OK]	xsave offset = 7744, cr2 offset = 8575
XSAVE to offset 7808
[OK]	xsave offset = 7808, cr2 offset = 8639
XSAVE to offset 7872
[OK]	xsave offset = 7872, cr2 offset = 8703
XSAVE to offset 7936
[OK]	xsave offset = 7936, cr2 offset = 8767
XSAVE to offset 8000
[OK]	xsave offset = 8000, cr2 offset = 8831
XSAVE to offset 8064
[OK]	xsave offset = 8064, cr2 offset = 8895
XSAVE to offset 8128
[OK]	xsave offset = 8128, cr2 offset = 8959
XSAVE to offset 8192
[OK]	xsave offset = 8192, cr2 offset = 9023
PASS!


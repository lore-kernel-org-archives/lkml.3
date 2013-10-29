Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752834Ab3J2Jr7 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Oct 2013 05:47:59 -0400
Received: from mail-qe0-f48.google.com ([209.85.128.48]:51099 "EHLO
	mail-qe0-f48.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751287Ab3J2Jr5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Oct 2013 05:47:57 -0400
MIME-Version: 1.0
Date: Tue, 29 Oct 2013 15:17:56 +0530
Message-ID: <CAL7o8isPSWoVYODEDHPns7HiH0+nJJO8HCjDp6d6R9Fy5fUmWA@mail.gmail.com>
Subject: [PROBLEM] Softirq ticks are incorrectly reported in /proc/stat
From: Mohammed Riyaz <riyaz.list@gmail.com>
To: linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi All,

I am trying to run some ethernet stress tests on 3.12-rc7 and found that
the softirq ticks are being reported incorrectly in /proc/stat
This issue does not occur if I pass 'nohz=off' as the bootarg.
I have attached both the outputs (with the same load conditions).

The difference in the softirq values for CPU3 is noticeable.

Thanks.
Riyaz


Here is the output in tickless mode
-------------------------------------
# cat /proc/stat ; sar -P ALL -u ALL 3 3  ; cat /proc/stat
cpu  2752 158 1807 276307 3609 0 518 0 0 0
cpu0 771 157 666 70208 2098 0 135 0 0 0
cpu1 663 0 486 70506 497 0 98 0 0 0
cpu2 741 1 408 73203 591 0 0 0 0 0
cpu3 575 0 246 62388 422 0 284 0 0 0
intr 13442043 19 2462 0 0 0 0 0 0 1 2939 0 0 25383 0 0 0 225 1378 0 0
0 0 0 2191827 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 29 10951866 9905 12 543
31332 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0
0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0
0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0
0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0
0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0
0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0
0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0
0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0
0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0
0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0
0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0
0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0
0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0
0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0
0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0
0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0
0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0
0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0
0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0
0 0 0 0
ctxt 505810
btime 1382964540
processes 2541
procs_running 2
procs_blocked 0
softirq 16993923 0 35059 2190164 12523211 9533 0 2188339 23582 54 23981
Linux 3.12.0-rc7-custom (mpiyaraj-ubuntu-13)    Monday 28 October 2013
 _x86_64_        (4 CPU)

06:31:31  IST     CPU      %usr     %nice      %sys   %iowait
%steal      %irq     %soft    %guest    %gnice     %idle
06:31:34  IST     all      0.09      0.00      0.00      0.00
0.00      0.00      0.00      0.00      0.00     99.91
06:31:34  IST       0      0.00      0.00      0.33      0.00
0.00      0.00      0.00      0.00      0.00     99.67
06:31:34  IST       1      0.33      0.00      0.00      0.00
0.00      0.00      0.00      0.00      0.00     99.67
06:31:34  IST       2      0.33      0.00      0.00      0.00
0.00      0.00      0.00      0.00      0.00     99.67
06:31:34  IST       3      0.00      0.00      0.00      0.00
0.00      0.00      0.00      0.00      0.00    100.00

06:31:34  IST     CPU      %usr     %nice      %sys   %iowait
%steal      %irq     %soft    %guest    %gnice     %idle
06:31:37  IST     all      0.09      0.00      0.09      0.27
0.00      0.00      0.27      0.00      0.00     99.27
06:31:37  IST       0      0.33      0.00      0.33      0.99
0.00      0.00      0.00      0.00      0.00     98.34
06:31:37  IST       1      0.00      0.00      0.00      0.00
0.00      0.00      0.00      0.00      0.00    100.00
06:31:37  IST       2      0.00      0.00      0.00      0.00
0.00      0.00      0.00      0.00      0.00    100.00
06:31:37  IST       3      0.50      0.00      0.00      0.00
0.00      0.00      1.01      0.00      0.00     98.49

06:31:37  IST     CPU      %usr     %nice      %sys   %iowait
%steal      %irq     %soft    %guest    %gnice     %idle
06:31:40  IST     all      0.00      0.00      0.09      0.09
0.00      0.00      0.00      0.00      0.00     99.82
06:31:40  IST       0      0.00      0.00      0.00      0.33
0.00      0.00      0.00      0.00      0.00     99.67
06:31:40  IST       1      0.00      0.00      0.00      0.00
0.00      0.00      0.00      0.00      0.00    100.00
06:31:40  IST       2      0.00      0.00      0.00      0.00
0.00      0.00      0.00      0.00      0.00    100.00
06:31:40  IST       3      0.00      0.00      0.00      0.00
0.00      0.00      0.00      0.00      0.00    100.00

Average:        CPU      %usr     %nice      %sys   %iowait    %steal
    %irq     %soft    %guest    %gnice     %idle
Average:        all      0.06      0.00      0.06      0.12      0.00
    0.00      0.09      0.00      0.00     99.67
Average:          0      0.11      0.00      0.22      0.44      0.00
    0.00      0.00      0.00      0.00     99.22
Average:          1      0.11      0.00      0.00      0.00      0.00
    0.00      0.00      0.00      0.00     99.89
Average:          2      0.11      0.00      0.00      0.00      0.00
    0.00      0.00      0.00      0.00     99.89
Average:          3      0.17      0.00      0.00      0.00      0.00
    0.00      0.34      0.00      0.00     99.49
cpu  2754 158 1810 279588 3613 0 521 0 0 0
cpu0 772 157 668 71102 2102 0 135 0 0 0
cpu1 664 0 486 71404 497 0 98 0 0 0
cpu2 742 1 408 74103 591 0 0 0 0 0
cpu3 576 0 247 62977 422 0 286 0 0 0
intr 13797414 19 2463 0 0 0 0 0 0 1 2963 0 0 25383 0 0 0 225 1378 0 0
0 0 0 2263885 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 29 11233916 9923 12 543
31872 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0
0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0
0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0
0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0
0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0
0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0
0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0
0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0
0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0
0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0
0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0
0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0
0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0
0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0
0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0
0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0
0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0
0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0
0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0
0 0 0 0
ctxt 507234
btime 1382964540
processes 2544
procs_running 1
procs_blocked 0
softirq 17472809 0 35150 2262208 12857795 9546 0 2260380 23650 54 24026



Here is the output with nohz=off
--------------------------------
# cat /proc/stat ; sar -P ALL -u ALL 3 3 ; cat /proc/stat
cpu  1526 292 982 66057 3878 0 3880 0 0 0
cpu0 393 2 270 16424 1627 0 447 0 0 0
cpu1 399 220 168 16629 889 0 849 0 0 0
cpu2 392 10 244 17040 724 0 709 0 0 0
cpu3 341 58 299 15963 636 0 1874 0 0 0
intr 6061445 19 1172 0 0 0 0 0 0 1 1144 0 0 8481 0 0 0 164 539 0 0 0 0
0 1378773 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 29 4347466 8177 12 10098 538
0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0
0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0
0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0
0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0
0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0
0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0
0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0
0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0
0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0
0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0
0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0
0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0
0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0
0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0
0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0
0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0
0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0
0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0
0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0
0
ctxt 313500
btime 1382963977
processes 2333
procs_running 1
procs_blocked 0
softirq 7524638 0 191542 542 5680722 8104 0 1380078 135807 1 127842
Linux 3.12.0-rc7-custom (mpiyaraj-ubuntu-13)    Monday 28 October 2013
 _x86_64_        (4 CPU)

06:12:49  IST     CPU      %usr     %nice      %sys   %iowait
%steal      %irq     %soft    %guest    %gnice     %idle
06:12:52  IST     all      0.17      0.00      0.08      0.17
0.00      0.00     14.65      0.00      0.00     84.93
06:12:52  IST       0      0.33      0.00      0.00      0.67
0.00      0.00      0.00      0.00      0.00     99.00
06:12:52  IST       1      0.00      0.00      0.00      0.00
0.00      0.00      0.00      0.00      0.00    100.00
06:12:52  IST       2      0.00      0.00      0.00      0.00
0.00      0.00      0.00      0.00      0.00    100.00
06:12:52  IST       3      0.33      0.00      0.00      0.00
0.00      0.00     58.33      0.00      0.00     41.33

06:12:52  IST     CPU      %usr     %nice      %sys   %iowait
%steal      %irq     %soft    %guest    %gnice     %idle
06:12:55  IST     all      0.08      0.00      0.00      0.00
0.00      0.00      9.18      0.00      0.00     90.73
06:12:55  IST       0      0.00      0.00      0.33      0.00
0.00      0.00      0.00      0.00      0.00     99.67
06:12:55  IST       1      0.33      0.00      0.33      0.00
0.00      0.00      0.00      0.00      0.00     99.33
06:12:55  IST       2      0.00      0.00      0.00      0.00
0.00      0.00      0.00      0.00      0.00    100.00
06:12:55  IST       3      0.00      0.00      0.00      0.00
0.00      0.00     37.00      0.00      0.00     63.00

06:12:55  IST     CPU      %usr     %nice      %sys   %iowait
%steal      %irq     %soft    %guest    %gnice     %idle
06:12:58  IST     all      0.08      0.00      0.08      0.17
0.00      0.00     11.40      0.00      0.00     88.27
06:12:58  IST       0      0.00      0.00      0.00      0.67
0.00      0.00      0.00      0.00      0.00     99.33
06:12:58  IST       1      0.00      0.00      0.00      0.00
0.00      0.00      0.00      0.00      0.00    100.00
06:12:58  IST       2      0.00      0.00      0.00      0.00
0.00      0.00      0.00      0.00      0.00    100.00
06:12:58  IST       3      0.00      0.00      0.00      0.00
0.00      0.00     45.33      0.00      0.00     54.67

Average:        CPU      %usr     %nice      %sys   %iowait    %steal
    %irq     %soft    %guest    %gnice     %idle
Average:        all      0.11      0.00      0.06      0.11      0.00
    0.00     11.75      0.00      0.00     87.98
Average:          0      0.11      0.00      0.11      0.44      0.00
    0.00      0.00      0.00      0.00     99.33
Average:          1      0.11      0.00      0.11      0.00      0.00
    0.00      0.00      0.00      0.00     99.78
Average:          2      0.00      0.00      0.00      0.00      0.00
    0.00      0.00      0.00      0.00    100.00
Average:          3      0.11      0.00      0.00      0.00      0.00
    0.00     46.89      0.00      0.00     53.00

cpu  1530 292 985 69241 3886 0 4303 0 0 0
cpu0 394 2 272 17320 1634 0 447 0 0 0
cpu1 400 220 169 17532 889 0 849 0 0 0
cpu2 392 10 244 17944 725 0 709 0 0 0
cpu3 342 58 299 16444 637 0 2297 0 0 0
intr 6472605 19 1173 0 0 0 0 0 0 1 1170 0 0 8481 0 0 0 164 539 0 0 0 0
0 1451221 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 29 4675786 8202 12 10641 538
0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0
0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0
0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0
0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0
0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0
0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0
0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0
0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0
0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0
0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0
0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0
0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0
0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0
0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0
0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0
0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0
0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0
0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0
0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0
0
ctxt 316598
btime 1382963977
processes 2336
procs_running 1
procs_blocked 0
softirq 8013998 0 200598 545 6074472 8125 0 1452527 144163 1 133567

mpiyaraj@mpiyaraj-ubuntu-13:~$ cat /proc/version
Linux version 3.12.0-rc7-custom (mpiyaraj@mpiyaraj-ubuntu-13) (gcc
version 4.8.1 (Ubuntu/Linaro 4.8.1-10ubuntu8) ) #1 SMP Mon Oct 28
17:14:27 IST 2013

mpiyaraj@mpiyaraj-ubuntu-13:~$ lsb_release -rd
Description:    Ubuntu 13.10
Release:        13.10

mpiyaraj@mpiyaraj-ubuntu-13:~$
/usr/src/linux-headers-3.12.0-rc7-custom/scripts/ver_linux
If some fields are empty or look unusual you may have an old version.
Compare to the current minimal requirements in Documentation/Changes.

Linux mpiyaraj-ubuntu-13 3.12.0-rc7-custom #1 SMP Mon Oct 28 17:14:27
IST 2013 x86_64 x86_64 x86_64 GNU/Linux

Gnu C                  4.8
Gnu make               3.81
binutils               2.23.52.20130913
util-linux             2.20.1
mount                  support
module-init-tools      9
e2fsprogs              1.42.8
pcmciautils            018
PPP                    2.4.5
Linux C Library        2.17
Dynamic linker (ldd)   2.17
Procps                 3.3.3
Net-tools              1.60
Kbd                    1.15.5
Sh-utils               8.20
wireless-tools         30
Modules Loaded         x86_pkg_temp_thermal intel_powerclamp coretemp
rfcomm kvm_intel bnep parport_pc ppdev kvm crct10dif_pclmul
crc32_pclmul ghash_clmulni_intel aesni_intel aes_x86_64 lrw gf128mul
joydev glue_helper ablk_helper cryptd snd_hda_codec_hdmi
snd_hda_codec_realtek uvcvideo videobuf2_vmalloc videobuf2_memops
videobuf2_core videodev asix usbnet arc4 rtl8192ce rtl_pci rtlwifi
rtl8192c_common mac80211 snd_hda_intel snd_hda_codec thinkpad_acpi
cfg80211 snd_hwdep nvram snd_pcm btusb i915 snd_page_alloc
snd_seq_midi snd_seq_midi_event snd_rawmidi snd_seq drm_kms_helper
microcode drm bluetooth psmouse snd_seq_device snd_timer i2c_algo_bit
rtsx_pci_ms lpc_ich serio_raw snd memstick mei_me soundcore mei video
wmi tpm_tis lp mac_hid parport rtsx_pci_sdmmc ahci libahci r8169 mii
rtsx_pci

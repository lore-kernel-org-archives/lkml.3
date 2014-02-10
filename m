Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752770AbaBJWVF (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Feb 2014 17:21:05 -0500
Received: from mx1.redhat.com ([209.132.183.28]:62178 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751323AbaBJWVB (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Feb 2014 17:21:01 -0500
Date: Mon, 10 Feb 2014 17:20:23 -0500
From: Don Zickus <dzickus@redhat.com>
To: Peter Zijlstra <peterz@infradead.org>
Cc: acme@ghostprotocols.net, LKML <linux-kernel@vger.kernel.org>,
        jolsa@redhat.com, jmario@redhat.com, fowles@inreach.com,
        eranian@google.com
Subject: Re: [PATCH 00/21] perf, c2c: Add new tool to analyze cacheline
 contention on NUMA systems
Message-ID: <20140210222023.GU25953@redhat.com>
References: <1392053356-23024-1-git-send-email-dzickus@redhat.com>
 <20140210212955.GC5002@laptop.programming.kicks-ass.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140210212955.GC5002@laptop.programming.kicks-ass.net>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Feb 10, 2014 at 10:29:55PM +0100, Peter Zijlstra wrote:
> On Mon, Feb 10, 2014 at 12:28:55PM -0500, Don Zickus wrote:
> > The data output is verbose and there are lots of data tables that interprit the latencies
> > and data addresses in different ways to help see where bottlenecks might be lying.
> 
> Would be good to see what the output looks like.

hehe.  unfortunately, my node info is causing double frees now, but
attached below (without node info)..

> 
> What I haven't seen; and what I would find most useful; is using the IP
> + dwarf info to map it back to a data structure member.

Yeah, we would like that too. :-)

> 
> Since you're already using the PEBS data-source fields, you can also
> have a precise IP. For many cases its possible to reconstruct the exact
> data member the instruction is modifying.
> 
> At that point you can do pahole like output of data structures, showing
> which members are 'hot' on misses etc.

Yeah, Arnaldo promised to look into that.  I think Stephane was doing some
research into that too.

Cheers,
Don


=================================================
            Trace Event Information              
=================================================
  Total records                     :    1322047
  Locked Load/Store Operations      :     206317
  Load Operations                   :     355701
  Loads - uncacheable               :        590
  Loads - no mapping                :        207
  Load Fill Buffer Hit              :     100214
  Load L1D hit                      :     148454
  Load L2D hit                      :      15170
  Load LLC hit                      :      53872
  Load Local HITM                   :      15388
  Load Remote HITM                  :      26760
  Load Remote HIT                   :       3910
  Load Local DRAM                   :       2436
  Load Remote DRAM                  :       3648
  Load MESI State Exclusive         :       2883
  Load MESI State Shared            :       3201
  Load LLC Misses                   :      36754
  LLC Misses to Local DRAM          :        6.6%
  LLC Misses to Remote DRAM         :        9.9%
  LLC Misses to Remote cache (HIT)  :       10.6%
  LLC Misses to Remote cache (HITM) :       72.8%
  Store Operations                  :     966322
  Store - uncacheable               :          0
  Store - no mapping                :      42931
  Store L1D Hit                     :     915696
  Virt -> Phys Remap Rejects        :          0
  No Page Map Rejects               :          0


================================================================================
                Execution Latency For Loads to Non Shared Memory

Metric                           Overall            Extremes            Selected
================================================================================
Samples                           301189                3454                 104

Minimum                               32                1006                4095
Maximum                             8149                8149                8149
Threshold                              0                1005                4042

Mode                                  34                1152                4556
Median                               136                1250                5163
Mean                                 236                1524                5337

Std Dev                            256.3               839.7               979.5
Coeff of Variation                 1.086               0.551               0.184
Confid Interval                      0.8                23.5                41.3




====================================================================================================================================================================
                                                       Non Shared Data Loads With Excessive Execution Latency

                        Load                                            ------ Load Inst Execute Latency ------                                                     
  Num  %dist  %cumm    Count       Data Address       Inst Address      Min   Median      Max     Mean       CV  Symbol                         Object              
====================================================================================================================================================================
-----------------------------------------------
    0  57.3%  57.3%       59 0xffffffff81c57ac0
-----------------------------------------------
                       33.9%               0x00 0xffffffff81098c43     4169     0.0     8149  5479.0    20.5%  update_cfs_shares              [kernel.kallsyms]   
                       66.1%               0x20 0xffffffff81094929     4155     0.0     7492  5286.6    16.9%  update_cfs_rq_blocked_load     [kernel.kallsyms]   
-----------------------------------------------
    1   5.8%  63.1%        6 0xffffffff818a1180
-----------------------------------------------
                       50.0%               0x04 0xffffffff815c4f1e     4866     0.0     8116  6745.7    25.0%  _raw_spin_lock                 [kernel.kallsyms]   
                       50.0%               0x04 0xffffffff815c4f47     4556     0.0     7389  6099.3    23.5%  _raw_spin_lock                 [kernel.kallsyms]   
-----------------------------------------------
    2   4.9%  68.0%        5 0xffff881fbf608ac0
-----------------------------------------------
                      100.0%               0x24 0xffffffff810981dd     4201     0.0     6653  5429.4    17.4%  task_tick_numa                 [kernel.kallsyms]   
-----------------------------------------------
    3   2.9%  70.9%        3 0xffff881fa55b0140
-----------------------------------------------
                      100.0%               0x38 0xffffffff81082e8a     4317     0.0     4571  4418.7     3.0%  mspin_lock                     [kernel.kallsyms]   
-----------------------------------------------
    4   2.9%  73.8%        3 0xffff883fff834700
-----------------------------------------------
                      100.0%               0x30 0xffffffff810948e4     4906     0.0     6078  5532.3    10.7%  update_cfs_rq_blocked_load     [kernel.kallsyms]   
-----------------------------------------------
    5   2.9%  76.7%        3 0xffff885fff834700
-----------------------------------------------
                      100.0%               0x30 0xffffffff810948e4     4921     0.0     6703  5828.7    15.3%  update_cfs_rq_blocked_load     [kernel.kallsyms]   
-----------------------------------------------
    6   2.9%  79.6%        3 0xffff885fff8b4700
-----------------------------------------------
                      100.0%               0x30 0xffffffff810948e4     4101     0.0     6022  5166.7    18.9%  update_cfs_rq_blocked_load     [kernel.kallsyms]   
-----------------------------------------------
    7   2.9%  82.5%        3 0xffff885fff9d4700
-----------------------------------------------
                      100.0%               0x30 0xffffffff810948e4     4319     0.0     4486  4381.7     2.1%  update_cfs_rq_blocked_load     [kernel.kallsyms]   
-----------------------------------------------
    8   1.9%  84.5%        2 0xffff885fff854700
-----------------------------------------------
                      100.0%               0x30 0xffffffff810948e4     5434     0.0     6075  5754.5     7.9%  update_cfs_rq_blocked_load     [kernel.kallsyms]   
-----------------------------------------------
    9   1.9%  86.4%        2 0xffff885fff974700
-----------------------------------------------
                      100.0%               0x30 0xffffffff810948e4     5326     0.0     5589  5457.5     3.4%  update_cfs_rq_blocked_load     [kernel.kallsyms]   
-----------------------------------------------
   10   1.9%  88.3%        2 0xffffffff819bd400
-----------------------------------------------
                       50.0%               0x04 0xffffffff810ae886     5427     0.0     5427  5427.0     0.0%  ktime_get                      [kernel.kallsyms]   
                       50.0%               0x04 0xffffffff810aed07     4334     0.0     4334  4334.0     0.0%  update_wall_time               [kernel.kallsyms]   
-----------------------------------------------
   11   1.0%  89.3%        1 0xffff881fc5600040
-----------------------------------------------
                      100.0%               0x20 0xffffffffa162cb70     5606     0.0     5606  5606.0     0.0%  mtip_irq_handler               [mtip32xx]          

<snip 11 records>
...




========================================================================================================
                                Load Access & Excute Latency Information

                                       Count      Minmum     Average        CV       Maximum       %dist
========================================================================================================
L1  Hit  - Snp None                   148444          32         242      1.1501        7492        39.5%
LFB Hit  - Snp None                   100190          32         271      0.8572        8149        29.8%
L2  Hit  - Snp None                    15154          32         227      0.9071        1682         3.8%
L3  Hit  - Snp None                    32029          32          70      1.7761        6353         2.5%
L3  Hit  - Snp Miss                     2489          38         373      0.7307        5306         1.0%
L3  Hit  - Snp Hit  - Lcl Cache         3802          32         150      0.9289        3225         0.6%
L3  Hit  - Snp Hitm - Lcl Cache        15388          32         187      1.0542        8485         3.2%
L3  Miss - Snp Hit  - Rmt Cache         3910          32         355      0.3318        3972         1.5%
L3  Miss - Snp Hitm - Rmt Cache        26760          32         493      0.5116        6236        14.5%
L3  Miss - Snp Hit  - Lcl Dram          1029          32         400      0.5783        3578         0.5%
L3  Miss - Snp Hit  - Rmt Dram          2170          32         541      0.7315        9967         1.3%
L3  Miss - Snp Miss - Lcl Dram          1406          32         431      0.9117        8116         0.7%
L3  Miss - Snp Miss - Rmt Dram          1477          34         554      0.4437        2956         0.9%
L3  Miss - Snp NA                        440           0         607      0.6940        2717         0.3%
Ld  UNC  - Snp None                        0  18446744073709551615           0        -nan           0         0.0%

=================================================
    Global Shared Cache Line Event Information   
=================================================
  Total Shared Cache Lines          :       1327
  Load HITs on shared lines         :     167131
  Fill Buffer Hits on shared lines  :      43469
  L1D hits on shared lines          :      50497
  L2D hits on shared lines          :        960
  LLC hits on shared lines          :      38467
  Locked Access on shared lines     :     100032
  Store HITs on shared lines        :     118659
  Store L1D hits on shared lines    :     113783
  Total Merged records              :     160807


================================================================================================================================================================================================================

                                                                                          Shared Data Cache Line Table

                                 Total     %All                Total       ---- Core Load Hit ----  -- LLC Load Hit --     ----- LLC Load Hitm -----     -- Load Dram --     LLC       ---- Store Reference ----
   Index           Phys Adrs   Records   Ld Miss     %hitm     Loads        FB       L1D       L2D       Lcl       Rmt     Total       Lcl       Rmt       Lcl       Rmt   Ld Miss     Total     L1Hit    L1Miss
================================================================================================================================================================================================================
       0  0xffff881fa55b0140     72006    16.97%    23.31%     43095     13591     16860        45      2651        25      9526      3288      6238       266       131      6660     28911     28098       813
       1  0xffff881fba47f000     21854     5.29%     7.26%     13938      3887      6941        15         1         7      3087      1143      1944         0         0      1951      7916      7916         0
       2  0xffff881fc21b9cc0      2153     1.61%     2.21%       862        32        70         0        15         1       740       148       592         0         4       597      1291      1235        56
       3  0xffff881fc7d91cc0      1957     1.40%     1.92%       866        34        94         0        14         3       720       207       513         0         1       517      1091      1028        63
       4  0xffff881fba539cc0      1813     1.35%     1.85%       808        33        84         3        14         1       665       170       495         8         0       504      1005       967        38
       5  0xffff881fc770bcc0      1939     1.30%     1.78%       827        36        70         0        16         1       700       223       477         4         0       482      1112      1058        54
       6  0xffff881fbc8adcc0      1854     1.25%     1.72%       788        21        77         1        12         2       674       215       459         0         1       462      1066       965       101
       7  0xffff881fc6c03cc0      1825     1.19%     1.63%       800        20        80         1        16         3       677       240       437         1         2       443      1025       973        52
       8  0xffff881fb93f1cc0      1934     1.17%     1.61%       846        42        79         2         7         2       711       280       431         0         3       436      1088      1022        66
       9  0xffff881fd1391cc0      1901     1.16%     1.59%       840        35        97         0        10         0       693       267       426         0         5       431      1061      1000        61
      10  0xffff881fd0771cc0      1731     1.14%     1.57%       779        19        62         1        22         9       663       244       419         1         2       431       952       890        62
      11  0xffff881fc7d31cc0      1971     1.13%     1.56%       826        29        91         2        19         5       677       260       417         0         3       425      1145      1064        81
      12  0xffff881fb9dcdcc0      1821     1.13%     1.55%       784        31        67         0        13         8       663       249       414         0         2       424      1037       973        64
      13  0xffff881fc3febcc0      1795     1.10%     1.51%       788        33        74         1        11         4       663       258       405         1         1       411      1007       936        71
      14  0xffff881fc7d29cc0      1837     1.10%     1.51%       756        30        71         0        19         1       634       229       405         1         0       407      1081      1023        58
      15  0xffff881fbc365cc0      1961     1.06%     1.46%       850        23        73         0        16         0       736       345       391         2         0       393      1111      1047        64
      16  0xffff881fd0259cc0      1896     1.04%     1.43%       779        28        68         1        15         0       665       282       383         1         1       385      1117      1052        65
      17  0xffff881fd0589cc0      1848     1.03%     1.42%       860        26        95         0        22         2       714       334       380         0         1       383       988       921        67
      18  0xffff881fd01a1cc0      1822     1.02%     1.40%       823        38        78         0        17         1       688       313       375         1         0       377       999       926        73
      19  0xffff881fb7ce1cc0      1833     1.00%     1.38%       761        28        72         0        11         2       642       274       368         1         5       376      1072       975        97
      20  0xffff881fb8099cc0      1846     0.94%     1.30%       779        23        52         1        11         2       684       337       347         1         5       355      1067       991        76
      21  0xffff881fc7e91cc0      1751     0.91%     1.25%       792        29        79         0        20         1       662       327       335         0         1       337       959       905        54
      22  0xffff881fbf608000       625     0.33%     0.45%       551       162        17        27       189        18       134        13       121         4         0       143        74        64        10

<snip 40 lines>
....


================================================================================================================================================================================================================

                                                                                      Shared Cache Line Distribution Pareto

     ---- All ----  -- Shared --    ---- HITM ----                                                                        Load Inst Execute Latency                                                             
       Data Misses   Data Misses   Remote    Local  -- Store Refs --                                                                      
                                                                                                                          ---- cycles ----             cpu
 Num  %dist  %cumm  %dist  %cumm  LLCmiss   LLChit   L1 hit  L1 Miss       Data Address    Pid    Tid       Inst Address   median     mean     CV      cnt Symbol                         Object                
================================================================================================================================================================================================================
-----------------------------------------------------------------------------------------------
   0  17.0%  17.0%  23.3%  23.3%     6238     3288    28098      813 0xffff881fa55b0140    ***
-----------------------------------------------------------------------------------------------
                                     0.0%     0.0%     0.0%     0.0%               0x00    375    375 0xffffffffa018ff5b      n/a      n/a      n/a      1 ext4_bio_write_page            [ext4]                
                                     0.0%     0.0%     0.0%     0.0%               0x08  18156  18165 0xffffffffa018b7f9       -1      384     0.0%      1 ext4_mark_iloc_dirty           [ext4]                
                                     0.2%     0.0%     0.0%     0.0%               0x10  18156    *** 0xffffffff811ca1aa       -1      387    10.7%      7 __mark_inode_dirty             [kernel.kallsyms]     
                                     0.7%     0.1%    15.9%     0.0%               0x18  18156    *** 0xffffffff815c15b1       -1     1241    24.0%     51 mutex_unlock                   [kernel.kallsyms]     
                                     0.0%     0.0%    23.2%     0.0%               0x18  18156    *** 0xffffffff815c1615       -1      684     0.0%     50 mutex_lock                     [kernel.kallsyms]     
                                     0.0%     0.0%     0.5%     3.1%               0x18  18156    *** 0xffffffff815c2082      n/a      n/a      n/a     38 __mutex_unlock_slowpath        [kernel.kallsyms]     
                                     0.2%     3.3%     0.0%     0.0%               0x18  18156    *** 0xffffffff815c2139       -1      496    22.7%     31 __mutex_lock_slowpath          [kernel.kallsyms]     
                                     0.2%     3.4%     5.1%     0.0%               0x18  18156    *** 0xffffffff815c2142       -1      821    13.2%     50 __mutex_lock_slowpath          [kernel.kallsyms]     
                                     0.0%     0.0%     0.1%     0.0%               0x18  18156    *** 0xffffffff815c21bf       -1     1203     0.0%     18 __mutex_lock_slowpath          [kernel.kallsyms]     
                                     1.2%     0.1%     0.0%     0.0%               0x18  18156    *** 0xffffffff815c21ed       -1      671    42.9%     37 __mutex_lock_slowpath          [kernel.kallsyms]     
                                     0.0%     0.1%     0.1%     0.1%               0x18  18156    *** 0xffffffff815c21f6       -1      971    16.5%     25 __mutex_lock_slowpath          [kernel.kallsyms]     
                                    10.9%     6.2%     2.5%    89.3%               0x1c  18156    *** 0xffffffff815c4e4a       -1      478    51.7%     50 _raw_spin_unlock               [kernel.kallsyms]     
                                    11.8%     2.0%    18.4%     0.0%               0x1c  18156    *** 0xffffffff815c4f1e       -1     1276    22.0%     50 _raw_spin_lock                 [kernel.kallsyms]     
                                     3.2%     2.6%     0.0%     0.0%               0x1c  18156    *** 0xffffffff815c4f47       -1      831    54.2%     48 _raw_spin_lock                 [kernel.kallsyms]     
                                     0.8%     0.4%     0.0%     0.0%               0x20  18156    *** 0xffffffff815c207f       -1      669    26.3%     26 __mutex_unlock_slowpath        [kernel.kallsyms]     
                                     0.0%     0.0%     0.0%     0.6%               0x28  18156    *** 0xffffffff812b7e4e      n/a      n/a      n/a      5 __list_add                     [kernel.kallsyms]     
                                     0.0%     0.1%     0.0%     0.0%               0x30  18156    *** 0xffffffff81082f19       -1      738    58.4%      5 mutex_spin_on_owner            [kernel.kallsyms]     
                                     0.1%     8.8%     0.0%     0.0%               0x30  18156    *** 0xffffffff81082f55       -1      730    33.9%     23 mutex_spin_on_owner            [kernel.kallsyms]     
                                     0.0%     0.0%     0.2%     0.4%               0x30  18156    *** 0xffffffff815c15a6      n/a      n/a      n/a     27 mutex_unlock                   [kernel.kallsyms]     
                                     0.0%     0.0%     2.8%     6.5%               0x30  18156    *** 0xffffffff815c1628      n/a      n/a      n/a     50 mutex_lock                     [kernel.kallsyms]     
                                     0.4%     0.4%     0.0%     0.0%               0x30  18156    *** 0xffffffff815c20d6       -1      860    50.5%     17 __mutex_lock_slowpath          [kernel.kallsyms]     
                                    60.3%    66.7%     0.0%     0.0%               0x30  18156    *** 0xffffffff815c211d       -1      471    46.6%     50 __mutex_lock_slowpath          [kernel.kallsyms]     
                                     0.0%     0.0%     0.0%     0.0%               0x30  18156  18165 0xffffffff815c2157      n/a      n/a      n/a      1 __mutex_lock_slowpath          [kernel.kallsyms]     
                                     9.8%     5.8%    31.0%     0.0%               0x38  18156    *** 0xffffffff81082e8a       -1      960    33.3%     50 mspin_lock                     [kernel.kallsyms]     
                                     0.0%     0.0%     0.1%     0.0%               0x38  18156    *** 0xffffffff81082ec4       -1      588    42.1%     18 mspin_unlock                   [kernel.kallsyms]     

-----------------------------------------------------------------------------------------------
   1   5.3%  22.3%   7.3%  30.6%     1944     1143     7916        0 0xffff881fba47f000  18156
-----------------------------------------------------------------------------------------------
                                   100.0%   100.0%     0.0%     0.0%               0x00  18156    *** 0xffffffffa01b410e       -1      401    13.5%     50 __ext4_journal_start_sb        [ext4]                
                                     0.0%     0.0%    10.1%     0.0%               0x28  18156    *** 0xffffffffa0167409      n/a      n/a      n/a     50 start_this_handle              [jbd2]                
                                     0.0%     0.0%    89.9%     0.0%               0x28  18156    *** 0xffffffff815c4be9      n/a      n/a      n/a     50 _raw_read_lock                 [kernel.kallsyms]     

-----------------------------------------------------------------------------------------------
   2   1.6%  23.9%   2.2%  32.8%      592      148     1235       56 0xffff881fc21b9cc0  18156
-----------------------------------------------------------------------------------------------
                                     0.0%     0.0%     0.2%     0.0%               0x00  18156  18172 0xffffffff81082e75      n/a      n/a      n/a      2 mspin_lock                     [kernel.kallsyms]     
                                     0.0%     0.0%     0.2%     0.0%               0x00  18156  18172 0xffffffff81082f15      n/a      n/a      n/a      2 mutex_spin_on_owner            [kernel.kallsyms]     
                                     0.3%     0.0%     0.0%     0.0%               0x00  18156  18172 0xffffffff81082f5a       -1      449     0.3%      1 mutex_spin_on_owner            [kernel.kallsyms]     
                                     0.0%     0.0%     0.2%     0.0%               0x00  18156  18172 0xffffffff810908ac      n/a      n/a      n/a      1 try_to_wake_up                 [kernel.kallsyms]     
                                     0.0%     0.0%     0.9%     0.0%               0x00  18156  18172 0xffffffff81090a73      n/a      n/a      n/a      5 try_to_wake_up                 [kernel.kallsyms]     
                                     0.0%     0.0%     2.3%     0.0%               0x00  18156  18172 0xffffffff8113524c      n/a      n/a      n/a      7 generic_segment_checks         [kernel.kallsyms]     
                                     0.0%     0.0%     1.1%     0.0%               0x00  18156  18172 0xffffffff81135f09      n/a      n/a      n/a      3 generic_file_buffered_write    [kernel.kallsyms]     
                                     0.0%     0.0%     3.8%     0.0%               0x00  18156  18172 0xffffffff811ba059      n/a      n/a      n/a      6 file_update_time               [kernel.kallsyms]     
                                     0.0%     0.0%     0.0%     1.8%               0x00  18156  18172 0xffffffff815c4275      n/a      n/a      n/a      1 schedule_preempt_disabled      [kernel.kallsyms]     
                                     2.9%     0.0%     0.0%     0.0%               0x00  18156  18172 0xffffffff815c4299       -1      353    15.2%      6 schedule_preempt_disabled      [kernel.kallsyms]     
                                     0.0%     0.0%     1.9%     0.0%               0x08  18156  18172 0xffffffff81135245      n/a      n/a      n/a      6 generic_segment_checks         [kernel.kallsyms]     
                                     0.0%     0.0%     0.5%     0.0%               0x08  18156  18172 0xffffffff81135f05      n/a      n/a      n/a      3 generic_file_buffered_write    [kernel.kallsyms]     
                                     0.0%     0.0%    10.0%     0.0%               0x08  18156  18172 0xffffffff811b9cb5      n/a      n/a      n/a      8 file_remove_suid               [kernel.kallsyms]     
                                     0.0%     0.0%     2.3%     0.0%               0x08  18156  18172 0xffffffff811ba055      n/a      n/a      n/a      8 file_update_time               [kernel.kallsyms]     
                                     0.0%     0.0%     2.8%     3.6%               0x08  18156  18172 0xffffffff815c2106      n/a      n/a      n/a      5 __mutex_lock_slowpath          [kernel.kallsyms]     
                                     0.0%     0.0%    12.2%     0.0%               0x08  18156  18172 0xffffffff815c2118      n/a      n/a      n/a      9 __mutex_lock_slowpath          [kernel.kallsyms]     
                                     0.0%     0.0%     2.9%    33.9%               0x08  18156  18172 0xffffffff815c212c      n/a      n/a      n/a      8 __mutex_lock_slowpath          [kernel.kallsyms]     
                                     0.0%     0.0%     0.0%     7.1%               0x08  18156  18172 0xffffffff815c21e8      n/a      n/a      n/a      3 __mutex_lock_slowpath          [kernel.kallsyms]     
                                     0.3%     0.0%     0.0%     0.0%               0x08  18156  18172 0xffffffff815c429a       -1      314    28.6%      2 schedule_preempt_disabled      [kernel.kallsyms]     
                                     0.0%     0.0%     0.1%     0.0%               0x10  18156  18172 0xffffffff81082e80      n/a      n/a      n/a      1 mspin_lock                     [kernel.kallsyms]     
                                     0.0%     0.0%     0.0%    17.9%               0x10  18156    *** 0xffffffff81082e9b      n/a      n/a      n/a      8 mspin_lock                     [kernel.kallsyms]     
                                     0.0%     0.0%     0.1%     0.0%               0x10  18156  18172 0xffffffff810908a2      n/a      n/a      n/a      1 try_to_wake_up                 [kernel.kallsyms]     
                                     0.0%     0.0%     1.4%     0.0%               0x10  18156  18172 0xffffffff81137c4d      n/a      n/a      n/a      7 __generic_file_aio_write       [kernel.kallsyms]     
                                     0.0%     0.0%     7.4%     0.0%               0x10  18156  18172 0xffffffff81137d7b      n/a      n/a      n/a      9 __generic_file_aio_write       [kernel.kallsyms]     
                                     0.0%     0.0%     0.2%     0.0%               0x10  18156  18172 0xffffffff81137dbc      n/a      n/a      n/a      2 __generic_file_aio_write       [kernel.kallsyms]     
                                     0.2%     0.7%     0.0%     0.0%               0x10  18156    *** 0xffffffff812b7e3b       -1      507     0.0%      2 __list_add                     [kernel.kallsyms]     
                                    89.0%    98.0%     0.0%     0.0%               0x18  18156  18172 0xffffffff81082ea7       -1      471    28.5%      9 mspin_lock                     [kernel.kallsyms]     
                                     0.0%     0.0%     0.0%    33.9%               0x18  18156    *** 0xffffffff81082eda      n/a      n/a      n/a     15 mspin_unlock                   [kernel.kallsyms]     
                                     0.0%     0.0%     0.1%     0.0%               0x18  18156  18172 0xffffffff810908a0      n/a      n/a      n/a      1 try_to_wake_up                 [kernel.kallsyms]     
                                     0.0%     0.0%    13.8%     1.8%               0x18  18156  18172 0xffffffff811360de      n/a      n/a      n/a      9 generic_file_buffered_write    [kernel.kallsyms]     
                                     0.0%     0.0%     6.6%     0.0%               0x18  18156  18172 0xffffffff81137dab      n/a      n/a      n/a      9 __generic_file_aio_write       [kernel.kallsyms]     
                                     0.0%     0.0%     0.2%     0.0%               0x20  18156  18172 0xffffffff8109089e      n/a      n/a      n/a      1 try_to_wake_up                 [kernel.kallsyms]     
                                     7.3%     1.4%     0.0%     0.0%               0x20  18156    *** 0xffffffff815c208e       -1      402    13.6%     29 __mutex_unlock_slowpath        [kernel.kallsyms]     
                                     0.0%     0.0%    19.5%     0.0%               0x28  18156  18172 0xffffffff81137d63      n/a      n/a      n/a      9 __generic_file_aio_write       [kernel.kallsyms]     
                                     0.0%     0.0%     0.2%     0.0%               0x30  18156  18172 0xffffffff81137c49      n/a      n/a      n/a      1 __generic_file_aio_write       [kernel.kallsyms]     
                                     0.0%     0.0%     5.4%     0.0%               0x30  18156  18172 0xffffffff81137dc1      n/a      n/a      n/a      6 __generic_file_aio_write       [kernel.kallsyms]     
                                     0.0%     0.0%     2.6%     0.0%               0x38  18156  18172 0xffffffff81090b4e      n/a      n/a      n/a      7 wake_up_process                [kernel.kallsyms]     
                                     0.0%     0.0%     1.3%     0.0%               0x38  18156  18172 0xffffffff81137c2c      n/a      n/a      n/a      4 __generic_file_aio_write       [kernel.kallsyms]     

-----------------------------------------------------------------------------------------------
   3   1.4%  25.3%   1.9%  34.7%      513      207     1028       63 0xffff881fc7d91cc0  18156
-----------------------------------------------------------------------------------------------
                                     0.0%     0.0%     0.2%     0.0%               0x00  18156  18159 0xffffffff81082e75      n/a      n/a      n/a      2 mspin_lock                     [kernel.kallsyms]     
                                     0.0%     0.0%     0.1%     0.0%               0x00  18156  18159 0xffffffff81082f15      n/a      n/a      n/a      1 mutex_spin_on_owner            [kernel.kallsyms]     
                                     0.4%     0.5%     0.0%     0.0%               0x00  18156  18159 0xffffffff81082f5a       -1      446     2.5%      2 mutex_spin_on_owner            [kernel.kallsyms]     
                                     0.0%     0.0%     0.3%     0.0%               0x00  18156  18159 0xffffffff810908ac      n/a      n/a      n/a      3 try_to_wake_up                 [kernel.kallsyms]     
                                     0.0%     0.0%     0.1%     0.0%               0x00  18156  18159 0xffffffff810908fc      n/a      n/a      n/a      1 try_to_wake_up                 [kernel.kallsyms]     
                                     0.0%     0.0%     1.6%     0.0%               0x00  18156  18159 0xffffffff81090a73      n/a      n/a      n/a      7 try_to_wake_up                 [kernel.kallsyms]     
                                     0.0%     0.0%     2.9%     0.0%               0x00  18156  18159 0xffffffff8113524c      n/a      n/a      n/a      6 generic_segment_checks         [kernel.kallsyms]     
                                     0.0%     0.0%     0.1%     0.0%               0x00  18156  18159 0xffffffff81135f09      n/a      n/a      n/a      1 generic_file_buffered_write    [kernel.kallsyms]     
                                     0.0%     0.0%     0.2%     0.0%               0x00  18156  18159 0xffffffff811ba059      n/a      n/a      n/a      1 file_update_time               [kernel.kallsyms]     
                                     0.0%     0.0%     0.1%     0.0%               0x00  18156  18159 0xffffffff815c4275      n/a      n/a      n/a      1 schedule_preempt_disabled      [kernel.kallsyms]     
                                     3.1%     0.0%     0.0%     0.0%               0x00  18156  18159 0xffffffff815c4299       -1      376    18.4%      5 schedule_preempt_disabled      [kernel.kallsyms]     
                                     0.2%     0.0%     0.0%     0.0%               0x00  18156  18159 0xffffffff815c4f4f       -1      431     0.0%      1 _raw_spin_lock                 [kernel.kallsyms]     
                                     0.0%     0.0%     1.9%     0.0%               0x08  18156  18159 0xffffffff81135245      n/a      n/a      n/a      5 generic_segment_checks         [kernel.kallsyms]     
                                     0.0%     0.0%     1.6%     0.0%               0x08  18156  18159 0xffffffff811b9cb5      n/a      n/a      n/a      5 file_remove_suid               [kernel.kallsyms]     
                                     0.0%     0.0%     0.1%     0.0%               0x08  18156  18159 0xffffffff811ba055      n/a      n/a      n/a      1 file_update_time               [kernel.kallsyms]     
                                     0.0%     0.0%     2.9%     3.2%               0x08  18156  18159 0xffffffff815c2106      n/a      n/a      n/a      5 __mutex_lock_slowpath          [kernel.kallsyms]     
                                     0.0%     0.0%    17.6%     0.0%               0x08  18156  18159 0xffffffff815c2118      n/a      n/a      n/a      7 __mutex_lock_slowpath          [kernel.kallsyms]     
                                     0.0%     0.0%     6.2%    31.7%               0x08  18156  18159 0xffffffff815c212c      n/a      n/a      n/a      7 __mutex_lock_slowpath          [kernel.kallsyms]     
                                     0.0%     0.0%     0.1%     0.0%               0x08  18156  18159 0xffffffff815c21aa      n/a      n/a      n/a      1 __mutex_lock_slowpath          [kernel.kallsyms]     
                                     0.0%     0.0%     0.0%     9.5%               0x08  18156  18159 0xffffffff815c21e8      n/a      n/a      n/a      5 __mutex_lock_slowpath          [kernel.kallsyms]     
                                     0.0%     0.0%     0.1%     0.0%               0x08  18156  18159 0xffffffff815c2246      n/a      n/a      n/a      1 __mutex_lock_slowpath          [kernel.kallsyms]     
                                     0.4%     0.0%     0.0%     0.0%               0x08  18156  18159 0xffffffff815c429a       -1      358    35.7%      2 schedule_preempt_disabled      [kernel.kallsyms]     
                                     0.0%     0.0%     0.0%    23.8%               0x10  18156    *** 0xffffffff81082e9b      n/a      n/a      n/a     10 mspin_lock                     [kernel.kallsyms]     
                                     0.0%     0.0%     0.2%     0.0%               0x10  18156  18159 0xffffffff810908a2      n/a      n/a      n/a      2 try_to_wake_up                 [kernel.kallsyms]     
                                     0.0%     0.0%     1.3%     0.0%               0x10  18156  18159 0xffffffff81137c4d      n/a      n/a      n/a      4 __generic_file_aio_write       [kernel.kallsyms]     
                                     0.0%     0.0%     4.2%     0.0%               0x10  18156  18159 0xffffffff81137d7b      n/a      n/a      n/a      6 __generic_file_aio_write       [kernel.kallsyms]     
                                     0.0%     0.0%     2.0%     0.0%               0x10  18156  18159 0xffffffff81137dbc      n/a      n/a      n/a      5 __generic_file_aio_write       [kernel.kallsyms]     
                                     0.2%     0.0%     0.0%     0.0%               0x10  18156  18175 0xffffffff812b7e3b       -1      502     0.0%      1 __list_add                     [kernel.kallsyms]     
                                    90.8%    92.3%     0.0%     0.0%               0x18  18156  18159 0xffffffff81082ea7       -1      481    25.2%      7 mspin_lock                     [kernel.kallsyms]     
                                     0.0%     0.0%     0.0%    31.7%               0x18  18156    *** 0xffffffff81082eda      n/a      n/a      n/a     12 mspin_unlock                   [kernel.kallsyms]     
                                     0.0%     0.0%     0.1%     0.0%               0x18  18156  18159 0xffffffff810908a0      n/a      n/a      n/a      1 try_to_wake_up                 [kernel.kallsyms]     
                                     0.0%     0.0%    24.2%     0.0%               0x18  18156  18159 0xffffffff811360de      n/a      n/a      n/a      7 generic_file_buffered_write    [kernel.kallsyms]     
                                     0.0%     0.0%     7.8%     0.0%               0x18  18156  18159 0xffffffff81137dab      n/a      n/a      n/a      6 __generic_file_aio_write       [kernel.kallsyms]     
                                     0.0%     0.0%     0.1%     0.0%               0x20  18156  18159 0xffffffff8109089e      n/a      n/a      n/a      1 try_to_wake_up                 [kernel.kallsyms]     
                                     4.9%     7.2%     0.0%     0.0%               0x20  18156    *** 0xffffffff815c208e       -1      381    15.7%     28 __mutex_unlock_slowpath        [kernel.kallsyms]     
                                     0.0%     0.0%    15.9%     0.0%               0x28  18156  18159 0xffffffff81137d63      n/a      n/a      n/a      7 __generic_file_aio_write       [kernel.kallsyms]     
                                     0.0%     0.0%     0.1%     0.0%               0x30  18156  18159 0xffffffff81090895      n/a      n/a      n/a      1 try_to_wake_up                 [kernel.kallsyms]     
                                     0.0%     0.0%     0.1%     0.0%               0x30  18156  18159 0xffffffff81137c49      n/a      n/a      n/a      1 __generic_file_aio_write       [kernel.kallsyms]     
                                     0.0%     0.0%     4.3%     0.0%               0x30  18156  18159 0xffffffff81137dc1      n/a      n/a      n/a      7 __generic_file_aio_write       [kernel.kallsyms]     
                                     0.0%     0.0%     0.1%     0.0%               0x30  18156  18159 0xffffffff815ce68c      n/a      n/a      n/a      1 apic_timer_interrupt           [kernel.kallsyms]     
                                     0.0%     0.0%     2.3%     0.0%               0x38  18156  18159 0xffffffff81090b4e      n/a      n/a      n/a      5 wake_up_process                [kernel.kallsyms]     
                                     0.0%     0.0%     1.3%     0.0%               0x38  18156  18159 0xffffffff81137c2c      n/a      n/a      n/a      6 __generic_file_aio_write       [kernel.kallsyms]     

-----------------------------------------------------------------------------------------------
   4   1.3%  26.6%   1.8%  36.6%      495      170      967       38 0xffff881fba539cc0  18156
-----------------------------------------------------------------------------------------------
                                     0.0%     0.0%     0.2%     0.0%               0x00  18156  18169 0xffffffff81082e75      n/a      n/a      n/a      2 mspin_lock                     [kernel.kallsyms]     
                                     0.0%     0.0%     0.2%     0.0%               0x00  18156  18169 0xffffffff81082f15      n/a      n/a      n/a      2 mutex_spin_on_owner            [kernel.kallsyms]     
                                     0.0%     0.6%     0.0%     0.0%               0x00  18156  18169 0xffffffff81082f5a      n/a      n/a      n/a      1 mutex_spin_on_owner            [kernel.kallsyms]     
                                     0.0%     0.0%     0.1%     0.0%               0x00  18156  18169 0xffffffff810908ac      n/a      n/a      n/a      1 try_to_wake_up                 [kernel.kallsyms]     
                                     0.0%     0.0%     1.0%     0.0%               0x00  18156  18169 0xffffffff81090a73      n/a      n/a      n/a      5 try_to_wake_up                 [kernel.kallsyms]     
                                     0.0%     0.0%     2.1%     0.0%               0x00  18156  18169 0xffffffff8113524c      n/a      n/a      n/a      7 generic_segment_checks         [kernel.kallsyms]     
                                     0.0%     0.0%     0.1%     0.0%               0x00  18156  18169 0xffffffff81135f09      n/a      n/a      n/a      1 generic_file_buffered_write    [kernel.kallsyms]     
                                     0.0%     0.0%     0.4%     0.0%               0x00  18156  18169 0xffffffff811ba059      n/a      n/a      n/a      3 file_update_time               [kernel.kallsyms]     
                                     0.0%     0.0%     0.1%     0.0%               0x00  18156  18169 0xffffffff815c4275      n/a      n/a      n/a      1 schedule_preempt_disabled      [kernel.kallsyms]     
                                     1.2%     0.0%     0.0%     0.0%               0x00  18156  18169 0xffffffff815c4299       -1      298     8.7%      6 schedule_preempt_disabled      [kernel.kallsyms]     
                                     0.2%     0.0%     0.0%     0.0%               0x00  18156  18169 0xffffffff815c4f2c       -1      441     0.0%      1 _raw_spin_lock                 [kernel.kallsyms]     
                                     0.4%     0.0%     0.0%     0.0%               0x00  18156  18169 0xffffffff815c4f4f       -1      353     8.8%      2 _raw_spin_lock                 [kernel.kallsyms]     
                                     0.0%     0.0%     1.2%     0.0%               0x08  18156  18169 0xffffffff81135245      n/a      n/a      n/a      9 generic_segment_checks         [kernel.kallsyms]     
                                     0.0%     0.0%     1.3%     0.0%               0x08  18156  18169 0xffffffff811b9cb5      n/a      n/a      n/a      8 file_remove_suid               [kernel.kallsyms]     
                                     0.0%     0.0%     0.6%     0.0%               0x08  18156  18169 0xffffffff811ba055      n/a      n/a      n/a      4 file_update_time               [kernel.kallsyms]     
                                     0.0%     0.0%     4.2%    13.2%               0x08  18156  18169 0xffffffff815c2106      n/a      n/a      n/a      9 __mutex_lock_slowpath          [kernel.kallsyms]     
                                     0.0%     0.0%    13.8%     0.0%               0x08  18156  18169 0xffffffff815c2118      n/a      n/a      n/a     12 __mutex_lock_slowpath          [kernel.kallsyms]     
                                     0.0%     0.0%     5.0%    50.0%               0x08  18156  18169 0xffffffff815c212c      n/a      n/a      n/a     11 __mutex_lock_slowpath          [kernel.kallsyms]     
                                     0.0%     0.0%     0.1%     0.0%               0x08  18156  18169 0xffffffff815c21e0      n/a      n/a      n/a      1 __mutex_lock_slowpath          [kernel.kallsyms]     
                                     0.0%     0.0%     0.1%    15.8%               0x08  18156  18169 0xffffffff815c21e8      n/a      n/a      n/a      5 __mutex_lock_slowpath          [kernel.kallsyms]     
                                     1.0%     0.0%     0.0%     0.0%               0x08  18156  18169 0xffffffff815c429a       -1      286     5.8%      3 schedule_preempt_disabled      [kernel.kallsyms]     
                                     0.0%     0.0%     0.1%     0.0%               0x10  18156  18169 0xffffffff81082e80      n/a      n/a      n/a      1 mspin_lock                     [kernel.kallsyms]     
                                     0.0%     0.0%     0.2%     0.0%               0x10  18156  18169 0xffffffff810908a2      n/a      n/a      n/a      2 try_to_wake_up                 [kernel.kallsyms]     
                                     0.0%     0.0%     1.2%     0.0%               0x10  18156  18169 0xffffffff81137c4d      n/a      n/a      n/a      6 __generic_file_aio_write       [kernel.kallsyms]     
                                     0.0%     0.0%     5.2%     0.0%               0x10  18156  18169 0xffffffff81137d7b      n/a      n/a      n/a     12 __generic_file_aio_write       [kernel.kallsyms]     
                                     0.0%     0.0%     1.9%     0.0%               0x10  18156  18169 0xffffffff81137dbc      n/a      n/a      n/a      8 __generic_file_aio_write       [kernel.kallsyms]     
                                     0.2%     0.0%     0.0%     0.0%               0x10  18156  18175 0xffffffff812b7e3b       -1      355     0.0%      1 __list_add                     [kernel.kallsyms]     
                                    90.9%    93.5%     0.0%     0.0%               0x18  18156  18169 0xffffffff81082ea7       -1      613    28.9%     13 mspin_lock                     [kernel.kallsyms]     
                                     0.0%     0.0%     0.0%    21.1%               0x18  18156    *** 0xffffffff81082eda      n/a      n/a      n/a      7 mspin_unlock                   [kernel.kallsyms]     
                                     0.0%     0.0%    26.0%     0.0%               0x18  18156  18169 0xffffffff811360de      n/a      n/a      n/a     12 generic_file_buffered_write    [kernel.kallsyms]     
                                     0.0%     0.0%     9.0%     0.0%               0x18  18156  18169 0xffffffff81137dab      n/a      n/a      n/a     12 __generic_file_aio_write       [kernel.kallsyms]     
                                     6.1%     5.9%     0.0%     0.0%               0x20  18156    *** 0xffffffff815c208e       -1      377    19.3%     25 __mutex_unlock_slowpath        [kernel.kallsyms]     
                                     0.0%     0.0%    18.2%     0.0%               0x28  18156  18169 0xffffffff81137d63      n/a      n/a      n/a     12 __generic_file_aio_write       [kernel.kallsyms]     
                                     0.0%     0.0%     0.2%     0.0%               0x30  18156  18169 0xffffffff81137c49      n/a      n/a      n/a      2 __generic_file_aio_write       [kernel.kallsyms]     
                                     0.0%     0.0%     0.1%     0.0%               0x30  18156  18169 0xffffffff81137d67      n/a      n/a      n/a      1 __generic_file_aio_write       [kernel.kallsyms]     
                                     0.0%     0.0%     3.1%     0.0%               0x30  18156  18169 0xffffffff81137dc1      n/a      n/a      n/a      8 __generic_file_aio_write       [kernel.kallsyms]     
                                     0.0%     0.0%     3.1%     0.0%               0x38  18156  18169 0xffffffff81090b4e      n/a      n/a      n/a     11 wake_up_process                [kernel.kallsyms]     
                                     0.0%     0.0%     1.1%     0.0%               0x38  18156  18169 0xffffffff81137c2c      n/a      n/a      n/a      8 __generic_file_aio_write       [kernel.kallsyms]     


<snip 58 records>
....



=====================================================================================================================================
                                                   Object Name, Path & Reference Counts

Index    Records   Object Name                       Object Path                                                                     
=====================================================================================================================================
    0     931379   [kernel.kallsyms]                 [kernel.kallsyms]                                                               
    1     192258   fio                               /home/joe/old_fio-2.0.15/fio                                                    
    2      80302   [jbd2]                            /lib/modules/3.10.0c2c_all+/kernel/fs/jbd2/jbd2.ko                              
    3      65392   [ext4]                            /lib/modules/3.10.0c2c_all+/kernel/fs/ext4/ext4.ko                              
    4       8236   libpthread-2.17.so                /usr/lib64/libpthread-2.17.so                                                   
    5         19   [ip_tables]                       /lib/modules/3.10.0c2c_all+/kernel/net/ipv4/netfilter/ip_tables.ko              
    6         17   [ixgbe]                           /lib/modules/3.10.0c2c_all+/kernel/drivers/net/ethernet/intel/ixgbe/ixgbe.ko    
    7         17   perf                              /home/root/git/rhel7.don/tools/perf/perf                                        
    8         13   [ipmi_si]                         /lib/modules/3.10.0c2c_all+/kernel/drivers/char/ipmi/ipmi_si.ko                 
    9         11   libc-2.17.so                      /usr/lib64/libc-2.17.so                                                         
   10         10   [megaraid_sas]                    /lib/modules/3.10.0c2c_all+/kernel/drivers/scsi/megaraid/megaraid_sas.ko        
   11          9   [mtip32xx]                        /lib/modules/3.10.0c2c_all+/kernel/drivers/block/mtip32xx/mtip32xx.ko           
   12          6   irqbalance                        /usr/sbin/irqbalance                                                            
   13          6   libpython2.7.so.1.0               /usr/lib64/libpython2.7.so.1.0                                                  
   14          5   [ip6_tables]                      /lib/modules/3.10.0c2c_all+/kernel/net/ipv6/netfilter/ip6_tables.ko             
   15          4   [nf_conntrack]                    /lib/modules/3.10.0c2c_all+/kernel/net/netfilter/nf_conntrack.ko                
   16          2   [dm_mod]                          /lib/modules/3.10.0c2c_all+/kernel/drivers/md/dm-mod.ko                         
   17          2   sshd                              /usr/sbin/sshd                                                                  
   18          1   [iptable_raw]                     /lib/modules/3.10.0c2c_all+/kernel/net/ipv4/netfilter/iptable_raw.ko            
   19          1   [sb_edac]                         /lib/modules/3.10.0c2c_all+/kernel/drivers/edac/sb_edac.ko                      
   20          1   [edac_core]                       /lib/modules/3.10.0c2c_all+/kernel/drivers/edac/edac_core.ko                    
   21          1   libdbus-1.so.3.7.4                /usr/lib64/libdbus-1.so.3.7.4                                                   


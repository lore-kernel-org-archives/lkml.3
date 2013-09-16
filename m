Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751570Ab3IPWU0 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Sep 2013 18:20:26 -0400
Received: from e8.ny.us.ibm.com ([32.97.182.138]:57974 "EHLO e8.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751197Ab3IPWUY (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Sep 2013 18:20:24 -0400
From: zwu.kernel@gmail.com
To: viro@zeniv.linux.org.uk
Cc: linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org,
        Zhi Yong Wu <wuzhy@linux.vnet.ibm.com>
Subject: [PATCH v5 00/10] VFS hot tracking
Date: Tue, 17 Sep 2013 06:17:45 +0800
Message-Id: <1379369875-5123-1-git-send-email-zwu.kernel@gmail.com>
X-Mailer: git-send-email 1.7.11.7
X-TM-AS-MML: No
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 13091622-0320-0000-0000-000001064241
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Zhi Yong Wu <wuzhy@linux.vnet.ibm.com>

  The patchset is trying to introduce hot tracking function in
VFS layer, which will keep track of real disk I/O in memory.
By it, you will easily know more details about disk I/O, and
then detect where disk I/O hot spots are. Also, specific FS
can take use of it to do accurate defragment, and hot relocation
support, etc.

  Now it's time to send out its V5 for external review, and
any comments or ideas are appreciated, thanks.

NOTE:

  The patchset can be obtained via my kernel dev git on github:
git://github.com/wuzhy/kernel.git hot_tracking
  If you're interested, you can also review them via
https://github.com/wuzhy/kernel/commits/hot_tracking

  For how to use and more other info and performance report,
please check hot_tracking.txt in Documentation and following
links:
  1.) http://lwn.net/Articles/525651/
  2.) https://lkml.org/lkml/2012/12/20/199

  This patchset has been done scalability or performance tests
by fs_mark, ffsb and compilebench.

  The perf testing was done on Linux 3.11.0+ with Intel(R) Core(TM)
i7-3770 CPU @ 3.40GHz with 8 CPUs, 16G ram and 260G disk.

  Below is the perf testing report:

1. fs_mark test

w/ : with hot tracking
w/o: without hot tracking

  Count     Size    FSUse%          Files/sec            App Overhead
                   w/     w/o      w/        w/o         w/         w/o
  800000     1      5      5     5606.9    40486.6     7773339     8575934  
 1600000     1      5      5     1244.8     1194.8     8262292     8253933
 2400000     1      6      6     1155.7      997.2     7640679     7854540
 3200000     1      7      8     1079.7     1124.0     7373659     8121016
 4000000     1      9      9     1169.4     1324.8     7961605     9598549
 4800000     1     10     10     1259.8     1331.7     8992159     8743297
 5600000     1     11     11     1337.7     1339.3     8675246     8029501
 6400000     1     13     13     1346.7     1365.5     8613958    10018455
 7200000     1     14     14     1339.8     1423.1     7885932     8466961
 8000000     1     15     15     1353.0     1368.6    13543947     9727348
 8800000     1     16     17     1460.7     1396.4     8744351     8034638
 9600000     1     18     18     1462.9     1415.4    11678864     8557992
10400000     1     19     19     1503.8     1457.6     8984918     9696330
11200000     1     20     20     1521.9     1491.4     8732741     8307835
12000000     1     21     22     1617.7     1556.0    12948158     8776620
12800000     1     23     23     1518.0     1572.3     8470307     8652605
13600000     1     24     24     1595.8     1570.5    11476909     8622940
14400000     1     25     26     1651.8     1722.1    11864599     9646962
15200000     1     26     27     1696.8     1619.     10679127     8472579
16000000     1     28     28     1567.4     1652.3     8756616     8713324
16800000     1     29     29     1599.9     1683.7    10982360     9084005
17600000     1     31     30     1671.3     1699.6     9559853     8388523
18400000     1     32     32     1567.3     1666.7    10576088    11717888
19200000     1     33     33     1668.4     1606.0     8657168     9063387
20000000     1     34     34     1654.1     1521.5    11115008     8384464
20800000     1     36     36     1637.6     1666.2     9964151     8176858
21600000     1     37     37     1598.7     1677.0     8648364     8190571
22400000     1     38     38     1688.8     1674.0     8881927    12847479
23200000     1     39     39     1627.0     1648.2     8707422     9350644
24000000     1     41     41     1704.7     1718.9     9525011     8437322
24800000     1     42     42     1628.2     1649.7     8445795     9195963
25600000     1     43     43     1690.4     1647.3    10444544    10808578
26400000     1     44     44     1597.4     1582.4     8956981    12286644
27200000     1     46     46     1677.7     1710.4     8244101     9492204
28000000     1     47     47     1664.9     1640.9     8860491     8683678
28800000     1     48     48     1608.7     1670.8     8381652    12105478
29600000     1     50     50     1682.0     1652.4    13991121     8630876
30400000     1     51     51     1672.6     1743.2     8853590    10377349
31200000     1     52     52     1648.5     1691.3    11290708     8407930
32000000     1     53     53     1649.5     1708.1    11647884    10120780
32800000     1     55     55     1725.2     1663.4     9641226    10092158
33600000     1     56     56     1662.2     1668.9    12228440     8579953
34400000     1     57     57     1629.7     1688.0     8232209     8290118
35200000     1     59     59     1711.5     1733.5     8175308     9081545
36000000     1     60     60     1670.6     1742.4     9884533     8554858
36800000     1     61     61     1663.0     1654.8    13227858     9112083
37600000     1     62     62     1692.4     1663.0     8590629     8884916
38400000     1     64     64     1691.6     1617.1     9437834    11534400
39200000     1     65     65     1763.5     1646.3    10385440     9854624
40000000     1     66     66     1686.8     1643.8     8860676     9939637
40800000     1     67     67     1542.9     1652.9     9280078    17640321
41600000     1     68     69     1696.2     1655.4     8972165     9473507
42400000     1     70     70     1637.8     1685.2     8294407     8767330
43200000     1     71     71     1712.8     1739.8    14135589     9175591
44000000     1     72     73     1692.4     1632.2    10287428     9130585
44800000     1     73     74     1794.9     1685.0    10727955     9486110
45600000     1     75     75     1438.1     1624.3     8476478     9232791
46400000     1     76     76     1761.2     1768.7     8644609    15745264
47200000     1     77     77     1684.2     1505.7    10269613    12412119
48000000     1     79     79     1647.0     1713.2     8287281    15352189
48800000     1     80     80     1665.7     1675.0     17468300    9012407
49600000     1     81     81     1632.5     1692.5     8178082     8865803
50400000     1     83     83     1584.5     1752.1     12857867   11970443

2. FFSB test

                                w/ hot tracking         w/o hot tracking           ratio             
                                       v1                     v2                 (v1-v2)/v2
large_file_create
        1 thread
           - Trans/sec              28091.76               28126.31               -0.12%
           - Throughput             110MB/sec              110MB/sec              +0.00%
           - %CPU                   10.7%                  11.2%                  -4.47%
           - Trans/%CPU             2625.4                 2511.28                -4.54%
       
        8 threads
           - Trans/sec              27980.47               28140.34               -0.57%
           - Throughput             109MB/sec              110MB/sec              -0.91%
           - %CPU                   12.3%                  12.8%                  -3.90%
           - Trans/%CPU             2274.83                2198.46                +3.47%

        16 threads
           - Trans/sec              27764.36               27940.96               -0.63%
           - Throughput             108MB/sec              109MB/sec              -0.92%
           - %CPU                   12.8%                  13.7%                  -6.57%
           - Trans/%CPU             2169.09                2039.49                +6.35%

        32 threads
           - Trans/sec              27461.82               27624.48               -0.59%
           - Throughput             107MB/sec              108MB/sec              -0.93%
           - %CPU                     13.7%                14.4%                  -4.86%
           - Trans/%CPU             2004.51                1918.37                +4.49%

large_file_seq_read     
        1 thread
           - Trans/sec              34121.46               34838.65               -2.06%
           - Throughput             133MB/sec              136MB/sec              -2.21%
           - %CPU                   8.8%                   8.8%                   +0.00%
           - Trans/%CPU             3877.44                3958.94                -2.06%

        8 threads
           - Trans/sec              10883.15               11679.40               -6.82%
           - Throughput             42.5MB/sec             45.6MB/sec             -6.80%
           - %CPU                   3.3%                   3.4%                   -2.94%
           - Trans/%CPU             3297.92                3435.12                -3.99%

        16 threads
           - Trans/sec              5760.16                6193.20                -6.99%
           - Throughput             22.5MB/sec             24.2MB/sec             -7.02%
           - %CPU                   1.8%                   1.9%                   -5.26%
           - Trans/%CPU             3200.09                3259.58                -1.83%

        32 threads
           - Trans/sec              5470.50                5490.12                -0.36%
           - Throughput             21.4MB/sec             21.4MB/sec             +0.00%
           - %CPU                   1.7%                   1.7%                   +0.00%
           - Trans/%CPU             3217.94                3229.48                -0.36%

random_write
        1 thread
           - Trans/sec              1611.99                1582.57                +1.86%
           - Throughput             220MB/sec              216MB/sec              +1.85%
           - %CPU                   0.6%                   0.6%                   +0.00%
           - Trans/%CPU             2686.65                2637.62                +1.86%

        8 threads
           - Trans/sec              2215.59                2292.57                -3.36%
           - Throughput             303MB/sec              313MB/sec              -3.39%
           - %CPU                   1.4%                   1.5%                   -6.67%
           - Trans/%CPU             1582.56                1528.38                +3.35%

        16 threads
           - Trans/sec              2068.52                1935.96                +6.85%
           - Throughput             283MB/sec              265MB/sec              +6.79%
           - %CPU                   1.3%                   1.3%                   +0.00%
           - Trans/%CPU             1591.17                1464.8                 +8.63%

        32 threads
           - Trans/sec              1764.28                1875.23                -5.92%
           - Throughput             241MB/sec              256MB/sec              -5.86%
           - %CPU                   1.2%                   1.3%                   -7.69%
           - Trans/%CPU             1470.23                1442.48                +1.92%

random_read
        1 thread
           - Trans/sec              222.84                 224.28                 -0.64%
           - Throughput             891KB/sec              897KB/sec              -0.67%
           - %CPU                   1.1%                   1.0%                   +10.0%
           - Trans/%CPU             202.58                 224.28                 -9.68%

        8 threads
           - Trans/sec              143.30                 136.47                 +5.01%
           - Throughput             573KB/sec              546KB/sec              +4.95%
           - %CPU                   0.5%                   0.5%                   +0.00%
           - Trans/%CPU             286.60                 272.94                 +5.01%

        16 threads
           - Trans/sec              105.17                 103.75                 +1.37%
           - Throughput             421KB/sec              415KB/sec              +1.45%
           - %CPU                   0.5%                   0.5%                   +0.00%
           - Trans/%CPU             210.34                 207.5                  +1.37%

        32 threads
           - Trans/sec              105.78                 103.39                 +2.31%
           - Throughput             423KB/sec              414KB/sec              +2.17%
           - %CPU                   0.5%                   0.5%                   +0.00%
           - Trans/%CPU             211.56                 206.78                 +2.31%
 
mail_server
        1 thread
           - Trans/sec  [read]      433.23                 446.68                 -3.01%
           - Throughput [read]      1.7MB/sec              1.75MB/sec             -2.86%
           - Trans/sec  [write]     224.06                 213.84                 +4.78%
           - Throughput [write]     889KB/sec              848KB/sec              +4.83%
           - %CPU                   0.8%                   0.8%                   +0.00%
           - Trans/%CPU [read]      541.54                 558.35                 -3.01%
           - Trans/%CPU [write]     280.08                 267.3                  +4.78%

        8 threads
           - Trans/sec  [read]      430.47                 435.84                 -1.23%
           - Throughput [read]      1.69MB/sec             1.71MB/sec             -1.17%
           - Trans/sec  [write]     198.18                 207.61                 -4.54%
           - Throughput [write]     786KB/sec              823KB/sec              -4.50%
           - %CPU                   0.9%                   0.9%                   +0.00%
           - Trans/%CPU [read]      478.3                  484.27                 -1.23%
           - Trans/%CPU [write]     220.2                  230.68                 -4.54%

        16 threads
           - Trans/sec  [read]      326.05                 347.85                 -6.27%
           - Throughput [read]      1.28MB/sec             1.37MB/sec             -6.57%
           - Trans/sec  [write]     187.69                 177.59                 +5.69%
           - Throughput [write]     744KB/sec              705KB/sec              +5.53%
           - %CPU                   0.9%                   0.9%                   +0.00%
           - Trans/%CPU [read]      362.28                 386.5                  -6.27%
           - Trans/%CPU [write]     208.54                 197.2                  +5.75%

        32 threads
           - Trans/sec  [read]      388.04                 419.52                 -7.50%
           - Throughput [read]      1.53MB/sec             1.65MB/sec             -7.27%
           - Trans/sec  [write]     204.70                 207.50                 -1.35%
           - Throughput [write]     811KB/sec              823KB/sec              -1.46%
           - %CPU                   1.2%                   1.2%                   +0.00%
           - Trans/%CPU [read]      323.37                 349.6                  -7.50%
           - Trans/%CPU [write]     170.58                 172.92                 -1.35%

3. Compilebench test

                         w/ hot tracking        w/o hot tracking            ratio
                               v1                     v2                 (v1-v2)/v2
intial create              59.33 MB/s              63.25 MB/s              -6.20%

create                     91.81 MB/s              81.12 MB/s             +13.18%

patch                      12.39 MB/s              14.94 MB/s             -17.07%

compile                   470.24 MB/s             442.08 MB/s              +6.37%

clean                    2205.16 MB/s            1992.06 MB/s             +10.70%

read tree                 136.77 MB/s             142.41 MB/s              -3.96%

read compiled tree         46.83 MB/s              50.08 MB/s              -6.49%

delete tree              3.48 seconds            3.02 seconds             +15.23%

delete compiled tree     3.94 seconds            3.98 seconds              -1.01%

stat tree                1.45 seconds            1.66 seconds             -12.65%
 
stat compiled tree       0.71 seconds            0.86 seconds             -17.44%

Changelog from v4:
 - Added all kinds of perf testing report [viro]
 - Covered mmap() now [viro]
 - Removed list_sort() in hot_update_worker() to avoid locking contention
   and cacheline bouncing [viro]
 - Removed a /proc interface to control low memory usage [Chandra]
 - Adjusted shrinker support due to the change of public shrinker APIs [zwu]
 - Fixed the locking missing issue when hot_inode_item_put() is called
   in ioctl_heat_info() [viro]
 - Fixed some locking contention issues [zwu]

v4:
 - Removed debugfs support, but leave it to TODO list [viro, Chandra]
 - Killed HOT_DELETING and HOT_IN_LIST flag [viro]
 - Fixed unlink issues [viro]
 - Fixed the issue on lookups (both for inode and range)
   leak on race with unlink  [viro]
 - Killed hot_comm_item and split the functions which take it [virio]
 - Fixed some other issues [zwu, Chandra]

v3:
 - Added memory caping function for hot items [Zhiyong]
 - Cleanup aging function [Zhiyong]

v2:
 - Refactored to be under RCU [Chandra Seetharaman]
  Merged some code changes [Chandra Seetharaman]
 - Fixed some issues [Chandra Seetharaman]

v1:
 - Solved 64 bits inode number issue. [David Sterba]
 - Embed struct hot_type in struct file_system_type [Darrick J. Wong]
 - Cleanup Some issues [David Sterba]
 - Use a static hot debugfs root [Greg KH]

rfcv4:
 - Introduce hot func registering framework [Zhiyong]
 - Remove global variable for hot tracking [Zhiyong]
 - Add btrfs hot tracking support [Zhiyong]

rfcv3:
 1.) Rewritten debugfs support based seq_file operation. [Dave Chinner]
 2.) Refactored workqueue support. [Dave Chinner]
 3.) Turn some Micro into be tunable [Zhiyong, Liu Zheng]
       TIME_TO_KICK, and HEAT_UPDATE_DELAY
 4.) Cleanedup a lot of other issues [Dave Chinner]


rfcv2:
 1.) Converted to Radix trees, not RB-tree [Zhiyong, Dave Chinner]
 2.) Added memory shrinker [Dave Chinner]
 3.) Converted to one workqueue to update map info periodically [Dave Chinner]
 4.) Cleanedup a lot of other issues [Dave Chinner]

rfcv1:
 1.) Reduce new files and put all in fs/hot_tracking.[ch] [Dave Chinner]
 2.) The first three patches can probably just be flattened into one.
                                        [Marco Stornelli , Dave Chinner]

Dave Chinner (1):
  VFS hot tracking, xfs: Add hot tracking support

Zhi Yong Wu (9):
  VFS hot tracking: Define basic data structures and functions
  VFS hot tracking: Track IO and record heat information
  VFS hot tracking: Add a workqueue to move items between hot maps
  VFS hot tracking: Add shrinker functionality to curtail memory usage
  VFS hot tracking: Add an ioctl to get hot tracking information
  VFS hot tracking: Add a /proc interface to make the interval tunable
  VFS hot tracking: Add a /proc interface to control memory usage
  VFS hot tracking: Add documentation
  VFS hot tracking, btrfs: Add hot tracking support

 Documentation/filesystems/00-INDEX         |   2 +
 Documentation/filesystems/hot_tracking.txt | 207 ++++++++
 fs/Makefile                                |   2 +-
 fs/btrfs/ctree.h                           |   1 +
 fs/btrfs/super.c                           |  22 +-
 fs/compat_ioctl.c                          |   5 +
 fs/dcache.c                                |   2 +
 fs/direct-io.c                             |   5 +
 fs/hot_tracking.c                          | 811 +++++++++++++++++++++++++++++
 fs/hot_tracking.h                          |  66 +++
 fs/ioctl.c                                 |  71 +++
 fs/namei.c                                 |   3 +
 fs/xfs/xfs_mount.h                         |   1 +
 fs/xfs/xfs_super.c                         |  18 +
 include/linux/fs.h                         |   4 +
 include/linux/hot_tracking.h               | 146 ++++++
 kernel/sysctl.c                            |  14 +
 mm/filemap.c                               |  19 +-
 mm/page-writeback.c                        |  13 +
 mm/readahead.c                             |   6 +
 20 files changed, 1414 insertions(+), 4 deletions(-)
 create mode 100644 Documentation/filesystems/hot_tracking.txt
 create mode 100644 fs/hot_tracking.c
 create mode 100644 fs/hot_tracking.h
 create mode 100644 include/linux/hot_tracking.h

-- 
1.7.11.7


Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755168Ab3LCUQP (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Dec 2013 15:16:15 -0500
Received: from mail-oa0-f45.google.com ([209.85.219.45]:44450 "EHLO
	mail-oa0-f45.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754612Ab3LCUQK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Dec 2013 15:16:10 -0500
MIME-Version: 1.0
In-Reply-To: <CAEH94LiAD4_AJf6kM2_ZDij9WdXFBJkKi0dFGmmoLFepXYAfKA@mail.gmail.com>
References: <1383745544-391-1-git-send-email-zwu.kernel@gmail.com>
	<CAEH94LiF=dL+pVuHd3vkGAf8jpVnpBbBJy_9au7i-sdGUs=0Ew@mail.gmail.com>
	<CAEH94LjUyO7fR5EsiKJtytQm1tJxJTx0obQfAyo5gDoYpkLUMA@mail.gmail.com>
	<CAEH94LiAD4_AJf6kM2_ZDij9WdXFBJkKi0dFGmmoLFepXYAfKA@mail.gmail.com>
Date: Wed, 4 Dec 2013 04:16:09 +0800
Message-ID: <CAEH94LjQAiLaJtXwbpvAOrBaZbDhORJny0TG8wXjTiRY4X4h2w@mail.gmail.com>
Subject: Re: [PATCH v6 00/11] VFS hot tracking
From: Zhi Yong Wu <zwu.kernel@gmail.com>
To: Al Viro <viro@zeniv.linux.org.uk>,
        Linus Torvalds <torvalds@linux-foundation.org>
Cc: "linux-fsdevel@vger.kernel.org" <linux-fsdevel@vger.kernel.org>,
        linux-kernel mlist <linux-kernel@vger.kernel.org>,
        Zhi Yong Wu <wuzhy@linux.vnet.ibm.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Ping 6,

any reason why this patchset can't get reviewed so far? If no
comments, pls merge them.  Please don't force me to be impolite,
thanks.

On Sat, Nov 30, 2013 at 5:55 PM, Zhi Yong Wu <zwu.kernel@gmail.com> wrote:
> HI,
>
> Ping again....
>
> On Thu, Nov 21, 2013 at 9:57 PM, Zhi Yong Wu <zwu.kernel@gmail.com> wrote:
>> HI, Maintainers
>>
>> Ping again....
>>
>> On Thu, Nov 14, 2013 at 2:33 AM, Zhi Yong Wu <zwu.kernel@gmail.com> wrote:
>>> Ping....
>>>
>>> On Wed, Nov 6, 2013 at 9:45 PM, Zhi Yong Wu <zwu.kernel@gmail.com> wrote:
>>>> From: Zhi Yong Wu <wuzhy@linux.vnet.ibm.com>
>>>>
>>>>   The patchset is trying to introduce hot tracking function in
>>>> VFS layer, which will keep track of real disk I/O in memory.
>>>> By it, you will easily know more details about disk I/O, and
>>>> then detect where disk I/O hot spots are. Also, specific FS
>>>> can take use of it to do accurate defragment, and hot relocation
>>>> support, etc.
>>>>
>>>>   Now it's time to send out its V6 for external review, and
>>>> any comments or ideas are appreciated, thanks.
>>>>
>>>> NOTE:
>>>>
>>>>   The patchset can be obtained via my kernel dev git on github:
>>>> git://github.com/wuzhy/kernel.git hot_tracking
>>>>   If you're interested, you can also review them via
>>>> https://github.com/wuzhy/kernel/commits/hot_tracking
>>>>
>>>>   For how to use and more other info and performance report,
>>>> please check hot_tracking.txt in Documentation and following
>>>> links:
>>>>   1.) http://lwn.net/Articles/525651/
>>>>   2.) https://lkml.org/lkml/2012/12/20/199
>>>>
>>>>   This patchset has been done scalability or performance tests
>>>> by fs_mark, ffsb and compilebench.
>>>>
>>>>   The perf testings were done on Linux 3.12.0-rc7 with Model IBM,8231-E2C
>>>> Big Endian PPC64 with 64 CPUs and 2 NUMA nodes, 250G RAM and 1.50 TiB
>>>> test hard disk where each test file size is 20G or 100G.
>>>> Architecture:          ppc64
>>>> Byte Order:            Big Endian
>>>> CPU(s):                64
>>>> On-line CPU(s) list:   0-63
>>>> Thread(s) per core:    4
>>>> Core(s) per socket:    1
>>>> Socket(s):             16
>>>> NUMA node(s):          2
>>>> Model:                 IBM,8231-E2C
>>>> Hypervisor vendor:     pHyp
>>>> Virtualization type:   full
>>>> L1d cache:             32K
>>>> L1i cache:             32K
>>>> L2 cache:              256K
>>>> L3 cache:              4096K
>>>> NUMA node0 CPU(s):     0-31
>>>> NUMA node1 CPU(s):     32-63
>>>>
>>>>   Below is the perf testing report:
>>>>
>>>>   Please focus on the two key points:
>>>>   - The overall overhead which is injected by the patchset
>>>>   - The stability of the perf results
>>>>
>>>> 1. fio tests
>>>>
>>>>                             w/o hot tracking                               w/ hot tracking
>>>>
>>>> RAM size                            32G          32G         16G           8G           4G           2G          250G
>>>>
>>>> sequential-8k-1jobs-read         61260KB/s    60918KB/s    60901KB/s    62610KB/s    60992KB/s    60213KB/s    60948KB/s
>>>>
>>>> sequential-8k-1jobs-write         1329KB/s     1329KB/s     1328KB/s     1329KB/s     1328KB/s     1329KB/s     1329KB/s
>>>>
>>>> sequential-8k-8jobs-read         91139KB/s    92614KB/s    90907KB/s    89895KB/s    92022KB/s    90851KB/s    91877KB/s
>>>>
>>>> sequential-8k-8jobs-write         2523KB/s     2522KB/s     2516KB/s     2521KB/s     2516KB/s     2518KB/s     2521KB/s
>>>>
>>>> sequential-256k-1jobs-read      151432KB/s   151403KB/s   151406KB/s   151422KB/s   151344KB/s   151446KB/s   151372KB/s
>>>>
>>>> sequential-256k-1jobs-write      33451KB/s    33470KB/s    33481KB/s    33470KB/s    33459KB/s    33472KB/s    33477KB/s
>>>>
>>>> sequential-256k-8jobs-read      235291KB/s   234555KB/s   234251KB/s   233656KB/s   234927KB/s   236380KB/s   235535KB/s
>>>>
>>>> sequential-256k-8jobs-write      62419KB/s    62402KB/s    62191KB/s    62859KB/s    62629KB/s    62720KB/s    62523KB/s
>>>>
>>>> random-io-mix-8k-1jobs  [READ]    2929KB/s     2942KB/s     2946KB/s     2929KB/s     2934KB/s     2947KB/s     2946KB/s
>>>>                         [WRITE]   1262KB/s     1266KB/s     1257KB/s     1262KB/s     1257KB/s     1257KB/s     1265KB/s
>>>>
>>>> random-io-mix-8k-8jobs  [READ]    2444KB/s     2442KB/s     2436KB/s     2416KB/s     2353KB/s     2441KB/s     2442KB/s
>>>>                         [WRITE]   1047KB/s     1044KB/s     1047KB/s     1028KB/s     1017KB/s     1034KB/s     1049KB/s
>>>>
>>>> random-io-mix-8k-16jobs [READ]    2182KB/s     2184KB/s     2169KB/s     2178KB/s     2190KB/s     2184KB/s     2180KB/s
>>>>                         [WRITE]    932KB/s      930KB/s      943KB/s      936KB/s      937KB/s      929KB/s      931KB/s
>>>>
>>>> The above perf parameter is the aggregate bandwidth of threads in the group;
>>>> If you hope to know how about other perf parameters, or fio raw results, please let me know, thanks.
>>>>
>>>> 2. Locking stat - Contention & Cacheline Bouncing
>>>>
>>>> RAM size         class name         con-bounces  contentions  acq-bounces   acquisitions   cacheline bouncing  locking contention
>>>>                                                                                                  ratio              ratio
>>>>
>>>>               &(&root->t_lock)->rlock:  1508        1592         157834      374639292           0.96%              0.00%
>>>> 250G          &(&root->m_lock)->rlock:  1469        1484         119221       43077842           1.23%              0.00%
>>>>               &(&he->i_lock)->rlock:       0           0         101879      376755218           0.00%              0.00%
>>>>
>>>>               &(&root->t_lock)->rlock:  2912        2985         342575      374691186           0.85%              0.00%
>>>> 32G           &(&root->m_lock)->rlock:   188         193         307765        8803163           0.00%              0.00%
>>>>               &(&he->i_lock)->rlock:       0           0         291860      376756084           0.00%              0.00%
>>>>
>>>>               &(&root->t_lock)->rlock:  3863        3948         298041      374727038           1.30%              0.00%
>>>> 16G           &(&root->m_lock)->rlock:   220         228         254451        8687057           0.00%              0.00%
>>>>               &(&he->i_lock)->rlock:       0           0         235027      376756830           0.00%              0.00%
>>>>
>>>>               &(&root->t_lock)->rlock:  3283        3409         233790      374722064           1.40%              0.00%
>>>> 8G            &(&root->m_lock)->rlock:   136         139         203917        8684313           0.00%              0.00%
>>>>               &(&he->i_lock)->rlock:       0           0         193746      376756438           0.00%              0.00%
>>>>
>>>>               &(&root->t_lock)->rlock: 15090       15705         283460      374889666           5.32%              0.00%
>>>> 4G            &(&root->m_lock)->rlock:   172         173         222480        8555052           0.00%              0.00%
>>>>               &(&he->i_lock)->rlock:       0           0         206431      376759452           0.00%              0.00%
>>>>
>>>>               &(&root->t_lock)->rlock: 25515       27368         305129       375394828          8.36%              0.00%
>>>> 2G            &(&root->m_lock)->rlock:   100         101         216516        6752265           0.00%              0.00%
>>>>               &(&he->i_lock)->rlock:       0           0         214713      376765169           0.00%              0.00%
>>>>
>>>> 3. Perf test - Cacheline Ping-pong
>>>>
>>>>                       w/o hot tracking                                                        w/ hot tracking
>>>>
>>>> RAM size                    32G                  32G                 16G                  8G                   4G                    2G                  250G
>>>>
>>>> cache-references    1,264,996,437,581    1,401,504,955,577    1,398,308,614,801    1,396,525,544,527    1,384,793,467,410    1,432,042,560,409    1,571,627,148,771
>>>>
>>>> cache-misses           45,424,567,057       58,432,749,807       59,200,504,032       59,762,030,933       58,104,156,576       57,283,962,840       61,963,839,419
>>>>
>>>> seconds time elapsed  22956.327674298      23035.457069488      23017.232397085      23012.397142967      23008.420970731      23057.245578767      23342.456015188
>>>>
>>>> cache-misses ratio            3.591 %              4.169 %              4.234 %              4.279 %              4.196 %              4.000 %              3.943 %
>>>>
>>>> Changelog from v5:
>>>>  - Also added the hook hot_freqs_update() in the page cache I/O path,
>>>>    not only in real disk I/O path [viro]
>>>>  - Don't export the stuff until it's used by a module [viro]
>>>>  - Splitted hot_inode_item_lookup() [viro]
>>>>  - Prevented hot items from being re-created after the inode was unlinked. [viro]
>>>>  - Made hot_freqs_update() to be inline and adopt one private hot flag [viro]
>>>>  - Killed hot_bit_shift() [viro]
>>>>  - Used file_inode() instead of file->f_dentry->d_inode [viro]
>>>>  - Introduced one new file hot_tracking.h in include/uapi/linux/ [viro]
>>>>  - Made the checks for ->i_nlink to be protectd by ->i_mutex [viro]
>>>>
>>>> v5:
>>>>  - Added all kinds of perf testing report [viro]
>>>>  - Covered mmap() now [viro]
>>>>  - Removed list_sort() in hot_update_worker() to avoid locking contention
>>>>    and cacheline bouncing [viro]
>>>>  - Removed a /proc interface to control low memory usage [Chandra]
>>>>  - Adjusted shrinker support due to the change of public shrinker APIs [zwu]
>>>>  - Fixed the locking missing issue when hot_inode_item_put() is called
>>>>    in ioctl_heat_info() [viro]
>>>>  - Fixed some locking contention issues [zwu]
>>>>
>>>> v4:
>>>>  - Removed debugfs support, but leave it to TODO list [viro, Chandra]
>>>>  - Killed HOT_DELETING and HOT_IN_LIST flag [viro]
>>>>  - Fixed unlink issues [viro]
>>>>  - Fixed the issue on lookups (both for inode and range)
>>>>    leak on race with unlink  [viro]
>>>>  - Killed hot_comm_item and split the functions which take it [virio]
>>>>  - Fixed some other issues [zwu, Chandra]
>>>>
>>>> v3:
>>>>  - Added memory caping function for hot items [Zhiyong]
>>>>  - Cleanup aging function [Zhiyong]
>>>>
>>>> v2:
>>>>  - Refactored to be under RCU [Chandra Seetharaman]
>>>>   Merged some code changes [Chandra Seetharaman]
>>>>  - Fixed some issues [Chandra Seetharaman]
>>>>
>>>> v1:
>>>>  - Solved 64 bits inode number issue. [David Sterba]
>>>>  - Embed struct hot_type in struct file_system_type [Darrick J. Wong]
>>>>  - Cleanup Some issues [David Sterba]
>>>>  - Use a static hot debugfs root [Greg KH]
>>>>
>>>> rfcv4:
>>>>  - Introduce hot func registering framework [Zhiyong]
>>>>  - Remove global variable for hot tracking [Zhiyong]
>>>>  - Add btrfs hot tracking support [Zhiyong]
>>>>
>>>> rfcv3:
>>>>  1.) Rewritten debugfs support based seq_file operation. [Dave Chinner]
>>>>  2.) Refactored workqueue support. [Dave Chinner]
>>>>  3.) Turn some Micro into be tunable [Zhiyong, Liu Zheng]
>>>>      TIME_TO_KICK, and HEAT_UPDATE_DELAY
>>>>  4.) Cleanedup a lot of other issues [Dave Chinner]
>>>>
>>>>
>>>> rfcv2:
>>>>  1.) Converted to Radix trees, not RB-tree [Zhiyong, Dave Chinner]
>>>>  2.) Added memory shrinker [Dave Chinner]
>>>>  3.) Converted to one workqueue to update map info periodically [Dave Chinner]
>>>>  4.) Cleanedup a lot of other issues [Dave Chinner]
>>>>
>>>> rfcv1:
>>>>  1.) Reduce new files and put all in fs/hot_tracking.[ch] [Dave Chinner]
>>>>  2.) The first three patches can probably just be flattened into one.
>>>>                                         [Marco Stornelli , Dave Chinner]
>>>>
>>>>
>>>> Dave Chinner (1):
>>>>   VFS hot tracking, xfs: Add hot tracking support
>>>>
>>>> Zhi Yong Wu (10):
>>>>   VFS hot tracking: Define basic data structures and functions
>>>>   VFS hot tracking: Track IO and record heat information
>>>>   VFS hot tracking: Add a workqueue to move items between hot maps
>>>>   VFS hot tracking: Add shrinker functionality to curtail memory usage
>>>>   VFS hot tracking: Add an ioctl to get hot tracking information
>>>>   VFS hot tracking: Add a /proc interface to make the interval tunable
>>>>   VFS hot tracking: Add a /proc interface to control memory usage
>>>>   VFS hot tracking: Add documentation
>>>>   VFS hot tracking, btrfs: Add hot tracking support
>>>>   MAINTAINERS: add the maintainers for VFS hot tracking
>>>>
>>>>  Documentation/filesystems/00-INDEX         |   2 +
>>>>  Documentation/filesystems/hot_tracking.txt | 207 ++++++++
>>>>  MAINTAINERS                                |  12 +
>>>>  fs/Makefile                                |   2 +-
>>>>  fs/btrfs/ctree.h                           |   1 +
>>>>  fs/btrfs/super.c                           |  22 +-
>>>>  fs/compat_ioctl.c                          |   5 +
>>>>  fs/dcache.c                                |   2 +
>>>>  fs/hot_tracking.c                          | 816 +++++++++++++++++++++++++++++
>>>>  fs/hot_tracking.h                          |  72 +++
>>>>  fs/ioctl.c                                 |  71 +++
>>>>  fs/namei.c                                 |   4 +
>>>>  fs/xfs/xfs_mount.h                         |   1 +
>>>>  fs/xfs/xfs_super.c                         |  18 +
>>>>  include/linux/fs.h                         |   4 +
>>>>  include/linux/hot_tracking.h               | 107 ++++
>>>>  include/uapi/linux/fs.h                    |   1 +
>>>>  include/uapi/linux/hot_tracking.h          |  33 ++
>>>>  kernel/sysctl.c                            |  14 +
>>>>  mm/filemap.c                               |  24 +-
>>>>  mm/readahead.c                             |   6 +
>>>>  21 files changed, 1420 insertions(+), 4 deletions(-)
>>>>  create mode 100644 Documentation/filesystems/hot_tracking.txt
>>>>  create mode 100644 fs/hot_tracking.c
>>>>  create mode 100644 fs/hot_tracking.h
>>>>  create mode 100644 include/linux/hot_tracking.h
>>>>  create mode 100644 include/uapi/linux/hot_tracking.h
>>>>
>>>> --
>>>> 1.7.11.7
>>>>
>>>> --
>>>> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
>>>> the body of a message to majordomo@vger.kernel.org
>>>> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>>>> Please read the FAQ at  http://www.tux.org/lkml/
>>>
>>>
>>>
>>> --
>>> Regards,
>>>
>>> Zhi Yong Wu
>>
>>
>>
>> --
>> Regards,
>>
>> Zhi Yong Wu
>
>
>
> --
> Regards,
>
> Zhi Yong Wu



-- 
Regards,

Zhi Yong Wu

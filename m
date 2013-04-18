Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030226Ab3DRKP5 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 18 Apr 2013 06:15:57 -0400
Received: from e7.ny.us.ibm.com ([32.97.182.137]:60484 "EHLO e7.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S967061Ab3DRKPs (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Apr 2013 06:15:48 -0400
Date: Thu, 18 Apr 2013 18:15:41 +0800
From: Han Pingtian <hanpt@linux.vnet.ibm.com>
To: linux-kernel@vger.kernel.org
Cc: rientjes@google.com, mhocko@suse.cz
Subject: Re: OOM-killer and strange RSS value in 3.9-rc7
Message-ID: <20130418101541.GC2672@localhost.localdomain>
Mail-Followup-To: linux-kernel@vger.kernel.org, rientjes@google.com,
	mhocko@suse.cz
References: <20130416110009.GA2664@localhost.localdomain>
 <alpine.DEB.2.02.1304161315290.30779@chino.kir.corp.google.com>
 <20130417094750.GB2672@localhost.localdomain>
 <20130417141909.GA24912@dhcp22.suse.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20130417141909.GA24912@dhcp22.suse.cz>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-TM-AS-MML: No
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 13041810-5806-0000-0000-000020C71D98
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Apr 17, 2013 at 07:19:09AM -0700, Michal Hocko wrote:
> On Wed 17-04-13 17:47:50, Han Pingtian wrote:
> > [ 5233.949714] Node 1 DMA free:3968kB min:7808kB low:9728kB high:11712kB active_anon:0kB inactive_anon:3584kB active_file:2240kB inactive_file:576kB unevictable:0kB isolated(anon):0kB isolated(file):0kB present:4194304kB managed:3854464kB mlocked:0kB dirty:64kB writeback:448kB mapped:0kB shmem:64kB slab_reclaimable:106496kB slab_unreclaimable:3654976kB kernel_stack:14912kB pagetables:18496kB unstable:0kB bounce:0kB free_cma:0kB writeback_tmp:0kB pages_scanned:531 all_unreclaimable? yes
> 
> This smells either like a slab backed memory leak or something went
> crazy and allocate huge amount of slab. You have 3.6G (or of 4G
> available) of slab_unreclaimable. I would check /proc/slabinfo for which
> cache consumes that huge amount of memory.

Thanks your reply. But I cannot find any clues in the slabinfo:


[root@riblp3 ~]# cat /proc/slabinfo
slabinfo - version: 2.1
# name            <active_objs> <num_objs> <objsize> <objperslab> <pagesperslab> : tunables <limit> <batchcount> <sharedfactor> : slabdata <active_slabs> <num_slabs> <sharedavail>
nfs_direct_cache       0      0    208  315    1 : tunables    0    0    0 : slabdata      0      0      0
nfs_inode_cache      320    320   1024   64    1 : tunables    0    0    0 : slabdata      5      5      0
fscache_cookie_jar   2457   2457     80  819    1 : tunables    0    0    0 : slabdata      3      3      0
nf_conntrack_c00000000108d000  11550  11550    312  210    1 : tunables    0    0    0 : slabdata     55     55      0
nfsd4_delegations      0      0    368  178    1 : tunables    0    0    0 : slabdata      0      0      0
nfsd4_openowners       0      0    392  167    1 : tunables    0    0    0 : slabdata      0      0      0
rpc_inode_cache      510    510    640  102    1 : tunables    0    0    0 : slabdata      5      5      0
xfs_dquot              0      0    456  143    1 : tunables    0    0    0 : slabdata      0      0      0
xfs_ili            30952  30952    224  292    1 : tunables    0    0    0 : slabdata    106    106      0
xfs_inode          31719  33142    896   73    1 : tunables    0    0    0 : slabdata    454    454      0
xfs_efd_item       15974  16789    400  163    1 : tunables    0    0    0 : slabdata    103    103      0
xfs_trans          18720  18720    280  234    1 : tunables    0    0    0 : slabdata     80     80      0
xfs_da_state       10720  10720    488  134    1 : tunables    0    0    0 : slabdata     80     80      0
xfs_btree_cur      25200  25200    208  315    1 : tunables    0    0    0 : slabdata     80     80      0
scsi_tgt_cmd           0      0     80  819    1 : tunables    0    0    0 : slabdata      0      0      0
kcopyd_job             0      0   3240   40    2 : tunables    0    0    0 : slabdata      0      0      0
dm_uevent              0      0   2608   50    2 : tunables    0    0    0 : slabdata      0      0      0
dm_rq_target_io        0      0    416  157    1 : tunables    0    0    0 : slabdata      0      0      0
UDPLITEv6              0      0   1152   56    1 : tunables    0    0    0 : slabdata      0      0      0
UDPv6                616    616   1152   56    1 : tunables    0    0    0 : slabdata     11     11      0
tw_sock_TCPv6          0      0    256  256    1 : tunables    0    0    0 : slabdata      0      0      0
TCPv6                680    680   1920   34    1 : tunables    0    0    0 : slabdata     20     20      0
bsg_cmd                0      0    312  210    1 : tunables    0    0    0 : slabdata      0      0      0
mqueue_inode_cache     73     73    896   73    1 : tunables    0    0    0 : slabdata      1      1      0
isofs_inode_cache      0      0    608  107    1 : tunables    0    0    0 : slabdata      0      0      0
hugetlbfs_inode_cache    226    226    576  113    1 : tunables    0    0    0 : slabdata      2      2      0
jbd2_journal_head      0      0    112  585    1 : tunables    0    0    0 : slabdata      0      0      0
jbd2_revoke_record_s      0      0     32 2048    1 : tunables    0    0    0 : slabdata      0      0      0
ext4_inode_cache       0      0    952   68    1 : tunables    0    0    0 : slabdata      0      0      0
ext4_xattr             0      0     88  744    1 : tunables    0    0    0 : slabdata      0      0      0
ext4_free_data         0      0     64 1024    1 : tunables    0    0    0 : slabdata      0      0      0
ext4_allocation_context      0      0    136  481    1 : tunables    0    0    0 : slabdata      0      0      0
ext4_system_zone  131040 131040     40 1638    1 : tunables    0    0    0 : slabdata     80     80      0
ext4_io_end            0      0   1088   60    1 : tunables    0    0    0 : slabdata      0      0      0
ext4_io_page           0      0     16 4096    1 : tunables    0    0    0 : slabdata      0      0      0
ext4_extent_status      0      0     40 1638    1 : tunables    0    0    0 : slabdata      0      0      0
configfs_dir_cache      0      0     88  744    1 : tunables    0    0    0 : slabdata      0      0      0
dquot                  0      0    256  256    1 : tunables    0    0    0 : slabdata      0      0      0
dio                  918   1020    640  102    1 : tunables    0    0    0 : slabdata     10     10      0
pid_namespace          0      0    248  264    1 : tunables    0    0    0 : slabdata      0      0      0
posix_timers_cache  22560  22560    232  282    1 : tunables    0    0    0 : slabdata     80     80      0
rtas_flash_cache       0      0   8192   32    4 : tunables    0    0    0 : slabdata      0      0      0
UDP-Lite               0      0    896   73    1 : tunables    0    0    0 : slabdata      0      0      0
ip_fib_trie         3510   3510     56 1170    1 : tunables    0    0    0 : slabdata      3      3      0
RAW                 5840   5840    896   73    1 : tunables    0    0    0 : slabdata     80     80      0
UDP                 3504   3504    896   73    1 : tunables    0    0    0 : slabdata     48     48      0
tw_sock_TCP          256    256    256  256    1 : tunables    0    0    0 : slabdata      1      1      0
TCP                 1260   1260   1792   36    1 : tunables    0    0    0 : slabdata     35     35      0
blkdev_queue         352    352   2024   32    1 : tunables    0    0    0 : slabdata     11     11      0
blkdev_requests    13920  13920    376  174    1 : tunables    0    0    0 : slabdata     80     80      0
blkdev_ioc         50400  50400    104  630    1 : tunables    0    0    0 : slabdata     80     80      0
fsnotify_event_holder 212940 212940     24 2730    1 : tunables    0    0    0 : slabdata     78     78      0
fsnotify_event     43680  43680    120  546    1 : tunables    0    0    0 : slabdata     80     80      0
bip-256               62     62   4224   62    4 : tunables    0    0    0 : slabdata      1      1      0
bip-128                0      0   2176   60    2 : tunables    0    0    0 : slabdata      0      0      0
bip-16             23970  24820    384  170    1 : tunables    0    0    0 : slabdata    146    146      0
sock_inode_cache    8364   8364    640  102    1 : tunables    0    0    0 : slabdata     82     82      0
net_namespace          0      0   4736   55    4 : tunables    0    0    0 : slabdata      0      0      0
shmem_inode_cache   6969   6969    648  101    1 : tunables    0    0    0 : slabdata     69     69      0
taskstats            995    995    328  199    1 : tunables    0    0    0 : slabdata      5      5      0
proc_inode_cache   24047  24570    624  105    1 : tunables    0    0    0 : slabdata    234    234      0
sigqueue           32720  32720    160  409    1 : tunables    0    0    0 : slabdata     80     80      0
bdev_cache           949    949    896   73    1 : tunables    0    0    0 : slabdata     13     13      0
sysfs_dir_cache    63765  63765    112  585    1 : tunables    0    0    0 : slabdata    109    109      0
inode_cache        33350  34047    560  117    1 : tunables    0    0    0 : slabdata    291    291      0
dentry            185915 187550    192  341    1 : tunables    0    0    0 : slabdata    550    550      0
buffer_head        60480  60480    104  630    1 : tunables    0    0    0 : slabdata     96     96      0
vm_area_struct     88644  88644    184  356    1 : tunables    0    0    0 : slabdata    249    249      0
files_cache         6885   6885    768   85    1 : tunables    0    0    0 : slabdata     81     81      0
signal_cache        5376   5376   1152   56    1 : tunables    0    0    0 : slabdata     96     96      0
sighand_cache       5460   5460   2176   60    2 : tunables    0    0    0 : slabdata     91     91      0
task_struct         3873  34510   6992   37    4 : tunables    0    0    0 : slabdata    938    938      0
anon_vma           82944  82944     64 1024    1 : tunables    0    0    0 : slabdata     81     81      0
shared_policy_node   5460   5460     48 1365    1 : tunables    0    0    0 : slabdata      4      4      0
numa_policy        80080  80080     72  910    1 : tunables    0    0    0 : slabdata     88     88      0
kmemleak_scan_area  49152  49152     32 2048    1 : tunables    0    0    0 : slabdata     24     24      0
kmemleak_object   311396 370875    304  215    1 : tunables    0    0    0 : slabdata   1725   1725      0
radix_tree_node    16330  16330    568  115    1 : tunables    0    0    0 : slabdata    142    142      0
idr_layer_cache     5890   5890   2112   62    2 : tunables    0    0    0 : slabdata     95     95      0
pgtable-2^12        1647   1728  65536    8    8 : tunables    0    0    0 : slabdata    223    223      0
pgtable-2^6         5120   5120   1024   64    1 : tunables    0    0    0 : slabdata     80     80      0
dma-kmalloc-131072      0      0 131072    4    8 : tunables    0    0    0 : slabdata      0      0      0
dma-kmalloc-65536      0      0  65536    8    8 : tunables    0    0    0 : slabdata      0      0      0
dma-kmalloc-32768      0      0  32768   16    8 : tunables    0    0    0 : slabdata      0      0      0
dma-kmalloc-16384      0      0  16384   32    8 : tunables    0    0    0 : slabdata      0      0      0
dma-kmalloc-8192       0      0   8192   32    4 : tunables    0    0    0 : slabdata      0      0      0
dma-kmalloc-4096       0      0   4096   32    2 : tunables    0    0    0 : slabdata      0      0      0
dma-kmalloc-2048       0      0   2048   32    1 : tunables    0    0    0 : slabdata      0      0      0
dma-kmalloc-1024       0      0   1024   64    1 : tunables    0    0    0 : slabdata      0      0      0
dma-kmalloc-512        0      0    512  128    1 : tunables    0    0    0 : slabdata      0      0      0
dma-kmalloc-256        0      0    256  256    1 : tunables    0    0    0 : slabdata      0      0      0
dma-kmalloc-128        0      0    128  512    1 : tunables    0    0    0 : slabdata      0      0      0
dma-kmalloc-64         0      0     64 1024    1 : tunables    0    0    0 : slabdata      0      0      0
dma-kmalloc-32         0      0     32 2048    1 : tunables    0    0    0 : slabdata      0      0      0
dma-kmalloc-16         0      0     16 4096    1 : tunables    0    0    0 : slabdata      0      0      0
dma-kmalloc-8          0      0      8 8192    1 : tunables    0    0    0 : slabdata      0      0      0
dma-kmalloc-192        0      0    192  341    1 : tunables    0    0    0 : slabdata      0      0      0
dma-kmalloc-96         0      0     96  682    1 : tunables    0    0    0 : slabdata      0      0      0
kmalloc-131072         0      0 131072    4    8 : tunables    0    0    0 : slabdata      0      0      0
kmalloc-65536        640    640  65536    8    8 : tunables    0    0    0 : slabdata     80     80      0
kmalloc-32768       1104   4208  32768   16    8 : tunables    0    0    0 : slabdata    263    263      0
kmalloc-16384       3352  31532  16384   32    8 : tunables    0    0    0 : slabdata   1016   1016      0
kmalloc-8192        7243  14912   8192   32    4 : tunables    0    0    0 : slabdata    466    466      0
kmalloc-4096        5348   5536   4096   32    2 : tunables    0    0    0 : slabdata    173    173      0
kmalloc-2048        8456 149632   2048   32    1 : tunables    0    0    0 : slabdata   4676   4676      0
kmalloc-1024        7110  22528   1024   64    1 : tunables    0    0    0 : slabdata    352    352      0
kmalloc-512        33616 2396160    512  128    1 : tunables    0    0    0 : slabdata  18720  18720      0
kmalloc-256        86175  87040    256  256    1 : tunables    0    0    0 : slabdata    340    340      0
kmalloc-128        76207 256000    128  512    1 : tunables    0    0    0 : slabdata    500    500      0
kmalloc-64        173062 178176     64 1024    1 : tunables    0    0    0 : slabdata    174    174      0
kmalloc-32        172105 182272     32 2048    1 : tunables    0    0    0 : slabdata     89     89      0
kmalloc-16        596238 1064960     16 4096    1 : tunables    0    0    0 : slabdata    260    260      0
kmalloc-8         655360 655360      8 8192    1 : tunables    0    0    0 : slabdata     80     80      0
kmalloc-192        54183 160270    192  341    1 : tunables    0    0    0 : slabdata    470    470      0
kmalloc-96         90988 3204718     96  682    1 : tunables    0    0    0 : slabdata   4699   4699      0
kmem_cache_node     8192   8192     64 1024    1 : tunables    0    0    0 : slabdata      8      8      0
kmem_cache           504    504   2304   56    2 : tunables    0    0    0 : slabdata      9      9      0
[root@riblp3 ~]#


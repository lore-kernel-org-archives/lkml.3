Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757621Ab3CHNPb (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 Mar 2013 08:15:31 -0500
Received: from pindarots.xs4all.nl ([80.101.128.228]:46635 "EHLO
	pindarots.xs4all.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753139Ab3CHNPa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 Mar 2013 08:15:30 -0500
Message-ID: <5139E470.10900@xs4all.nl>
Date: Fri, 08 Mar 2013 14:15:28 +0100
From: Udo van den Heuvel <udovdh@xs4all.nl>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130219 Thunderbird/17.0.3
MIME-Version: 1.0
CC: linux-kernel@vger.kernel.org
Subject: Re: 3.6.11: khubd issue SLAB related?
References: <5139E36A.5000109@xs4all.nl>
In-Reply-To: <5139E36A.5000109@xs4all.nl>
X-Enigmail-Version: 1.5.1
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
To: unlisted-recipients:; (no To-header on input)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 2013-03-08 14:11, Udo van den Heuvel wrote:
> Hello,
> 
> I found this in dmesg:

slabtop:

 Active / Total Objects (% used)    : 784982 / 981439 (80.0%)
 Active / Total Slabs (% used)      : 62996 / 63077 (99.9%)
 Active / Total Caches (% used)     : 119 / 196 (60.7%)
 Active / Total Size (% used)       : 205966.20K / 236692.16K (87.0%)
 Minimum / Average / Maximum Object : 0.02K / 0.24K / 4096.00K

  OBJS ACTIVE  USE OBJ SIZE  SLABS OBJ/SLAB CACHE SIZE NAME

217946 211509  97%    0.06K   3694	 59     14776K size-64
158508  65908  41%    0.10K   4284	 37     17136K buffer_head
121380 107155  88%    0.12K   4046	 30     16184K size-128
110692 108707  98%    0.86K  27673        4    110692K ext4_inode_cache
 98980  85163  86%    0.19K   4949	 20     19796K dentry
 37927  32219  84%    0.16K   1649	 23	 6596K vm_area_struct
 36001  24087  66%    0.55K   5143        7     20572K radix_tree_node
 25179  19801  78%    0.05K    327	 77	 1308K anon_vma_chain
 22561   7716  34%    0.05K    293	 77	 1172K jbd2_inode
 17696  12708  71%    0.03K    158	112	  632K size-32
 17260  11348  65%    0.19K    863	 20	 3452K size-192
 13416   8703  64%    0.29K   1032	 13	 4128K nf_conntrack_ffffffff815d8840
 12274  12046  98%    0.11K    361	 34	 1444K sysfs_dir_cache
 11977  10117  84%    0.06K    203	 59	  812K anon_vma
 11070   9712  87%    0.25K    738	 15	 2952K filp
 10638  10457  98%    0.60K   1773        6	 7092K proc_inode_cache
  9156   9136  99%    0.13K    327	 28	 1308K ext4_groupinfo_4k
  3762   3161  84%    0.60K    627        6	 2508K shmem_inode_cache
  3744   3553  94%    0.02K     26	144	  104K dm_target_io
  3680   3553  96%    0.04K     40	 92	  160K dm_io
  3577   2991  83%    0.54K    511        7	 2044K inode_cache
  3524   3103  88%    1.00K    881        4	 3524K size-1024
  2756   2586  93%    0.07K     52	 53	  208K Acpi-Operand
  2044   1929  94%    0.13K     73	 28	  292K inotify_inode_mark
  1600   1439  89%    0.50K    200        8	  800K size-512
  1380    552  40%    0.19K     69	 20	  276K cred_jar
  1092    910  83%    0.62K    182        6	  728K sock_inode_cache
  1029    979  95%    0.53K    147        7	  588K idr_layer_cache
  1020    537  52%    0.19K     51	 20	  204K bio-0
  1012    953  94%    0.04K     11	 92        44K Acpi-Namespace
   860    839  97%    0.19K     43	 20	  172K ip_dst_cache
   810    605  74%    0.12K     27	 30	  108K pid
   808    303  37%    0.02K	 4	202        16K ext4_io_page
   788    775  98%    2.00K    394        2	 1576K size-2048
   782    585  74%    0.11K     23	 34        92K task_delay_info
   765    474  61%    0.25K     51	 15	  204K skbuff_head_cache
   742    209  28%    0.07K     14	 53        56K eventpoll_pwq
   693    640  92%    0.81K     77        9	  616K UNIX
   605    591  97%    1.56K    121        5	  968K task_struct
   560    119  21%    0.03K	 5	112        20K tcp_bind_bucket
   500    209  41%    0.19K     25	 20	  100K eventpoll_epi
   486    418  86%    0.81K     54        9	  432K task_xstate
   480    378  78%    0.25K     32	 15	  128K size-256
   480    241  50%    0.19K     24	 20        96K inet_peer_cache
   408    189  46%    0.11K     12	 34        48K jbd2_journal_head
   400    299  74%    0.15K     16	 25        64K dm_crypt_io
   369    308  83%    4.00K    369        1	 1476K biovec-256
   368    304  82%    1.00K     92        4	  368K signal_cache
   360    220  61%    0.09K	 9	 40        36K blkdev_ioc
   354    354 100%    4.00K    354        1	 1416K size-4096
   354    149  42%    0.06K	 6	 59        24K fs_cache
   350    230  65%    0.50K     50        7	  200K skbuff_fclone_cache
   303    296  97%    2.06K    101        3	  808K sighand_cache
   289    284  98%   16.00K    289        1	 4624K size-16384
   285    228  80%    0.25K     19	 15        76K mnt_cache
   276     50  18%    0.04K	 3	 92        12K khugepaged_mm_slot
   270    224  82%    0.12K	 9	 30        36K scsi_sense_cache
   255    183  71%    0.25K     17	 15        68K sgpool-8


99.9% used?
Please help!


Udo

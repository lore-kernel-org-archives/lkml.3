Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932611AbaFCOFH (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Jun 2014 10:05:07 -0400
Received: from plane.gmane.org ([80.91.229.3]:54572 "EHLO plane.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932073AbaFCOFF (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Jun 2014 10:05:05 -0400
X-Injected-Via-Gmane: http://gmane.org/
To: linux-kernel@vger.kernel.org
From: Prankul Garg <prankul.iiitm@gmail.com>
Subject: perf tools[ARM]:Not able to detect [kernel.kallsyms] dso on Qualcomm MSM 8974
Date: Tue, 3 Jun 2014 14:02:52 +0000 (UTC)
Message-ID: <loom.20140603T154538-510@post.gmane.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Complaints-To: usenet@ger.gmane.org
X-Gmane-NNTP-Posting-Host: sea.gmane.org
User-Agent: Loom/3.14 (http://gmane.org/)
X-Loom-IP: 118.102.239.85 (Mozilla/5.0 (Windows NT 6.1; WOW64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/35.0.1916.114 Safari/537.36)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

Qualcomm MSM 8974 is not able to detect [kernel.kallsyms] dso either with 
Hardware or Tracepoint events while Exynos do.

Corresponding logs are as:

-----------------Qualcomm MSM 8974----------------------------------

./perf record -e cycles cal
# Overhead  Command  Shared Object                         Symbol
# ........  .......  .............  .............................
#

    75.02%      cal  [ks8851]       [k] 0x01114a5c               
     4.58%      cal  libc-2.13.so   [.] 0x000f9fa8               
     4.49%      cal  ld-2.13.so     [.] __udivsi3                
     4.49%      cal  ld-2.13.so     [.] do_lookup_x              
     2.94%      cal  ld-2.13.so     [.] _dl_relocate_object      
     1.50%      cal  ld-2.13.so     [.] _dl_protect_relro        
     1.50%      cal  ld-2.13.so     [.] check_match.8416         
     1.46%      cal  ld-2.13.so     [.] calloc                   
     1.39%      cal  ld-2.13.so     [.] _dl_add_to_namespace_list
     1.39%      cal  ld-2.13.so     [.] memset                   
     1.24%      cal  ld-2.13.so     [.] _dl_new_object     

./perf record -e kmem:kmalloc cal
# Overhead  Command  Shared Object          Symbol
# ........  .......  .............  ..............
#

   100.00%      cal  [ks8851]       [k] 0x01151dac



----------------Exynos------------------------------------

./perf record -e cycles cal
# Overhead  Command               Shared Object                           
Symbol
# ........  .......  ..........................  
...............................
#

     8.02%      cal  ld-2.13.so                  [.] 0x00001d40                 
     5.47%      cal  [kernel.kallsyms]           [k] cpu_v7_set_pte_ext         
     5.46%      cal  libc-2.13.so                [.] 0x000fbcc8                 
     5.44%      cal  [kernel.kallsyms]           [k] __memzero                  
     5.39%      cal  [kernel.kallsyms]           [k] strcmp                     
     5.29%      cal  [kernel.kallsyms]           [k] copy_page                  
     5.20%      cal  cal                         [.] 0x00000cb0                 
     4.87%      cal  [kernel.kallsyms]           [k] unmap_page_range           
     2.78%      cal  [kernel.kallsyms]           [k] __wake_up_bit              
     2.77%      cal  [kernel.kallsyms]           [k] hrtimer_run_pending        
     2.76%      cal  [kernel.kallsyms]           [k] 
mem_cgroup_uncharge_start  
     2.76%      cal  [kernel.kallsyms]           [k] submit_bio                 
     2.75%      cal  [kernel.kallsyms]           [k] n_tty_write                
     2.73%      cal  [kernel.kallsyms]           [k] strncpy                    
     2.68%      cal  [kernel.kallsyms]           [k] do_page_fault
	[...]     

./perf record -e kmem:kmalloc cal
# Overhead  Command      Shared Object                      Symbol
# ........  .......  .................  ..........................
#

    97.37%      cal  [kernel.kallsyms]  [k] kmem_cache_alloc_trace
     2.63%      cal  [kernel.kallsyms]  [k] __kmalloc             



  


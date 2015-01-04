Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752640AbbADCSj (ORCPT <rfc822;w@1wt.eu>);
	Sat, 3 Jan 2015 21:18:39 -0500
Received: from mga03.intel.com ([134.134.136.65]:10580 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751764AbbADCSh (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 3 Jan 2015 21:18:37 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.97,862,1389772800"; 
   d="yaml'?scan'208";a="436210409"
Message-ID: <1420337915.6201.3.camel@intel.com>
Subject: [LKP] [net/socket.c ] 0cf00c6f360: -3.1% netperf.Throughput_Mbps
From: Huang Ying <ying.huang@intel.com>
To: Gu Zheng <guz.fnst@cn.fujitsu.com>
Cc: "David S. Miller" <davem@davemloft.net>,
        LKML <linux-kernel@vger.kernel.org>, LKP ML <lkp@01.org>
Date: Sun, 04 Jan 2015 10:18:35 +0800
Content-Type: multipart/mixed; boundary="=-YLUflT1+0yRbfyrfBgn2"
X-Mailer: Evolution 3.12.9-1 
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--=-YLUflT1+0yRbfyrfBgn2
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8bit

FYI, we noticed the below changes on

commit 0cf00c6f360a3f7b97be000520f1acde88800536 ("net/socket.c : introduce helper function do_sock_sendmsg to replace reduplicate code")


testbox/testcase/testparams: lkp-t410/netperf/performance-300s-200%-10K-SCTP_STREAM_MANY

42eef7a0bb0989cd  0cf00c6f360a3f7b97be000520  
----------------  --------------------------  
         %stddev     %change         %stddev
             \          |                \  
   1293786 ±  4%     -17.0%    1073209 ±  4%  netperf.time.voluntary_context_switches
     13.73 ±  3%      -8.2%      12.61 ±  1%  netperf.time.user_time
      1198 ±  0%      -3.1%       1162 ±  0%  netperf.Throughput_Mbps
       220 ±  0%      -2.8%        214 ±  0%  netperf.time.percent_of_cpu_this_job_got
       653 ±  0%      -2.7%        635 ±  0%  netperf.time.system_time
      5.91 ± 22%    -100.0%       0.00 ±  0%  perf-profile.cpu-cycles._raw_spin_unlock_bh.release_sock.sctp_sendmsg.inet_sendmsg.sock_sendmsg
         0 ±  0%      +Inf%        131 ±  1%  latency_stats.avg.sctp_sendmsg.[sctp].inet_sendmsg.do_sock_sendmsg.___sys_sendmsg.__sys_sendmsg.SyS_sendmsg.system_call_fastpath
         0 ±  0%      +Inf%       4976 ±  0%  latency_stats.max.sctp_sendmsg.[sctp].inet_sendmsg.do_sock_sendmsg.___sys_sendmsg.__sys_sendmsg.SyS_sendmsg.system_call_fastpath
     15.58 ±  5%    -100.0%       0.00 ±  0%  perf-profile.cpu-cycles.sctp_datamsg_from_user.sctp_sendmsg.inet_sendmsg.sock_sendmsg.___sys_sendmsg
     21.57 ±  6%    -100.0%       0.00 ±  0%  perf-profile.cpu-cycles.sctp_primitive_SEND.sctp_sendmsg.inet_sendmsg.sock_sendmsg.___sys_sendmsg
     21.10 ±  6%    -100.0%       0.00 ±  0%  perf-profile.cpu-cycles.release_sock.sctp_sendmsg.inet_sendmsg.sock_sendmsg.___sys_sendmsg
     62.06 ±  2%    -100.0%       0.00 ±  0%  perf-profile.cpu-cycles.sctp_sendmsg.inet_sendmsg.sock_sendmsg.___sys_sendmsg.__sys_sendmsg
     62.68 ±  2%    -100.0%       0.00 ±  0%  perf-profile.cpu-cycles.inet_sendmsg.sock_sendmsg.___sys_sendmsg.__sys_sendmsg.sys_sendmsg
     63.26 ±  2%    -100.0%       0.00 ±  0%  perf-profile.cpu-cycles.sock_sendmsg.___sys_sendmsg.__sys_sendmsg.sys_sendmsg.system_call_fastpath
         0 ±  0%      +Inf%    1068435 ±  4%  latency_stats.hits.sctp_sendmsg.[sctp].inet_sendmsg.do_sock_sendmsg.___sys_sendmsg.__sys_sendmsg.SyS_sendmsg.system_call_fastpath
     14.88 ±  1%    -100.0%       0.00 ±  0%  perf-profile.cpu-cycles.sctp_backlog_rcv.release_sock.sctp_sendmsg.inet_sendmsg.sock_sendmsg
     12.33 ±  4%    -100.0%       0.00 ±  0%  perf-profile.cpu-cycles.sctp_do_sm.sctp_primitive_SEND.sctp_sendmsg.inet_sendmsg.sock_sendmsg
         0 ±  0%      +Inf%  1.404e+08 ±  3%  latency_stats.sum.sctp_sendmsg.[sctp].inet_sendmsg.do_sock_sendmsg.___sys_sendmsg.__sys_sendmsg.SyS_sendmsg.system_call_fastpath
      8.68 ±  5%    -100.0%       0.00 ±  0%  perf-profile.cpu-cycles.sctp_user_addto_chunk.sctp_datamsg_from_user.sctp_sendmsg.inet_sendmsg.sock_sendmsg
      5.78 ±  6%    -100.0%       0.00 ±  0%  perf-profile.cpu-cycles.sctp_make_datafrag_empty.sctp_datamsg_from_user.sctp_sendmsg.inet_sendmsg.sock_sendmsg
      4960 ±  1%    -100.0%          0 ±  0%  latency_stats.max.sctp_sendmsg.[sctp].inet_sendmsg.sock_sendmsg.___sys_sendmsg.__sys_sendmsg.SyS_sendmsg.system_call_fastpath
       135 ±  3%    -100.0%          0 ±  0%  latency_stats.avg.sctp_sendmsg.[sctp].inet_sendmsg.sock_sendmsg.___sys_sendmsg.__sys_sendmsg.SyS_sendmsg.system_call_fastpath
 1.755e+08 ±  5%    -100.0%          0 ±  0%  latency_stats.sum.sctp_sendmsg.[sctp].inet_sendmsg.sock_sendmsg.___sys_sendmsg.__sys_sendmsg.SyS_sendmsg.system_call_fastpath
   1289900 ±  4%    -100.0%          0 ±  0%  latency_stats.hits.sctp_sendmsg.[sctp].inet_sendmsg.sock_sendmsg.___sys_sendmsg.__sys_sendmsg.SyS_sendmsg.system_call_fastpath
      0.00 ±  0%      +Inf%       5.88 ±  9%  perf-profile.cpu-cycles._raw_spin_unlock_bh.release_sock.sctp_sendmsg.inet_sendmsg.do_sock_sendmsg
      0.00 ±  0%      +Inf%       6.16 ±  0%  perf-profile.cpu-cycles.sctp_make_datafrag_empty.sctp_datamsg_from_user.sctp_sendmsg.inet_sendmsg.do_sock_sendmsg
      0.00 ±  0%      +Inf%       8.69 ±  0%  perf-profile.cpu-cycles.sctp_user_addto_chunk.sctp_datamsg_from_user.sctp_sendmsg.inet_sendmsg.do_sock_sendmsg
      0.00 ±  0%      +Inf%      12.81 ±  3%  perf-profile.cpu-cycles.sctp_do_sm.sctp_primitive_SEND.sctp_sendmsg.inet_sendmsg.do_sock_sendmsg
      0.00 ±  0%      +Inf%      22.40 ±  4%  perf-profile.cpu-cycles.sctp_primitive_SEND.sctp_sendmsg.inet_sendmsg.do_sock_sendmsg.___sys_sendmsg
      0.00 ±  0%      +Inf%      16.02 ±  0%  perf-profile.cpu-cycles.sctp_datamsg_from_user.sctp_sendmsg.inet_sendmsg.do_sock_sendmsg.___sys_sendmsg
      0.00 ±  0%      +Inf%      20.81 ±  3%  perf-profile.cpu-cycles.release_sock.sctp_sendmsg.inet_sendmsg.do_sock_sendmsg.___sys_sendmsg
      0.00 ±  0%      +Inf%      64.24 ±  2%  perf-profile.cpu-cycles.do_sock_sendmsg.___sys_sendmsg.__sys_sendmsg.sys_sendmsg.system_call_fastpath
      0.00 ±  0%      +Inf%      63.64 ±  2%  perf-profile.cpu-cycles.inet_sendmsg.do_sock_sendmsg.___sys_sendmsg.__sys_sendmsg.sys_sendmsg
      0.00 ±  0%      +Inf%      63.01 ±  2%  perf-profile.cpu-cycles.sctp_sendmsg.inet_sendmsg.do_sock_sendmsg.___sys_sendmsg.__sys_sendmsg
      0.00 ±  0%      +Inf%      14.61 ±  1%  perf-profile.cpu-cycles.sctp_backlog_rcv.release_sock.sctp_sendmsg.inet_sendmsg.do_sock_sendmsg
      1911 ± 30%     +92.9%       3687 ± 19%  latency_stats.sum.down.console_lock.console_device.tty_open.chrdev_open.do_dentry_open.vfs_open.do_last.path_openat.do_filp_open.do_sys_open.SyS_open
    197535 ± 24%     +45.6%     287661 ± 14%  sched_debug.cpu#1.sched_goidle
      2800 ±  7%     +58.9%       4449 ± 12%  cpuidle.C6-NHM.usage
   8319130 ±  3%     +48.0%   12315380 ± 12%  cpuidle.C6-NHM.time
  16345940 ± 12%     +52.9%   24992140 ±  9%  cpuidle.C1-NHM.time
      4.83 ± 13%     +52.6%       7.37 ± 10%  turbostat.%c1
  36210370 ± 14%     +54.4%   55904924 ± 10%  cpuidle.C1E-NHM.time
      4763 ± 14%     +70.5%       8121 ±  7%  cpuidle.C3-NHM.usage
    740074 ± 13%     +54.9%    1146007 ±  9%  cpuidle.C1E-NHM.usage
    201068 ± 19%     +38.3%     277987 ± 11%  sched_debug.cpu#0.sched_goidle
      0.23 ± 10%     +60.4%       0.36 ± 27%  turbostat.%c6
      0.14 ± 16%     +27.8%       0.17 ± 19%  turbostat.%c3
    198646 ± 19%     +44.9%     287931 ± 11%  sched_debug.cpu#2.sched_goidle
    401326 ± 16%     +47.4%     591389 ± 10%  cpuidle.C1-NHM.usage
       115 ± 10%     -23.6%         88 ± 16%  latency_stats.avg.rpc_wait_bit_killable.__rpc_execute.rpc_execute.rpc_run_task.rpc_call_sync.nfs3_rpc_wrapper.nfs3_proc_access.nfs_do_access.nfs_permission.__inode_permission.inode_permission.may_open
     34172 ±  7%     +30.3%      44535 ±  5%  softirqs.SCHED
   3363437 ± 11%     +34.9%    4538159 ± 14%  cpuidle.C3-NHM.time
       156 ±  5%     +26.1%        197 ±  6%  uptime.idle
    212838 ± 17%     +39.3%     296432 ±  7%  sched_debug.cpu#3.sched_goidle
       151 ±  5%     -18.5%        123 ±  3%  latency_stats.avg.sctp_skb_recv_datagram.[sctp].sctp_recvmsg.[sctp].sock_common_recvmsg.sock_recvmsg.___sys_recvmsg.__sys_recvmsg.SyS_recvmsg.system_call_fastpath
   1137848 ±  9%     +15.6%    1314801 ±  4%  sched_debug.cpu#1.sched_count
   1137594 ±  9%     +15.5%    1314483 ±  4%  sched_debug.cpu#1.nr_switches
       427 ±  7%     +15.8%        495 ±  5%  sched_debug.cpu#3.load
    607501 ±  6%     -11.3%     539116 ±  4%  sched_debug.cpu#2.ttwu_local
   1063918 ±  4%     -10.4%     952749 ±  6%  latency_stats.sum.do_wait.SyS_wait4.system_call_fastpath
   3700692 ±  3%     +12.8%    4174394 ±  2%  latency_stats.hits.sctp_skb_recv_datagram.[sctp].sctp_recvmsg.[sctp].sock_common_recvmsg.sock_recvmsg.___sys_recvmsg.__sys_recvmsg.SyS_recvmsg.system_call_fastpath
      1.05 ±  4%     +10.2%       1.16 ±  4%  perf-profile.cpu-cycles.kmalloc_large_node.__kmalloc_node_track_caller.__kmalloc_reserve.__alloc_skb.sctp_packet_transmit
      2.93 ±  5%      +7.9%       3.16 ±  3%  perf-profile.cpu-cycles.__kmalloc_reserve.isra.26.__alloc_skb._sctp_make_chunk.sctp_make_datafrag_empty.sctp_datamsg_from_user
    334282 ±  4%      -7.3%     309726 ±  2%  sched_debug.cfs_rq[1]:/.min_vruntime
      0.91 ±  7%     -11.0%       0.81 ±  3%  perf-profile.cpu-cycles.nf_hook_slow.ip_output.ip_local_out_sk.ip_queue_xmit.sctp_v4_xmit
      2.74 ±  2%      +8.2%       2.97 ±  2%  perf-profile.cpu-cycles.get_page_from_freelist.__alloc_pages_nodemask.alloc_kmem_pages_node.kmalloc_large_node.__kmalloc_node_track_caller
    245637 ±  3%     -13.0%     213811 ±  9%  sched_debug.cfs_rq[1]:/.MIN_vruntime
    245637 ±  3%     -13.0%     213811 ±  9%  sched_debug.cfs_rq[1]:/.max_vruntime
    623176 ±  4%      -9.9%     561641 ±  5%  sched_debug.cpu#3.ttwu_local
       437 ±  2%      -7.7%        403 ±  4%  sched_debug.cpu#1.cpu_load[3]
   1293786 ±  4%     -17.0%    1073209 ±  4%  time.voluntary_context_switches
     27545 ±  3%     +11.2%      30617 ±  1%  vmstat.system.cs
     94.80 ±  0%      -2.9%      92.09 ±  0%  turbostat.%c0
       220 ±  0%      -2.8%        214 ±  0%  time.percent_of_cpu_this_job_got
       653 ±  0%      -2.7%        635 ±  0%  time.system_time

lkp-t410: Westmere
Memory: 2G


To reproduce:

	apt-get install ruby ruby-oj
	git clone git://git.kernel.org/pub/scm/linux/kernel/git/wfg/lkp-tests.git
	cd lkp-tests
	bin/setup-local job.yaml # the job file attached in this email
	bin/run-local   job.yaml


Disclaimer:
Results have been estimated based on internal Intel analysis and are provided
for informational purposes only. Any difference in system hardware or software
design or configuration may affect actual performance.


Thanks,
Huang, Ying


--=-YLUflT1+0yRbfyrfBgn2
Content-Type: text/plain; charset=us-ascii
Content-Disposition: attachment; filename="job.yaml"
Content-Transfer-Encoding: 7bit

---
testcase: netperf
default_monitors:
  wait: pre-test
  uptime: 
  iostat: 
  vmstat: 
  numa-numastat: 
  numa-vmstat: 
  numa-meminfo: 
  proc-vmstat: 
  proc-stat: 
  meminfo: 
  slabinfo: 
  interrupts: 
  lock_stat: 
  latency_stats: 
  softirqs: 
  bdi_dev_mapping: 
  diskstats: 
  cpuidle: 
  cpufreq: 
  turbostat: 
  sched_debug:
    interval: 10
  pmeter: 
default_watchdogs:
  watch-oom: 
  watchdog: 
cpufreq_governor:
- performance
commit: 97bf6af1f928216fd6c5a66e8a57bfa95a659672
model: Westmere
memory: 2G
hdd_partitions: "/dev/disk/by-id/ata-FUJITSU_MJA2250BH_G2_K95CT9C2G29W-part6"
swap_partitions: 
rootfs_partition: "/dev/disk/by-id/ata-FUJITSU_MJA2250BH_G2_K95CT9C2G29W-part7"
runtime: 300s
nr_threads:
- 200%
perf-profile:
  freq: 800
netperf:
  send_size: 10K
  test:
  - SCTP_STREAM_MANY
testbox: lkp-t410
tbox_group: lkp-t410
kconfig: x86_64-rhel
enqueue_time: 2014-12-15 13:40:54.843970648 +08:00
head_commit: 7cdaf4cc2a07d2467abe82b847fc3bd2bc9e017b
base_commit: 97bf6af1f928216fd6c5a66e8a57bfa95a659672
branch: linux-devel/devel-hourly-2014122319
kernel: "/kernel/x86_64-rhel/97bf6af1f928216fd6c5a66e8a57bfa95a659672/vmlinuz-3.19.0-rc1-g97bf6af"
user: lkp
queue: cyclic
rootfs: debian-x86_64.cgz
result_root: "/result/lkp-t410/netperf/performance-300s-200%-10K-SCTP_STREAM_MANY/debian-x86_64.cgz/x86_64-rhel/97bf6af1f928216fd6c5a66e8a57bfa95a659672/0"
job_file: "/lkp/scheduled/lkp-t410/cyclic_netperf-performance-300s-200%-10K-SCTP_STREAM_MANY-x86_64-rhel-BASE-97bf6af1f928216fd6c5a66e8a57bfa95a659672-0.yaml"
dequeue_time: 2014-12-23 21:26:20.228864218 +08:00
job_state: finished
loadavg: 7.17 5.23 2.31 1/99 5442
start_time: '1419341212'
end_time: '1419341514'
version: "/lkp/lkp/.src-20141223-112927"

--=-YLUflT1+0yRbfyrfBgn2
Content-Type: text/plain; charset=us-ascii
Content-Disposition: attachment; filename="reproduce"
Content-Transfer-Encoding: 7bit

echo performance > /sys/devices/system/cpu/cpu0/cpufreq/scaling_governor
echo performance > /sys/devices/system/cpu/cpu1/cpufreq/scaling_governor
echo performance > /sys/devices/system/cpu/cpu2/cpufreq/scaling_governor
echo performance > /sys/devices/system/cpu/cpu3/cpufreq/scaling_governor
netserver
netperf -t SCTP_STREAM_MANY -c -C -l 300 -- -m 10K
netperf -t SCTP_STREAM_MANY -c -C -l 300 -- -m 10K
netperf -t SCTP_STREAM_MANY -c -C -l 300 -- -m 10K
netperf -t SCTP_STREAM_MANY -c -C -l 300 -- -m 10K
netperf -t SCTP_STREAM_MANY -c -C -l 300 -- -m 10K
netperf -t SCTP_STREAM_MANY -c -C -l 300 -- -m 10K
netperf -t SCTP_STREAM_MANY -c -C -l 300 -- -m 10K
netperf -t SCTP_STREAM_MANY -c -C -l 300 -- -m 10K

--=-YLUflT1+0yRbfyrfBgn2
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

_______________________________________________
LKP mailing list
LKP@linux.intel.com
=0D
--=-YLUflT1+0yRbfyrfBgn2--


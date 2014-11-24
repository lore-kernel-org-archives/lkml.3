Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751796AbaKXC5j (ORCPT <rfc822;w@1wt.eu>);
	Sun, 23 Nov 2014 21:57:39 -0500
Received: from mga11.intel.com ([192.55.52.93]:34821 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750804AbaKXC5i (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 23 Nov 2014 21:57:38 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.97,862,1389772800"; 
   d="yaml'?scan'208";a="420604501"
Date: Mon, 24 Nov 2014 10:58:13 +0800
From: Yuanhan Liu <yuanhan.liu@linux.intel.com>
To: Viresh Kumar <viresh.kumar@linaro.org>
Cc: Frederic Weisbecker <frederic@kernel.org>,
        LKML <linux-kernel@vger.kernel.org>, lkp@01.org,
        Yuanhan Liu <yuanhan.liu@linux.intel.com>
Subject: [LKP] [nohz] 2a16fc93d2c:
Message-ID: <20141124025813.GB7310@yliu-dev.sh.intel.com>
MIME-Version: 1.0
Content-Type: multipart/mixed; boundary="SkvwRMAIpAhPCcCJ"
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--SkvwRMAIpAhPCcCJ
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

FYI, we noticed the below changes on

commit 2a16fc93d2c9568e16d45db77c7b5f15e1921cf1 ("nohz: Avoid tick's double reprogramming in highres mode")


testbox/testcase/testparams: snb-drag/piglit/performance-igt-001

b5e995e671d8e4d7  2a16fc93d2c9568e16d45db77c  
----------------  --------------------------  
       fail:runs  %reproduction    fail:runs
           |             |             |    
           :5          100%           5:5     kmsg.drm:__gen6_gt_force_wake_get]*ERROR*Timed_out_waiting_for_forcewake_to_ack_request
           :5          100%           5:5     piglit.igt/gem_ctx_exec/reset-pin-leak.dmesg-warn

snb-drag: Sandy Bridge
Memory: 6G


<3>[   90.915459] [drm:__gen6_gt_force_wake_get] *ERROR* Timed out waiting for forcewake to ack request.
<3>[   90.925094] [drm:__gen6_gt_force_wake_get] *ERROR* Timed out waiting for forcewake to ack request.
<3>[   90.934725] [drm:__gen6_gt_force_wake_get] *ERROR* Timed out waiting for forcewake to ack request.
<3>[   90.944347] [drm:__gen6_gt_force_wake_get] *ERROR* Timed out waiting for forcewake to ack request.
<3>[   90.953956] [drm:__gen6_gt_force_wake_get] *ERROR* Timed out waiting for forcewake to ack request.
<3>[   90.963559] [drm:__gen6_gt_force_wake_get] *ERROR* Timed out waiting for forcewake to ack request.
<3>[   90.973173] [drm:__gen6_gt_force_wake_get] *ERROR* Timed out waiting for forcewake to ack request.
<3>[   90.982793] [drm:__gen6_gt_force_wake_get] *ERROR* Timed out waiting for forcewake to ack request.
<3>[   90.992405] [drm:__gen6_gt_force_wake_get] *ERROR* Timed out waiting for forcewake to ack request.
<3>[   91.002008] [drm:__gen6_gt_force_wake_get] *ERROR* Timed out waiting for forcewake to ack request.
<3>[   91.011618] [drm:__gen6_gt_force_wake_get] *ERROR* Timed out waiting for forcewake to ack request.
<3>[   91.021222] [drm:__gen6_gt_force_wake_get] *ERROR* Timed out waiting for forcewake to ack request.
<3>[   91.030825] [drm:__gen6_gt_force_wake_get] *ERROR* Timed out waiting for forcewake to ack request.
<3>[   91.040430] [drm:__gen6_gt_force_wake_get] *ERROR* Timed out waiting for forcewake to ack request.
<3>[   91.050016] [drm:__gen6_gt_force_wake_get] *ERROR* Timed out waiting for forcewake to ack request.
<3>[   91.059593] [drm:__gen6_gt_force_wake_get] *ERROR* Timed out waiting for forcewake to ack request.
<3>[   91.069152] [drm:__gen6_gt_force_wake_get] *ERROR* Timed out waiting for forcewake to ack request.


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


	--yliu

--SkvwRMAIpAhPCcCJ
Content-Type: text/plain; charset=us-ascii
Content-Disposition: attachment; filename="job.yaml"

---
testcase: piglit
default_monitors:
  wait: pre-test
  vmstat: 
default_watchdogs:
  watch-oom: 
  watchdog: 
cpufreq_governor:
- performance
commit: 9bdebfefe1de2b6fa7e193c10411ef209b0ebc96
model: Sandy Bridge
memory: 6G
hdd_partitions: "/dev/disk/by-id/ata-ST3750528AS_6VP2W0PA-part5 /dev/disk/by-id/ata-ST3750528AS_6VP2W0PA-part6
  /dev/disk/by-id/ata-ST3750528AS_6VP2W0PA-part7 /dev/disk/by-id/ata-ST3750528AS_6VP2W0PA-part8
  /dev/disk/by-id/ata-ST3750528AS_6VP2W0PA-part9 /dev/disk/by-id/ata-ST3750528AS_6VP2W0PA-part10"
swap_partitions: 
rootfs_partition: "/dev/disk/by-id/ata-ST3750528AS_6VP2W0PA-part2"
timeout: 30m
piglit:
  group:
  - igt-001
enqueue_time: 2014-10-27 03:51:37.871425766 +08:00
testbox: snb-drag
tbox_group: snb-drag
kconfig: x86_64-rhel
head_commit: 9bdebfefe1de2b6fa7e193c10411ef209b0ebc96
base_commit: cac7f2429872d3733dc3f9915857b1691da2eb2f
branch: linux-devel/devel-hourly-2014103002
kernel: "/kernel/x86_64-rhel/9bdebfefe1de2b6fa7e193c10411ef209b0ebc96/vmlinuz-3.18.0-rc2-g9bdebfe"
user: lkp
queue: cyclic
rootfs: debian-x86_64.cgz
result_root: "/result/snb-drag/piglit/performance-igt-001/debian-x86_64.cgz/x86_64-rhel/9bdebfefe1de2b6fa7e193c10411ef209b0ebc96/0"
job_file: "/lkp/scheduled/snb-drag/cyclic_piglit-performance-igt-001-x86_64-rhel-HEAD-9bdebfefe1de2b6fa7e193c10411ef209b0ebc96-0.yaml"
dequeue_time: 2014-10-30 03:46:50.534182476 +08:00
job_state: finished
loadavg: 0.62 0.46 0.25 1/96 9645
start_time: '1414612069'
end_time: '1414612536'
version: "/lkp/lkp/.src-20141029-214343"

--SkvwRMAIpAhPCcCJ
Content-Type: text/plain; charset=us-ascii
Content-Disposition: attachment; filename=reproduce

echo performance > /sys/devices/system/cpu/cpu0/cpufreq/scaling_governor
echo performance > /sys/devices/system/cpu/cpu1/cpufreq/scaling_governor
echo performance > /sys/devices/system/cpu/cpu2/cpufreq/scaling_governor
echo performance > /sys/devices/system/cpu/cpu3/cpufreq/scaling_governor
piglit run igt -t igt/drv_hangman/error-state-capture-bsd /lkp/lkp/src/tmp/piglit-results-0
piglit summary console /lkp/lkp/src/tmp/piglit-results-0
piglit run igt -t igt/gem_reset_stats/reset-count-ctx-vebox /lkp/lkp/src/tmp/piglit-results-1
piglit summary console /lkp/lkp/src/tmp/piglit-results-1
piglit run igt -t igt/gem_gtt_cpu_tlb /lkp/lkp/src/tmp/piglit-results-2
piglit summary console /lkp/lkp/src/tmp/piglit-results-2
piglit run igt -t igt/kms_addfb/bo-too-small-due-to-tiling /lkp/lkp/src/tmp/piglit-results-3
piglit summary console /lkp/lkp/src/tmp/piglit-results-3
piglit run igt -t igt/gem_reloc_overflow/source-offset-end-reloc-cpu /lkp/lkp/src/tmp/piglit-results-4
piglit summary console /lkp/lkp/src/tmp/piglit-results-4
piglit run igt -t igt/core_get_client_auth/simple /lkp/lkp/src/tmp/piglit-results-5
piglit summary console /lkp/lkp/src/tmp/piglit-results-5
piglit run igt -t igt/kms_flip/bo-too-big /lkp/lkp/src/tmp/piglit-results-6
piglit summary console /lkp/lkp/src/tmp/piglit-results-6
piglit run igt -t igt/prime_nv_api/nv_self_import_to_different_fd /lkp/lkp/src/tmp/piglit-results-7
piglit summary console /lkp/lkp/src/tmp/piglit-results-7
piglit run igt -t igt/gem_set_tiling_vs_blt/untiled-to-tiled /lkp/lkp/src/tmp/piglit-results-8
piglit summary console /lkp/lkp/src/tmp/piglit-results-8
piglit run igt -t igt/kms_flip/2x-vblank-vs-hang-interruptible /lkp/lkp/src/tmp/piglit-results-9
piglit summary console /lkp/lkp/src/tmp/piglit-results-9
piglit run igt -t igt/gem_ctx_exec/reset-pin-leak /lkp/lkp/src/tmp/piglit-results-10
piglit summary console /lkp/lkp/src/tmp/piglit-results-10
piglit run igt -t igt/kms_addfb/bad-pitch-65536 /lkp/lkp/src/tmp/piglit-results-11
piglit summary console /lkp/lkp/src/tmp/piglit-results-11
piglit run igt -t igt/gem_readwrite/write-bad-handle /lkp/lkp/src/tmp/piglit-results-12
piglit summary console /lkp/lkp/src/tmp/piglit-results-12
piglit run igt -t igt/gem_pread_after_blit/normal /lkp/lkp/src/tmp/piglit-results-13
piglit summary console /lkp/lkp/src/tmp/piglit-results-13
piglit run igt -t igt/kms_flip/blocking-absolute-wf_vblank /lkp/lkp/src/tmp/piglit-results-14
piglit summary console /lkp/lkp/src/tmp/piglit-results-14
piglit run igt -t igt/kms_plane/plane-panning-bottom-right-pipe-C-plane-1 /lkp/lkp/src/tmp/piglit-results-15
piglit summary console /lkp/lkp/src/tmp/piglit-results-15
piglit run igt -t igt/kms_plane/plane-panning-bottom-right-pipe-C-plane-3 /lkp/lkp/src/tmp/piglit-results-16
piglit summary console /lkp/lkp/src/tmp/piglit-results-16
piglit run igt -t igt/kms_plane/plane-panning-bottom-right-pipe-C-plane-2 /lkp/lkp/src/tmp/piglit-results-17
piglit summary console /lkp/lkp/src/tmp/piglit-results-17
piglit run igt -t igt/gem_pread/normal /lkp/lkp/src/tmp/piglit-results-18
piglit summary console /lkp/lkp/src/tmp/piglit-results-18
piglit run igt -t igt/pm_rpm/gem-mmap-cpu /lkp/lkp/src/tmp/piglit-results-19
piglit summary console /lkp/lkp/src/tmp/piglit-results-19
piglit run igt -t igt/gem_mmap_gtt/write-read-distinct /lkp/lkp/src/tmp/piglit-results-20
piglit summary console /lkp/lkp/src/tmp/piglit-results-20
piglit run igt -t igt/kms_mmio_vs_cs_flip/setcrtc_vs_cs_flip /lkp/lkp/src/tmp/piglit-results-21
piglit summary console /lkp/lkp/src/tmp/piglit-results-21
piglit run igt -t igt/kms_flip/busy-flip-interruptible /lkp/lkp/src/tmp/piglit-results-22
piglit summary console /lkp/lkp/src/tmp/piglit-results-22
piglit run igt -t igt/kms_flip/wf_vblank-vs-modeset-interruptible /lkp/lkp/src/tmp/piglit-results-23
piglit summary console /lkp/lkp/src/tmp/piglit-results-23
piglit run igt -t igt/prime_nv_api/i915_nv_double_export /lkp/lkp/src/tmp/piglit-results-24
piglit summary console /lkp/lkp/src/tmp/piglit-results-24
piglit run igt -t igt/gem_pwrite_pread/snooped-pwrite-blt-cpu_mmap-correctness /lkp/lkp/src/tmp/piglit-results-25
piglit summary console /lkp/lkp/src/tmp/piglit-results-25
piglit run igt -t igt/gem_reloc_overflow/source-offset-page-stradle-gen8-reloc-cpu /lkp/lkp/src/tmp/piglit-results-26
piglit summary console /lkp/lkp/src/tmp/piglit-results-26
piglit run igt -t igt/gem_reset_stats/close-pending-ctx-render /lkp/lkp/src/tmp/piglit-results-27
piglit summary console /lkp/lkp/src/tmp/piglit-results-27
piglit run igt -t igt/gem_reset_stats/ban-vebox /lkp/lkp/src/tmp/piglit-results-28
piglit summary console /lkp/lkp/src/tmp/piglit-results-28
piglit run igt -t igt/gem_render_copy_redux /lkp/lkp/src/tmp/piglit-results-29
piglit summary console /lkp/lkp/src/tmp/piglit-results-29
piglit run igt -t igt/gem_pwrite_pread/uncached-pwrite-blt-gtt_mmap-correctness /lkp/lkp/src/tmp/piglit-results-30
piglit summary console /lkp/lkp/src/tmp/piglit-results-30
piglit run igt -t igt/kms_flip/2x-flip-vs-absolute-wf_vblank /lkp/lkp/src/tmp/piglit-results-31
piglit summary console /lkp/lkp/src/tmp/piglit-results-31
piglit run igt -t igt/gem_evict_everything/forked-swapping-multifd-normal /lkp/lkp/src/tmp/piglit-results-32
piglit summary console /lkp/lkp/src/tmp/piglit-results-32
piglit run igt -t igt/gem_exec_bad_domains/gtt-domain /lkp/lkp/src/tmp/piglit-results-33
piglit summary console /lkp/lkp/src/tmp/piglit-results-33
piglit run igt -t igt/gem_pipe_control_store_loop/reused-buffer /lkp/lkp/src/tmp/piglit-results-34
piglit summary console /lkp/lkp/src/tmp/piglit-results-34
piglit run igt -t igt/gem_reloc_overflow/batch-start-unaligned /lkp/lkp/src/tmp/piglit-results-35
piglit summary console /lkp/lkp/src/tmp/piglit-results-35
piglit run igt -t igt/gem_concurrent_blit/cpu-early-read-interruptible /lkp/lkp/src/tmp/piglit-results-36
piglit summary console /lkp/lkp/src/tmp/piglit-results-36
piglit run igt -t igt/gem_concurrent_blit/prw-gpu-read-after-write /lkp/lkp/src/tmp/piglit-results-37
piglit summary console /lkp/lkp/src/tmp/piglit-results-37
piglit run igt -t igt/kms_flip/2x-flip-vs-wf_vblank /lkp/lkp/src/tmp/piglit-results-38
piglit summary console /lkp/lkp/src/tmp/piglit-results-38
piglit run igt -t igt/gem_pread/uncached /lkp/lkp/src/tmp/piglit-results-39
piglit summary console /lkp/lkp/src/tmp/piglit-results-39
piglit run igt -t igt/gem_userptr_blits/sync-unmap /lkp/lkp/src/tmp/piglit-results-40
piglit summary console /lkp/lkp/src/tmp/piglit-results-40
piglit run igt -t igt/kms_fbc_crc/blt /lkp/lkp/src/tmp/piglit-results-41
piglit summary console /lkp/lkp/src/tmp/piglit-results-41
piglit run igt -t igt/kms_flip/flip-vs-expired-vblank-interruptible /lkp/lkp/src/tmp/piglit-results-42
piglit summary console /lkp/lkp/src/tmp/piglit-results-42
piglit run igt -t igt/gem_exec_bad_domains/conflicting-write-domain /lkp/lkp/src/tmp/piglit-results-43
piglit summary console /lkp/lkp/src/tmp/piglit-results-43
piglit run igt -t igt/gem_madvise/dontneed-after-mmap /lkp/lkp/src/tmp/piglit-results-44
piglit summary console /lkp/lkp/src/tmp/piglit-results-44
piglit run igt -t igt/kms_pipe_crc_basic/read-crc-pipe-A-frame-sequence /lkp/lkp/src/tmp/piglit-results-45
piglit summary console /lkp/lkp/src/tmp/piglit-results-45
piglit run igt -t igt/gem_double_irq_loop /lkp/lkp/src/tmp/piglit-results-46
piglit summary console /lkp/lkp/src/tmp/piglit-results-46
piglit run igt -t igt/kms_flip/2x-wf_vblank-vs-dpms-interruptible /lkp/lkp/src/tmp/piglit-results-47
piglit summary console /lkp/lkp/src/tmp/piglit-results-47
piglit run igt -t igt/kms_psr_sink_crc/cursor_move /lkp/lkp/src/tmp/piglit-results-48
piglit summary console /lkp/lkp/src/tmp/piglit-results-48
piglit run igt -t igt/gem_userptr_blits/Testing synchronized mappings... /lkp/lkp/src/tmp/piglit-results-49
piglit summary console /lkp/lkp/src/tmp/piglit-results-49
piglit run igt -t igt/gem_fence_thrash/bo-write-verify-none /lkp/lkp/src/tmp/piglit-results-50
piglit summary console /lkp/lkp/src/tmp/piglit-results-50
piglit run igt -t igt/gem_concurrent_blit/prw-early-read /lkp/lkp/src/tmp/piglit-results-51
piglit summary console /lkp/lkp/src/tmp/piglit-results-51
piglit run igt -t igt/kms_fbc_crc/render /lkp/lkp/src/tmp/piglit-results-52
piglit summary console /lkp/lkp/src/tmp/piglit-results-52
piglit run igt -t igt/gem_exec_bad_domains/cpu-domain /lkp/lkp/src/tmp/piglit-results-53
piglit summary console /lkp/lkp/src/tmp/piglit-results-53
piglit run igt -t igt/kms_addfb/normal /lkp/lkp/src/tmp/piglit-results-54
piglit summary console /lkp/lkp/src/tmp/piglit-results-54
piglit run igt -t igt/gem_reset_stats/close-pending-fork-bsd /lkp/lkp/src/tmp/piglit-results-55
piglit summary console /lkp/lkp/src/tmp/piglit-results-55
piglit run igt -t igt/gem_pwrite_pread/snooped-pwrite-blt-cpu_mmap-performance /lkp/lkp/src/tmp/piglit-results-56
piglit summary console /lkp/lkp/src/tmp/piglit-results-56
piglit run igt -t igt/gem_threaded_access_tiled /lkp/lkp/src/tmp/piglit-results-57
piglit summary console /lkp/lkp/src/tmp/piglit-results-57
piglit run igt -t igt/gem_reset_stats/ban-ctx-bsd /lkp/lkp/src/tmp/piglit-results-58
piglit summary console /lkp/lkp/src/tmp/piglit-results-58
piglit run igt -t igt/gem_ctx_bad_destroy /lkp/lkp/src/tmp/piglit-results-59
piglit summary console /lkp/lkp/src/tmp/piglit-results-59
piglit run igt -t igt/kms_flip/2x-vblank-vs-modeset-suspend-interruptible /lkp/lkp/src/tmp/piglit-results-60
piglit summary console /lkp/lkp/src/tmp/piglit-results-60
piglit run igt -t igt/kms_addfb/too-high /lkp/lkp/src/tmp/piglit-results-61
piglit summary console /lkp/lkp/src/tmp/piglit-results-61
piglit run igt -t igt/kms_psr_sink_crc/mmap_gtt_waiting_no_busy /lkp/lkp/src/tmp/piglit-results-62
piglit summary console /lkp/lkp/src/tmp/piglit-results-62
piglit run igt -t igt/gem_storedw_batches_loop/secure-dispatch /lkp/lkp/src/tmp/piglit-results-63
piglit summary console /lkp/lkp/src/tmp/piglit-results-63
piglit run igt -t igt/gem_exec_params/rel-constants-invalid-rel-gen5 /lkp/lkp/src/tmp/piglit-results-64
piglit summary console /lkp/lkp/src/tmp/piglit-results-64
piglit run igt -t igt/kms_plane/plane-position-hole-pipe-A-plane-2 /lkp/lkp/src/tmp/piglit-results-65
piglit summary console /lkp/lkp/src/tmp/piglit-results-65
piglit run igt -t igt/gem_dummy_reloc_loop/mixed /lkp/lkp/src/tmp/piglit-results-66
piglit summary console /lkp/lkp/src/tmp/piglit-results-66
piglit run igt -t igt/kms_plane/plane-position-hole-pipe-A-plane-3 /lkp/lkp/src/tmp/piglit-results-67
piglit summary console /lkp/lkp/src/tmp/piglit-results-67
piglit run igt -t igt/kms_psr_sink_crc/page_flip_and_mmap_cpu /lkp/lkp/src/tmp/piglit-results-68
piglit summary console /lkp/lkp/src/tmp/piglit-results-68
piglit run igt -t igt/kms_flip/flip-vs-fences-interruptible /lkp/lkp/src/tmp/piglit-results-69
piglit summary console /lkp/lkp/src/tmp/piglit-results-69
piglit run igt -t igt/kms_flip/2x-blocking-absolute-wf_vblank-interruptible /lkp/lkp/src/tmp/piglit-results-70
piglit summary console /lkp/lkp/src/tmp/piglit-results-70
piglit run igt -t igt/kms_flip/2x-plain-flip-fb-recreate-interruptible /lkp/lkp/src/tmp/piglit-results-71
piglit summary console /lkp/lkp/src/tmp/piglit-results-71
piglit run igt -t igt/gem_set_tiling_vs_blt/tiled-to-tiled /lkp/lkp/src/tmp/piglit-results-72
piglit summary console /lkp/lkp/src/tmp/piglit-results-72
piglit run igt -t igt/gen3_render_tiledx_blits /lkp/lkp/src/tmp/piglit-results-73
piglit summary console /lkp/lkp/src/tmp/piglit-results-73
piglit run igt -t igt/gem_reloc_vs_gpu/forked-interruptible-thrash-inactive /lkp/lkp/src/tmp/piglit-results-74
piglit summary console /lkp/lkp/src/tmp/piglit-results-74
piglit run igt -t igt/kms_flip/2x-bcs-flip-vs-modeset-interruptible /lkp/lkp/src/tmp/piglit-results-75
piglit summary console /lkp/lkp/src/tmp/piglit-results-75
piglit run igt -t igt/pm_rps/basic-api /lkp/lkp/src/tmp/piglit-results-76
piglit summary console /lkp/lkp/src/tmp/piglit-results-76
piglit run igt -t igt/gem_reset_stats/unrelated-ctx-blt /lkp/lkp/src/tmp/piglit-results-77
piglit summary console /lkp/lkp/src/tmp/piglit-results-77
piglit run igt -t igt/kms_flip/2x-rcs-flip-vs-dpms /lkp/lkp/src/tmp/piglit-results-78
piglit summary console /lkp/lkp/src/tmp/piglit-results-78
piglit run igt -t igt/gem_evict_everything/minor-interruptible /lkp/lkp/src/tmp/piglit-results-79
piglit summary console /lkp/lkp/src/tmp/piglit-results-79
piglit run igt -t igt/gem_reset_stats/close-pending-render /lkp/lkp/src/tmp/piglit-results-80
piglit summary console /lkp/lkp/src/tmp/piglit-results-80
piglit run igt -t igt/prime_self_import/export-vs-gem_close-race /lkp/lkp/src/tmp/piglit-results-81
piglit summary console /lkp/lkp/src/tmp/piglit-results-81

--SkvwRMAIpAhPCcCJ--

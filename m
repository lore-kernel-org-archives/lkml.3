Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751461AbaI3K4w (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Sep 2014 06:56:52 -0400
Received: from mail-we0-f169.google.com ([74.125.82.169]:58482 "EHLO
	mail-we0-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751014AbaI3K4v (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Sep 2014 06:56:51 -0400
MIME-Version: 1.0
Date: Tue, 30 Sep 2014 16:26:49 +0530
Message-ID: <CAEOkp47rz9-V_qZkOGDjfsZQj5bRHq2hf8dghS3xRcwdrP9UzQ@mail.gmail.com>
Subject: Enabling ftrace on ARM MMU-less system
From: Amit Virdi <amitvi128@gmail.com>
To: fweisbec@gmail.com, rostedt@goodmis.org, mingo@redhat.com
Cc: linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

I'm trying to enable Ftrace on my ARM based MMU-less system.
Unexpectedly, I don't see tracing directory under /sys/kernel/debug
I have done the following so far but no success:
1. Verified that I have enabled these flags in my .config
    CONFIG_FUNCTION_TRACER
    CONFIG_FUNCTION_GRAPH_TRACER
    CONFIG_STACK_TRACER
    CONFIG_DYNAMIC_FTRACE

2. Enabled Ftrace startup steps. The startup log output is
----
<...>
ftrace: allocating 8996 entries in 27 pages
Testing tracer nop: PASSED
<...>
Testing tracer function: PASSED
Testing dynamic ftrace: PASSED
Testing dynamic ftrace ops #1: (1 0 1 1 0) (1 1 2 1 0) (2 1 3 1 2) (2
2 4 1 59) PASSED
Testing dynamic ftrace ops #2: (1 0 1 2 0) (1 1 2 59 0) (2 1 3 1 2) (2
2 4 58 59) PASSED
Testing tracer function_graph: PASSED
<..>
Running tests on trace events:
Testing event snd_soc_reg_write: OK
Testing event snd_soc_reg_read: OK
Testing event snd_soc_preg_write: OK
Testing event snd_soc_preg_read: OK
Testing event snd_soc_bias_level_start: OK
Testing event snd_soc_bias_level_done: OK
Testing event snd_soc_dapm_start: OK
Testing event snd_soc_dapm_done: OK
Testing event snd_soc_dapm_widget_power: OK
Testing event snd_soc_dapm_widget_event_start: OK
Testing event snd_soc_dapm_widget_event_done: OK
Testing event snd_soc_dapm_walk_done: OK
Testing event snd_soc_jack_irq: OK
Testing event snd_soc_jack_report: OK
Testing event snd_soc_jack_notify: OK
Testing event snd_soc_cache_sync: OK
Testing event scsi_dispatch_cmd_start: OK
Testing event scsi_dispatch_cmd_error: OK
Testing event scsi_dispatch_cmd_done: OK
Testing event scsi_dispatch_cmd_timeout: OK
Testing event scsi_eh_wakeup: OK
Testing event regmap_reg_write: OK
Testing event regmap_reg_read: OK
Testing event regmap_reg_read_cache: OK
Testing event regmap_hw_read_start: OK
Testing event regmap_hw_read_done: OK
Testing event regmap_hw_write_start: OK
Testing event regmap_hw_write_done: OK
Testing event regcache_sync: OK
Testing event gpio_direction: OK
Testing event gpio_value: OK
Testing event block_rq_abort: OK
Testing event block_rq_requeue: OK
Testing event block_rq_complete: OK
Testing event block_rq_insert: OK
Testing event block_rq_issue: OK
Testing event block_bio_bounce: OK
Testing event block_bio_complete: OK
Testing event block_bio_backmerge: OK
Testing event block_bio_frontmerge: OK
Testing event block_bio_queue: OK
Testing event block_getrq: OK
Testing event block_sleeprq: OK
Testing event block_plug: OK
Testing event block_unplug: OK
Testing event block_split: OK
Testing event block_bio_remap: OK
Testing event block_rq_remap: OK
Testing event writeback_nothread: OK
Testing event writeback_queue: OK
Testing event writeback_exec: OK
Testing event writeback_start: OK
Testing event writeback_written: OK
Testing event writeback_wait: OK
Testing event writeback_pages_written: OK
Testing event writeback_nowork: OK
Testing event writeback_wake_background: OK
Testing event writeback_wake_thread: OK
Testing event writeback_wake_forker_thread: OK
Testing event writeback_bdi_register: OK
Testing event writeback_bdi_unregister: OK
Testing event writeback_thread_start: OK
Testing event writeback_thread_stop: OK
Testing event wbc_writepage: OK
Testing event writeback_queue_io: OK
Testing event global_dirty_state: OK
Testing event bdi_dirty_ratelimit: OK
Testing event balance_dirty_pages: OK
Testing event writeback_congestion_wait: OK
Testing event writeback_wait_iff_congested: OK
Testing event writeback_single_inode_requeue: OK
Testing event writeback_single_inode: OK
Testing event kmalloc: OK
Testing event kmem_cache_alloc: OK
Testing event kmalloc_node: OK
Testing event kmem_cache_alloc_node: OK
Testing event kfree: OK
Testing event kmem_cache_free: OK
Testing event mm_page_free: OK
Testing event mm_page_free_batched: OK
Testing event mm_page_alloc: OK
Testing event mm_page_alloc_zone_locked: OK
Testing event mm_page_pcpu_drain: OK
Testing event mm_page_alloc_extfrag: OK
Testing event mm_vmscan_kswapd_sleep: OK
Testing event mm_vmscan_kswapd_wake: OK
Testing event mm_vmscan_wakeup_kswapd: OK
Testing event mm_vmscan_direct_reclaim_begin: OK
Testing event mm_vmscan_memcg_reclaim_begin: OK
Testing event mm_vmscan_memcg_softlimit_reclaim_begin: OK
Testing event mm_vmscan_direct_reclaim_end: OK
Testing event mm_vmscan_memcg_reclaim_end: OK
Testing event mm_vmscan_memcg_softlimit_reclaim_end: OK
Testing event mm_shrink_slab_start: OK
Testing event mm_shrink_slab_end: OK
Testing event mm_vmscan_lru_isolate: OK
Testing event mm_vmscan_memcg_isolate: OK
Testing event mm_vmscan_writepage: OK
Testing event mm_vmscan_lru_shrink_inactive: OK
Testing event replace_swap_token: OK
Testing event put_swap_token: OK
Testing event disable_swap_token: OK
Testing event update_swap_token_priority: OK
Testing event oom_score_adj_update: OK
Testing event cpu_idle: OK
Testing event cpu_frequency: OK
Testing event machine_suspend: OK
Testing event power_start: OK
Testing event power_frequency: OK
Testing event power_end: OK
Testing event clock_enable: OK
Testing event clock_disable: OK
Testing event clock_set_rate: OK
Testing event power_domain_target: OK
Testing event ftrace_test_filter: OK
Testing event module_load: OK
Testing event module_free: OK
Testing event module_get: OK
Testing event module_put: OK
Testing event module_request: OK
Testing event sched_kthread_stop: OK
Testing event sched_kthread_stop_ret: OK
Testing event sched_wakeup: OK
Testing event sched_wakeup_new: OK
Testing event sched_switch: OK
Testing event sched_migrate_task: OK
Testing event sched_process_free: OK
Testing event sched_process_exit: OK
Testing event sched_wait_task: OK
Testing event sched_process_wait: OK
Testing event sched_process_fork: OK
Testing event sched_stat_wait: OK
Testing event sched_stat_sleep: OK
Testing event sched_stat_iowait: OK
Testing event sched_stat_blocked: OK
Testing event sched_stat_runtime: OK
Testing event sched_stat_sleeptime: OK
Testing event sched_pi_setprio: OK
Testing event rcu_utilization: OK
Testing event workqueue_queue_work: OK
Testing event workqueue_activate_work: OK
Testing event workqueue_execute_start: OK
Testing event workqueue_execute_end: OK
Testing event signal_generate: OK
Testing event signal_deliver: OK
Testing event signal_overflow_fail: OK
Testing event signal_lose_info: OK
Testing event timer_init: OK
Testing event timer_start: OK
Testing event timer_expire_entry: OK
Testing event timer_expire_exit: OK
Testing event timer_cancel: OK
Testing event hrtimer_init: OK
Testing event hrtimer_start: OK
Testing event hrtimer_expire_entry: OK
Testing event hrtimer_expire_exit: OK
Testing event hrtimer_cancel: OK
Testing event itimer_state: OK
Testing event itimer_expire: OK
Testing event irq_handler_entry: OK
Testing event irq_handler_exit: OK
Testing event softirq_entry: OK
Testing event softirq_exit: OK
Testing event softirq_raise: OK
Testing event task_newtask: OK
Testing event task_rename: OK
Running tests on trace event systems:
Testing event system asoc: OK
Testing event system scsi: OK
Testing event system regmap: OK
Testing event system gpio: OK
Testing event system block: OK
Testing event system writeback: OK
Testing event system kmem: OK
Testing event system vmscan: OK
Testing event system oom: OK
Testing event system power: OK
Testing event system test: OK
Testing event system module: OK
Testing event system sched: OK
Testing event system rcu: OK
Testing event system workqueue: OK
Testing event system signal: OK
Testing event system timer: OK
Testing event system irq: OK
Testing event system task: OK
Running tests on all trace events:
Testing all events: OK
Running tests again, along with the function tracer
Running tests on trace events:
Testing event snd_soc_reg_write: OK
Testing event snd_soc_reg_read: OK
Testing event snd_soc_preg_write: OK
Testing event snd_soc_preg_read: OK
Testing event snd_soc_bias_level_start: OK
Testing event snd_soc_bias_level_done: OK
Testing event snd_soc_dapm_start: OK
Testing event snd_soc_dapm_done: OK
Testing event snd_soc_dapm_widget_power: OK
Testing event snd_soc_dapm_widget_event_start: OK
Testing event snd_soc_dapm_widget_event_done: OK
Testing event snd_soc_dapm_walk_done: OK
Testing event snd_soc_jack_irq: OK
Testing event snd_soc_jack_report: OK
Testing event snd_soc_jack_notify: OK
Testing event snd_soc_cache_sync: OK
Testing event scsi_dispatch_cmd_start: OK
Testing event scsi_dispatch_cmd_error: OK
Testing event scsi_dispatch_cmd_done: OK
Testing event scsi_dispatch_cmd_timeout: OK
Testing event scsi_eh_wakeup: OK
Testing event regmap_reg_write: OK
Testing event regmap_reg_read: OK
Testing event regmap_reg_read_cache: OK
Testing event regmap_hw_read_start: OK
Testing event regmap_hw_read_done: OK
Testing event regmap_hw_write_start: OK
Testing event regmap_hw_write_done: OK
Testing event regcache_sync: OK
Testing event gpio_direction: OK
Testing event gpio_value: OK
Testing event block_rq_abort: OK
Testing event block_rq_requeue: OK
Testing event block_rq_complete: OK
Testing event block_rq_insert: OK
Testing event block_rq_issue: OK
Testing event block_bio_bounce: OK
Testing event block_bio_complete: OK
Testing event block_bio_backmerge: OK
Testing event block_bio_frontmerge: OK
Testing event block_bio_queue: OK
Testing event block_getrq: OK
Testing event block_sleeprq: OK
Testing event block_plug: OK
Testing event block_unplug: OK
Testing event block_split: OK
Testing event block_bio_remap: OK
Testing event block_rq_remap: OK
Testing event writeback_nothread: OK
Testing event writeback_queue: OK
Testing event writeback_exec: OK
Testing event writeback_start: OK
Testing event writeback_written: OK
Testing event writeback_wait: OK
Testing event writeback_pages_written: OK
Testing event writeback_nowork: OK
Testing event writeback_wake_background: OK
Testing event writeback_wake_thread: OK
Testing event writeback_wake_forker_thread: OK
Testing event writeback_bdi_register: OK
Testing event writeback_bdi_unregister: OK
Testing event writeback_thread_start: OK
Testing event writeback_thread_stop: OK
Testing event wbc_writepage: OK
Testing event writeback_queue_io: OK
Testing event global_dirty_state: OK
Testing event bdi_dirty_ratelimit: OK
Testing event balance_dirty_pages: OK
Testing event writeback_congestion_wait: OK
Testing event writeback_wait_iff_congested: OK
Testing event writeback_single_inode_requeue: OK
Testing event writeback_single_inode: OK
Testing event kmalloc: OK
Testing event kmem_cache_alloc: OK
Testing event kmalloc_node: OK
Testing event kmem_cache_alloc_node: OK
Testing event kfree: OK
Testing event kmem_cache_free: OK
Testing event mm_page_free: OK
Testing event mm_page_free_batched: OK
Testing event mm_page_alloc: OK
Testing event mm_page_alloc_zone_locked: OK
Testing event mm_page_pcpu_drain: OK
Testing event mm_page_alloc_extfrag: OK
Testing event mm_vmscan_kswapd_sleep: OK
Testing event mm_vmscan_kswapd_wake: OK
Testing event mm_vmscan_wakeup_kswapd: OK
Testing event mm_vmscan_direct_reclaim_begin: OK
Testing event mm_vmscan_memcg_reclaim_begin: OK
Testing event mm_vmscan_memcg_softlimit_reclaim_begin: OK
Testing event mm_vmscan_direct_reclaim_end: OK
Testing event mm_vmscan_memcg_reclaim_end: OK
Testing event mm_vmscan_memcg_softlimit_reclaim_end: OK
Testing event mm_shrink_slab_start: OK
Testing event mm_shrink_slab_end: OK
Testing event mm_vmscan_lru_isolate: OK
Testing event mm_vmscan_memcg_isolate: OK
Testing event mm_vmscan_writepage: OK
Testing event mm_vmscan_lru_shrink_inactive: OK
Testing event replace_swap_token: OK
Testing event put_swap_token: OK
Testing event disable_swap_token: OK
Testing event update_swap_token_priority: OK
Testing event oom_score_adj_update: OK
Testing event cpu_idle: OK
Testing event cpu_frequency: OK
Testing event machine_suspend: OK
Testing event power_start: OK
Testing event power_frequency: OK
Testing event power_end: OK
Testing event clock_enable: OK
Testing event clock_disable: OK
Testing event clock_set_rate: OK
Testing event power_domain_target: OK
Testing event ftrace_test_filter: OK
Testing event module_load: OK
Testing event module_free: OK
Testing event module_get: OK
Testing event module_put: OK
Testing event module_request: OK
Testing event sched_kthread_stop: OK
Testing event sched_kthread_stop_ret: OK
Testing event sched_wakeup: OK
Testing event sched_wakeup_new: OK
Testing event sched_switch: OK
Testing event sched_migrate_task: OK
Testing event sched_process_free: OK
Testing event sched_process_exit: OK
Testing event sched_wait_task: OK
Testing event sched_process_wait: OK
Testing event sched_process_fork: OK
Testing event sched_stat_wait: OK
Testing event sched_stat_sleep: OK
Testing event sched_stat_iowait: OK
Testing event sched_stat_blocked: OK
Testing event sched_stat_runtime: OK
Testing event sched_stat_sleeptime: OK
Testing event sched_pi_setprio: OK
Testing event rcu_utilization: OK
Testing event workqueue_queue_work: OK
Testing event workqueue_activate_work: OK
Testing event workqueue_execute_start: OK
Testing event workqueue_execute_end: OK
Testing event signal_generate: OK
Testing event signal_deliver: OK
Testing event signal_overflow_fail: OK
Testing event signal_lose_info: OK
Testing event timer_init: OK
Testing event timer_start: OK
Testing event timer_expire_entry: OK
Testing event timer_expire_exit: OK
Testing event timer_cancel: OK
Testing event hrtimer_init: OK
Testing event hrtimer_start: OK
Testing event hrtimer_expire_entry: OK
Testing event hrtimer_expire_exit: OK
Testing event hrtimer_cancel: OK
Testing event itimer_state: OK
Testing event itimer_expire: OK
Testing event irq_handler_entry: OK
Testing event irq_handler_exit: OK
Testing event softirq_entry: OK
Testing event softirq_exit: OK
Testing event softirq_raise: OK
Testing event task_newtask: OK
Testing event task_rename: OK
Running tests on trace event systems:
Testing event system asoc: OK
Testing event system scsi: OK
Testing event system regmap: OK
Testing event system gpio: OK
Testing event system block: OK
Testing event system writeback: OK
Testing event system kmem: OK
Testing event system vmscan: OK
Testing event system oom: OK
Testing event system power: OK
Testing event system test: OK
Testing event system module: OK
Testing event system sched: OK
Testing event system rcu: OK
Testing event system workqueue: OK
Testing event system signal: OK
Testing event system timer: OK
Testing event system irq: OK
Testing event system task: OK
Running tests on all trace events:
Testing all events: OK
Testing ftrace filter: OK
---

3. The output of /proc/sys/kernel/ftrace_enabled is 1.

Can anyone help what I'm missing or if ftrace is supported on MMU-less
platforms?

Thanks!

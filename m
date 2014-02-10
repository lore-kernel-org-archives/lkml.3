Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752575AbaBJWT4 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Feb 2014 17:19:56 -0500
Received: from fw-tnat.cambridge.arm.com ([217.140.96.21]:52675 "EHLO
	cam-smtp0.cambridge.arm.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1752085AbaBJWTw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Feb 2014 17:19:52 -0500
Date: Mon, 10 Feb 2014 14:17:59 -0800
From: Drew Richardson <drew.richardson@arm.com>
To: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Cc: Peter Zijlstra <peterz@infradead.org>, Arnaldo <acme@redhat.com>,
        Will Deacon <Will.Deacon@arm.com>, Pawel Moll <Pawel.Moll@arm.com>,
        Wade Cherry <Wade.Cherry@arm.com>
Subject: Perf Oops on 3.14-rc2
Message-ID: <20140210221758.GB11542@dreric01-Precision-T1600>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Thread-Topic: Perf Oops on 3.14-rc2
Accept-Language: en-US, en-GB
Content-Language: en-US
User-Agent: Mutt/1.5.21 (2010-09-15)
X-OriginalArrivalTime: 10 Feb 2014 22:18:00.0394 (UTC) FILETIME=[F550BAA0:01CF26AD]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

While adding CPU on/offlining support during perf captures I get an
Oops both on ARM as well as my desktop x86_64. Below is a small
program that duplicates the issue.

Here's the oops from an ARM Versatile Express TC2 board running a
vanilla 3.14-rc2 kernel.

[  119.176648] Unable to handle kernel NULL pointer dereference at virtual address 00000040
[  119.203448] pgd = ec178000
[  119.211562] [00000040] *pgd=adcee831, *pte=00000000, *ppte=00000000
[  119.230399] Internal error: Oops: 17 [#1] SMP THUMB2
[  119.245263] Modules linked in:
[  119.254409] CPU: 1 PID: 2268 Comm: perf_fail Not tainted 3.14.0-rc2 #1
[  119.273962] task: ee2c1540 ti: ed6b8000 task.ti: ed6b8000
[  119.290133] PC is at perf_event_aux_ctx+0x36/0x5c
[  119.304216] LR is at perf_event_aux_ctx+0x4b/0x5c
[  119.318299] pc : [<c008c62a>]    lr : [<c008c63f>]    psr: 00000033
[  119.318299] sp : ed6b9dd0  ip : ee2c1a80  fp : ee3cefe0
[  119.352701] r10: ee252420  r9 : ed6b8000  r8 : c00910b9
[  119.368346] r7 : ed6b9e48  r6 : 00000001  r5 : eefc7180  r4 : 00000000
[  119.387898] r3 : 00000000  r2 : 00000002  r1 : ed6b9e48  r0 : 00000000
[  119.407452] Flags: nzcv  IRQs on  FIQs on  Mode SVC_32  ISA Thumb  Segment user
[  119.429352] Control: 50c5387d  Table: ac17806a  DAC: 00000015
[  119.446562] Process perf_fail (pid: 2268, stack limit = 0xed6b8240)
[  119.465333] Stack: (0xed6b9dd0 to 0xed6ba000)
[  119.478374] 9dc0:                                     edb11f34 00000000 ed6b8000 ee923880
[  119.502880] 9de0: ed6b8000 00000000 ed6b9e48 c00910b9 c06bd43c c008c9d1 00000001 00000000
[  119.527385] 9e00: c008c930 00000000 00000001 ee923880 edc25c80 00000000 00000000 ee3ce000
[  119.551890] 9e20: 00000008 000014a5 00000000 c0091ebd ed6b8000 00000000 00000080 00000000
[  119.576394] 9e40: c00b1a97 00000000 ee252420 ee3cefe0 00000018 00000000 00000008 00000000
[  119.600899] 9e60: 000014a5 00000000 00000000 00000000 00000001 00402002 00000000 00000000
[  119.625404] 9e80: b1daa000 00000000 00101000 00000000 00000000 00000000 ee6c4a14 ee2520c8
[  119.649910] 9ea0: b1daa000 ee2520c0 edc25c80 edc18d80 040600fb ed55db00 ed6b8000 c00b32cb
[  119.674414] 9ec0: ee2520c0 00000000 edc25c80 00000000 00000000 00101000 00000000 ee252420
[  119.698924] 9ee0: 00000101 edc25c80 b1daa000 00000000 b1daa000 ed6b8000 edc25c80 edc18d80
[  119.723430] 9f00: 00101000 00000101 c06ad7e4 c00b37e5 00000000 edc18df8 edc18dd4 000000fb
[  119.747934] 9f20: 00100100 ed6b9f5c 00000001 00000003 00101000 00000000 edc25c80 edc18dd4
[  119.772439] 9f40: 00000000 c00a723b 00000001 00000000 ed6b9f5c c00d4bdd 00000001 00000000
[  119.796944] 9f60: 00000001 00000003 00101000 00000000 00000000 edc25c80 00000000 c00b275d
[  119.821449] 9f80: 00000001 00000000 ffffffff 00000003 00000000 be823718 000000c0 c000cfc4
[  119.845954] 9fa0: ed6b8000 c000ce01 00000003 00000000 00000000 00101000 00000003 00000001
[  119.870459] 9fc0: 00000003 00000000 be823718 000000c0 00000000 00000000 b6fd5000 00000000
[  119.894965] 9fe0: 00000000 be823664 00008bab b6f39588 40000010 00000000 00afbc1e 00000000
[  119.919477] [<c008c62a>] (perf_event_aux_ctx) from [<c008c9d1>] (perf_event_aux+0xa1/0xd4)
[  119.944251] [<c008c9d1>] (perf_event_aux) from [<c0091ebd>] (perf_event_mmap+0xf9/0x190)
[  119.968506] [<c0091ebd>] (perf_event_mmap) from [<c00b32cb>] (mmap_region+0xd7/0x418)
[  119.991973] [<c00b32cb>] (mmap_region) from [<c00b37e5>] (do_mmap_pgoff+0x1d9/0x244)
[  120.015184] [<c00b37e5>] (do_mmap_pgoff) from [<c00a723b>] (vm_mmap_pgoff+0x5b/0x74)
[  120.038389] [<c00a723b>] (vm_mmap_pgoff) from [<c00b275d>] (SyS_mmap_pgoff+0x61/0xa4)
[  120.061861] [<c00b275d>] (SyS_mmap_pgoff) from [<c000ce01>] (ret_fast_syscall+0x1/0x44)
[  120.085847] Code: 9301 9c01 42ac d00e (6c23) 2b00
[  120.100239] ---[ end trace c41e3da6a7630bd4 ]---
[  120.114104] note: perf_fail[2268] exited with preempt_count 2

Drew

--->8

#include <assert.h>
#include <fcntl.h>
#include <linux/perf_event.h>
#include <pthread.h>
#include <stdio.h>
#include <stdlib.h>
#include <sys/ioctl.h>
#include <sys/mman.h>
#include <sys/stat.h>
#include <sys/syscall.h>
#include <sys/types.h>
#include <unistd.h>

#define NR_CPUS 16
#define BUF_SIZE (1<<20)
#define MASK (BUF_SIZE - 1)

static void *bufs[NR_CPUS];
static int fds[NR_CPUS][3];
static long page_size;
static int nr_cpu_ids;

static int sys_perf_event_open(struct perf_event_attr *const attr, const pid_t pid, const int cpu, const int group_fd, const unsigned long flags) {
	return syscall(__NR_perf_event_open, attr, pid, cpu, group_fd, flags);
}

static long read_long(const char *const path)
{
	char buf[32];
	ssize_t bytes;
	int fd;

	fd = open(path, O_RDONLY);
	assert(fd >= 0);
	bytes = read(fd, buf, sizeof(buf) - 1);
	assert(bytes > 0);
	buf[bytes] = '\0';
	close(fd);

	return strtol(buf, NULL, 0);
}

static int write_cpu_online(const char online)
{
	ssize_t bytes;
	int fd;

	fd = open("/sys/devices/system/cpu/cpu1/online", O_WRONLY);
	assert(fd >= 0);
	bytes = write(fd, &online, sizeof(online));
	close(fd);

	return bytes == sizeof(online);
}

static void *busy_loop(void *arg)
{
	(void)arg;

	for (;;);

	return NULL;
}

static void create_threads(void)
{
	pthread_t thread;
	int cpu;
	int result;

	for (cpu = 0; cpu < 2*nr_cpu_ids; ++cpu) {
		result = pthread_create(&thread, NULL, busy_loop, NULL);
		assert(result == 0);
	}
}

static void start_perf(void)
{
	struct perf_event_attr pea = {
		.size = sizeof(pea),
		.read_format = PERF_FORMAT_ID | PERF_FORMAT_GROUP,
		.disabled = 1,
		.watermark = 1,
		.wakeup_watermark = 3 * BUF_SIZE / 4,
	};
	long sched_switch_id = read_long("/sys/kernel/debug/tracing/events/sched/sched_switch/id");
	int cpu;
	int i;
	int result;

	assert(sched_switch_id >= 0);

	// Setup perf
	for (cpu = 0; cpu < nr_cpu_ids; ++cpu) {
		pea.type = PERF_TYPE_TRACEPOINT;
		pea.config = sched_switch_id;
		pea.sample_period = 1;
		pea.sample_type = PERF_SAMPLE_TIME | PERF_SAMPLE_READ | PERF_SAMPLE_ID | PERF_SAMPLE_RAW,
		pea.pinned = 1;
		pea.mmap = 1;
		pea.comm = 1;
		pea.task = 1;
		pea.sample_id_all = 1;
		fds[cpu][0] = sys_perf_event_open(&pea, -1, cpu, -1, 0);
		assert(fds[cpu][0] >= 0);
		bufs[cpu] = mmap(NULL, page_size + BUF_SIZE, PROT_READ | PROT_WRITE, MAP_SHARED, fds[cpu][0], 0);
		assert(bufs[cpu] != MAP_FAILED);

		pea.pinned = 0;
		pea.mmap = 0;
		pea.comm = 0;
		pea.task = 0;
		pea.sample_id_all = 0;

		pea.type = PERF_TYPE_SOFTWARE;
		pea.config = PERF_COUNT_SW_CPU_CLOCK;
		pea.sample_period = 1000000;
		pea.sample_type = PERF_SAMPLE_TIME | PERF_SAMPLE_READ | PERF_SAMPLE_ID | PERF_SAMPLE_TID | PERF_SAMPLE_CALLCHAIN;
		fds[cpu][1] = sys_perf_event_open(&pea, -1, cpu, fds[cpu][0], PERF_FLAG_FD_OUTPUT);
		assert(fds[cpu][1] >= 0);
		result = ioctl(fds[cpu][1], PERF_EVENT_IOC_SET_OUTPUT, fds[cpu][0]);
		assert(result == 0);

		pea.type = PERF_TYPE_HARDWARE;
		pea.config = PERF_COUNT_HW_CPU_CYCLES;
		pea.sample_period = 0;
		pea.sample_type = PERF_SAMPLE_TIME | PERF_SAMPLE_READ | PERF_SAMPLE_ID;
		fds[cpu][2] = sys_perf_event_open(&pea, -1, cpu, fds[cpu][0], PERF_FLAG_FD_OUTPUT);
		assert(fds[cpu][2] >= 0);
		result = ioctl(fds[cpu][2], PERF_EVENT_IOC_SET_OUTPUT, fds[cpu][0]);
		assert(result == 0);
	}

	// Start perf
	for (cpu = 0; cpu < nr_cpu_ids; ++cpu) {
		for (i = 0; i < (int)(sizeof(fds[cpu])/sizeof(fds[cpu][0])); ++i) {
			result = ioctl(fds[cpu][i], PERF_EVENT_IOC_ENABLE);
			assert(result == 0);
		}
	}
}

static void read_perf(void)
{
	int cpu;

	for (cpu = 0; cpu < nr_cpu_ids; ++cpu) {
		if (bufs[cpu] != MAP_FAILED) {
			// Take a snapshot of the positions
			struct perf_event_mmap_page *pemp = (struct perf_event_mmap_page *)bufs[cpu];
			const __u64 head = pemp->data_head;
			__u64 tail = pemp->data_tail;

			if (head > tail) {
				printf("cpu %i has data\n", cpu);
				/*
				int header_print_count = 5;
				while (head > tail) {
					struct perf_event_header *const peh = (struct perf_event_header *)(bufs[cpu] + page_size + (tail % MASK));
					if (header_print_count > 0) {
						printf("header = {type = %i, misc = %i, size = %i}\n", peh->type, peh->misc, peh->size);
						--header_print_count;
					}
					if (peh->size <= 0) {
						printf("Found odd header\n");
						tail = head;
						break;
					}
					if (tail + peh->size > head) {
						break;
					}
					tail += peh->size;
				}
				*/

				// Update tail with the data read
				pemp->data_tail = tail;
			}
		}
	}
}

static void stop_perf(void)
{
	int cpu;
	int i;
	int result;

	// Stop perf
	for (cpu = 0; cpu < nr_cpu_ids; ++cpu) {
		for (i = 0; i < (int)(sizeof(fds[cpu])/sizeof(fds[cpu][0])); ++i) {
			result = ioctl(fds[cpu][i], PERF_EVENT_IOC_DISABLE);
			assert(result == 0);
		}
	}

	// Cleanup perf
	for (cpu = 0; cpu < nr_cpu_ids; ++cpu) {
		munmap(bufs[cpu], page_size + BUF_SIZE);
		for (i = 0; i < (int)(sizeof(fds[cpu])/sizeof(fds[cpu][0])); ++i) {
			close(fds[cpu][i]);
		}
	}
}

int main(void)
{
	int result;

	page_size = sysconf(_SC_PAGE_SIZE);
	assert(page_size > 0);
	nr_cpu_ids = sysconf(_SC_NPROCESSORS_CONF);
	assert(nr_cpu_ids > 0 && nr_cpu_ids <= NR_CPUS);

	write_cpu_online('1');
	create_threads();

	printf("Starting perf\n");
	start_perf();
	sleep(10);

	printf("Offlining cpu1\n");
	result = write_cpu_online('0');
	assert(result);
	sleep(1);

	read_perf();
	sleep(10);

	read_perf();
	stop_perf();
	write_cpu_online('1');

	return 0;
}

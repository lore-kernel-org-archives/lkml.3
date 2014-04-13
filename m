Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754464AbaDMBdN (ORCPT <rfc822;w@1wt.eu>);
	Sat, 12 Apr 2014 21:33:13 -0400
Received: from mout.gmx.net ([212.227.15.18]:49795 "EHLO mout.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753870AbaDMBdM (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 12 Apr 2014 21:33:12 -0400
MIME-Version: 1.0
Message-ID: <trinity-aef9715a-72d2-4824-a3d8-306d5850c633-1397352790457@3capp-gmx-bs18>
From: Alexander.Kleinsorge@gmx.de
To: linux-kernel@vger.kernel.org
Subject: new module to check constant memory for corruption
Content-Type: multipart/mixed;
 boundary=kenitramv-1a2aef1e-5c6a-4235-811d-a53169a2c63a
Date: Sun, 13 Apr 2014 03:33:10 +0200
Importance: normal
Sensitivity: Normal
X-Priority: 3
X-Provags-ID: V03:K0:NTpTCdidpN3xZmW73d0JEd71UoyUElALAFgnEPbesH0
 xD14MimGIFxUhw9QjRIcP9anjNI4Ktz7Y0lAiD4tQ/FFlbv2a1
 v25XFX8IRnq5Sd6s6L4HMEcyaYi4duXfYDuwBOEneq6cLqK1Y7
 u+85eEkF602hcFAmNJsWbW8BTqEnNajaay5ywMgC0wH6lxpwvM
 /XTbsH4TztC4uVw7nMBFRReBJebT3KOKLkQ8waIaiGGky+5tvM
 puBjdEeAuCn3GhsNxQcG7zs9CzBOHb3w7j0wjY4hW6CTPvidYF NY5ERU=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--kenitramv-1a2aef1e-5c6a-4235-811d-a53169a2c63a
Content-Type: text/plain; charset=UTF-8

ramcheck kernel module
new module to check constant memory for corruption

detect corruption of constant kernel memory (text and data) periodically.
runtime costs about 1..2 ms per sec (about 10 mb with 5 mb/ms),
which is distributed over 8 (BLOCKS) time partitions (less than half ms per sec).
in case of checksum (xor) error, an kernel log is posted.
manual trigger via /proc/ramcheck is possible.
range: kallsyms_lookup_name("_text") .. kallsyms_lookup_name("__end_rodata")

this new module helps against two scenarios:
1) bit flip on system without crc (typical pc)

more often than you think:
DRAM Errors in the Wild: A Large-Scale Field Study, Mai 2009.
http://www.cs.toronto.edu/~bianca/papers/sigmetrics09.pdf

2) architectures without memory protection plus attack or out-of-bound-writes.
x86 and x64 using it (write protection), but missing (or not enabled) on most other arch.

see: ramcheck.tgz

--kenitramv-1a2aef1e-5c6a-4235-811d-a53169a2c63a
Content-Type: application/octet-stream
Content-Disposition: attachment; filename=ramcheck.tgz
Content-Transfer-Encoding: base64

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
--kenitramv-1a2aef1e-5c6a-4235-811d-a53169a2c63a
Content-Type: text/plain
Content-Disposition: attachment; filename=ramcheck.c

/* ramcheck.c - checks predefined kernel memory region
*
* KernelRamCheck by
*
* Copyright 2014 Alexander Kleinsorge <alexander[dot]kleinsorge[at]gmx[dot]de>
* Copyright 2014 Benjamin Schroedl <benjamin[at]dev-tec[dot]de>
*
* This program is free software; you can redistribute it and/or modify
* it under the terms of the GNU General Public License as published by
* the Free Software Foundation; either version 2 of the License, or
* (at your option) any later version.
*
* This program is distributed in the hope that it will be useful,
* but WITHOUT ANY WARRANTY; without even the implied warranty of
* MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
* GNU General Public License for more details.
*
* You should have received a copy of the GNU General Public License
* along with this program; if not, write to the Free Software
* Foundation, Inc., 59 Temple Place, Suite 330, Boston, MA  02111-1307  USA
*
*/

// Defining __KERNEL__ and MODULE allows us to access kernel-level code not usually available to userspace programs.
/*
#undef __KERNEL__
#define __KERNEL__

#undef MODULE
#define MODULE
*/
#include <linux/init.h>
#include <linux/module.h>
#include <linux/kallsyms.h>
#include <linux/kernel.h>
#include <linux/pfn.h>
#include <linux/proc_fs.h>
#include <linux/seq_file.h>
#include <linux/timer.h>
#include <linux/delay.h>
#include <crypto/algapi.h>
#include <asm/uaccess.h>
#include <asm/sections.h>
#include <linux/time.h>


#define DRIVER_AUTHOR    "Alexander Kleinsorge <alexander[dot]kleinsorge[at]gmx[dot]de> and Benjamin Schroedl <benjamin[at]dev-tec[dot]de>"
#define DRIVER_DESC      "checks predefined memory kernel region"
#define proc_fs_name     "ramcheck"
#define MODNAME proc_fs_name" "

#define CHECK_TIMER_MS   1000
#define BLOCK ((sizeof(long) <= 4) ? 1u << 20 : 2u << 20) /* 64bit CPU is often faster (bigger blocks at once) */
#define BLOCKS 8

MODULE_LICENSE("GPL");
MODULE_AUTHOR(DRIVER_AUTHOR);
MODULE_DESCRIPTION(DRIVER_DESC);


static void ram_check_exit(void);
static int  ram_check_init(void);
static int  ram_check_print(struct seq_file *m, void *v);
static int  ram_check_run(void);
void        ram_check_timer_callback(unsigned long data);
static int  ram_check_open(struct inode *inode, struct file *file);

static struct timer_list ram_check_timer;
struct proc_dir_entry *ram_check_proc_file;
struct file_operations proc_fops = {
	.open     = ram_check_open,
	.read     = seq_read,
	.llseek   = seq_lseek,
	.release  = single_release,
};


/* Global Variables */

static unsigned long g_RangeSize = 0;
static unsigned long g_RangeStart = 0;

static unsigned int g_TempCount = 0;
static unsigned int g_Timers = 0;
static unsigned int g_TimerActive = 0;

static unsigned long g_SumFirst = 0;
static unsigned long g_SumLast = 0;

static unsigned long g_BlockSum[BLOCKS];


/* Functions */

/* simple checksum/hash, xor is fastest (~1-6 MB/ms) */
static unsigned long calcChecksumXor(const void* ptr, const unsigned long bytes)
{
	unsigned long ret, i;
	const unsigned long long* ptr64 = (const unsigned long long*) ptr;
	const unsigned long len = bytes / sizeof(*ptr64);
	unsigned long long sum64 = 0u;

	for (i=0; i < len; i++) {
		sum64 ^= ptr64[i];
	}

	/* return 32 or 64 bit possible */
	ret = ((unsigned long) sum64) ^ ((unsigned long) (sum64>>32));

	return ret;
}

/* merge 4 to 1 byte ==> less info (security reason) */
static unsigned char shrink2byte(unsigned long u)
{
	unsigned long ret = (u) ^ (u>>8) ^ (u>>16) ^ (u>>24);
	/* (lowest) 32 bit --> 8 bit */
	return (unsigned char) ret;
}

static unsigned long long getTimeUS(void)
{
	struct timespec ts;
	ktime_get_ts( &ts );

	return (ts.tv_sec*USEC_PER_SEC) + (ts.tv_nsec/1000u);
}

// check for const range (in case of strange checksum)
static int check_range(void)
{
	unsigned long start = kallsyms_lookup_name("_text");
	unsigned long size  = kallsyms_lookup_name("__end_rodata") - start;
	int ret = 0;

	if (g_RangeSize && ((start != g_RangeStart) || (size != g_RangeSize))) {
		printk(KERN_WARNING MODNAME "error: const kernel memory address changed (%08lx + %lu K), stop!\n", start, size/1024u);
		g_RangeSize = 0; /* stop working */
		ret = -1;
	}

	return ret;
}

/* partitions to limit runtime to 1 ms (1..6 MB) */
static unsigned long check_block(unsigned long blk, unsigned long lastblk)
{
	const unsigned long offset = blk * BLOCK;
	unsigned long start = g_RangeStart + offset;
	unsigned long size = BLOCK;
	unsigned long ret;

	if (blk >= lastblk) {
		size = g_RangeSize % BLOCK;
		if (blk > lastblk) {
			return (~0u); /* should never happen */
		}
	}
	ret = calcChecksumXor((const void *) start, size);

	return ret;
}

static int ram_check_init(void)
{
	int ret;
	unsigned long start, size, end;
	unsigned long b, t, bps;

	for (b=0; b<BLOCKS; b++) {
		g_BlockSum[b] = 0u;
	}

	ram_check_proc_file = proc_create(proc_fs_name, 0, NULL, &proc_fops);

	if (ram_check_proc_file == NULL) {
		remove_proc_entry(proc_fs_name, NULL);
		printk(KERN_ALERT MODNAME "error: Could not initialize /proc/%s\n", proc_fs_name);

		return -ENOMEM;
	}

	start = kallsyms_lookup_name("_text");
	end   = kallsyms_lookup_name("__end_rodata");
	/* kallsyms_lookup_name("__end_rodata_hpage_align"); ==> Bad Address! */
	size  = (end - start);

	/* error handling on illegal size and ptr or size to big */
	if ((start == 0) || (end == 0) || (end <= start) || (size > (1000u << 20))) {
		printk(KERN_ALERT MODNAME "error: bad start or end adress [%lx + %lx]\n", start, size);

		return -EFAULT;
	}
	if ((size < (1u << 20)) || (size > (200u << 20))) {
		printk(KERN_INFO MODNAME "warning: strange const size = %lu MB\n", size>>20);
	}

	g_RangeStart = start;
	g_RangeSize  = size;

	t = (unsigned long) getTimeUS();
	for (b = 0; b <= size/BLOCK; b++) {
		g_BlockSum[b % BLOCKS] ^= check_block(b, size/BLOCK);
	}
	t = (unsigned long) getTimeUS() - t; /* ca. 1k..7k Byte/us */
	for (b = 0; b < BLOCKS; b++) {
		g_SumFirst ^= g_BlockSum[b]; /* all together */
	}

	bps = (t > 0) ? (size / t) : 0;
	printk(KERN_INFO MODNAME "init: %lu B/us, %lu kB, %d bit, (0x%02x, %u)\n",
		bps, size>>10, (int)sizeof(g_SumFirst)*8, shrink2byte(g_SumFirst), BLOCKS);

	/* TIMER init */
	setup_timer(&ram_check_timer, ram_check_timer_callback, 0);

	ret = mod_timer(&ram_check_timer, jiffies + msecs_to_jiffies(CHECK_TIMER_MS));
	if (ret) {
		printk(KERN_ALERT MODNAME "error: Failure in mod_timer\n");

		return -EFAULT;
	}
	g_TimerActive = 1;

	return 0;
}


static void ram_check_exit(void)
{
	int ret;
	g_RangeSize = 0; /* stop work */

	remove_proc_entry(proc_fs_name, NULL);
	check_range();

	for (ret = 0; (g_TimerActive > 0) && (ret < 1000/20); ret ++) {
		mdelay(20);
	}

	ret = del_timer_sync(&ram_check_timer);

	if (ret) {
		printk(KERN_WARNING MODNAME "warning: timer still in use on exit...(%d,%u)\n", ret, g_Timers);
	} else {
		printk(KERN_INFO MODNAME ": exit (%lx,%u)\n", g_SumLast, g_Timers);
	}
}

/* file handler /proc/.. */
static int ram_check_print(struct seq_file *m, void *v)
{
	int ret = 0;
	unsigned long t = 0;

	ret = check_range();
	if (ret) {
		seq_printf(m, "ERROR: const kernel memory address changed (%08lx), stop!\n", g_SumLast);

		return -1;
	}

	if (g_SumLast != 0u) {
		seq_printf(m, "ERROR: const kernel memory was earlier broken (%08lx), no check again!\n", g_SumLast);

		return -2;
	}

	if (g_TempCount <= 2) { /* max 2 calls per timer (1 sec) */
		unsigned long xor;
		g_TempCount ++;
		t = (unsigned long) getTimeUS();
		xor = calcChecksumXor((const void *) g_RangeStart, g_RangeSize);
		t = (unsigned long) getTimeUS() - t;
		xor = g_SumFirst ^ xor;
		if (xor) g_SumLast = xor; /* only write bad events */
	} else {
		g_TempCount ++;
		seq_printf(m, "warning: too much triggers (%u) for ram_check (%08lx) !\n", g_TempCount, g_SumLast);
	}

	if (!g_SumLast) {
		seq_printf(m, "const kernel memory is OK, size = %lu MB, t = %lu us (%u)\n", g_RangeSize>>20, t, g_Timers);
	} else {
		printk(KERN_EMERG MODNAME "error: const kernel memory is broken (%08lx != 0), please reboot!", g_SumLast);
		seq_printf(m, "ERROR: const kernel memory is broken (%08lx != 0), please reboot!\n", g_SumLast);
		ret = -3;
		/* !! kernel panic (ram error) !! */
	}

	return ret;
}

/* only inside timer (1 sec) */
static int ram_check_run(void)
{
	const unsigned int lastblk = (unsigned int) (g_RangeSize / BLOCK);
	const unsigned int b = g_Timers % BLOCKS;
	unsigned int  l;
	unsigned long x = 0;

	if (0 == b) {
		check_range(); /* check sometimes */
	}

	for (l = b; l <= lastblk; l += BLOCKS) {
		x ^= check_block(l, lastblk);
	}
	x ^= g_BlockSum[b];

	if (x != 0u) {
		check_range();
		g_SumLast = x;
		/* !! kernel panic (ram error) !! */
		printk(KERN_EMERG MODNAME "error: const kernel memory broken (%08lx != 0), timer(%u, %u) !", x, g_Timers, b);
	}

	return 0;
}

/* Timer Callback */
void ram_check_timer_callback(unsigned long data)
{
	int ret;

	g_Timers ++;
	if (0 == g_RangeSize) {
		g_TimerActive = 0;

		return;
	}

	if (g_SumLast != 0u) { /* failure earlier detected, skip */
		if (0 == (g_Timers % 32u)) {
			printk(KERN_WARNING MODNAME "error: const kernel memory earlier broken (%08lx), skip !\n", g_SumLast);
		}

		return;
	}

	ram_check_run();

	ret = mod_timer(&ram_check_timer, jiffies + msecs_to_jiffies(CHECK_TIMER_MS));
	if (ret) {
		printk(KERN_ALERT MODNAME "error: in mod_timer (%u, %d)\n", g_Timers, ret);
	}

	g_TimerActive = 1; /* is already set, but be safe */
	g_TempCount = 0;
}


static int ram_check_open(struct inode *inode, struct file *file)
{
	return single_open(file, ram_check_print, NULL);
}


module_init(ram_check_init);
module_exit(ram_check_exit);


--kenitramv-1a2aef1e-5c6a-4235-811d-a53169a2c63a--

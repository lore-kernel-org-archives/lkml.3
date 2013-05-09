Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753793Ab3EIUvE (ORCPT <rfc822;w@1wt.eu>);
	Thu, 9 May 2013 16:51:04 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:45046 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751419Ab3EIUvC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 9 May 2013 16:51:02 -0400
Date: Thu, 9 May 2013 13:51:00 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Robin Holt <holt@sgi.com>
Cc: "H. Peter Anvin" <hpa@zytor.com>, Russ Anderson <rja@sgi.com>,
        Russell King <linux@arm.linux.org.uk>,
        Guan Xuetao <gxt@mprc.pku.edu.cn>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        the arch/x86 maintainers <x86@kernel.org>,
        Arm Mailing List <linux-arm-kernel@lists.infradead.org>
Subject: Re: [PATCH -v9 04/11] Move shutdown/reboot related functions to
 kernel/reboot.c
Message-Id: <20130509135100.13947d1805a583703ee8488b@linux-foundation.org>
In-Reply-To: <1368127405-112717-5-git-send-email-holt@sgi.com>
References: <1368127405-112717-1-git-send-email-holt@sgi.com>
	<1368127405-112717-5-git-send-email-holt@sgi.com>
X-Mailer: Sylpheed 3.2.0beta5 (GTK+ 2.24.10; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu,  9 May 2013 14:23:18 -0500 Robin Holt <holt@sgi.com> wrote:

> This patch is preparatory.  It moves reboot related syscall, etc
> functions from kernel/sys.c to kernel/reboot.c.

This doesn't apply.

> -static void migrate_to_reboot_cpu(void)
> -{
> -	/* The boot cpu is always logical cpu 0 */
> -	int cpu = 0;
> -
> -	cpu_hotplug_disable();
> -
> -	/* Make certain the cpu I'm about to reboot on is online */
> -	if (!cpu_online(cpu))
> -		cpu = cpumask_first(cpu_online_mask);

Here it's deleting code which was already modified by "[PATCH -v9
02/11] Migrate shutdown/reboot to boot cpu.".  So patch [4/11]
generates rejects when applied on top of [patch 2/11].

There are several similar glitches.


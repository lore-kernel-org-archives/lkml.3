Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751633Ab3EBU6V (ORCPT <rfc822;w@1wt.eu>);
	Thu, 2 May 2013 16:58:21 -0400
Received: from hydra.sisk.pl ([212.160.235.94]:55551 "EHLO hydra.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750757Ab3EBU6T (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 2 May 2013 16:58:19 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Colin Cross <ccross@android.com>, Tejun Heo <tj@kernel.org>,
        Oleg Nesterov <oleg@redhat.com>
Cc: linux-pm@vger.kernel.org, linux-kernel@vger.kernel.org, arve@android.com
Subject: Re: [PATCH v2 00/10] optimize freezing tasks by reducing task wakeups
Date: Thu, 02 May 2013 23:06:35 +0200
Message-ID: <1678114.cijx7evM08@vostro.rjw.lan>
User-Agent: KMail/4.9.5 (Linux/3.9.0+; KDE/4.9.5; x86_64; ; )
In-Reply-To: <1367458508-9133-1-git-send-email-ccross@android.com>
References: <1367458508-9133-1-git-send-email-ccross@android.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="utf-8"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wednesday, May 01, 2013 06:34:58 PM Colin Cross wrote:
> On slow cpus the large number of task wakeups and context switches
> triggered by freezing and thawing tasks can take a significant amount
> of cpu time.  This patch series reduces the amount of work done during
> freezing tasks by avoiding waking up tasks that are already in a freezable
> state.
> 
> The first patch reduces the wasted time in try_to_freeze_tasks() by
> starting with a 1 ms sleep during the first loop and backing off
> up to an 8 ms sleep if all tasks are not frozen.
> 
> The second patch modifies the freeze_task() function to skip tasks
> that have set the PF_FREEZER_SKIP flag by calling freezer_do_not_count().
> These tasks will not enter the refrigerator during the suspend/resume
> cycle unless they woken up by something else, in which case they will
> enter the refrigerator in freezer_count() before they access any
> resources that would not be available in suspend or deadlock with
> another freezing/frozen task.
> 
> The rest of the series adds a few more freezable helpers and converts the
> top call sites that userspace tasks are usually blocked at to freezable
> helpers.  The list of call sites was collected on a Nexus 10 (ARM Exynos
> 5250 SoC), but all the top call sites other than binder show up at the
> top of the list on Ubuntu x86-64 as well.
> 
> This series cuts the time for freezing tasks from 50 ms to 5 ms when
> the cpu speed is locked at its lowest setting (200MHz), and reduces
> the number of context switches and restarted syscalls from 1000 to
> 25.
> 
> v2 moves the skip check to freeze_task(), and expands the commit
> messages.

The entire series makes sense to me, so are there any objections?

Tejun, Oleg??

Rafael


-- 
I speak only for myself.
Rafael J. Wysocki, Intel Open Source Technology Center.

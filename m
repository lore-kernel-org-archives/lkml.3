Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751564AbaLCSZb (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Dec 2014 13:25:31 -0500
Received: from cantor2.suse.de ([195.135.220.15]:36738 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750891AbaLCSZa (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Dec 2014 13:25:30 -0500
From: Thomas Renninger <trenn@suse.de>
To: Prarit Bhargava <prarit@redhat.com>
Cc: linux-kernel@vger.kernel.org, linux-pm@vger.kernel.org
Subject: Re: [PATCH] tools, cpupower, fix return checks for sysfs_get_idlestate_count()
Date: Wed, 03 Dec 2014 19:25:25 +0100
Message-ID: <2645048.kv31YXMmsb@skinner>
User-Agent: KMail/4.14.2 (Linux/3.16.6-2-desktop; KDE/4.14.2; x86_64; ; )
In-Reply-To: <1417444762-26450-1-git-send-email-prarit@redhat.com>
References: <1417444762-26450-1-git-send-email-prarit@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Monday, December 01, 2014 09:39:22 AM Prarit Bhargava wrote:
> Red Hat and Fedora use a bug reporting tool that gathers data about
> "broken" systems called sosreport.  Among other things, it includes the
> output of 'cpupower idle-info'.  Executing 'cpupower idle-info' on a
> system that has cpuidle disabled via 'cpuidle.off=1' results in a 300
> second hang in the cpupower application.
> 
> ie)
> [root@intel-brickland-05]# cpupower idle-info
> Could not determine cpuidle driver
> 
> Analyzing CPU 0:
> Number of idle states: -19
> [hang]
> 
> The problem is that the cpupower code only checks for a zero return from
> sysfs_get_idlestate_count().  The function can return -ENODEV (-19) as
> above.  This patch fixes callers to sysfs_get_idlestate_count() to check
> the right return values.
> 
> Cc: Thomas Renninger <trenn@suse.de>
> Cc: linux-pm@vger.kernel.org
> Signed-off-by: Prarit Bhargava <prarit@redhat.com>

Signed-off-by: Thomas Renninger <trenn@suse.de>


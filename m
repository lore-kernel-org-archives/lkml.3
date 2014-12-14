Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751623AbaLNVIn (ORCPT <rfc822;w@1wt.eu>);
	Sun, 14 Dec 2014 16:08:43 -0500
Received: from v094114.home.net.pl ([79.96.170.134]:56862 "HELO
	v094114.home.net.pl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1750986AbaLNVIg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 14 Dec 2014 16:08:36 -0500
From: "Rafael J. Wysocki" <rjw@rjwysocki.net>
To: Prarit Bhargava <prarit@redhat.com>
Cc: linux-pm@vger.kernel.org, linux-kernel@vger.kernel.org,
        Thomas Renninger <trenn@suse.de>,
        "Rafael J. Wysocki" <rafael.j.wysocki@intel.com>
Subject: Re: [PATCH 0/2] Properly fix sysfs_get_idlestate_count()
Date: Sun, 14 Dec 2014 22:30:17 +0100
Message-ID: <4068135.ExVigq9HJY@vostro.rjw.lan>
User-Agent: KMail/4.11.5 (Linux/3.16.0-rc5+; KDE/4.11.5; x86_64; ; )
In-Reply-To: <1418565998-3701-1-git-send-email-prarit@redhat.com>
References: <1418565998-3701-1-git-send-email-prarit@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="utf-8"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sunday, December 14, 2014 09:06:36 AM Prarit Bhargava wrote:
> My previous commit 16b7c275c055 ("tools: cpupower: fix return checks for
> sysfs_get_idlestate_count()") was not correct.  After looking
> at the changelog for cpupower I noticed that Thomas had changed the return of
> sysfs_get_idlestate_count() to an unsigned int to simplify the code.  The
> problem is really that both he (in his original change) and I (in my new
> change) missed the obvious that sysfs_get_idlestate_count()
> can't return -ENODEV.  It should just return 0 for "no c-states".
> 
> Patch 1 reverts my recent change and patch 2 fixes the problem correctly.
> 
> Sorry 'bout that Thomas.  I should have caught that the the first time.
> 
> Cc: Thomas Renninger <trenn@suse.de>
> Cc: Rafael J. Wysocki <rafael.j.wysocki@intel.com>
> Signed-off-by: Prarit Bhargava <prarit@redhat.com>
> 
> Prarit Bhargava (2):
>   Revert "tools: cpupower: fix return checks for
>     sysfs_get_idlestate_count()"
>   Fix no idle state information return value
> 
>  tools/power/cpupower/utils/cpuidle-info.c  |    8 ++++----
>  tools/power/cpupower/utils/helpers/sysfs.c |    2 +-
>  2 files changed, 5 insertions(+), 5 deletions(-)

I'll queue up the revert, but I need an ACK from Thomas for the second patch.


-- 
I speak only for myself.
Rafael J. Wysocki, Intel Open Source Technology Center.

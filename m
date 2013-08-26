Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757287Ab3HZQvW (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 Aug 2013 12:51:22 -0400
Received: from out01.mta.xmission.com ([166.70.13.231]:47103 "EHLO
	out01.mta.xmission.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752269Ab3HZQvV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 Aug 2013 12:51:21 -0400
From: ebiederm@xmission.com (Eric W. Biederman)
To: Djalal Harouni <tixxdz@opendz.org>
Cc: Al Viro <viro@zeniv.linux.org.uk>,
        Andrew Morton <akpm@linux-foundation.org>,
        linux-kernel@vger.kernel.org, kernel-hardening@lists.openwall.com
References: <1377534240-13227-1-git-send-email-tixxdz@opendz.org>
	<1377534240-13227-2-git-send-email-tixxdz@opendz.org>
Date: Mon, 26 Aug 2013 09:50:42 -0700
In-Reply-To: <1377534240-13227-2-git-send-email-tixxdz@opendz.org> (Djalal
	Harouni's message of "Mon, 26 Aug 2013 17:24:00 +0100")
Message-ID: <87wqn8pfa5.fsf@xmission.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/24.1 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
X-XM-AID: U2FsdGVkX1923e+nGCxgJYtQVfUgEasfVtJfmllQ65g=
X-SA-Exim-Connect-IP: 98.207.154.105
X-SA-Exim-Mail-From: ebiederm@xmission.com
X-Spam-Report: * -1.0 ALL_TRUSTED Passed through trusted hosts only via SMTP
	*  1.5 XMNoVowels Alpha-numberic number with no vowels
	*  0.7 XMSubLong Long Subject
	*  0.0 T_TM2_M_HEADER_IN_MSG BODY: T_TM2_M_HEADER_IN_MSG
	* -3.0 BAYES_00 BODY: Bayes spam probability is 0 to 1%
	*      [score: 0.0007]
	* -0.0 DCC_CHECK_NEGATIVE Not listed in DCC
	*      [sa06 1397; Body=1 Fuz1=1 Fuz2=1]
X-Spam-DCC: XMission; sa06 1397; Body=1 Fuz1=1 Fuz2=1 
X-Spam-Combo: ;Djalal Harouni <tixxdz@opendz.org>
X-Spam-Relay-Country: 
Subject: Re: [PATCH 2/2] procfs: restore 0400 permissions on /proc/*/pagemap
X-Spam-Flag: No
X-SA-Exim-Version: 4.2.1 (built Wed, 14 Nov 2012 14:26:46 -0700)
X-SA-Exim-Scanned: Yes (on in01.mta.xmission.com)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Djalal Harouni <tixxdz@opendz.org> writes:

> Do not give an fd on privileged /proc/*/pagemap files for free.

The same objections apply to this patch as it's predecessor so I won't
repeat them.

Eric

> Restore the previous 0400 mode
>
> Signed-off-by: Djalal Harouni <tixxdz@opendz.org>
> ---
>  fs/proc/base.c | 4 ++--
>  1 file changed, 2 insertions(+), 2 deletions(-)
>
> diff --git a/fs/proc/base.c b/fs/proc/base.c
> index 6b162cd..93a1c89 100644
> --- a/fs/proc/base.c
> +++ b/fs/proc/base.c
> @@ -2605,7 +2605,7 @@ static const struct pid_entry tgid_base_stuff[] = {
>  #ifdef CONFIG_PROC_PAGE_MONITOR
>  	REG("clear_refs", S_IWUSR, proc_clear_refs_operations),
>  	REG("smaps",      S_IRUGO, proc_pid_smaps_operations),
> -	REG("pagemap",    S_IRUGO, proc_pagemap_operations),
> +	REG("pagemap",    S_IRUSR, proc_pagemap_operations),
>  #endif
>  #ifdef CONFIG_SECURITY
>  	DIR("attr",       S_IRUGO|S_IXUGO, proc_attr_dir_inode_operations, proc_attr_dir_operations),
> @@ -2943,7 +2943,7 @@ static const struct pid_entry tid_base_stuff[] = {
>  #ifdef CONFIG_PROC_PAGE_MONITOR
>  	REG("clear_refs", S_IWUSR, proc_clear_refs_operations),
>  	REG("smaps",     S_IRUGO, proc_tid_smaps_operations),
> -	REG("pagemap",    S_IRUGO, proc_pagemap_operations),
> +	REG("pagemap",    S_IRUSR, proc_pagemap_operations),
>  #endif
>  #ifdef CONFIG_SECURITY
>  	DIR("attr",      S_IRUGO|S_IXUGO, proc_attr_dir_inode_operations, proc_attr_dir_operations),

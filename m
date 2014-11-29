Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751402AbaK2QRt (ORCPT <rfc822;w@1wt.eu>);
	Sat, 29 Nov 2014 11:17:49 -0500
Received: from out01.mta.xmission.com ([166.70.13.231]:36524 "EHLO
	out01.mta.xmission.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751075AbaK2QRp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 29 Nov 2014 11:17:45 -0500
From: ebiederm@xmission.com (Eric W. Biederman)
To: Andy Lutomirski <luto@amacapital.net>
Cc: Linux Containers <containers@lists.linux-foundation.org>,
        Josh Triplett <josh@joshtriplett.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Kees Cook <keescook@chromium.org>,
        Michael Kerrisk-manpages <mtk.manpages@gmail.com>,
        Linux API <linux-api@vger.kernel.org>,
        linux-man <linux-man@vger.kernel.org>,
        "linux-kernel\@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        LSM <linux-security-module@vger.kernel.org>,
        Casey Schaufler <casey@schaufler-ca.com>,
        "Serge E. Hallyn" <serge@hallyn.com>,
        Richard Weinberger <richard@nod.at>, kenton@sandstorm.io,
        stable@vger.kernel.org
References: <81ba656ffbdc62a7f7e94ad17f0238ee063fe6b3.1417214430.git.luto@amacapital.net>
Date: Sat, 29 Nov 2014 10:16:23 -0600
In-Reply-To: <81ba656ffbdc62a7f7e94ad17f0238ee063fe6b3.1417214430.git.luto@amacapital.net>
	(Andy Lutomirski's message of "Fri, 28 Nov 2014 14:53:20 -0800")
Message-ID: <87vblym17s.fsf@x220.int.ebiederm.org>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/24.3 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
X-XM-AID: U2FsdGVkX1+U7ZVGNihLOukQXrGPnSW9R4ux0ASiFN4=
X-SA-Exim-Connect-IP: 97.121.92.161
X-SA-Exim-Mail-From: ebiederm@xmission.com
X-Spam-Report: * -1.0 ALL_TRUSTED Passed through trusted hosts only via SMTP
	*  0.0 TVD_RCVD_IP Message was received from an IP address
	*  0.7 XMSubLong Long Subject
	*  0.0 T_TM2_M_HEADER_IN_MSG BODY: No description available.
	*  1.2 LotsOfNums_01 BODY: Lots of long strings of numbers
	*  0.8 BAYES_50 BODY: Bayes spam probability is 40 to 60%
	*      [score: 0.5000]
	* -0.0 DCC_CHECK_NEGATIVE Not listed in DCC
	*      [sa07 1397; Body=1 Fuz1=1 Fuz2=1]
	*  1.0 T_XMDrugObfuBody_08 obfuscated drug references
X-Spam-DCC: XMission; sa07 1397; Body=1 Fuz1=1 Fuz2=1 
X-Spam-Combo: **;Andy Lutomirski <luto@amacapital.net>
X-Spam-Relay-Country: 
X-Spam-Timing: total 936 ms - load_scoreonly_sql: 0.06 (0.0%),
	signal_user_changed: 3.9 (0.4%), b_tie_ro: 2.8 (0.3%), parse: 1.11 (0.1%),
	extract_message_metadata: 18 (1.9%), get_uri_detail_list: 3.9 (0.4%),
	tests_pri_-1000: 8 (0.9%), tests_pri_-950: 1.24 (0.1%), tests_pri_-900: 1.08
	(0.1%), tests_pri_-400: 31 (3.3%), check_bayes: 29 (3.1%), b_tokenize: 10
	(1.1%), b_tok_get_all: 10 (1.1%), b_comp_prob: 3.2 (0.3%), b_tok_touch_all:
	3.0 (0.3%), b_finish: 0.72 (0.1%), tests_pri_0: 864 (92.3%), tests_pri_500: 5
	(0.6%), rewrite_mail: 0.00 (0.0%)
Subject: Re: [RFC PATCH] userns: Disallow setgroups unless the gid_map writer is privileged
X-Spam-Flag: No
X-SA-Exim-Version: 4.2.1 (built Wed, 24 Sep 2014 11:00:52 -0600)
X-SA-Exim-Scanned: Yes (on in02.mta.xmission.com)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Andy Lutomirski <luto@amacapital.net> writes:

The patch is buggy.

Nacked-by: "Eric W. Biederman" <ebiederm@xmission.com>

> ---
>
> Eric, this is an alternative to your patch.  I think it will cause
> less breakage, and it will keep unprivileged user namespaces
> more or less fully functional.
>
> Kenton, I think that neither run-bundle nor supervisor-main will be
> broken by this patch.
>
>  include/linux/user_namespace.h |  3 +++
>  kernel/groups.c                |  3 +++
>  kernel/user.c                  |  1 +
>  kernel/user_namespace.c        | 36 ++++++++++++++++++++++++++++++++++++
>  4 files changed, 43 insertions(+)
>
> diff --git a/include/linux/user_namespace.h b/include/linux/user_namespace.h
> index e95372654f09..a74c1f3d44fe 100644
> --- a/include/linux/user_namespace.h
> +++ b/include/linux/user_namespace.h
> @@ -17,6 +17,8 @@ struct uid_gid_map {	/* 64 bytes -- 1 cache line */
>  	} extent[UID_GID_MAP_MAX_EXTENTS];
>  };
>  
> +#define USERNS_SETGROUPS_ALLOWED 1
> +
>  struct user_namespace {
>  	struct uid_gid_map	uid_map;
>  	struct uid_gid_map	gid_map;
> @@ -27,6 +29,7 @@ struct user_namespace {
>  	kuid_t			owner;
>  	kgid_t			group;
>  	unsigned int		proc_inum;
> +	unsigned int		flags;

If you are going to add a flags field it needs to be atomic as otherwise
changing or reading individual flags won't be safe without a lock.

>  	/* Register of per-UID persistent keyrings for this namespace */
>  #ifdef CONFIG_PERSISTENT_KEYRINGS
> diff --git a/kernel/groups.c b/kernel/groups.c
> index 451698f86cfa..e27433809978 100644
> --- a/kernel/groups.c
> +++ b/kernel/groups.c
> @@ -6,6 +6,7 @@
>  #include <linux/slab.h>
>  #include <linux/security.h>
>  #include <linux/syscalls.h>
> +#include <linux/user_namespace.h>
>  #include <asm/uaccess.h>
>  
>  /* init to 2 - one for init_task, one to ensure it is never freed */
> @@ -223,6 +224,8 @@ SYSCALL_DEFINE2(setgroups, int, gidsetsize, gid_t __user *, grouplist)
>  	struct group_info *group_info;
>  	int retval;
>  
> +	if (!(current_user_ns()->flags & USERNS_SETGROUPS_ALLOWED))
> +		return -EPERM;
>  	if (!ns_capable(current_user_ns(), CAP_SETGID))
>  		return -EPERM;
>  	if ((unsigned)gidsetsize > NGROUPS_MAX)
> diff --git a/kernel/user.c b/kernel/user.c
> index 4efa39350e44..f8cdb1ec6049 100644
> --- a/kernel/user.c
> +++ b/kernel/user.c
> @@ -51,6 +51,7 @@ struct user_namespace init_user_ns = {
>  	.owner = GLOBAL_ROOT_UID,
>  	.group = GLOBAL_ROOT_GID,
>  	.proc_inum = PROC_USER_INIT_INO,
> +	.flags = USERNS_SETGROUPS_ALLOWED,
>  #ifdef CONFIG_PERSISTENT_KEYRINGS
>  	.persistent_keyring_register_sem =
>  	__RWSEM_INITIALIZER(init_user_ns.persistent_keyring_register_sem),
> diff --git a/kernel/user_namespace.c b/kernel/user_namespace.c
> index aa312b0dc3ec..6e7b9ee5bddc 100644
> --- a/kernel/user_namespace.c
> +++ b/kernel/user_namespace.c
> @@ -600,6 +600,8 @@ static ssize_t map_write(struct file *file, const char __user *buf,
>  	unsigned long page = 0;
>  	char *kbuf, *pos, *next_line;
>  	ssize_t ret = -EINVAL;
> +	unsigned int gid_flags = 0;
> +	bool seen_explicit_gid_flag = false;
>  
>  	/*
>  	 * The id_map_mutex serializes all writes to any given map.
> @@ -633,6 +635,19 @@ static ssize_t map_write(struct file *file, const char __user *buf,
>  	if (cap_valid(cap_setid) && !file_ns_capable(file, ns, CAP_SYS_ADMIN))
>  		goto out;
>  
> +	/* Deal with supplementary groups. */
> +	if (map == &ns->gid_map) {
> +		/*
> +		 * By default, setgroups is allowed inside the userns
> +		 * if the writer has no supplementary groups (making
> +		 * it useless) or if the writer is privileged.
> +		 */
> +		if ((ns->parent->flags & USERNS_SETGROUPS_ALLOWED) &&
> +		    file_ns_capable(file, ns->parent, CAP_SETGID) &&
> +		    ns_capable(ns->parent, CAP_SETGID))
> +			gid_flags = USERNS_SETGROUPS_ALLOWED;

We can't do this.

It is wrong to mix permissions and flags to request functionality.

That way lies madness, and impossible maintenance, and it will silently
break every application that expects setgroups to work if they have
CAP_SETGID after a mapping has been established.

> +	}
> +
>  	/* Get a buffer */
>  	ret = -ENOMEM;
>  	page = __get_free_page(GFP_TEMPORARY);
> @@ -667,6 +682,25 @@ static ssize_t map_write(struct file *file, const char __user *buf,
>  				next_line = NULL;
>  		}
>  
> +		/* Is this line a gid_map option? */
> +		if (map == &ns->gid_map) {
> +			if (!strcmp(pos, "setgroups deny")) {
> +				if (seen_explicit_gid_flag)
> +					goto out;
> +				seen_explicit_gid_flag = 1;
> +				gid_flags = 0;
> +				continue;
> +			} else if (!strcmp(pos, "setgroups allow")) {
> +				if (seen_explicit_gid_flag)
> +					goto out;
> +				if (!(gid_flags & USERNS_SETGROUPS_ALLOWED)) {
> +					ret = -EPERM;
> +					goto out;
> +				}
> +				continue;
> +			}
> +		}
> +
>  		pos = skip_spaces(pos);
>  		extent->first = simple_strtoul(pos, &pos, 10);
>  		if (!isspace(*pos))
> @@ -746,6 +780,8 @@ static ssize_t map_write(struct file *file, const char __user *buf,
>  		new_map.nr_extents*sizeof(new_map.extent[0]));
>  	smp_wmb();
>  	map->nr_extents = new_map.nr_extents;
> +	if (map == &ns->gid_map)
> +		ns->flags |= gid_flags;
>  
>  	*ppos = count;
>  	ret = count;

Eric

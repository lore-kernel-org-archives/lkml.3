Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758520Ab3DXXsU (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Apr 2013 19:48:20 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:34816 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757971Ab3DXXsT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Apr 2013 19:48:19 -0400
Date: Wed, 24 Apr 2013 18:48:13 -0500
From: Serge Hallyn <serge.hallyn@ubuntu.com>
To: =?iso-8859-1?Q?St=E9phane?= Graber <stgraber@ubuntu.com>
Cc: linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org,
        Alexander Viro <viro@zeniv.linux.org.uk>,
        "Eric W. Biederman" <ebiederm@xmission.com>,
        Serge Hallyn <serge.hallyn@canonical.com>
Subject: Re: [PATCH] coredump: Add new %P variable in core_pattern
Message-ID: <20130424234813.GB27325@sergelap>
References: <1366845347-4532-1-git-send-email-stgraber@ubuntu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <1366845347-4532-1-git-send-email-stgraber@ubuntu.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Quoting Stéphane Graber (stgraber@ubuntu.com):
> This adds a new %P variable to be used in core_pattern. This variable contains
> the global PID (PID in the init namespace) as %p contains the PID in the
> current namespace which isn't always what we want.
> 
> The main use for this is to make it easier to handle crashes that happened
> within a container. With that new variables it's possible to have the crashes
> dumped into the container or forwarded to the host with the right PID
> (from the host's point of view).
> 
> Reported-by: Hans Feldt <hans.feldt@ericsson.com>
> Cc: Alexander Viro <viro@zeniv.linux.org.uk>
> Cc: Eric W. Biederman <ebiederm@xmission.com>
> Cc: Serge Hallyn <serge.hallyn@canonical.com>

Thanks, Stéphane.

Acked-by: Serge E. Hallyn <serge.hallyn@ubuntu.com>

> Signed-off-by: Stéphane Graber <stgraber@ubuntu.com>
> ---
>  Documentation/sysctl/kernel.txt | 1 +
>  fs/coredump.c                   | 5 +++++
>  2 files changed, 6 insertions(+)
> 
> diff --git a/Documentation/sysctl/kernel.txt b/Documentation/sysctl/kernel.txt
> index ccd4258..833026d 100644
> --- a/Documentation/sysctl/kernel.txt
> +++ b/Documentation/sysctl/kernel.txt
> @@ -182,6 +182,7 @@ core_pattern is used to specify a core dumpfile pattern name.
>  	%<NUL>	'%' is dropped
>  	%%	output one '%'
>  	%p	pid
> +	%P	global pid (init PID namespace)
>  	%u	uid
>  	%g	gid
>  	%d	dump mode, matches PR_SET_DUMPABLE and
> diff --git a/fs/coredump.c b/fs/coredump.c
> index c647965..528c6fc 100644
> --- a/fs/coredump.c
> +++ b/fs/coredump.c
> @@ -186,6 +186,11 @@ static int format_corename(struct core_name *cn, struct coredump_params *cprm)
>  				err = cn_printf(cn, "%d",
>  					      task_tgid_vnr(current));
>  				break;
> +			/* global pid */
> +			case 'P':
> +				err = cn_printf(cn, "%d",
> +					      task_tgid_nr(current));
> +				break;
>  			/* uid */
>  			case 'u':
>  				err = cn_printf(cn, "%d", cred->uid);
> -- 
> 1.8.1.2
> 

Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752567Ab3H0BCT (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 Aug 2013 21:02:19 -0400
Received: from out01.mta.xmission.com ([166.70.13.231]:53122 "EHLO
	out01.mta.xmission.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751522Ab3H0BCR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 Aug 2013 21:02:17 -0400
From: ebiederm@xmission.com (Eric W. Biederman)
To: Andy Lutomirski <luto@amacapital.net>
Cc: security@kernel.org, linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
        stable@vger.kernel.org
References: <cover.1377196394.git.luto@amacapital.net>
	<cover.1377196394.git.luto@amacapital.net>
	<ff9dd301d8c91ec02362d52494b4a640f370bc68.1377196394.git.luto@amacapital.net>
Date: Mon, 26 Aug 2013 18:02:09 -0700
In-Reply-To: <ff9dd301d8c91ec02362d52494b4a640f370bc68.1377196394.git.luto@amacapital.net>
	(Andy Lutomirski's message of "Thu, 22 Aug 2013 11:39:15 -0700")
Message-ID: <8738pwndym.fsf@xmission.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/24.1 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
X-XM-AID: U2FsdGVkX19Nn00hGSSkaJRQQo1WtecVqdNEgzaj1cY=
X-SA-Exim-Connect-IP: 98.207.154.105
X-SA-Exim-Mail-From: ebiederm@xmission.com
X-Spam-Report: * -1.0 ALL_TRUSTED Passed through trusted hosts only via SMTP
	*  1.5 XMNoVowels Alpha-numberic number with no vowels
	*  0.7 XMSubLong Long Subject
	*  0.0 T_TM2_M_HEADER_IN_MSG BODY: T_TM2_M_HEADER_IN_MSG
	* -0.0 BAYES_20 BODY: Bayes spam probability is 5 to 20%
	*      [score: 0.0941]
	* -0.0 DCC_CHECK_NEGATIVE Not listed in DCC
	*      [sa07 1397; Body=1 Fuz1=1 Fuz2=1]
	*  0.0 T_TooManySym_01 4+ unique symbols in subject
X-Spam-DCC: XMission; sa07 1397; Body=1 Fuz1=1 Fuz2=1 
X-Spam-Combo: *;Andy Lutomirski <luto@amacapital.net>
X-Spam-Relay-Country: 
Subject: Re: [PATCH 1/2] net: Check the correct namespace when spoofing pid over SCM_RIGHTS
X-Spam-Flag: No
X-SA-Exim-Version: 4.2.1 (built Wed, 14 Nov 2012 14:26:46 -0700)
X-SA-Exim-Scanned: Yes (on in01.mta.xmission.com)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Andy Lutomirski <luto@amacapital.net> writes:

> This is a security bug.
>
> The follow-up will fix nsproxy to discourage this type of issue from
> happening again.

Reviewed-by: "Eric W. Biederman" <ebiederm@xmission.com>
>
> Cc: stable@vger.kernel.org
> Signed-off-by: Andy Lutomirski <luto@amacapital.net>
> ---
>  net/core/scm.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
>
> diff --git a/net/core/scm.c b/net/core/scm.c
> index 03795d0..b4da80b 100644
> --- a/net/core/scm.c
> +++ b/net/core/scm.c
> @@ -54,7 +54,7 @@ static __inline__ int scm_check_creds(struct ucred *creds)
>  		return -EINVAL;
>  
>  	if ((creds->pid == task_tgid_vnr(current) ||
> -	     ns_capable(current->nsproxy->pid_ns->user_ns, CAP_SYS_ADMIN)) &&
> +	     ns_capable(task_active_pid_ns(current)->user_ns, CAP_SYS_ADMIN)) &&
>  	    ((uid_eq(uid, cred->uid)   || uid_eq(uid, cred->euid) ||
>  	      uid_eq(uid, cred->suid)) || nsown_capable(CAP_SETUID)) &&
>  	    ((gid_eq(gid, cred->gid)   || gid_eq(gid, cred->egid) ||

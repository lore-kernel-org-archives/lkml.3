Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755454AbaDKVuU (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 Apr 2014 17:50:20 -0400
Received: from smtp103.biz.mail.ne1.yahoo.com ([98.138.207.10]:26381 "HELO
	smtp103.biz.mail.ne1.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1755336AbaDKVuS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 Apr 2014 17:50:18 -0400
X-Greylist: delayed 320 seconds by postgrey-1.27 at vger.kernel.org; Fri, 11 Apr 2014 17:50:18 EDT
X-Yahoo-Newman-Property: ymail-3
X-YMail-OSG: xL.4QTIVM1kjc9oXgDw8lyiTRcS9SgPhdR1oEwJgoeF01XH
 H4PcE4am4d0rrlWo20vEnWnHJm6gg.gnHvmcP6WazOskWe6fEvvqV9nPDKgJ
 61iUq0FeF29Gzr8j.qoV5w4CKWXqC6Yj5kHeMOLONdhXgWBUL4KA3zlI1H4s
 qTOym4km65ZKudQbP07uxQMD4GhJnI5DCMVU9Kapnl4n0ec92yjHnzdRCVLa
 0huff7X7jqiXEL51rqC7apCBCT8RIPWzwDDLQnkFdOAIFirayZBQApUzkIOL
 Q8VF2J3jIGv5Pz5xF1XNFmkcftIgkjEV8DsEXwCz2jluwlp0w8ypX4xIqEUX
 4Fe1InyUvCtHiK3Uil_.us6tt7W6vPf4F_IGnzAHP7sFRBlzTxURF9jeqQnx
 hrdC.GFiW_1uFZPHfqKr1No39Gqv1qtCuqyMsTb5iV.GtF6g8u.5N2XcUMmB
 75GdAc88.9ofseS7OsDPxYBOH2900aOUp9nYNwj4qiaBZvEm1EdM1x5Gbd5N
 tzRTr3RVzz7WBR8QvDgr6OOtzSBdPmEjeOrbv7RLI.QnIGYLcQr4PG7wJc0a
 HVmAzIY_0bElpzbhV.ihg44HowmC_p0pJ2I6pdlOEyxE1c2US56YKZEWqERS
 6LXNHH0XKrg--
X-Yahoo-SMTP: OIJXglSswBDfgLtXluJ6wiAYv6_cnw--
X-Rocket-Received: from [192.168.0.105] (casey@67.180.103.242 with plain [98.138.105.25])
        by smtp103.biz.mail.ne1.yahoo.com with SMTP; 11 Apr 2014 14:50:17 -0700 PDT
Message-ID: <534863B2.4090506@schaufler-ca.com>
Date: Fri, 11 Apr 2014 14:50:42 -0700
From: Casey Schaufler <casey@schaufler-ca.com>
User-Agent: Mozilla/5.0 (Windows NT 6.1; WOW64; rv:24.0) Gecko/20100101 Thunderbird/24.4.0
MIME-Version: 1.0
To: Lukasz Pawelczyk <l.pawelczyk@partner.samsung.com>,
        James Morris <james.l.morris@oracle.com>,
        linux-security-module@vger.kernel.org, linux-kernel@vger.kernel.org
CC: r.krypa@samsung.com, t.swierczek@samsung.com
Subject: Re: [PATCH 1/3] Smack: fix the subject/object order in smack_ptrace_traceme()
References: <1394554026-23924-1-git-send-email-l.pawelczyk@partner.samsung.com> <1394554026-23924-2-git-send-email-l.pawelczyk@partner.samsung.com>
In-Reply-To: <1394554026-23924-2-git-send-email-l.pawelczyk@partner.samsung.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 3/11/2014 9:07 AM, Lukasz Pawelczyk wrote:
> The order of subject/object is currently reversed in
> smack_ptrace_traceme(). It is currently checked if the tracee has a
> capability to trace tracer and according to this rule a decision is made
> whether the tracer will be allowed to trace tracee.
>
> Signed-off-by: Lukasz Pawelczyk <l.pawelczyk@partner.samsung.com>
> Signed-off-by: Rafal Krypa <r.krypa@samsung.com>

Acked-by: Casey Schaufler <casey@schaufler-ca.com>

Applied to git://git.gitorious.org/smack-next/kernel.git smack-for-3.16

> ---
>  security/smack/smack.h        |  1 +
>  security/smack/smack_access.c | 33 ++++++++++++++++++++++++++-------
>  security/smack/smack_lsm.c    |  4 ++--
>  3 files changed, 29 insertions(+), 9 deletions(-)
>
> diff --git a/security/smack/smack.h b/security/smack/smack.h
> index d072fd3..b9dfc4e 100644
> --- a/security/smack/smack.h
> +++ b/security/smack/smack.h
> @@ -225,6 +225,7 @@ struct inode_smack *new_inode_smack(char *);
>   */
>  int smk_access_entry(char *, char *, struct list_head *);
>  int smk_access(struct smack_known *, char *, int, struct smk_audit_info *);
> +int smk_tskacc(struct task_smack *, char *, u32, struct smk_audit_info *);
>  int smk_curacc(char *, u32, struct smk_audit_info *);
>  struct smack_known *smack_from_secid(const u32);
>  char *smk_parse_smack(const char *string, int len);
> diff --git a/security/smack/smack_access.c b/security/smack/smack_access.c
> index 14293cd..f161deb 100644
> --- a/security/smack/smack_access.c
> +++ b/security/smack/smack_access.c
> @@ -192,20 +192,21 @@ out_audit:
>  }
>  
>  /**
> - * smk_curacc - determine if current has a specific access to an object
> + * smk_tskacc - determine if a task has a specific access to an object
> + * @tsp: a pointer to the subject task
>   * @obj_label: a pointer to the object's Smack label
>   * @mode: the access requested, in "MAY" format
>   * @a : common audit data
>   *
> - * This function checks the current subject label/object label pair
> + * This function checks the subject task's label/object label pair
>   * in the access rule list and returns 0 if the access is permitted,
> - * non zero otherwise. It allows that current may have the capability
> + * non zero otherwise. It allows that the task may have the capability
>   * to override the rules.
>   */
> -int smk_curacc(char *obj_label, u32 mode, struct smk_audit_info *a)
> +int smk_tskacc(struct task_smack *subject, char *obj_label,
> +	       u32 mode, struct smk_audit_info *a)
>  {
> -	struct task_smack *tsp = current_security();
> -	struct smack_known *skp = smk_of_task(tsp);
> +	struct smack_known *skp = smk_of_task(subject);
>  	int may;
>  	int rc;
>  
> @@ -219,7 +220,7 @@ int smk_curacc(char *obj_label, u32 mode, struct smk_audit_info *a)
>  		 * it can further restrict access.
>  		 */
>  		may = smk_access_entry(skp->smk_known, obj_label,
> -					&tsp->smk_rules);
> +					&subject->smk_rules);
>  		if (may < 0)
>  			goto out_audit;
>  		if ((mode & may) == mode)
> @@ -241,6 +242,24 @@ out_audit:
>  	return rc;
>  }
>  
> +/**
> + * smk_curacc - determine if current has a specific access to an object
> + * @obj_label: a pointer to the object's Smack label
> + * @mode: the access requested, in "MAY" format
> + * @a : common audit data
> + *
> + * This function checks the current subject label/object label pair
> + * in the access rule list and returns 0 if the access is permitted,
> + * non zero otherwise. It allows that current may have the capability
> + * to override the rules.
> + */
> +int smk_curacc(char *obj_label, u32 mode, struct smk_audit_info *a)
> +{
> +	struct task_smack *tsp = current_security();
> +
> +	return smk_tskacc(tsp, obj_label, mode, a);
> +}
> +
>  #ifdef CONFIG_AUDIT
>  /**
>   * smack_str_from_perm : helper to transalate an int to a
> diff --git a/security/smack/smack_lsm.c b/security/smack/smack_lsm.c
> index d814e35..48d61f6 100644
> --- a/security/smack/smack_lsm.c
> +++ b/security/smack/smack_lsm.c
> @@ -207,11 +207,11 @@ static int smack_ptrace_traceme(struct task_struct *ptp)
>  	if (rc != 0)
>  		return rc;
>  
> -	skp = smk_of_task(task_security(ptp));
> +	skp = smk_of_task(current_security());
>  	smk_ad_init(&ad, __func__, LSM_AUDIT_DATA_TASK);
>  	smk_ad_setfield_u_tsk(&ad, ptp);
>  
> -	rc = smk_curacc(skp->smk_known, MAY_READWRITE, &ad);
> +	rc = smk_tskacc(ptp, skp->smk_known, MAY_READWRITE, &ad);
>  	return rc;
>  }
>  


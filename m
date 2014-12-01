Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754078AbaLAVdO (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Dec 2014 16:33:14 -0500
Received: from smtp107.biz.mail.bf1.yahoo.com ([98.139.244.55]:22654 "EHLO
	smtp107.biz.mail.bf1.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S932428AbaLAVdL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Dec 2014 16:33:11 -0500
X-Yahoo-Newman-Property: ymail-3
X-YMail-OSG: lCGOzbgVM1mJgeHXIbANlw_5BXPueOFsy3A.2nH0qIYiEhV
 UWBemjjyJPl7ZJWZuoV31QPkuy1B_FPr10TMVv39VzUhh5qjrejblqQOr3zL
 jOBSfknCB246oBxuzBzfAArADW1l55HDk_VPuCwN0EExo0MbTrVfz48lTw4G
 JDMlX9RkIpEjDAg.1.K0ZiZw3PiEmMx24QalPEpiJi.JbCDOvKsCgjWLi_T6
 DxSaLgkvuTuT4MV0onOAbdayW.KmXdcH738xK0LMhIrFe2QUV.YKj4dhTORs
 z0nMsbYylUpryvH.Uevo2iEup6GmMc8TyOjANMJcLC85Fxb_jOaJ9GqPg5ZP
 1qU_.UZjmHeDuwZyZZwHzb34jZAIwxQhvqyUtbNJa.zx4HmVFquwx5TnYQF4
 daGRgc6DBn5LlXZz9Gu34VLGdq_YdGuDxkx8bJOZWjwq2BtSEYDLjP8xUSsi
 aRgU8ndx.uduzAqLZHxWuuNCML9eNMcIoSrRIMhC_Br9akB0pd3yY.LvpclQ
 ..ErZFUQ36ER2UshQAa_3MT2nHo1RD.dPAHR9YRYx4YOJD4X4Mk4nbbS3fCh
 ssAR4Yhmfbrn3.XSYqyI3x2TW5bFF8hmO3enzkZkG0zs9uThMKIaZIUFLSzi
 smb3wfw--
X-Yahoo-SMTP: OIJXglSswBDfgLtXluJ6wiAYv6_cnw--
Message-ID: <547CDE94.303@schaufler-ca.com>
Date: Mon, 01 Dec 2014 13:33:08 -0800
From: Casey Schaufler <casey@schaufler-ca.com>
User-Agent: Mozilla/5.0 (Windows NT 6.1; WOW64; rv:24.0) Gecko/20100101 Thunderbird/24.6.0
MIME-Version: 1.0
To: Lukasz Pawelczyk <l.pawelczyk@samsung.com>,
        James Morris <james.l.morris@oracle.com>,
        "Serge E. Hallyn" <serge@hallyn.com>,
        linux-security-module@vger.kernel.org, linux-kernel@vger.kernel.org
CC: Lukasz Pawelczyk <havner@gmail.com>
Subject: Re: [PATCH 1/2] smack: miscellaneous small fixes in function comments
References: <1417012267-21298-1-git-send-email-l.pawelczyk@samsung.com>
In-Reply-To: <1417012267-21298-1-git-send-email-l.pawelczyk@samsung.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 11/26/2014 6:31 AM, Lukasz Pawelczyk wrote:
> Signed-off-by: Lukasz Pawelczyk <l.pawelczyk@samsung.com>

Applied to git://git.gitorious.org/smack-next/kernel.git#smack-for-3.20

> ---
>  security/smack/smack_lsm.c | 14 +++++++++-----
>  1 file changed, 9 insertions(+), 5 deletions(-)
>
> diff --git a/security/smack/smack_lsm.c b/security/smack/smack_lsm.c
> index 2717cdd..d1b14d5 100644
> --- a/security/smack/smack_lsm.c
> +++ b/security/smack/smack_lsm.c
> @@ -202,6 +202,7 @@ static int smk_bu_credfile(const struct cred *cred, struct file *file,
>  
>  /**
>   * smk_fetch - Fetch the smack label from a file.
> + * @name: type of the label (attribute)
>   * @ip: a pointer to the inode
>   * @dp: a pointer to the dentry
>   *
> @@ -254,7 +255,9 @@ struct inode_smack *new_inode_smack(struct smack_known *skp)
>  
>  /**
>   * new_task_smack - allocate a task security blob
> - * @smack: a pointer to the Smack label to use in the blob
> + * @task: a pointer to the Smack label for the running task
> + * @forked: a pointer to the Smack label for the forked task
> + * @gfp: type of the memory for the allocation
>   *
>   * Returns the new blob or NULL if there's no memory available
>   */
> @@ -277,8 +280,9 @@ static struct task_smack *new_task_smack(struct smack_known *task,
>  
>  /**
>   * smk_copy_rules - copy a rule set
> - * @nhead - new rules header pointer
> - * @ohead - old rules header pointer
> + * @nhead: new rules header pointer
> + * @ohead: old rules header pointer
> + * @gfp: type of the memory for the allocation
>   *
>   * Returns 0 on success, -ENOMEM on error
>   */
> @@ -3835,11 +3839,11 @@ static void smack_key_free(struct key *key)
>  	key->security = NULL;
>  }
>  
> -/*
> +/**
>   * smack_key_permission - Smack access on a key
>   * @key_ref: gets to the object
>   * @cred: the credentials to use
> - * @perm: unused
> + * @perm: requested key permissions
>   *
>   * Return 0 if the task has read and write to the object,
>   * an error code otherwise


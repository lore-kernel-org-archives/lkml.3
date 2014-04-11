Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755599AbaDKVvi (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 Apr 2014 17:51:38 -0400
Received: from smtp107.biz.mail.ne1.yahoo.com ([98.138.207.14]:27509 "HELO
	smtp107.biz.mail.ne1.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1754687AbaDKVvg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 Apr 2014 17:51:36 -0400
X-Yahoo-Newman-Property: ymail-3
X-YMail-OSG: OabP148VM1mZDuuV.8OKC7WqnMr_vqQrGjvTgB.sSOdv7EP
 zqecN1iR2KxrQNhC4chQPN.KOBjU5vMLBNrR29ckgos8eff.Co2FOtDzT_Qs
 dBjgEtOyP3arqhlXg1jnwn.GtJLUD8fVLf2_Nrwqn3QLv0Ph0HsdBOsuUDT1
 LCbuDsF7LwBtIl7EdIOlETwv6XnMYjtV7R6j6tNF8tKv1_H9rHljVGmKNuuC
 4yhBzJm_e1Sow_WKej_OKU.nnTEoteyZlr3kPxt8j7CqG1IA_gooUGS90gFM
 LCsQyVzUQ5oymgCMC9rGwwmEmqCIAJIWrfTptQyRErjajPkukukI4SBCrKxB
 hCwmi1LeU6DE6SHo3xJzIJRxRbyvD2UvF7ceLhyKdIfO2u.Sc9eMUNL5s7kq
 AlUq3JUd8imih7SJmbyb8.HFoAEk52axdZ87Icvjuzw4sc4JiqLWHp7sqxl3
 s_Cr.t9_v0osvv_5W68wnwpHVKwk4ZP2JR4GS_Oc9ojQ5cSfIGlbpKDP534D
 9963in5s86A9YPU9.AtjjXRcpGnaknjbf.GCXWQNOi3cOfGU6aN0fYPf2l9E
 CpCZKoyMVg1_r_9nwfrAC5JuGL3S8Ve79OSVjsKytd0uIt18eEqLB6NyDzaK
 CRKUikmHR1Q--
X-Yahoo-SMTP: OIJXglSswBDfgLtXluJ6wiAYv6_cnw--
X-Rocket-Received: from [192.168.0.105] (casey@67.180.103.242 with plain [98.138.105.25])
        by smtp107.biz.mail.ne1.yahoo.com with SMTP; 11 Apr 2014 14:44:56 -0700 PDT
Message-ID: <53486272.6020901@schaufler-ca.com>
Date: Fri, 11 Apr 2014 14:45:22 -0700
From: Casey Schaufler <casey@schaufler-ca.com>
User-Agent: Mozilla/5.0 (Windows NT 6.1; WOW64; rv:24.0) Gecko/20100101 Thunderbird/24.4.0
MIME-Version: 1.0
To: Pankaj Kumar <pankaj13lvs3@gmail.com>, linux-kernel@vger.kernel.org,
        linux-security-module@vger.kernel.org
CC: pankaj.k2@samsung.com
Subject: Re: [PATCH] smack lsm bug fixes
References: <CABPv_jf7Sy26C=LUzFkYyDSFrvtk05Snv-PQJEu2fpm5dhJWrQ@mail.gmail.com>
In-Reply-To: <CABPv_jf7Sy26C=LUzFkYyDSFrvtk05Snv-PQJEu2fpm5dhJWrQ@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 2/20/2014 2:15 AM, Pankaj Kumar wrote:
> From: Pankaj Kumar <pankaj.k2@samsung.com>
>
> 1. In order to remove any SMACK extended attribute from a file, a user
> should have CAP_MAC_ADMIN capability. But any user without this
> capability is able to remove SMACK64MMAP security attribute. This error
> has been corrected by a modification in smack_inode_removexattr hook.
>
> 2. While setting extended attribute in smack_inode_setsecurity hook,
> '-EACCES' error is returned if extended attribute size or value is not
> correct. This is wrong error rather this is invalid extended attribute
> case. Corrected error '-EINVAL' shall be returned.
>
> Signed-off-by: Pankaj Kumar <pankaj.k2@samsung.com>
> Signed-off-by: Himanshu Shukla <himanshu.sh@samsung.com>

Acked-by: Casey Schaufler <casey@schaufler-ca.com>

Applied to git://git.gitorious.org/smack-next/kernel.git smack-for-3.16

> ---
>  security/smack/smack_lsm.c | 4 ++--
>  1 file changed, 2 insertions(+), 2 deletions(-)
>
> diff --git a/security/smack/smack_lsm.c b/security/smack/smack_lsm.c
> index 14f52be..e1b1650 100644
> --- a/security/smack/smack_lsm.c
> +++ b/security/smack/smack_lsm.c
> @@ -938,7 +938,7 @@ static int smack_inode_removexattr(struct dentry
> *dentry, const char *name)
>          strcmp(name, XATTR_NAME_SMACKIPOUT) == 0 ||
>          strcmp(name, XATTR_NAME_SMACKEXEC) == 0 ||
>          strcmp(name, XATTR_NAME_SMACKTRANSMUTE) == 0 ||
> -        strcmp(name, XATTR_NAME_SMACKMMAP)) {
> +        strcmp(name, XATTR_NAME_SMACKMMAP) == 0) {
>          if (!smack_privileged(CAP_MAC_ADMIN))
>              rc = -EPERM;
>      } else
> @@ -2076,7 +2076,7 @@ static int smack_inode_setsecurity(struct inode
> *inode, const char *name,
>      int rc = 0;
>
>      if (value == NULL || size > SMK_LONGLABEL || size == 0)
> -        return -EACCES;
> +        return -EINVAL;
>
>      skp = smk_import_entry(value, size);
>      if (skp == NULL)


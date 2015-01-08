Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756776AbbAHNxt (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 Jan 2015 08:53:49 -0500
Received: from mail-oi0-f45.google.com ([209.85.218.45]:57661 "EHLO
	mail-oi0-f45.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754305AbbAHNxr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 Jan 2015 08:53:47 -0500
MIME-Version: 1.0
In-Reply-To: <1420663980-20842-9-git-send-email-zohar@linux.vnet.ibm.com>
References: <1420663980-20842-1-git-send-email-zohar@linux.vnet.ibm.com>
	<1420663980-20842-9-git-send-email-zohar@linux.vnet.ibm.com>
Date: Thu, 8 Jan 2015 08:53:46 -0500
X-Google-Sender-Auth: F9CcC9OJ4UiC0iU59ZEQmJsW4PM
Message-ID: <CA+5PVA7QiaLpiH+7oWQ5Uu8Z30mPczou89_9ga1CnW6c+_cQWQ@mail.gmail.com>
Subject: Re: [RFC][PATCH 8/9] ima: include tmpfs in ima_appraise_tcb policy
From: Josh Boyer <jwboyer@fedoraproject.org>
To: Mimi Zohar <zohar@linux.vnet.ibm.com>
Cc: initramfs <initramfs@vger.kernel.org>, Al Viro <viro@zeniv.linux.org.uk>,
        linux-ima-devel@lists.sourceforge.net,
        linux-security-module <linux-security-module@vger.kernel.org>,
        linux-kernel <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jan 7, 2015 at 3:52 PM, Mimi Zohar <zohar@linux.vnet.ibm.com> wrote:
> Now that the rootfs includes extended attributes, don't
> automatically exclude tmpfs file systems from being appraised.
>
> Signed-off-by: Mimi Zohar <zohar@linux.vnet.ibm.com>
> ---
>  security/integrity/evm/evm_main.c   | 1 +
>  security/integrity/ima/ima_policy.c | 2 ++
>  2 files changed, 3 insertions(+)
>
> diff --git a/security/integrity/evm/evm_main.c b/security/integrity/evm/evm_main.c
> index 9c71af7..e942e63 100644
> --- a/security/integrity/evm/evm_main.c
> +++ b/security/integrity/evm/evm_main.c
> @@ -19,6 +19,7 @@
>  #include <linux/module.h>
>  #include <linux/crypto.h>
>  #include <linux/audit.h>
> +#include <linux/magic.h>
>  #include <linux/xattr.h>
>  #include <linux/integrity.h>
>  #include <linux/evm.h>
> diff --git a/security/integrity/ima/ima_policy.c b/security/integrity/ima/ima_policy.c
> index d1eefb9..7267eac 100644
> --- a/security/integrity/ima/ima_policy.c
> +++ b/security/integrity/ima/ima_policy.c
> @@ -93,7 +93,9 @@ static struct ima_rule_entry default_appraise_rules[] = {
>         {.action = DONT_APPRAISE, .fsmagic = PROC_SUPER_MAGIC, .flags = IMA_FSMAGIC},
>         {.action = DONT_APPRAISE, .fsmagic = SYSFS_MAGIC, .flags = IMA_FSMAGIC},
>         {.action = DONT_APPRAISE, .fsmagic = DEBUGFS_MAGIC, .flags = IMA_FSMAGIC},
> +#ifndef CONFIG_IMA_LOAD_X509
>         {.action = DONT_APPRAISE, .fsmagic = TMPFS_MAGIC, .flags = IMA_FSMAGIC},
> +#endif

The commit log makes it sound like tmpfs should be appraised
unconditionally, but you only have it being appraised if IMA_LOAD_X509
is set.  Which is correct (and why isn't it based on whether
CONFIG_IMA_APPRAISE is set)?

Also, what happens if someone creates an initramfs that doesn't
include xattrs and has this option set?

Slightly confusing.

josh

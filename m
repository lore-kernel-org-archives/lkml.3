Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932291AbbAHPNV (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 Jan 2015 10:13:21 -0500
Received: from e28smtp01.in.ibm.com ([122.248.162.1]:51789 "EHLO
	e28smtp01.in.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753160AbbAHPNS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 Jan 2015 10:13:18 -0500
Message-ID: <1420729987.6338.51.camel@dhcp-9-2-203-236.watson.ibm.com>
Subject: Re: [RFC][PATCH 8/9] ima: include tmpfs in ima_appraise_tcb policy
From: Mimi Zohar <zohar@linux.vnet.ibm.com>
To: Josh Boyer <jwboyer@fedoraproject.org>
Cc: initramfs <initramfs@vger.kernel.org>, Al Viro <viro@zeniv.linux.org.uk>,
        linux-ima-devel@lists.sourceforge.net,
        linux-security-module <linux-security-module@vger.kernel.org>,
        linux-kernel <linux-kernel@vger.kernel.org>
Date: Thu, 08 Jan 2015 10:13:07 -0500
In-Reply-To: <CA+5PVA7QiaLpiH+7oWQ5Uu8Z30mPczou89_9ga1CnW6c+_cQWQ@mail.gmail.com>
References: <1420663980-20842-1-git-send-email-zohar@linux.vnet.ibm.com>
	 <1420663980-20842-9-git-send-email-zohar@linux.vnet.ibm.com>
	 <CA+5PVA7QiaLpiH+7oWQ5Uu8Z30mPczou89_9ga1CnW6c+_cQWQ@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.6.4 (3.6.4-3.fc18) 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
X-TM-AS-MML: disable
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 15010815-4790-0000-0000-000006176671
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2015-01-08 at 08:53 -0500, Josh Boyer wrote: 
> On Wed, Jan 7, 2015 at 3:52 PM, Mimi Zohar <zohar@linux.vnet.ibm.com> wrote:
> > Now that the rootfs includes extended attributes, don't
> > automatically exclude tmpfs file systems from being appraised.
> >
> > Signed-off-by: Mimi Zohar <zohar@linux.vnet.ibm.com>
> > ---
> >  security/integrity/evm/evm_main.c   | 1 +
> >  security/integrity/ima/ima_policy.c | 2 ++
> >  2 files changed, 3 insertions(+)
> >
> > diff --git a/security/integrity/evm/evm_main.c b/security/integrity/evm/evm_main.c
> > index 9c71af7..e942e63 100644
> > --- a/security/integrity/evm/evm_main.c
> > +++ b/security/integrity/evm/evm_main.c
> > @@ -19,6 +19,7 @@
> >  #include <linux/module.h>
> >  #include <linux/crypto.h>
> >  #include <linux/audit.h>
> > +#include <linux/magic.h>
> >  #include <linux/xattr.h>
> >  #include <linux/integrity.h>
> >  #include <linux/evm.h>
> > diff --git a/security/integrity/ima/ima_policy.c b/security/integrity/ima/ima_policy.c
> > index d1eefb9..7267eac 100644
> > --- a/security/integrity/ima/ima_policy.c
> > +++ b/security/integrity/ima/ima_policy.c
> > @@ -93,7 +93,9 @@ static struct ima_rule_entry default_appraise_rules[] = {
> >         {.action = DONT_APPRAISE, .fsmagic = PROC_SUPER_MAGIC, .flags = IMA_FSMAGIC},
> >         {.action = DONT_APPRAISE, .fsmagic = SYSFS_MAGIC, .flags = IMA_FSMAGIC},
> >         {.action = DONT_APPRAISE, .fsmagic = DEBUGFS_MAGIC, .flags = IMA_FSMAGIC},
> > +#ifndef CONFIG_IMA_LOAD_X509
> >         {.action = DONT_APPRAISE, .fsmagic = TMPFS_MAGIC, .flags = IMA_FSMAGIC},
> > +#endif
> 
> The commit log makes it sound like tmpfs should be appraised
> unconditionally, but you only have it being appraised if IMA_LOAD_X509
> is set.  Which is correct (and why isn't it based on whether
> CONFIG_IMA_APPRAISE is set)?
> 
> Also, what happens if someone creates an initramfs that doesn't
> include xattrs and has this option set?
> 
> Slightly confusing.

Right, with commit fd5f4e90 "ima: load x509 certificate from the
kernel", the IMA appraisal key can be loaded before executing "init",
wherever it might be.

Only if IMA-appraisal is enabled and the ima_appraise_tcb is specified
on the kernel boot command line, are the builtin ima_appraise_tcb policy
rules used.

Mimi


Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932575AbaDVMd2 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Apr 2014 08:33:28 -0400
Received: from moutng.kundenserver.de ([212.227.126.131]:55478 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932172AbaDVMdY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Apr 2014 08:33:24 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: Ley Foon Tan <lftan@altera.com>
Subject: Re: [PATCH 04/28] nios2: Exception handling
Date: Tue, 22 Apr 2014 14:33:17 +0200
User-Agent: KMail/1.12.2 (Linux/3.8.0-22-generic; KDE/4.3.2; x86_64; ; )
Cc: linux-arch@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-doc@vger.kernel.org, lftan.linux@gmail.com,
        cltang@codesourcery.com
References: <1397824031-4892-1-git-send-email-lftan@altera.com> <1397824031-4892-4-git-send-email-lftan@altera.com>
In-Reply-To: <1397824031-4892-4-git-send-email-lftan@altera.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-15"
Content-Transfer-Encoding: 7bit
Message-Id: <201404221433.17861.arnd@arndb.de>
X-Provags-ID: V02:K0:HJim56/Iz+chKmbYS16czwIL+G8FKuNYyOMjaYdkqkM
 gnt0YjcJ9RdqS2kfdM5XTMSoEveyroyb+mtzF7rCEmtt4hccFi
 jYXu9Mwr/pwu5cIa/zDGpiIWZWG2KMOTYphS7DfOXx6+OdKtTC
 OhaywnwE3Qv3sVMjOmgwvtPN8pTPcqHzBH+yrJpkta/JpSLk4z
 d1771gGBL4AuIYWXSqt7gTAEYY2XhZm/YxEVg47iJR6zjzLG1R
 wOBnEH4ZgVwVcLT0XZcmDb4ZKynKI63f+G8CM6/gGSUwLm/a33
 UWHKAt3vT5hkigPlW7f+boH2gBrVLxOy5+cRhgyLBhLI6YTolN
 pC8fBGXJ2pJ/6xpQ7CSA=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Friday 18 April 2014, Ley Foon Tan wrote:
> +static const struct file_operations misalign_fops = {
> +       .open           = proc_misaligned_open,
> +       .read           = seq_read,
> +       .llseek         = seq_lseek,
> +       .release        = single_release,
> +       .write          = proc_misaligned_write,
> +};
> +#endif /* CONFIG_PROC_FS */

We really shouldn't be doing new architecture specific procfs files
any more. I suggest you drop this one for now, and add back the
functionality using perf or ftrace at a later point.

	Arnd

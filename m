Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757250AbbA2NXM (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 Jan 2015 08:23:12 -0500
Received: from cantor2.suse.de ([195.135.220.15]:43600 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754625AbbA2NXK (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 Jan 2015 08:23:10 -0500
Message-ID: <54CA343B.6060005@suse.cz>
Date: Thu, 29 Jan 2015 14:23:07 +0100
From: Michal Marek <mmarek@suse.cz>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Thunderbird/31.4.0
MIME-Version: 1.0
To: Jan Kiszka <jan.kiszka@siemens.com>
CC: Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
        Thomas Gleixner <tglx@linutronix.de>,
        Jason Wessel <jason.wessel@windriver.com>,
        kgdb-bugreport@lists.sourceforge.net, Andi Kleen <andi@firstfloor.org>,
        Tom Tromey <tromey@redhat.com>, Ben Widawsky <ben@bwidawsk.net>,
        Borislav Petkov <bp@suse.de>, linux-kbuild@vger.kernel.org
Subject: Re: [PATCH v11 01/28] scripts/gdb: Add infrastructure
References: <cover.1422514006.git.jan.kiszka@siemens.com> <39c235fa6c349bf025f957a1913c2e63be5b87c5.1422514006.git.jan.kiszka@siemens.com>
In-Reply-To: <39c235fa6c349bf025f957a1913c2e63be5b87c5.1422514006.git.jan.kiszka@siemens.com>
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 2015-01-29 07:46, Jan Kiszka wrote:
> --- a/scripts/Makefile
> +++ b/scripts/Makefile
> @@ -36,6 +36,7 @@ subdir-$(CONFIG_MODVERSIONS) += genksyms
>  subdir-y                     += mod
>  subdir-$(CONFIG_SECURITY_SELINUX) += selinux
>  subdir-$(CONFIG_DTC)         += dtc
> +subdir-$(CONFIG_GDB_SCRIPTS) += gdb
>  
>  # Let clean descend into subdirs
> -subdir-	+= basic kconfig package
> +subdir-	+= basic kconfig package gdb

The second assignment is superfluous. basic, kconfig and package are
listed there, because they are built explicitly by the toplevel Makefile
and not during the recursion.

Michal


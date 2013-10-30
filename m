Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753715Ab3J3K2k (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Oct 2013 06:28:40 -0400
Received: from thoth.sbs.de ([192.35.17.2]:33028 "EHLO thoth.sbs.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751644Ab3J3K2i (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Oct 2013 06:28:38 -0400
Message-ID: <5270DF35.1040708@siemens.com>
Date: Wed, 30 Oct 2013 11:28:05 +0100
From: Jan Kiszka <jan.kiszka@siemens.com>
User-Agent: Mozilla/5.0 (X11; U; Linux i686 (x86_64); de; rv:1.8.1.12) Gecko/20080226 SUSE/2.0.0.12-1.1 Thunderbird/2.0.0.12 Mnenhy/0.7.5.666
MIME-Version: 1.0
To: Andi Kleen <andi@firstfloor.org>
CC: Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
        Jason Wessel <jason.wessel@windriver.com>,
        kgdb-bugreport@lists.sourceforge.net, Tom Tromey <tromey@redhat.com>,
        Ben Widawsky <ben@bwidawsk.net>, Borislav Petkov <bp@suse.de>,
        Tatiana Al-Chueyr Martins <tatiana.alchueyr@gmail.com>,
        Michal Marek <mmarek@suse.cz>, linux-kbuild@vger.kernel.org
Subject: Re: [PATCH v6 01/21] scripts/gdb: Add infrastructure
References: <cover.1382950737.git.jan.kiszka@siemens.com> <74596df6935455908a146314b9b42ae2d79f6712.1382950737.git.jan.kiszka@siemens.com> <20131030053521.GU29695@two.firstfloor.org>
In-Reply-To: <20131030053521.GU29695@two.firstfloor.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 2013-10-30 06:35, Andi Kleen wrote:
>> The loading mechanism is based on gdb loading for <objfile>-gdb.py when
>> opening <objfile>. Therefore, this places a corresponding link to the
>> main helper script into the output directory that contains vmlinux.
> 
>> This feature depends on CONFIG_DEBUG_INFO.
> 
> Could you make this a separate config option? Having the links for
> people who don't use gdb would be ugly.
> 

Like this?

diff --git a/lib/Kconfig.debug b/lib/Kconfig.debug
index 06344d9..d66a8f8 100644
--- a/lib/Kconfig.debug
+++ b/lib/Kconfig.debug
@@ -143,6 +143,17 @@ config DEBUG_INFO_REDUCED
 	  DEBUG_INFO build and compile times are reduced too.
 	  Only works with newer gcc versions.
 
+config GDB_SCRIPTS
+	bool "Provide GDB scripts for kernel debugging"
+	select DEBUG_INFO
+	help
+	  This creates the required links to GDB helper scripts in the
+	  build directory. If you load vmlinux into gdb, the helper
+	  scripts will be automatically imported by gdb as well, and
+	  additional functions are available to analyze a Linux kernel
+	  instance. See Documentation/gdb-kernel-debugging.txt for further
+	  details.
+
 config ENABLE_WARN_DEPRECATED
 	bool "Enable __deprecated logic"
 	default y

Will send an updated series soon, also adjusting the docs, just waiting
for potential further comments.

Jan

-- 
Siemens AG, Corporate Technology, CT RTC ITP SES-DE
Corporate Competence Center Embedded Linux

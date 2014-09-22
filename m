Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753166AbaIVCyq (ORCPT <rfc822;w@1wt.eu>);
	Sun, 21 Sep 2014 22:54:46 -0400
Received: from smtp-69.nebula.fi ([83.145.220.69]:55188 "EHLO smtp.nebula.fi"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752738AbaIVCyp (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 21 Sep 2014 22:54:45 -0400
Date: Mon, 22 Sep 2014 05:53:35 +0300
From: Stefan Kristiansson <stefan.kristiansson@saunalahti.fi>
To: Guenter Roeck <linux@roeck-us.net>
Cc: Jonas Bonn <jonas@southpole.se>, linux@openrisc.net,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] openrisc: Support both old (or32) and new (or1k)
 toolchain
Message-ID: <20140922025334.GA19719@chokladfabriken.org>
References: <1410210049-30800-1-git-send-email-linux@roeck-us.net>
 <541BB786.1070700@roeck-us.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <541BB786.1070700@roeck-us.net>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Sep 18, 2014 at 09:56:38PM -0700, Guenter Roeck wrote:
> ping ... comments / feedback anyone ?
> 
> Guenter
> 

FWIW, I've tested this and it works fine.

Stefan

> On 09/08/2014 02:00 PM, Guenter Roeck wrote:
> >The output file format for openrisc has changed from "elf32-or32"
> >to "elf32-or1k" when using the or1k instead of the older or32 toochain.
> >Select the correct output format automatically to be able to compile
> >the kernel with both toolchain variants.
> >
> >Cc: Stefan Kristiansson <stefan.kristiansson@saunalahti.fi>
> >Signed-off-by: Guenter Roeck <linux@roeck-us.net>
> >---
> >Candidate for -stable ?
> >
> >  arch/openrisc/kernel/vmlinux.lds.S | 8 +++++++-
> >  1 file changed, 7 insertions(+), 1 deletion(-)
> >
> >diff --git a/arch/openrisc/kernel/vmlinux.lds.S b/arch/openrisc/kernel/vmlinux.lds.S
> >index 2d69a85..1c5d21a 100644
> >--- a/arch/openrisc/kernel/vmlinux.lds.S
> >+++ b/arch/openrisc/kernel/vmlinux.lds.S
> >@@ -30,7 +30,13 @@
> >  #include <asm/cache.h>
> >  #include <asm-generic/vmlinux.lds.h>
> >
> >-OUTPUT_FORMAT("elf32-or32", "elf32-or32", "elf32-or32")
> >+#ifdef __OR1K__
> >+#define __OUTPUT_FORMAT	"elf32-or1k"
> >+#else
> >+#define __OUTPUT_FORMAT	"elf32-or32"
> >+#endif
> >+
> >+OUTPUT_FORMAT(__OUTPUT_FORMAT, __OUTPUT_FORMAT, __OUTPUT_FORMAT)
> >  jiffies = jiffies_64 + 4;
> >
> >  SECTIONS
> >
> 

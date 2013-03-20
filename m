Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757645Ab3CTS4G (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Mar 2013 14:56:06 -0400
Received: from mail-pb0-f43.google.com ([209.85.160.43]:47781 "EHLO
	mail-pb0-f43.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752567Ab3CTS4E (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Mar 2013 14:56:04 -0400
Date: Wed, 20 Mar 2013 11:56:01 -0700 (PDT)
From: David Rientjes <rientjes@google.com>
X-X-Sender: rientjes@chino.kir.corp.google.com
To: Randy Dunlap <rdunlap@infradead.org>,
        HATAYAMA Daisuke <d.hatayama@jp.fujitsu.com>
cc: Stephen Rothwell <sfr@canb.auug.org.au>,
        Andrew Morton <akpm@linux-foundation.org>, linux-next@vger.kernel.org,
        linux-kernel@vger.kernel.org, kexec@lists.infradead.org
Subject: Re: linux-next: Tree for Mar 20 (vmcore)
In-Reply-To: <5149E813.8060307@infradead.org>
Message-ID: <alpine.DEB.2.02.1303201153330.17761@chino.kir.corp.google.com>
References: <20130320160536.54e62fc11a3651494b710e3b@canb.auug.org.au> <5149E813.8060307@infradead.org>
User-Agent: Alpine 2.02 (DEB 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 20 Mar 2013, Randy Dunlap wrote:

> on x86_64:
> 
> fs/proc/vmcore.c: In function 'merge_note_headers_elf64':
> fs/proc/vmcore.c:349:22: error: 'VMCOREINFO_NOTE_NAME' undeclared (first use in this function)
> fs/proc/vmcore.c:349:22: note: each undeclared identifier is reported only once for each function it appears in
> fs/proc/vmcore.c: In function 'merge_note_headers_elf32':
> fs/proc/vmcore.c:470:22: error: 'VMCOREINFO_NOTE_NAME' undeclared (first use in this function)
> make[3]: *** [fs/proc/vmcore.o] Error 1
> 
> 
> Needs to #include <linux/kexec.h>
> 

I don't think that's it, linux/kexec.h already gets included indirectly.  
The problem is that CONFIG_KEXEC isn't set so the definition in kexec.h is 
meaningless.

This comes from "vmcore: check NT_VMCORE_PAD as a mark indicating the end 
of ELF note buffer" merged through the -mm tree.  I've added the patch's 
author and Andrew to the cc.

How can this be protected by CONFIG_KEXEC?

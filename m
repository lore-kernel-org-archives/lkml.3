Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753222AbaBLVyy (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Feb 2014 16:54:54 -0500
Received: from mail-pb0-f42.google.com ([209.85.160.42]:40860 "EHLO
	mail-pb0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751914AbaBLVyv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Feb 2014 16:54:51 -0500
Date: Wed, 12 Feb 2014 13:54:43 -0800 (PST)
From: David Rientjes <rientjes@google.com>
X-X-Sender: rientjes@chino.kir.corp.google.com
To: dl9pf@gmx.de
cc: Behan Webster <behanw@converseincode.com>,
        David Woodhouse <David.Woodhouse@intel.com>,
        Matthew Garrett <matthew.garrett@nebula.com>,
        ibm-acpi-devel@lists.sourceforge.net,
        platform-driver-x86@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] x86, acpi: LLVMLinux: Remove nested functions from
 Thinkpad ACPI
In-Reply-To: <1392238726-18787-1-git-send-email-dl9pf@gmx.de>
Message-ID: <alpine.DEB.2.02.1402121351510.27082@chino.kir.corp.google.com>
References: <1392238726-18787-1-git-send-email-dl9pf@gmx.de>
User-Agent: Alpine 2.02 (DEB 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 12 Feb 2014, dl9pf@gmx.de wrote:

> From: Behan Webster <behanw@converseincode.com>
> 
> The only real change is passing in event_mask to the formerly nested functions.
> Otherwise it's just moving around function and macro code.
> 
> This is the only place in the Linux kernel where nested functions are still in
> use. Nested functions aren't part of the C standards, and complicate the
> generated code. Although the Linux Kernel has never set out to be entirely C
> standard compliant, it is increasingly compliant to the standard which is
> supported by other compilers such as Clang. The LLVMLinux project is working on
> being able to compile the Linux kernel with Clang. The use of nested functions
> blocks this effort.
> 

So this patch is only as a courtesy to clang and you're not complaining 
about things like __builtin() functions, typeof, or a ? : b conditional 
operators because clang happens to support them?

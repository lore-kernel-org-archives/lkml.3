Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756943Ab3JNQuE (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Oct 2013 12:50:04 -0400
Received: from mail-we0-f178.google.com ([74.125.82.178]:65340 "EHLO
	mail-we0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755633Ab3JNQuB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Oct 2013 12:50:01 -0400
MIME-Version: 1.0
In-Reply-To: <20131014102635.GC4009@pd.tnic>
References: <1381473166-29303-1-git-send-email-gong.chen@linux.intel.com>
	<1381473166-29303-4-git-send-email-gong.chen@linux.intel.com>
	<20131011152451.GF5925@pd.tnic>
	<20131014031633.GA12189@gchen.bj.intel.com>
	<20131014102635.GC4009@pd.tnic>
Date: Mon, 14 Oct 2013 09:50:00 -0700
Message-ID: <CA+8MBbJ+mOWhZR5d8wP4x_ncgumGOANziOGmDBzj0QdbPSDH0w@mail.gmail.com>
Subject: Re: [PATCH 3/8] ACPI, x86: Extended error log driver for x86 platform
From: Tony Luck <tony.luck@gmail.com>
To: Borislav Petkov <bp@alien8.de>
Cc: Chen Gong <gong.chen@linux.intel.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        linux-acpi <linux-acpi@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Oct 14, 2013 at 3:26 AM, Borislav Petkov <bp@alien8.de> wrote:
> On Sun, Oct 13, 2013 at 11:16:33PM -0400, Chen Gong wrote:
>> But this driver can be loaded as a module. If this module is unloaded,
>> extlog_print is gone. I can't keep such a pointer internally.
>
> Sure you can - you define a weak extlog_print() function in a
> compilation unit which is always builtin. Maybe mce.c or so.

"weak" is a good compile/link time tool to provide a default function
while allowing override with a architecture (or more generally a CONFIG_*)
specific one.  But it is no help when loading/unloading modules.

Think about it ... we have a call to this function from some place in the
base kernel (originating from mce.o).  Before the module is loaded you
want that to leap to your weak function.

Now load the module with the not-weak definition of the function - the
module loader would have to go do a relocation fix-up in the base kernel
to point to this new function. At module unload it would have to undo
that.

-Tony

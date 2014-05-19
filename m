Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932080AbaESNry (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 May 2014 09:47:54 -0400
Received: from mail.emea.novell.com ([130.57.118.101]:54186 "EHLO
	mail.emea.novell.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754561AbaESNrw convert rfc822-to-8bit (ORCPT
	<rfc822;groupwise-linux-kernel@vger.kernel.org:12:2>);
	Mon, 19 May 2014 09:47:52 -0400
Message-Id: <537A27A30200007800013AD9@mail.emea.novell.com>
X-Mailer: Novell GroupWise Internet Agent 14.0.0 
Date: Mon, 19 May 2014 14:47:47 +0100
From: "Jan Beulich" <JBeulich@suse.com>
To: "Andrew Cooper" <andrew.cooper3@citrix.com>
Cc: <david.vrabel@citrix.com>, <ian.campbell@citrix.com>,
        <stefano.stabellini@eu.citrix.com>, <jeremy@goop.org>,
        <matt.fleming@intel.com>, <x86@kernel.org>, <tglx@linutronix.de>,
        <xen-devel@lists.xenproject.org>, <boris.ostrovsky@oracle.com>,
        "Daniel Kiper" <daniel.kiper@oracle.com>, <eshelton@pobox.com>,
        <mingo@redhat.com>, <mjg59@srcf.ucam.org>, <linux-efi@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>, <hpa@zytor.com>
Subject: Re: [Xen-devel] [PATCH v4 3/5] xen: Put EFI machinery in place
References: <1400272904-31121-1-git-send-email-daniel.kiper@oracle.com>
 <1400272904-31121-4-git-send-email-daniel.kiper@oracle.com>
 <537A0974.40302@citrix.com>
In-Reply-To: <537A0974.40302@citrix.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 8BIT
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>>> On 19.05.14 at 15:39, <andrew.cooper3@citrix.com> wrote:
> On 16/05/14 21:41, Daniel Kiper wrote:
>> @@ -0,0 +1,374 @@
>> +/*
>> + * EFI support for Xen.
>> + *
>> + * Copyright (C) 1999 VA Linux Systems
>> + * Copyright (C) 1999 Walt Drummond <drummond@valinux.com>
>> + * Copyright (C) 1999-2002 Hewlett-Packard Co.
>> + *	David Mosberger-Tang <davidm@hpl.hp.com>
>> + *	Stephane Eranian <eranian@hpl.hp.com>
>> + * Copyright (C) 2005-2008 Intel Co.
>> + *	Fenghua Yu <fenghua.yu@intel.com>
>> + *	Bibo Mao <bibo.mao@intel.com>
>> + *	Chandramouli Narayanan <mouli@linux.intel.com>
>> + *	Huang Ying <ying.huang@intel.com>
>> + * Copyright (C) 2011 Novell Co.
>> + *	Jan Beulich <JBeulich@suse.com>
>> + * Copyright (C) 2011-2012 Oracle Co.
>> + *	Liang Tang <liang.tang@oracle.com>
>> + * Copyright (c) 2014 Daniel Kiper, Oracle Corporation
>> + */
>> +
>> +#include <linux/bug.h>
>> +#include <linux/efi.h>
>> +#include <linux/init.h>
>> +#include <linux/string.h>
>> +
>> +#include <xen/interface/xen.h>
>> +#include <xen/interface/platform.h>
>> +
>> +#include <asm/xen/hypercall.h>
>> +
>> +#define call (op.u.efi_runtime_call)
> 
> I think not.

??? (Read: What's wrong with putting this shortcut in place?)

>> +#define DECLARE_CALL(what) \
>> +	struct xen_platform_op op; \
>> +	op.cmd = XENPF_efi_runtime_call; \
>> +	call.function = XEN_EFI_##what; \
>> +	call.misc = 0
> 
> Macros like this which explicitly create local variable with implicit
> names are evil when reading code.
> 
> If you want to do initialisation like this, then at least do something like:
> 
> #define INIT_EFI_CALL(what) \
> { .cmd = XENPF_efi_runtime_call, \
>    .u.efi_runtime_call.function = XEN_EFI_##what, \
>    .u.efi_runtime_call.misc = 0 }
> 
> And use it as:
> 
> struct xen_platform_op op = INIT_EFI_CALL(foo);

That's minimal redundancy as a goal versus (to you, but not to me)
legibility.

Jan


Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752778AbaF0S5i (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 Jun 2014 14:57:38 -0400
Received: from mail-lb0-f177.google.com ([209.85.217.177]:63622 "EHLO
	mail-lb0-f177.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752527AbaF0S5g (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 Jun 2014 14:57:36 -0400
MIME-Version: 1.0
In-Reply-To: <53ADACF7.7080203@intel.com>
References: <1403084656-27284-1-git-send-email-qiaowei.ren@intel.com>
 <53A884B2.5070702@mit.edu> <53A88806.1060908@intel.com> <CALCETrXYZZiZsDiUvvZd0636+qHP9a0sHTN6wt_ZKjvLaeeBzw@mail.gmail.com>
 <53A88DE4.8050107@intel.com> <CALCETrWBbkFzQR3tz1TphqxiGYycvzrFrKc=ghzMynbem=d7rg@mail.gmail.com>
 <9E0BE1322F2F2246BD820DA9FC397ADE016AF41C@shsmsx102.ccr.corp.intel.com>
 <CALCETrX+iS5N8bCUm_O-1E4GPu4oG-SuFJoJjx_+S054K9-6pw@mail.gmail.com>
 <9E0BE1322F2F2246BD820DA9FC397ADE016B26AB@shsmsx102.ccr.corp.intel.com>
 <CALCETrWmmVC2qQtL0Js_Y7LvSPdTh5Hpk6c5ZG3Rt8uTJBWoHQ@mail.gmail.com>
 <CALCETrUD3L5Ta_v+NqgUrTk7Ok3zE=CRg0rqeKthOj2OORCLKQ@mail.gmail.com>
 <53AB42E1.4090102@intel.com> <CALCETrVTTh9yuXH0hfcOpytyBd25K6thPfqqUBQtnOqx90ZRqw@mail.gmail.com>
 <53ACA5B3.3010702@intel.com> <CALCETrVceOhRunCg1b9Q3VL10Kcb+uA-HFUURnq5f2S63_jACg@mail.gmail.com>
 <53ACB8A7.9050002@intel.com> <53ADAB39.6030403@intel.com> <53ADACF7.7080203@intel.com>
From: Andy Lutomirski <luto@amacapital.net>
Date: Fri, 27 Jun 2014 11:57:15 -0700
Message-ID: <CALCETrXban-Yk1e95Yy2-fXtudjBmKGFsLMjuB+zPCpxDP3OYg@mail.gmail.com>
Subject: Re: [PATCH v6 02/10] x86, mpx: add MPX specific mmap interface
To: Dave Hansen <dave.hansen@intel.com>
Cc: "Ren, Qiaowei" <qiaowei.ren@intel.com>, "H. Peter Anvin" <hpa@zytor.com>,
        Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>,
        X86 ML <x86@kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Linux MM <linux-mm@kvack.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jun 27, 2014 at 10:42 AM, Dave Hansen <dave.hansen@intel.com> wrote:
> On 06/27/2014 10:34 AM, Dave Hansen wrote:
>> I'm claiming that we need COW behavior for the bounds tables, at least
>> by default.  If userspace knows enough about the ways that it is using
>> the tables and knows how to share them, let it go to town.  The kernel
>> will permit this kind of usage model, but we simply won't be helping
>> with the management of the tables when userspace creates them.
>
> Actually, this is another reason we need to mark VMAs as being
> MPX-related explicitly instead of inferring it from the tables.  If
> userspace does something really specialized like this, the kernel does
> not want to confuse these VMAs the ones it created.
>

Good point.

--Andy

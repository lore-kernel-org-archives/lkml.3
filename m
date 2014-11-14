Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1161490AbaKNRTP (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 Nov 2014 12:19:15 -0500
Received: from mail-la0-f51.google.com ([209.85.215.51]:63053 "EHLO
	mail-la0-f51.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1161454AbaKNRTN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 Nov 2014 12:19:13 -0500
MIME-Version: 1.0
In-Reply-To: <20141114103406.GA7475@pd.tnic>
References: <c2522bcacf5db9a25a819a8756502edb1d2ca10f.1415739239.git.luto@amacapital.net>
 <20141112220058.GA5295@redhat.com> <CALCETrWA5z7-1fiz_9N0Qi2OR5s1jCkHiynCtTD_+9taOBs-Mg@mail.gmail.com>
 <3908561D78D1C84285E8C5FCA982C28F3292BAB4@ORSMSX114.amr.corp.intel.com>
 <CALCETrU8uyc4nu-5MBXQR0PY0rexUhPkuPRLK+gWt0gEWMDhTA@mail.gmail.com>
 <3908561D78D1C84285E8C5FCA982C28F3292BD44@ORSMSX114.amr.corp.intel.com>
 <CALCETrUpqSpcKFRM6a1zJWebEVZxNd-5pyBW4fU19+HgcBv+2Q@mail.gmail.com> <20141114103406.GA7475@pd.tnic>
From: Andy Lutomirski <luto@amacapital.net>
Date: Fri, 14 Nov 2014 09:18:51 -0800
Message-ID: <CALCETrXTxJnEejqV_LjrDHO6Pur5afhYERneZD+2KrshH28tVQ@mail.gmail.com>
Subject: Re: [RFC PATCH] x86, entry: Switch stacks on a paranoid entry from userspace
To: Borislav Petkov <bp@alien8.de>
Cc: Andi Kleen <andi@firstfloor.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        X86 ML <x86@kernel.org>, Peter Zijlstra <peterz@infradead.org>,
        "Luck, Tony" <tony.luck@intel.com>, Oleg Nesterov <oleg@redhat.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Nov 14, 2014 2:34 AM, "Borislav Petkov" <bp@alien8.de> wrote:
>
> On Wed, Nov 12, 2014 at 07:03:21PM -0800, Andy Lutomirski wrote:
> > printk seems to work just fine in do_machine_check.
>
> That must be pure luck. Has anything changed which I missed to make
> printk NMI-safe?

Heh.  Probably not.  Now I wonder whether that might have caused the
scheduling in idle cpu thing.

Grr.  Do you or Tony have any pointers for how to test this myself?  I
don't know enough about the acpi error injection thing, which I assume
is that Tony is using.

--Andy

>
> --
> Regards/Gruss,
>     Boris.
>
> Sent from a fat crate under my desk. Formatting is fine.
> --

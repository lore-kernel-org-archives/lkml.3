Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S964955AbaGCPpC (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Jul 2014 11:45:02 -0400
Received: from mail.emea.novell.com ([130.57.118.101]:48586 "EHLO
	mail.emea.novell.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753070AbaGCPpA convert rfc822-to-8bit (ORCPT
	<rfc822;groupwise-linux-kernel@vger.kernel.org:4:1>);
	Thu, 3 Jul 2014 11:45:00 -0400
Message-Id: <53B5969A0200007800020613@mail.emea.novell.com>
X-Mailer: Novell GroupWise Internet Agent 14.0.0 
Date: Thu, 03 Jul 2014 16:44:58 +0100
From: "Jan Beulich" <JBeulich@suse.com>
To: "Andy Lutomirski" <luto@amacapital.net>
Cc: "Ingo Molnar" <mingo@elte.hu>, "Thomas Gleixner" <tglx@linutronix.de>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "H. Peter Anvin" <hpa@zytor.com>
Subject: Re: [PATCH] ix86: fix vDSO build
References: <53B5863B02000078000204D5@mail.emea.novell.com>
 <CALCETrW2+jYz6NXaReTsEu4pN9G-pAkF8q7p+wP3-MPruy=DsA@mail.gmail.com>
In-Reply-To: <CALCETrW2+jYz6NXaReTsEu4pN9G-pAkF8q7p+wP3-MPruy=DsA@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 8BIT
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>>> On 03.07.14 at 17:34, <luto@amacapital.net> wrote:
> On Thu, Jul 3, 2014 at 7:35 AM, Jan Beulich <JBeulich@suse.com> wrote:
>> Relying on static functions used just once to get inlined (and
>> subsequently have dead code paths eliminated) is wrong: Compilers are
>> free to decide whether they do this, regardless of optimization level.
>> With this not happening for vdso_addr() (observed with gcc 4.1.x), an
>> unresolved reference to align_vdso_addr() causes the build to fail.
>>
>> Signed-off-by: Jan Beulich <jbeulich@suse.com>
>> Cc: Andy Lutomirski <luto@amacapital.net>
> 
> Acked-by: Andy Lutomirski <luto@amacapital.net>

Thanks (also for the other one).

> Any chance you could send a dump of the symbol and relocation tables
> of a .so.dbg with this problem?  I'm curious why checkundef.sh never
> caught it.

vma.o is part of the kernel, not the .so.

Jan


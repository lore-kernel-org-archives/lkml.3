Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753315AbaIJUbu (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Sep 2014 16:31:50 -0400
Received: from mail-lb0-f178.google.com ([209.85.217.178]:41631 "EHLO
	mail-lb0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753001AbaIJUbt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Sep 2014 16:31:49 -0400
MIME-Version: 1.0
In-Reply-To: <5410B10A.4030207@zytor.com>
References: <1410367910-6026-1-git-send-email-toshi.kani@hp.com>
 <1410367910-6026-3-git-send-email-toshi.kani@hp.com> <CALCETrXRjU3HvHogpm5eKB3Cogr5QHUvE67JOFGbOmygKYEGyA@mail.gmail.com>
 <1410377428.28990.260.camel@misato.fc.hp.com> <5410B10A.4030207@zytor.com>
From: Andy Lutomirski <luto@amacapital.net>
Date: Wed, 10 Sep 2014 13:31:27 -0700
Message-ID: <CALCETrX5JEZ3cLbuehobnH3bmBDAKARV9o0V5VYoazV8rL5o-A@mail.gmail.com>
Subject: Re: [PATCH v2 2/6] x86, mm, pat: Change reserve_memtype() to handle WT
To: "H. Peter Anvin" <hpa@zytor.com>
Cc: Toshi Kani <toshi.kani@hp.com>, Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Arnd Bergmann <arnd@arndb.de>,
        "linux-mm@kvack.org" <linux-mm@kvack.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Juergen Gross <jgross@suse.com>,
        Stefan Bader <stefan.bader@canonical.com>,
        Henrique de Moraes Holschuh <hmh@hmh.eng.br>,
        Yigal Korman <yigal@plexistor.com>,
        Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Sep 10, 2014 at 1:14 PM, H. Peter Anvin <hpa@zytor.com> wrote:
> On 09/10/2014 12:30 PM, Toshi Kani wrote:
>>
>> When WT is unavailable due to the PAT errata, it does not fail but gets
>> redirected to UC-.  Similarly, when PAT is disabled, WT gets redirected
>> to UC- as well.
>>
>
> But on pre-PAT hardware you can still do WT.
>

Using MTRRs?  /me shudders, although I suppose this would be okay for
NV-DIMMs as long as you map the whole thing WT.

One of these days I'll finish excising mtrr_add from everything
outside arch/x86.  I already killed it in all modern graphics drivers
:)

--Andy



>         -hpa
>



-- 
Andy Lutomirski
AMA Capital Management, LLC

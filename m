Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754285AbaGOPzQ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Jul 2014 11:55:16 -0400
Received: from mail-la0-f46.google.com ([209.85.215.46]:35468 "EHLO
	mail-la0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750722AbaGOPzO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Jul 2014 11:55:14 -0400
MIME-Version: 1.0
In-Reply-To: <53C54CA0.1060904@oracle.com>
References: <195642a5e9fd4515ad8ca4cd8bcffd4900df5790.1405437568.git.luto@amacapital.net>
 <20140715153801.GX3403@laptop.dumpdata.com> <53C54CA0.1060904@oracle.com>
From: Andy Lutomirski <luto@amacapital.net>
Date: Tue, 15 Jul 2014 08:54:53 -0700
Message-ID: <CALCETrX3stAHVvHceEHrbWgwgGx4XiZ61A1FAOGSxkrkmq0GnQ@mail.gmail.com>
Subject: Re: [PATCH] x86_64,xen,espfix: Initialize espfix on secondary CPUs
To: Boris Ostrovsky <boris.ostrovsky@oracle.com>
Cc: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>,
        "H. Peter Anvin" <hpa@zytor.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        stable <stable@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jul 15, 2014 at 8:45 AM, Boris Ostrovsky
<boris.ostrovsky@oracle.com> wrote:
> On 07/15/2014 11:38 AM, Konrad Rzeszutek Wilk wrote:
>>
>> On Tue, Jul 15, 2014 at 08:26:41AM -0700, Andy Lutomirski wrote:
>>>
>>> Xen doesn't call start_secondary.
>>
>> Duh!
>>>
>>> Cc: stable@vger.kernel.org
>>> Signed-off-by: Andy Lutomirski <luto@amacapital.net>
>>> ---
>>>
>>> espfix still doesn't seem to work on Xen (it goes boom in some way that
>>> I don't understand right now), but initializing all CPUs instead of just
>>> one of them seems like a good start.
>>>
>>> ISTM the right fix is probably to shove the espfix logic into
>>> native_iret and to tweak the paravirt logic so that native_iret always
>>> gets invoked.  I suspect that Xen will need its own implementation of
>>> espfix64 in the hypervisor and that, ultimately, someone may want to
>>> stop initializing espfix64 at all on Xen guests.
>>
>> I think just disallowing would be preferrable.
>
>
> I've been looking at sigreturn_64 and it seems to be crashing dom0 (with
> both mine and your patches). In kprobe_int3_handler().

You need:

http://lkml.kernel.org/g/c4e339882c121aa76254f2adde3fcbdf502faec2.1405099506.git.luto@amacapital.net

The newer version of sigreturn_32 that I pushed is a much better test
-- it tests the 64-bit cases (yay thunks!) and works on kernels
without my SS sigcontext fix.

--Andy

Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756099Ab3ANCb6 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 13 Jan 2013 21:31:58 -0500
Received: from miso.sublimeip.com ([203.12.5.51]:53184 "EHLO
	miso.sublimeip.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754564Ab3ANCb5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 13 Jan 2013 21:31:57 -0500
Message-ID: <a370d0f1bac7b2cee0bd2c2eea1ce22f.squirrel@mail.sublimeip.com>
In-Reply-To: <20130112181258.GA24903@redhat.com>
References: <20121125225533.GA24905@redhat.com>
    <20121125234834.DAC34592076@miso.sublimeip.com>
    <20121202193058.GA4264@redhat.com>
    <841b7a319f9d22402d269eed23d03835.squirrel@mail.sublimeip.com>
    <20121204175933.GA11537@redhat.com> <50EC527C.5030800@redhat.com>
    <20130109175203.GA32191@redhat.com>
    <6dff6dcdbfd7444f0b43d8b8bea6ca7c.squirrel@mail.sublimeip.com>
    <20130112181258.GA24903@redhat.com>
Date: Mon, 14 Jan 2013 13:31:55 +1100
Subject: Re: PTRACE_SYSCALL && vsyscall (Was: arch_check_bp_in_kernelspace:
 fix the range check)
From: u3557@miso.sublimeip.com
To: "Oleg Nesterov" <oleg@redhat.com>
Cc: u3557@miso.sublimeip.com, "Pedro Alves" <palves@redhat.com>,
        "Denys Vlasenko" <dvlasenk@redhat.com>,
        "Jan Kratochvil" <jan.kratochvil@redhat.com>,
        "Cyrill Gorcunov" <gorcunov@openvz.org>,
        "Pavel Emelyanov" <xemul@parallels.com>,
        "Steven Rostedt" <rostedt@goodmis.org>,
        "Frederic Weisbecker" <fweisbec@gmail.com>,
        "Ingo Molnar" <mingo@redhat.com>,
        "Peter Zijlstra" <a.p.zijlstra@chello.nl>,
        linux-kernel@vger.kernel.org
Reply-To: mosix@mosix.com.au
User-Agent: SquirrelMail/1.4.22
MIME-Version: 1.0
Content-Type: multipart/mixed;boundary="----=_20130114133154_69408"
X-Priority: 3 (Normal)
Importance: Normal
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

------=_20130114133154_69408
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit

Hi,

> I would not say this is a bug but let me repeat, no need to convince me.
>
> Please feel free to re-send the patch(es) I sent to maintainers. Sorry,
> I can't push these changes into Linus's tree.

So here again is the patch that I need so badly - clearly it fixes a bug
and harms nobody:

-----------------------------------------------------------------------
diff -Naur before/arch/x86/kernel/hw_breakpoint.c
after/arch/x86/kernel/hw_breakpoint.c
--- before/arch/x86/kernel/hw_breakpoint.c	2013-01-14 12:45:20.000000000
+1030
+++ after/arch/x86/kernel/hw_breakpoint.c	2013-01-14 12:46:24.000000000 +1030
@@ -200,7 +200,8 @@
 	va = info->address;
 	len = get_hbp_len(info->len);

-	return (va >= TASK_SIZE) && ((va + len - 1) >= TASK_SIZE);
+	return (va >= TASK_SIZE) && ((va + len - 1) >= TASK_SIZE) &&
+		!((va >= VSYSCALL_START) && ((va + len - 1) <= VSYSCALL_END));
 }

 int arch_bp_generic_fields(int x86_len, int x86_type,
-----------------------------------------------------------------------

Where else can I send it?
Amnon.

> On 01/10, u3557@miso.sublimeip.com wrote:
>>
>> Hi Everyone,
>>
>> > On 01/08, Pedro Alves wrote:
>> >>
>> >> On 12/04/2012 05:59 PM, Oleg Nesterov wrote:
>> >>
>> >> > But If we want to allow to trace vsyscall's, hw bp doesn't look
>> very
>> >> > nice imo. HBP_NUM = 4 and you need to setup 3 bp's to trace them
>> all.
>> >>
>> >> Irrespective of the whole syscall tracing issue, allowing HW bkpts in
>> >> the vsyscall just seems like a bug fix to me.
>> >
>> > And I never argued. I sent the patch iirc ;)
>>
>> Exactly, it is a bug and I am still waiting for it to be fixed in the
>> Linux kernel.
>
> I would not say this is a bug but let me repeat, no need to convince me.
>
> Please feel free to re-send the patch(es) I sent to maintainers. Sorry,
> I can't push these changes into Linus's tree.
>
> Oleg.
>
>

------=_20130114133154_69408
Content-Type: application/octet-stream; name="patch"
Content-Transfer-Encoding: base64
Content-Disposition: attachment; filename="patch"

ZGlmZiAtTmF1ciBiZWZvcmUvYXJjaC94ODYva2VybmVsL2h3X2JyZWFrcG9pbnQuYyBhZnRlci9h
cmNoL3g4Ni9rZXJuZWwvaHdfYnJlYWtwb2ludC5jCi0tLSBiZWZvcmUvYXJjaC94ODYva2VybmVs
L2h3X2JyZWFrcG9pbnQuYwkyMDEzLTAxLTE0IDEyOjQ1OjIwLjAwMDAwMDAwMCArMTAzMAorKysg
YWZ0ZXIvYXJjaC94ODYva2VybmVsL2h3X2JyZWFrcG9pbnQuYwkyMDEzLTAxLTE0IDEyOjQ2OjI0
LjAwMDAwMDAwMCArMTAzMApAQCAtMjAwLDcgKzIwMCw4IEBACiAJdmEgPSBpbmZvLT5hZGRyZXNz
OwogCWxlbiA9IGdldF9oYnBfbGVuKGluZm8tPmxlbik7CiAKLQlyZXR1cm4gKHZhID49IFRBU0tf
U0laRSkgJiYgKCh2YSArIGxlbiAtIDEpID49IFRBU0tfU0laRSk7CisJcmV0dXJuICh2YSA+PSBU
QVNLX1NJWkUpICYmICgodmEgKyBsZW4gLSAxKSA+PSBUQVNLX1NJWkUpICYmCisJCSEoKHZhID49
IFZTWVNDQUxMX1NUQVJUKSAmJiAoKHZhICsgbGVuIC0gMSkgPD0gVlNZU0NBTExfRU5EKSk7CiB9
CiAKIGludCBhcmNoX2JwX2dlbmVyaWNfZmllbGRzKGludCB4ODZfbGVuLCBpbnQgeDg2X3R5cGUs
Cg==
------=_20130114133154_69408--



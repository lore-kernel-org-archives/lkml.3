Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751768Ab3IFLJO (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Sep 2013 07:09:14 -0400
Received: from terminus.zytor.com ([198.137.202.10]:53231 "EHLO mail.zytor.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751108Ab3IFLJN (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Sep 2013 07:09:13 -0400
Message-ID: <5229B7BB.5020804@zytor.com>
Date: Fri, 06 Sep 2013 04:08:43 -0700
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130625 Thunderbird/17.0.7
MIME-Version: 1.0
To: Geert Uytterhoeven <geert@linux-m68k.org>
CC: David Herrmann <dh.herrmann@gmail.com>, Tom Gundersen <teg@jklm.no>,
        the arch/x86 maintainers <x86@kernel.org>,
        linux-kernel <linux-kernel@vger.kernel.org>,
        Ingo Molnar <mingo@redhat.com>, Thomas Gleixner <tglx@linutronix.de>
Subject: Re: [PATCH] x86: simplefb: avoid overflow
References: <1378459933-367-1-git-send-email-teg@jklm.no> <CANq1E4Tco9K1zeL2d7MhBQ=UjHFOktrrR8GHp8cJm3V6CTqf0g@mail.gmail.com> <CAMuHMdUEjLSRoSHdQUACupxiJ_GxMXSzk-KsMA5ep55sxNT3kw@mail.gmail.com>
In-Reply-To: <CAMuHMdUEjLSRoSHdQUACupxiJ_GxMXSzk-KsMA5ep55sxNT3kw@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 09/06/2013 03:59 AM, Geert Uytterhoeven wrote:
> On Fri, Sep 6, 2013 at 11:55 AM, David Herrmann <dh.herrmann@gmail.com> wrote:
>> On Fri, Sep 6, 2013 at 11:32 AM, Tom Gundersen <teg@jklm.no> wrote:
>>> lfb_size can easily be say 4M, which would make the bitshit overflow and
>>> the test fail.
>>>
>>> Signed-off-by: Tom Gundersen <teg@jklm.no>
>>> Cc: David Herrmann <dh.herrmann@gmail.com>
>>> Cc: H. Peter Anvin <hpa@zytor.com>
>>> ---
>>>   arch/x86/kernel/sysfb_simplefb.c | 2 +-
>>>   1 file changed, 1 insertion(+), 1 deletion(-)
>>>
>>> diff --git a/arch/x86/kernel/sysfb_simplefb.c b/arch/x86/kernel/sysfb_simplefb.c
>>> index 22513e9..fff44a5 100644
>>> --- a/arch/x86/kernel/sysfb_simplefb.c
>>> +++ b/arch/x86/kernel/sysfb_simplefb.c
>>> @@ -72,7 +72,7 @@ __init int create_simplefb(const struct screen_info *si,
>>>           * the part that is occupied by the framebuffer */
>>>          len = mode->height * mode->stride;
>>>          len = PAGE_ALIGN(len);
>>> -       if (len > si->lfb_size << 16) {
>>> +       if (len > ((unsigned long) si->lfb_size) << 16) {
>
> On 32-bit, "unsigned long" is the same size as __u32, so this doesn't
> make any difference.
>
>> Nice catch. vesafb uses "lfb_size * 65535" which causes an implicit
>> cast. I thought <<16 looks nicer but that doesn't do any implicit
>> cast..
>
> "lfb_size * 65535" is the same. "lfb_size" is __u32, "65535" is int.
> So there's no implicit cast. Or am I missing something?
>

<< 16 is * 65536 not 65535...

	-hpa



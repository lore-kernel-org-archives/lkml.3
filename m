Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754626AbaIDXfI (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Sep 2014 19:35:08 -0400
Received: from mail-lb0-f174.google.com ([209.85.217.174]:42765 "EHLO
	mail-lb0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750725AbaIDXfG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Sep 2014 19:35:06 -0400
MIME-Version: 1.0
In-Reply-To: <20140904231923.GA15320@khazad-dum.debian.net>
References: <1409855739-8985-1-git-send-email-toshi.kani@hp.com>
 <1409855739-8985-2-git-send-email-toshi.kani@hp.com> <20140904201123.GA9116@khazad-dum.debian.net>
 <5408C9C4.1010705@zytor.com> <20140904231923.GA15320@khazad-dum.debian.net>
From: Andy Lutomirski <luto@amacapital.net>
Date: Thu, 4 Sep 2014 16:34:43 -0700
Message-ID: <CALCETrWxKFtM8FhnHQz--uaHYbiqShE1XLJxMCKN7Rs4SO14eQ@mail.gmail.com>
Subject: Re: [PATCH 1/5] x86, mm, pat: Set WT to PA4 slot of PAT MSR
To: Henrique de Moraes Holschuh <hmh@hmh.eng.br>
Cc: "H. Peter Anvin" <hpa@zytor.com>, Toshi Kani <toshi.kani@hp.com>,
        Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>,
        akpm@linuxfoundation.org, Arnd Bergmann <arnd@arndb.de>,
        "linux-mm@kvack.org" <linux-mm@kvack.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Juergen Gross <jgross@suse.com>,
        Stefan Bader <stefan.bader@canonical.com>,
        Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Sep 4, 2014 at 4:19 PM, Henrique de Moraes Holschuh
<hmh@hmh.eng.br> wrote:
> On Thu, 04 Sep 2014, H. Peter Anvin wrote:
>> On 09/04/2014 01:11 PM, Henrique de Moraes Holschuh wrote:
>> > I am worried of uncharted territory, here.  I'd actually advocate for not
>> > enabling the upper four PAT entries on IA-32 at all, unless Windows 9X / XP
>> > is using them as well.  Is this a real concern, or am I being overly
>> > cautious?
>>
>> It is extremely unlikely that we'd have PAT issues in 32-bit mode and
>> not in 64-bit mode on the same CPU.
>
> Sure, but is it really a good idea to enable this on the *old* non-64-bit
> capable processors (note: I don't mean x86-64 processors operating in 32-bit
> mode) ?
>
>> As far as I know, the current blacklist rule is very conservative due to
>> lack of testing more than anything else.
>
> I was told that much in 2009 when I asked why cpuid 0x6d8 was blacklisted
> from using PAT :-)

At the very least, anyone who plugs an NV-DIMM into a 32-bit machine
is nuts, and not just because I'd be somewhat amazed if it even
physically fits into the slot. :)

--Andy

>
> --
>   "One disk to rule them all, One disk to find them. One disk to bring
>   them all and in the darkness grind them. In the Land of Redmond
>   where the shadows lie." -- The Silicon Valley Tarot
>   Henrique Holschuh



-- 
Andy Lutomirski
AMA Capital Management, LLC

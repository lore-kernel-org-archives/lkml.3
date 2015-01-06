Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754226AbbAFC0b (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Jan 2015 21:26:31 -0500
Received: from mail-lb0-f173.google.com ([209.85.217.173]:55832 "EHLO
	mail-lb0-f173.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751076AbbAFC03 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Jan 2015 21:26:29 -0500
MIME-Version: 1.0
In-Reply-To: <20150106021836.GA24121@node.dhcp.inet.fi>
References: <CAL82V5NN8U4PyiSjLxgpTrgsgkbM7rRCbVF5P-HHyEqphLOy+g@mail.gmail.com>
 <20141224220818.GA17655@amd> <20150105192329.5f32c155@lxorguk.ukuu.org.uk>
 <CALCETrXby82sgbGTcSZFj54t=resYcwtPbcFRNh6Ksbr+Ow8HQ@mail.gmail.com>
 <20150106014718.GA23775@node.dhcp.inet.fi> <CALCETrV1O1MFJeY6WacF+QHdBGG7HoHdVQy=n951=Y+=g+h7mQ@mail.gmail.com>
 <20150106021836.GA24121@node.dhcp.inet.fi>
From: Andy Lutomirski <luto@amacapital.net>
Date: Mon, 5 Jan 2015 18:26:07 -0800
Message-ID: <CALCETrXpJ7CPAKeh9nLA=PoCBT8w8NfhZg5cgUyG9BUtp2Jv+w@mail.gmail.com>
Subject: Re: DRAM unreliable under specific access patern
To: "Kirill A. Shutemov" <kirill@shutemov.name>
Cc: One Thousand Gnomes <gnomes@lxorguk.ukuu.org.uk>,
        Pavel Machek <pavel@ucw.cz>, Mark Seaborn <mseaborn@chromium.org>,
        kernel list <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jan 5, 2015 at 6:18 PM, Kirill A. Shutemov <kirill@shutemov.name> wrote:
> On Mon, Jan 05, 2015 at 05:57:24PM -0800, Andy Lutomirski wrote:
>> On Mon, Jan 5, 2015 at 5:47 PM, Kirill A. Shutemov <kirill@shutemov.name> wrote:
>> > On Mon, Jan 05, 2015 at 11:50:04AM -0800, Andy Lutomirski wrote:
>> >> On Mon, Jan 5, 2015 at 11:23 AM, One Thousand Gnomes
>> >> <gnomes@lxorguk.ukuu.org.uk> wrote:
>> >> >> In the meantime, I created test that actually uses physical memory,
>> >> >> 8MB apart, as described in some footnote. It is attached. It should
>> >> >> work, but it needs boot with specific config options and specific
>> >> >> kernel parameters.
>> >> >
>> >> > Why not just use hugepages. You know the alignment guarantees for 1GB
>> >> > pages and that means you don't even need to be root
>> >> >
>> >> > In fact - should we be disabling 1GB huge page support by default at this
>> >> > point, at least on non ECC boxes ?
>> >>
>> >> Can you actually damage anyone else's data using a 1 GB hugepage?
>> >
>> > hugetlbfs is a filesystem: the answer is yes. Although I don't see the
>> > issue as a big attach vector.
>>
>> What I mean is: if I map a 1 GB hugepage and rowhammer it, is it
>> likely that the corruption will be confined to the same 1 GB?
>
> I don't know for sure, but it looks likely to me according to claim in the
> paper (8MB). But it still can be sombody else's data: 644 file on
> hugetlbfs mmap()ed r/o by anyone.
>
> When I read the paper I thought that vdso would be interesting target for
> the attack, but having all these constrains in place, it's hard aim the
> attack anything widely used.
>

The vdso and the vvar page are both at probably-well-known physical
addresses, so you can at least target the kernel a little bit.  I
*think* that kASLR helps a little bit here.

--Andy

> --
>  Kirill A. Shutemov



-- 
Andy Lutomirski
AMA Capital Management, LLC

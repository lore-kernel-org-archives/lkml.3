Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751311AbaKFBAf (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Nov 2014 20:00:35 -0500
Received: from mail-ie0-f172.google.com ([209.85.223.172]:55419 "EHLO
	mail-ie0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750915AbaKFBAd convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Nov 2014 20:00:33 -0500
MIME-Version: 1.0
In-Reply-To: <xa1tsihxwblf.fsf@mina86.com>
References: <CADtm3G7DtGkvPk36Fiunwen8grw-94V6=iv82iusGumfNJkn-g@mail.gmail.com>
	<xa1tlhnq7ga7.fsf@mina86.com>
	<CADtm3G7bU6Y2aKco5Vb81KSqsy=FH9zmdDJm=Tixjoep1YeJ7Q@mail.gmail.com>
	<CAL1ERfMYmQcQ_sX7E0HC2bXmC-imh4T-7Q4nBVQRXkQSaTjvQQ@mail.gmail.com>
	<xa1tsihxwblf.fsf@mina86.com>
Date: Thu, 6 Nov 2014 09:00:33 +0800
Message-ID: <CAL1ERfMk+rhd=-MaLC2VVj61-T17_SVgKL4=Z_okhEYktFJ+tQ@mail.gmail.com>
Subject: Re: CMA alignment question
From: Weijie Yang <weijie.yang.kh@gmail.com>
To: Michal Nazarewicz <mina86@mina86.com>
Cc: Gregory Fong <gregory.0xf0@gmail.com>, linux-mm@kvack.org,
        Laura Abbott <lauraa@codeaurora.org>, iamjoonsoo.kim@lge.com,
        Marek Szyprowski <m.szyprowski@samsung.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Brian Norris <computersforpeace@gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Nov 6, 2014 at 6:01 AM, Michal Nazarewicz <mina86@mina86.com> wrote:
>> On Tue, Nov 04 2014, Gregory Fong wrote:
>>> The alignment in cma_alloc() is done w.r.t. the bitmap.  This is a
>>> problem when, for example:
>>>
>>> - a device requires 16M (order 12) alignment
>>> - the CMA region is not 16 M aligned
>
> On Wed, Nov 05 2014, Weijie Yang wrote:
>> I think the device driver should ensure that situation could not occur,
>> by assign suitable alignment parameter in cma_declare_contiguous().
>
> What about default CMA area? Besides, I think principle of least
> surprise applies here and alignment should be physical.

I agree the current code doesn't handle this issue properly.
However, I prefer to add specific usage to CMA interface rather than
modify the cma code, Because the latter hide the issue and could waste
memory.

> --
> Best regards,                                         _     _
> .o. | Liege of Serenely Enlightened Majesty of      o' \,=./ `o
> ..o | Computer Science,  Michał “mina86” Nazarewicz    (o o)
> ooo +--<mpn@google.com>--<xmpp:mina86@jabber.org>--ooO--(_)--Ooo--

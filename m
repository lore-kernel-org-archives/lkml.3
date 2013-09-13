Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755500Ab3IMLAO (ORCPT <rfc822;w@1wt.eu>);
	Fri, 13 Sep 2013 07:00:14 -0400
Received: from cantor2.suse.de ([195.135.220.15]:49799 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753428Ab3IMLAL (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 13 Sep 2013 07:00:11 -0400
Message-ID: <5232F037.4090504@suse.cz>
Date: Fri, 13 Sep 2013 13:00:07 +0200
From: Michal Marek <mmarek@suse.cz>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130801 Thunderbird/17.0.8
MIME-Version: 1.0
To: =?UTF-8?B?Q2zDqW1lbnQgQ2hhdXBsYW5uYXo=?= <chauplac@gmail.com>
Cc: Linus Walleij <linus.walleij@linaro.org>,
        "Yann E. MORIN" <yann.morin.1998@free.fr>,
        linux-kbuild <linux-kbuild@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 2/4] scripts/config: use sed's POSIX interface
References: <cover.1376600922.git.yann.morin.1998@free.fr> <83e8b90e1d2cc5ff5d2443f2486c2d786a4997ce.1376600922.git.yann.morin.1998@free.fr> <CACRpkdYjzGwaV0Eg5KZ7W_9YYkyiAXDc-9oagU49XWJUooVKdQ@mail.gmail.com> <CACW0xKXOKJXW+5m7JirKbsj4Em4SbVV0NeyK2x88x46dfJ4akw@mail.gmail.com> <CACRpkdY8nLnH5RG94kXuWBv=qb6osRSvGRODy3ywKDdHSGae5w@mail.gmail.com> <B58F4964-E48A-4D56-ABEE-C8E9514B2651@gmail.com>
In-Reply-To: <B58F4964-E48A-4D56-ABEE-C8E9514B2651@gmail.com>
X-Enigmail-Version: 1.5.2
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Dne 13.9.2013 11:54, Clément Chauplannaz napsal(a):
> On Sep 13, 2013, at 11:32 AM, Linus Walleij <linus.walleij@linaro.org> wrote:
> 
>> On Fri, Sep 13, 2013 at 10:38 AM, Clément Chauplannaz
>> <chauplac@gmail.com> wrote:
>>
>>> Thank you for this report. I was able to reproduce this bug and fix it.
>>
>> Thanks! Tested and works fine.
> Glad to read the patch solves your issue. Thanks for the quick feedback!
>>
>>> My previous commit changed the separator between sed's substitute
>>> command and its parameters, from ':' to '/'. The latter conflicted
>>> with the slashes found in the value of variable CMDLINE, as provided
>>> in your email.
>>
>> Hm it could actually be useful to be able to have colons in a CMDLINE,
>> I wonder if we can think about some better separator ... oh well that
>> is another issue, all old scripts work now anyway.
> Indeed config script may not work with all possible string values.
> My
> first concern for now was to fallback to previous interface. We may look
> into hardening the script later on.

Right. I will merge the patch because it reverts a regression. But feel
free to submit another patch that escapes the colons in $after. The
script already uses #!/bin/bash, so a "${after//:/\:}" should work.

Michal

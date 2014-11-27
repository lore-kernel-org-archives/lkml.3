Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1750994AbaK0T1A (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 Nov 2014 14:27:00 -0500
Received: from mail-wi0-f171.google.com ([209.85.212.171]:38852 "EHLO
	mail-wi0-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750780AbaK0T07 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 Nov 2014 14:26:59 -0500
MIME-Version: 1.0
In-Reply-To: <1417102910.5477463ec9948@mail.inbox.lv>
References: <1417102910.5477463ec9948@mail.inbox.lv>
Date: Thu, 27 Nov 2014 20:26:57 +0100
Message-ID: <CA+rthh-4Xa-vRsjvA7y9a64MFJbm8Kyt5o7shRZKZBF6HdMtxA@mail.gmail.com>
Subject: Re: bug in networking code causes GPF
From: Mathias Krause <minipli@googlemail.com>
To: =?UTF-8?B?0JTQtdC90LjRgdC60LAt0YDQtdC00LjRgdC60LA=?= 
	<slim@inbox.lv>
Cc: Daniel Borkmann <dborkman@redhat.com>, linux-net@vger.kernel.org,
        netdev@vger.kernel.org,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Florian Westphal <fw@strlen.de>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 27 November 2014 at 16:41, Дениска-редиска <slim@inbox.lv> wrote:
> well, I will try to disable CONFIG_PAX_MEMORY_SANITIZE.
> Will take some time to make sure that this resolve the issue

That should fix the issue for you. You could also try to add
"pax_sanitize_slab=0" to the kernel command line to disable slab
sanitization.

> Цитирование Daniel Borkmann <dborkman@redhat.com> :
>> On 11/27/2014 02:35 PM, Дениска-редиска wrote:
>> > [...]
>> > [354497.932330] ... RBX: fefefefefefefefe ...
>> > [...]
>> > [354497.934903] Code: c2 85 d2 49 8b 86 d0 04 00 00 74 14 66 45 85 ff 75 0e 65 ff 40 04 e8 85 f6 a4 ff 48 89 d8 eb 69 65 ff 00 48 8b 1b f6 c3 01 75 0f <8b> 43 10 39 45 00 b8 00 00 00 00 74 83 eb 9d 48 d1 eb 4c 39 eb

That's: mov    0x10(%rbx),%eax

RBX contains the PaX sanitize pattern, that's the reason for the #GP.
So this is very likely the bug Daniel mentioned.

Please update to a recent grsec kernel to get this issue fixed. It's
fixed in the stable patches as well as in the test patch.


Regards,
Mathias

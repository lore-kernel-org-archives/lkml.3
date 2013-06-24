Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752470Ab3FXBnH (ORCPT <rfc822;w@1wt.eu>);
	Sun, 23 Jun 2013 21:43:07 -0400
Received: from mail-pb0-f45.google.com ([209.85.160.45]:52943 "EHLO
	mail-pb0-f45.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752407Ab3FXBnE convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 23 Jun 2013 21:43:04 -0400
MIME-Version: 1.0
In-Reply-To: <51C2FABA.5050207@suse.cz>
References: <CA+qZnSSj+UCV9LUddS8qArnG5e8Q4wyC98B=awJ9TBbY+J6nBw@mail.gmail.com>
	<51C2FABA.5050207@suse.cz>
Date: Mon, 24 Jun 2013 09:43:03 +0800
Message-ID: <CA+qZnSQNrp3C=6_pjVMVGxK1rH9wOE1DerzQjT3v0njZvtz8ZA@mail.gmail.com>
Subject: Re:
From: tingwei liu <tingw.liu@gmail.com>
To: Jiri Slaby <jslaby@suse.cz>
Cc: linux-kernel@vger.kernel.org, Linus Torvalds <linus971@gmail.com>,
        Alan Cox <alan@lxorguk.ukuu.org.uk>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jun 20, 2013 at 8:51 PM, Jiri Slaby <jslaby@suse.cz> wrote:
> On 06/20/2013 02:28 PM, tingwei liu wrote:
>> Hi, dears:
>>
>>       On Suse 11 sp2 3.0.13 kernel. After a few days, Nginx reply
>> packets with src ip 0.0.0.0 and  dst ip 0.0.0.0。
>>       Just like https://bbs.archlinux.org/viewtopic.php?id=129304. Is
>> there a bug?
>
> You should better report this via suse's standard channels (suse
> support/bugzilla). We cannot help you otherwise.
>
> thanks,
> --
> js
> suse labs

The problem has been fixed. It is a known bug has fixed by Eric Dumazet.

commit dfd25ffffc132c00070eed64200e8950da5d7e9d
Author: Eric Dumazet <eric.dumazet@gmail.com>
Date:   Sat Mar 10 09:20:21 2012 +0000

    tcp: fix syncookie regression

    commit ea4fc0d619 (ipv4: Don't use rt->rt_{src,dst} in ip_queue_xmit())
    added a serious regression on synflood handling.

    Simon Kirby discovered a successful connection was delayed by 20 seconds
    before being responsive.

    In my tests, I discovered that xmit frames were lost, and needed ~4
    retransmits and a socket dst rebuild before being really sent.

    In case of syncookie initiated connection, we use a different path to
    initialize the socket dst, and inet->cork.fl.u.ip4 is left cleared.

    As ip_queue_xmit() now depends on inet flow being setup, fix this by
    copying the temp flowi4 we use in cookie_v4_check().

    Reported-by: Simon Kirby <sim@netnation.com>
    Bisected-by: Simon Kirby <sim@netnation.com>
    Signed-off-by: Eric Dumazet <eric.dumazet@gmail.com>
    Tested-by: Eric Dumazet <eric.dumazet@gmail.com>
    Signed-off-by: David S. Miller <davem@davemloft.net>

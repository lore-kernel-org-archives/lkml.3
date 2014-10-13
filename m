Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753587AbaJMLO4 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Oct 2014 07:14:56 -0400
Received: from mail-wg0-f52.google.com ([74.125.82.52]:51321 "EHLO
	mail-wg0-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753287AbaJMLOz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 Oct 2014 07:14:55 -0400
Message-ID: <543BB42B.30505@6wind.com>
Date: Mon, 13 Oct 2014 13:14:51 +0200
From: Nicolas Dichtel <nicolas.dichtel@6wind.com>
Reply-To: nicolas.dichtel@6wind.com
Organization: 6WIND
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Thunderbird/31.1.2
MIME-Version: 1.0
To: netdev@vger.kernel.org, linux-kernel@vger.kernel.org
CC: davem@davemloft.net, ebiederm@xmission.com, akpm@linux-foundation.org,
        adobriyan@gmail.com, rui.xiang@huawei.com, viro@zeniv.linux.org.uk,
        oleg@redhat.com, gorcunov@openvz.org, kirill.shutemov@linux.intel.com,
        grant.likely@secretlab.ca, tytso@mit.edu,
        Linus Torvalds <torvalds@linux-foundation.org>
Subject: Re: [PATCH linux v3 1/1] fs/proc: use a rb tree for the directory
 entries
References: <20141006.181448.1696747135961247651.davem@davemloft.net> <1412672559-5256-1-git-send-email-nicolas.dichtel@6wind.com> <1412672559-5256-2-git-send-email-nicolas.dichtel@6wind.com>
In-Reply-To: <1412672559-5256-2-git-send-email-nicolas.dichtel@6wind.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Le 07/10/2014 11:02, Nicolas Dichtel a écrit :
> The current implementation for the directories in /proc is using a single
> linked list. This is slow when handling directories with large numbers of
> entries (eg netdevice-related entries when lots of tunnels are opened).
>
> This patch replaces this linked list by a red-black tree.
>
> Here are some numbers:
>
> dummy30000.batch contains 30 000 times 'link add type dummy'.
>
> Before the patch:
> $ time ip -b dummy30000.batch
> real	2m31.950s
> user	0m0.440s
> sys	2m21.440s
> $ time rmmod dummy
> real	1m35.764s
> user	0m0.000s
> sys	1m24.088s
>
> After the patch:
> $ time ip -b dummy30000.batch
> real	2m0.874s
> user	0m0.448s
> sys	1m49.720s
> $ time rmmod dummy
> real	1m13.988s
> user	0m0.000s
> sys	1m1.008s
>
> The idea of improving this part was suggested by
> Thierry Herbelot <thierry.herbelot@6wind.com>.
>
> Signed-off-by: Nicolas Dichtel <nicolas.dichtel@6wind.com>
> Acked-by: David S. Miller <davem@davemloft.net>
> ---

I'm not sure who is in charge of taking this patch. Should I resend it to
someone else or is it already included in a tree?


Thank you,
Nicolas

Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932520Ab3BYKOR (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 Feb 2013 05:14:17 -0500
Received: from mailhub.sw.ru ([195.214.232.25]:35396 "EHLO relay.sw.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758546Ab3BYKOQ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 Feb 2013 05:14:16 -0500
Message-ID: <512B3957.1020505@parallels.com>
Date: Mon, 25 Feb 2013 14:13:43 +0400
From: Pavel Emelyanov <xemul@parallels.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:13.0) Gecko/20120605 Thunderbird/13.0
MIME-Version: 1.0
To: Andrey Vagin <avagin@openvz.org>
CC: linux-kernel@vger.kernel.org, criu@openvz.org, linux-api@vger.kernel.org,
        Roland McGrath <roland@redhat.com>, Oleg Nesterov <oleg@redhat.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
        David Howells <dhowells@redhat.com>, Dave Jones <davej@redhat.com>,
        "Michael Kerrisk (man-pages)" <mtk.manpages@gmail.com>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Pedro Alves <palves@redhat.com>
Subject: Re: [PATCH] ptrace: add ability to retrieve signals without removing
 from a queue (v2)
References: <1361786813-14652-1-git-send-email-avagin@openvz.org>
In-Reply-To: <1361786813-14652-1-git-send-email-avagin@openvz.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> +	for (i = 0; i < arg.nr; i++) {
> +		off = arg.off + i;
> +
> +		spin_lock_irq(&child->sighand->siglock);
> +		list_for_each_entry(q, &pending->list, list) {
> +			if (!off--) {
> +				copy_siginfo(&info, &q->info);
> +				break;
> +			}
> +		}
> +		spin_unlock_irq(&child->sighand->siglock);

What's the point of arg.nr if you for every single siginfo drop the lock
and perform linear search anyway?

Thanks,
Pavel

Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753293Ab3JVDC0 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Oct 2013 23:02:26 -0400
Received: from mail-oa0-f47.google.com ([209.85.219.47]:60582 "EHLO
	mail-oa0-f47.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753178Ab3JVDCY convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Oct 2013 23:02:24 -0400
MIME-Version: 1.0
In-Reply-To: <1382223537-10844-1-git-send-email-linus.luessing@web.de>
References: <1382223537-10844-1-git-send-email-linus.luessing@web.de>
Date: Mon, 21 Oct 2013 20:02:23 -0700
Message-ID: <CAM_iQpUq3EUu8GWsqbm_j9NonMGuWy0Qfimq1But9WrPsK8rbA@mail.gmail.com>
Subject: Re: [PATCH] Revert "bridge: only expire the mdb entry when query is received"
From: Cong Wang <xiyou.wangcong@gmail.com>
To: =?UTF-8?Q?Linus_L=C3=BCssing?= <linus.luessing@web.de>
Cc: Linux Kernel Network Developers <netdev@vger.kernel.org>,
        bridge@lists.linux-foundation.org,
        Stephen Hemminger <stephen@networkplumber.org>,
        "David S. Miller" <davem@davemloft.net>,
        LKML <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Oct 19, 2013 at 3:58 PM, Linus Lüssing <linus.luessing@web.de> wrote:
> While this commit was a good attempt to fix issues occuring when no
> multicast querier is present, this commit still has two more issues:
>
> 1) There are cases where mdb entries do not expire even if there is a
> querier present. The bridge will unnecessarily continue flooding
> multicast packets on the according ports.
>
> 2) Never removing an mdb entry could be exploited for a Denial of
> Service by an attacker on the local link, slowly, but steadily eating up
> all memory.
>

I raised the first issue too when I sent the patch, but Herbert said
it is not a problem. So, I will leave this to Herbert to decide.

For me, your patch makes sense.

Thanks.

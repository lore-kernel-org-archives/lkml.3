Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751905AbaLISHf (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Dec 2014 13:07:35 -0500
Received: from mail-qg0-f49.google.com ([209.85.192.49]:60646 "EHLO
	mail-qg0-f49.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751883AbaLISHc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Dec 2014 13:07:32 -0500
MIME-Version: 1.0
In-Reply-To: <6468.1418147500@turing-police.cc.vt.edu>
References: <6468.1418147500@turing-police.cc.vt.edu>
Date: Tue, 9 Dec 2014 10:07:31 -0800
Message-ID: <CANn89iJAN815z3TefSjj0uZyQQyH-wTiAckt3WeMc-F7DRgpKA@mail.gmail.com>
Subject: Re: linux-next 20141208 - net/sched/sch_fq_codel.c:97 suspicious RCU
From: Eric Dumazet <edumazet@google.com>
To: Valdis Kletnieks <Valdis.Kletnieks@vt.edu>
Cc: John Fastabend <john.r.fastabend@intel.com>,
        "David S. Miller" <davem@davemloft.net>, linux-kernel@vger.kernel.org,
        netdev <netdev@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Dec 9, 2014 at 9:51 AM, Valdis Kletnieks
<Valdis.Kletnieks@vt.edu> wrote:
> Spotted this in dmesg while investigating why my wireless broke
> sometime between next-20141201 and next-20141208.  Probably not
> related, as wireless has been broken on several boot attempts of -1208,
> but this has popped only once....
>
> Looks like the fault of
>
> commit 46e5da40aec256155cfedee96dd21a75da941f2c
> Author: John Fastabend <john.fastabend@gmail.com>
> Date:   Fri Sep 12 20:04:52 2014 -0700

Well, its a (harmless) typo : this should really be an
rcu_dereference_bh() instead of rcu_dereference()

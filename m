Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933225Ab3CGSSs (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Mar 2013 13:18:48 -0500
Received: from mail-pa0-f46.google.com ([209.85.220.46]:58149 "EHLO
	mail-pa0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932541Ab3CGSSr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Mar 2013 13:18:47 -0500
Message-ID: <1362680324.15793.219.camel@edumazet-glaptop>
Subject: Re: 3.9-rc1 NULL pointer crash at find_pid_ns
From: Eric Dumazet <eric.dumazet@gmail.com>
To: Sasha Levin <sasha.levin@oracle.com>
Cc: ebiederm@xmission.com, "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
        Li Zefan <lizefan@huawei.com>, CAI Qian <caiqian@redhat.com>,
        linux-kernel <linux-kernel@vger.kernel.org>,
        Containers <containers@lists.linux-foundation.org>
Date: Thu, 07 Mar 2013 10:18:44 -0800
In-Reply-To: <5138D8F2.5020900@oracle.com>
References: <611667212.10748821.1362649031475.JavaMail.root@redhat.com>
	 <513860E8.4080807@huawei.com> <876213wmwt.fsf@xmission.com>
	 <5138D001.8000409@oracle.com> <1362678371.15793.218.camel@edumazet-glaptop>
	 <5138D377.6040406@oracle.com> <87boavrspd.fsf@xmission.com>
	 <5138D8F2.5020900@oracle.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.3-0ubuntu6 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2013-03-07 at 13:14 -0500, Sasha Levin wrote:

> Okay, I'm even more confused now.
> 
> The expression in question is:
> 
> 	hlist_entry_safe(rcu_dereference_bh(hlist_first_rcu(head)))
> 
> You're saying that "rcu_dereference_bh(hlist_first_rcu(head))" can change between
> the two evaluations we do. That would mean that 'head' has changed in between, right?
> 
> In that case, the list itself has changed - which means that RCU has changed the
> list underneath us.
> 
> hlist_first_rcu() doesn't have any side-effects, it doesn't modify the list whatsoever,
> so the only thing that can change is 'head'. Why is it allowed to change if the list
> is protected by RCU?

Thats the point of RCU ;)

Things can change under us.




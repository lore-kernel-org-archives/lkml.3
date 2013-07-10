Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754355Ab3GJD52 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Jul 2013 23:57:28 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:41964 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754275Ab3GJD50 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Jul 2013 23:57:26 -0400
Date: Tue, 9 Jul 2013 20:57:55 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Li Zefan <lizefan@huawei.com>
Cc: "zhangwei(Jovi)" <jovi.zhangwei@huawei.com>,
        Ingo Molnar <mingo@redhat.com>, Steven Rostedt <rostedt@goodmis.org>,
        Jens Axboe <axboe@kernel.dk>, Al Viro <viro@zeniv.linux.org.uk>,
        Eric Dumazet <edumazet@google.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH V2] relay: fix timer madness
Message-Id: <20130709205755.aca39829.akpm@linux-foundation.org>
In-Reply-To: <51DCD6F6.2080802@huawei.com>
References: <51DCC48E.8050003@huawei.com>
	<51DCD6F6.2080802@huawei.com>
X-Mailer: Sylpheed 2.7.1 (GTK+ 2.18.9; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 10 Jul 2013 11:37:26 +0800 Li Zefan <lizefan@huawei.com> wrote:

> On 2013/7/10 10:18, zhangwei(Jovi) wrote:
> > When I'm using ktap script to tracing all event tracepoints by relay
> > transport, without this patch, the system will hang in few seconds.
> > 
> > I found the original patch discussion in 2007.
> > http://marc.info/?l=linux-kernel&m=118544794717162&w=2
> > (In that mail thread, the patch didn't fix that problem, but it fix
> > the problem I encountered now)
> > 
> > Changed from v1:
> > mod timer interval changed from jiffies+1 to HZ/10, as Ingo suggested.
> > 
> > Original patch changelog from Ingo in 2007:
> > 
> > Remove timer calls (!!!) from deep within the tracing infrastructure.
> > This was totally bogus code that can cause lockups and worse.
> > Poll the buffer every 2 jiffies for now.
> > 
> > Signed-off-by: Ingo Molnar <mingo@elte.hu>
> > Signed-off-by: "zhangwei(Jovi)" <jovi.zhangwei@huawei.com>
> > Cc: Steven Rostedt <rostedt@goodmis.org>
> > Cc: Jens Axboe <axboe@kernel.dk>
> > Cc: Al Viro <viro@zeniv.linux.org.uk>
> > Cc: Eric Dumazet <edumazet@google.com>
> > Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
> 
> I don't think this patch should have Andrew's signed-off-by?

I guess not, unless it was taken from -mm, which would be odd, as I
have the old version.

v1 has been in my tree for a few months - Ingo requested some updates
but nothing happened and I have not checked whether v2 addresses his
requests.


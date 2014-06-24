Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753143AbaFXOPK (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Jun 2014 10:15:10 -0400
Received: from mail.kernel.org ([198.145.19.201]:44820 "EHLO mail.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752322AbaFXOPI (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Jun 2014 10:15:08 -0400
Date: Tue, 24 Jun 2014 11:15:01 -0300
From: Arnaldo Carvalho de Melo <acme@kernel.org>
To: Stanislav Fomichev <stfomichev@yandex-team.ru>
Cc: a.p.zijlstra@chello.nl, paulus@samba.org, Ingo Molnar <mingo@kernel.org>,
        dsahern@gmail.com, jolsa@redhat.com, xiaoguangrong@linux.vnet.ibm.com,
        yangds.fnst@cn.fujitsu.com, adrian.hunter@intel.com,
        namhyung@kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2 0/7] perf trace pagefaults
Message-ID: <20140624141501.GA3456@kernel.org>
References: <1403261389-13423-1-git-send-email-stfomichev@yandex-team.ru>
 <20140620132105.GE31524@kernel.org>
 <20140620150318.GK15620@stfomichev-desktop.yandex.net>
 <20140620152449.GH31524@kernel.org>
 <20140620161859.GN15620@stfomichev-desktop.yandex.net>
 <20140620183028.GK31524@kernel.org>
 <20140623114139.GB20225@stfomichev-desktop.yandex.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140623114139.GB20225@stfomichev-desktop.yandex.net>
X-Url: http://acmel.wordpress.com
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Em Mon, Jun 23, 2014 at 03:41:39PM +0400, Stanislav Fomichev escreveu:
> > > But we then need to predefine many probes for decoding to work in the form of
> > > func:offset, and then play catch-up with all the kernel changes.
> > > Or I miss something important here?

> > No you don't.

> > If we want to disturb the system in the least way possible, we need to
> > tag along the copying from userspace of those pointers, so that we get
> > them fresh and just stash it in our ring buffer and get out of the way
> > quickly.

> I just thought maybe you have some grand plan in mind about automagically
> adding probes so argument tracing works transparently. I like the
> approach though.

First we use what we have in place, then we optimize it.
 
> > Almost a year ago, and it still works, now lets see the cset you mention...
> > 
> > [acme@zoo linux]$ git describe c4ad8f98bef77c7356aa6a9ad9188a6acc6b849d
> > v3.14-rc1-14-gc4ad8f98bef7
> > [acme@zoo linux]$
> > [root@zoo ~]# uname -r
> > 3.15.0-rc8+
> > 
> > Humm, what is the problem?

> I thought that result->name was actually set on 65th line of
> getname_flags, so the above commit would move it to 66th. But it's not
> the case, sorry for confusion.
 
> > [1] And I feel like all of tools/perf/ is just that, reference implementations, but hopefully
> >     done in a such a way that may well be useful as-is :-)

> I'd like perf to be a goto tool for all kind of performance analysis,

yay, and you're working for that, thanks!

> not just a reference implementation. I believe nobody looks at this
> reference, and we end up with tools like https://github.com/draios/sysdig

Never heard about it, will take a look, thanks for the pointer.

> which do their own events, ring buffer, etc.

There are several out there :)

- Arnaldo

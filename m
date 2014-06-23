Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753824AbaFWLlu (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Jun 2014 07:41:50 -0400
Received: from forward-corp1g.mail.yandex.net ([95.108.253.251]:45808 "EHLO
	forward-corp1g.mail.yandex.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753783AbaFWLlt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Jun 2014 07:41:49 -0400
X-Yandex-Uniq: f2218227-b348-45c9-b2c3-2c842100aa91
Authentication-Results: smtpcorp4.mail.yandex.net; dkim=pass header.i=@yandex-team.ru
Date: Mon, 23 Jun 2014 15:41:39 +0400
From: Stanislav Fomichev <stfomichev@yandex-team.ru>
To: Arnaldo Carvalho de Melo <acme@kernel.org>
Cc: a.p.zijlstra@chello.nl, paulus@samba.org, Ingo Molnar <mingo@kernel.org>,
        dsahern@gmail.com, jolsa@redhat.com, xiaoguangrong@linux.vnet.ibm.com,
        yangds.fnst@cn.fujitsu.com, adrian.hunter@intel.com,
        namhyung@kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2 0/7] perf trace pagefaults
Message-ID: <20140623114139.GB20225@stfomichev-desktop.yandex.net>
References: <1403261389-13423-1-git-send-email-stfomichev@yandex-team.ru>
 <20140620132105.GE31524@kernel.org>
 <20140620150318.GK15620@stfomichev-desktop.yandex.net>
 <20140620152449.GH31524@kernel.org>
 <20140620161859.GN15620@stfomichev-desktop.yandex.net>
 <20140620183028.GK31524@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140620183028.GK31524@kernel.org>
User-Agent: Mutt/1.5.22 (2013-10-16)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> > But we then need to predefine many probes for decoding to work in the form of
> > func:offset, and then play catch-up with all the kernel changes.
> > Or I miss something important here?
> 
> No you don't.
> 
> If we want to disturb the system in the least way possible, we need to
> tag along the copying from userspace of those pointers, so that we get
> them fresh and just stash it in our ring buffer and get out of the way
> quickly.
I just thought maybe you have some grand plan in mind about automagically
adding probes so argument tracing works transparently. I like the
approach though.

> Almost a year ago, and it still works, now lets see the cset you mention...
> 
> [acme@zoo linux]$ git describe c4ad8f98bef77c7356aa6a9ad9188a6acc6b849d
> v3.14-rc1-14-gc4ad8f98bef7
> [acme@zoo linux]$
> [root@zoo ~]# uname -r
> 3.15.0-rc8+
> 
> Humm, what is the problem?
I thought that result->name was actually set on 65th line of
getname_flags, so the above commit would move it to 66th. But it's not
the case, sorry for confusion.

> [1] And I feel like all of tools/perf/ is just that, reference implementations, but hopefully
>     done in a such a way that may well be useful as-is :-)
I'd like perf to be a goto tool for all kind of performance analysis,
not just a reference implementation. I believe nobody looks at this
reference, and we end up with tools like https://github.com/draios/sysdig
which do their own events, ring buffer, etc.

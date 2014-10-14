Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755349AbaJNRpn (ORCPT <rfc822;w@1wt.eu>);
	Tue, 14 Oct 2014 13:45:43 -0400
Received: from mx1.redhat.com ([209.132.183.28]:62676 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753866AbaJNRpl (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 14 Oct 2014 13:45:41 -0400
Date: Tue, 14 Oct 2014 19:42:29 +0200
From: Oleg Nesterov <oleg@redhat.com>
To: "Chen, Hanxiao" <chenhanxiao@cn.fujitsu.com>
Cc: "containers@lists.linux-foundation.org" 
	<containers@lists.linux-foundation.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Serge Hallyn <serge.hallyn@ubuntu.com>,
        "Eric W. Biederman" <ebiederm@xmission.com>,
        David Howells <dhowells@redhat.com>,
        Richard Weinberger <richard.weinberger@gmail.com>,
        Pavel Emelyanov <xemul@parallels.com>,
        Vasiliy Kulikov <segooon@gmail.com>, Mateusz Guzik <mguzik@redhat.com>
Subject: Re: [PATCHv4] procfs: show hierarchy of pid namespace
Message-ID: <20141014174229.GA31533@redhat.com>
References: <1412762198-21825-1-git-send-email-chenhanxiao@cn.fujitsu.com> <20141008151328.GB4835@redhat.com> <5871495633F38949900D2BF2DC04883E5E1649@G08CNEXMBPEKD02.g08.fujitsu.local> <20141009213414.GA10705@redhat.com> <5871495633F38949900D2BF2DC04883E5E864C@G08CNEXMBPEKD02.g08.fujitsu.local>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <5871495633F38949900D2BF2DC04883E5E864C@G08CNEXMBPEKD02.g08.fujitsu.local>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 10/13, Chen, Hanxiao wrote:
>
> > At the same time, for_each_process() in the global namespace can be
> > faster if there are a lot of sub-threads.
> >
> > > Perhaps that's not a good way.
> >
> > OK, I won't insist.
> >
> > although it would be nice to know why do you think this is bad.
> >
> I worried about it may slower in global namespace.
> But it will provide a great convenient way when query pid hierarchy
> when not in init_pid_ns.

Yes, it is not clear what is actually better, so ...

> I'll post a new patch using find_ge_pid + get_pid

Only if you think this makes more sense. I do not have a strong opinion.

And we can change the implementation at any time. The real problem is
the API this patch adds. I leave this to you and other reviewers who
understand the problem space better ;) Just I think that the changelog
could say a bit more, to explain why do we need this patch. IOW, explain
the problem and how/why this patch helps.

Oleg.


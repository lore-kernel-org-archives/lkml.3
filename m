Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752345AbaJYDQQ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 24 Oct 2014 23:16:16 -0400
Received: from static.92.5.9.176.clients.your-server.de ([176.9.5.92]:57458
	"EHLO mail.hallyn.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751102AbaJYDQN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 24 Oct 2014 23:16:13 -0400
Date: Sat, 25 Oct 2014 05:16:08 +0200
From: "Serge E. Hallyn" <serge@hallyn.com>
To: Aditya Kali <adityakali@google.com>
Cc: "Serge E. Hallyn" <serge@hallyn.com>, Tejun Heo <tj@kernel.org>,
        Li Zefan <lizefan@huawei.com>, Serge Hallyn <serge.hallyn@ubuntu.com>,
        Andy Lutomirski <luto@amacapital.net>, cgroups@vger.kernel.org,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Linux API <linux-api@vger.kernel.org>, Ingo Molnar <mingo@redhat.com>,
        Linux Containers <containers@lists.linux-foundation.org>
Subject: Re: [PATCHv1 5/8] cgroup: introduce cgroup namespaces
Message-ID: <20141025031608.GA13250@mail.hallyn.com>
References: <1413235430-22944-1-git-send-email-adityakali@google.com>
 <1413235430-22944-6-git-send-email-adityakali@google.com>
 <20141016163703.GE1392@mail.hallyn.com>
 <CAGr1F2E0VdBafZg6P2yeP6bgxsMEm53fEuT29HTLygTKobgi-w@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAGr1F2E0VdBafZg6P2yeP6bgxsMEm53fEuT29HTLygTKobgi-w@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Quoting Aditya Kali (adityakali@google.com):
> >> +void free_cgroup_ns(struct cgroup_namespace *ns)
> >> +{
> >> +     cgroup_put(ns->root_cgrp);
> >> +     put_user_ns(ns->user_ns);
> >
> > This is a problem on error patch in copy_cgroup_ns.  The
> > alloc_cgroup_ns() doesn't initialize these values, so if
> > you should fail in proc_alloc_inum() you'll show up here
> > with fandom values in ns->*.
> >
> 
> I don't see the codepath that leads to calling free_cgroup_ns() with
> uninitialized members. We don't call free_cgroup_ns() on the error
> path in copy_cgroup_ns().

Hm, yeah, I'm not seeing it now, sorry.

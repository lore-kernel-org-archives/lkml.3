Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752498AbaAPLCT (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 Jan 2014 06:02:19 -0500
Received: from mx1.redhat.com ([209.132.183.28]:24291 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751714AbaAPLCP (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 Jan 2014 06:02:15 -0500
From: Steve Grubb <sgrubb@redhat.com>
To: William Roberts <bill.c.roberts@gmail.com>
Cc: "linux-audit@redhat.com" <linux-audit@redhat.com>,
        "linux-mm@kvack.org" <linux-mm@kvack.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Richard Guy Briggs <rgb@redhat.com>,
        "viro@zeniv.linux.org.uk" <viro@zeniv.linux.org.uk>,
        akpm@linux-foundation.org, Stephen Smalley <sds@tycho.nsa.gov>,
        William Roberts <wroberts@tresys.com>
Subject: Re: [PATCH v3 3/3] audit: Audit proc cmdline value
Date: Thu, 16 Jan 2014 06:02:02 -0500
Message-ID: <2002335.9x4iUKkcnh@x2>
Organization: Red Hat
User-Agent: KMail/4.11.5 (Linux/3.12.7-300.fc20.x86_64; KDE/4.11.5; x86_64; ; )
In-Reply-To: <CAFftDdoi-9KZvuWz4czNMSWE=Y1tPQEhZVAeQb=S+jKQ=m8rZQ@mail.gmail.com>
References: <1389808934-4446-1-git-send-email-wroberts@tresys.com> <2708398.uWbqeU3VZe@x2> <CAFftDdoi-9KZvuWz4czNMSWE=Y1tPQEhZVAeQb=S+jKQ=m8rZQ@mail.gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wednesday, January 15, 2014 09:08:39 PM William Roberts wrote:
> >> > Try this,
> >> > 
> >> > cp /bin/ls 'test test test'
> >> > auditctll -a always,exit -F arch=b64 -S stat -k test
> >> > ./test\ test\ test './test\ test\ test'
> >> > auditctl -D
> >> > ausearch --start recent --key test
> >> > 
> >> >> On the event of weird chars, it gets hex escaped.
> >> > 
> >> > and its all in 1 lump with no escaping to figure out what is what.
> >> 
> >> Un-escape it. ausearch does this with paths. Then if you need to parse
> >> it, do it.
> > 
> > How can you? When you unescape cmdline for the example I gave, you will
> > have "./test test test ./test test test".  Which program ran and how many
> > arguments were passed? If we are trying to improve on what comm= provides
> > by having the full information, I have to be able to find out exactly
> > what the program name was so it can be used for searching. If that can't
> > be done, then we don't need this addition in its current form.
> 
> In your example, you will have an execve record, with it parsed, will you
> not?

Only if you change your patch.


> cmdline does not necessarily represent the arguments or process name.
> Sometimes it does, sometimes it doesn't. Just treat the thing as one
> string, perhaps do some form of substring matching in a tool. 

You are missing the point. The point is that you are trying to place trust in 
something that can be gamed. The audit system is designed such that it cannot 
be fooled very easily. Each piece of the subject and object are separated so 
that programs can be written to analyze events. What I am trying to say is now 
you are making something that concatenates fields with no way to regroup them 
later to reconstruct what really happened,


> To make this clear, I am not trying to improve on what comm provides.
> comm provides
> 16 chars for per thread name. The key is, its per thread, and can be
> anything. The
> "cmdline" value, is an arbitrary spot that is a global entity for the
> process. So in my change, all things coming into these events will have a
> similar cmdline audit. Which may help in narrowing down on whats going on
> in the system

It needs to be more trustworthy than this.

-Steve

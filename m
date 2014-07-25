Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935122AbaGYUae (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 Jul 2014 16:30:34 -0400
Received: from mail-vc0-f174.google.com ([209.85.220.174]:61255 "EHLO
	mail-vc0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759975AbaGYUad (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 Jul 2014 16:30:33 -0400
MIME-Version: 1.0
In-Reply-To: <53D2B7E2.5060200@redhat.com>
References: <1106785262.13440918.1406308542921.JavaMail.zimbra@redhat.com>
	<1717400531.13456321.1406309839199.JavaMail.zimbra@redhat.com>
	<20140725175257.GK17798@lenny.home.zabbo.net>
	<53D29D0C.2040606@redhat.com>
	<20140725182817.GL17798@lenny.home.zabbo.net>
	<53D2B7E2.5060200@redhat.com>
Date: Fri, 25 Jul 2014 16:30:32 -0400
Message-ID: <CAHQdGtSVk4uYE_6bPMwvH9E4HdedP0cbric8hh4TPkLs5u2wvQ@mail.gmail.com>
Subject: Re: [Cluster-devel] [RFC] readdirplus implementations: xgetdents vs
 dirreadahead syscalls
From: Trond Myklebust <trond.myklebust@primarydata.com>
To: Steven Whitehouse <swhiteho@redhat.com>
Cc: Zach Brown <zab@redhat.com>, Abhijith Das <adas@redhat.com>,
        linux-fsdevel <linux-fsdevel@vger.kernel.org>,
        cluster-devel <cluster-devel@redhat.com>,
        Linux Kernel mailing list <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jul 25, 2014 at 4:02 PM, Steven Whitehouse <swhiteho@redhat.com> wrote:
> Hi,
>
>
> On 25/07/14 19:28, Zach Brown wrote:
>>
>
>> How do the file systems that implement directory read-ahead today deal
>> with this?
>
> I don't know of one that does - or at least readahead of the directory info
> itself is one thing (which is relatively easy, and done by many file
> systems) its reading ahead the inodes within the directory which is more
> complex, and what we are talking about here.
>

NFS looks at whether or not there are lookup revalidations and/or
getattr calls in between the calls to readdir(). If there are, then we
assume an 'ls -l' workload, and continue to issue readdirplus calls to
the server.

Note that we also actively zap the readdir cache if we see getattr
calls over the wire, since the single call to readdirplus is usually
very much more efficient.

-- 
Trond Myklebust

Linux NFS client maintainer, PrimaryData

trond.myklebust@primarydata.com

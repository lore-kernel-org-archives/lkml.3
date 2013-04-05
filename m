Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1162240Ab3DEQ5U (ORCPT <rfc822;list-kernel77@spinics.net>);
	Fri, 5 Apr 2013 12:57:20 -0400
Received: from mail-ie0-f173.google.com ([209.85.223.173]:56572 "EHLO
	mail-ie0-f173.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1162136Ab3DEQ44 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 5 Apr 2013 12:56:56 -0400
MIME-Version: 1.0
In-Reply-To: <20130405155534.GC21852@quack.suse.cz>
References: <CALkWK0nRQi+vZeVR4LVzLewhR-dUZqYANRV7yH8grp-1J7=g8Q@mail.gmail.com>
 <20130405155534.GC21852@quack.suse.cz>
From: Ramkumar Ramachandra <artagnon@gmail.com>
Date: Fri, 5 Apr 2013 22:26:15 +0530
Message-ID: <CALkWK0ngNM-zrybHOtFGzm5aVnkFMPn1DP0h=2aUf=7b9_sh8A@mail.gmail.com>
Subject: Re: Beyond inotify recursive watches
To: Jan Kara <jack@suse.cz>
Cc: linux-kernel@vger.kernel.org, Junio C Hamano <gitster@pobox.com>,
        Thomas Rast <trast@inf.ethz.ch>,
        =?UTF-8?B?RHV5IE5ndXnhu4Vu?= <pclouds@gmail.com>,
        Jeff King <peff@peff.net>, Karsten Blees <karsten.blees@gmail.com>,
        Git List <git@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Jan Kara wrote:
>   Hum, I have somewhat hard time to understand what do you mean by
> 'magically optimized syscalls'. What should happen in VFS to speedup your
> load?

In retrospect, I think this is a terrible hack to begin with.  Tuning
the filesystem specifically for git repositories is inelegant on so
many levels, I can't recall why I ever thought it would be a good
idea.  Like all software, Git has scaling issues with ultra-large
repositories.  Too many stat() calls is just one of the problems:
there will be too many objects to do any operation at reasonable
speed, and the overall UX would just suck.  Instead of growing to a
huge monolithic beast that spawns off worker threads for everything
and ultimately dying off, I've decided that git should take a
different direction: it should work with well with many small
easily-composable repositories.  I've started work on this already,
and it looks very promising.

Let the filesystem people do what they do best: optimizing for all
applications uniformly.

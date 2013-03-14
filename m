Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933342Ab3CNBNS (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Mar 2013 21:13:18 -0400
Received: from mailout01.c08.mtsvc.net ([205.186.168.189]:38984 "EHLO
	mailout01.c08.mtsvc.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755609Ab3CNBNQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Mar 2013 21:13:16 -0400
Message-ID: <1363223574.25976.135.camel@thor.lan>
Subject: Re: [PATCH v5 00/44] ldisc patchset
From: Peter Hurley <peter@hurleysoftware.com>
To: Michel Lespinasse <walken@google.com>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Jiri Slaby <jslaby@suse.cz>, Sasha Levin <levinsasha928@gmail.com>,
        Dave Jones <davej@redhat.com>,
        Sebastian Andrzej Siewior <bigeasy@linutronix.de>,
        Shawn Guo <shawn.guo@linaro.org>, linux-kernel@vger.kernel.org,
        linux-serial@vger.kernel.org
Date: Wed, 13 Mar 2013 21:12:54 -0400
In-Reply-To: <CANN689HX1VAURYZL4=ixOSwim2LdYDgZyORtfUffrc4JCqK4xQ@mail.gmail.com>
References: <1361390599-15195-1-git-send-email-peter@hurleysoftware.com>
	 <1363034704-28036-1-git-send-email-peter@hurleysoftware.com>
	 <CANN689HvZK3gHyxRBPZyXwz2cJfheiEoQMA23oRARMCp=7GUCQ@mail.gmail.com>
	 <1363106846.27803.174.camel@thor.lan>
	 <CANN689HX1VAURYZL4=ixOSwim2LdYDgZyORtfUffrc4JCqK4xQ@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.6.3-0pjh1 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
X-Authenticated-User: 125194 peter@hurleysoftware.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2013-03-13 at 04:36 -0700, Michel Lespinasse wrote:
> Have you considered building your ldlock based on lib/rwsem-spinlock.c
> instead ? i.e. having an internal spinlock to protect the ldisc
> reference count and the reader and writer queues. This would seem much
> simpler get right. The downside would be that a spinlock would be
> taken for a short time whenever an ldisc reference is taken or
> released. I don't expect that the internal spinlock would get
> significant contention ?

That would have been too easy :)

TBH, I hadn't considered it until I was most the way through a working
atomic version. I had already split the reader/writer wait lists. And
figured out how to always use the wait bias for every waiting reader and
writer -- rather than the rwsem way of testing for an empty list --
which made the timeout handling easier.

At the time, the only thing that I was still struggling with was
recursion, and the spinlock flavor wasn't going to fix that. So I just
kept with the atomic flavor.



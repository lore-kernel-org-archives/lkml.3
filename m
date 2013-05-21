Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753929Ab3EUWiM (ORCPT <rfc822;w@1wt.eu>);
	Tue, 21 May 2013 18:38:12 -0400
Received: from mail-ve0-f171.google.com ([209.85.128.171]:47094 "EHLO
	mail-ve0-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753742Ab3EUWhv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 21 May 2013 18:37:51 -0400
MIME-Version: 1.0
In-Reply-To: <20130521223453.GY25399@ZenIV.linux.org.uk>
References: <CA+55aFyKg=m=USnRmFQNaRB_9MWNpzdLwxr-v7X0ONaG72+nsg@mail.gmail.com>
	<20130521223453.GY25399@ZenIV.linux.org.uk>
Date: Tue, 21 May 2013 15:37:50 -0700
X-Google-Sender-Auth: 47KGSKNbgPUbiyt846OT1oMGca4
Message-ID: <CA+55aFwouNkOUiEQO1RYX=bq_WR8AaiOgDv7irMV8uaQ3Anegg@mail.gmail.com>
Subject: Re: Stupid VFS name lookup interface..
From: Linus Torvalds <torvalds@linux-foundation.org>
To: Al Viro <viro@zeniv.linux.org.uk>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, May 21, 2013 at 3:34 PM, Al Viro <viro@zeniv.linux.org.uk> wrote:
>
> In principle, yes, but...  I wonder if those two cases are actually
> safe (especially ncpfs) right now.

Now I can agree that that may well be an issue.

I don't think my patch makes anything worse (because if the inode
isn't stable, we could have hit the before/after cases before, and the
new NULL case is trivial to handle).

But I'm certainly not going to claim that ncpfs doesn't already have a
race as-is. Just claiming that I wouldn't have made it worse ;)

> Let me dig around in that code a bit, OK?

Sure, no problem. This would be 3.11 material anyway, I'd expect.

                 Linus

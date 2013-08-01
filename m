Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755957Ab3HAQov (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 Aug 2013 12:44:51 -0400
Received: from mail-pd0-f169.google.com ([209.85.192.169]:58055 "EHLO
	mail-pd0-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751941Ab3HAQot (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 Aug 2013 12:44:49 -0400
Message-ID: <1375375486.10515.170.camel@edumazet-glaptop>
Subject: Re: [PATCH 0/8] include/net: next set of extern removals
From: Eric Dumazet <eric.dumazet@gmail.com>
To: Joe Perches <joe@perches.com>
Cc: David Howells <dhowells@redhat.com>, netdev@vger.kernel.org,
        linux-hams@vger.kernel.org, linux-wireless@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-afs@lists.infradead.org
Date: Thu, 01 Aug 2013 09:44:46 -0700
In-Reply-To: <1375374560.2034.52.camel@joe-AO722>
References: <cover.1375316912.git.joe@perches.com>
	 <24958.1375358650@warthog.procyon.org.uk>
	 <1375374560.2034.52.camel@joe-AO722>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.3-0ubuntu6 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2013-08-01 at 09:29 -0700, Joe Perches wrote:
> On Thu, 2013-08-01 at 13:04 +0100, David Howells wrote:
> > Joe Perches <joe@perches.com> wrote:
> > > Standardize on no extern use on function prototypes
> > Can we please standardise on _having_ externs on function prototypes?
> 
> Why?
> 
> What value is there in using extern for function prototypes?
> 
> Your argument for "picking out at a glance"
> https://lkml.org/lkml/2013/8/1/237
> really doesn't make sense to me.
> 
> Basically, anything with parentheses that's not a #define
> is an extern.
> 
> Exceptions exist for extern function pointers, but those
> are fairly unusual anyway.  Outside of netfilter,
> extern function pointers are only used about a dozen times
> total in the kernel tree.
> 
> So, please provide some examples supporting your view.

My main concern about these changes is they are a huge pain for us
doing bug tracking, rebases and backports. "git blame" and friends will
show lot of noise.

'extern' in include files are an easy way to have a grep friendly
marker, and otherwise are harmless.

_You_ believe they are useless, other people think otherwise.

I really don't see any value doing all these changes on existing code,
apart from adding noise to netdev and adding more work for us.

Using rules for new code is fine, but changing 10 years old code is
really not worth the pain.

I learned C 30 years ago, and using 'extern' is quite natural for me.

It's crazy the time we have to spend on these issues, while we have so
many bugs to fix in the kernel.




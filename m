Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752388AbaHRI0D (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Aug 2014 04:26:03 -0400
Received: from out1-smtp.messagingengine.com ([66.111.4.25]:46926 "EHLO
	out1-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752365AbaHRIZ7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Aug 2014 04:25:59 -0400
X-Sasl-enc: YoCWsqXzGw8153aUjg+TJCH+2XJj2IWCO+vacKaWMBHC 1408350358
Message-ID: <1408350340.2533.3.camel@perseus.fritz.box>
Subject: Re: [PATCH 0/5] RCU-walk support for autofs
From: Ian Kent <raven@themaw.net>
To: NeilBrown <neilb@suse.de>
Cc: autofs@vger.kernel.org, linux-kernel@vger.kernel.org
Date: Mon, 18 Aug 2014 16:25:40 +0800
In-Reply-To: <20140818062844.9860.43007.stgit@notabene.brown>
References: <20140818062844.9860.43007.stgit@notabene.brown>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.10.4 (3.10.4-3.fc20) 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2014-08-18 at 16:33 +1000, NeilBrown wrote:
> Hi Ian,
>  Have you had a chance to run your tests in these patches yet?
>  I've done what testing I can think of and cannot fault them.

I haven't, I've been plagued with illness so I'm not getting nearly
enough done. I'll try to put a kernel together and run the test in the
next week or so.

> 
>  This set is against 3.17-rc1 and make use of the new -EISDIR handling
>  for d_manage() and assumes the other patches which already went in
>  through Andrew Morton.
> 
>  I've added a section to autofs4.txt about mount namespaces, but it is
>  otherwise unchanged.
> 
>  If I could get an {Acked,Reviewed,Tested}-By in the next few weeks so
>  I can send them on to Andrew I would really appreciate it.
> 
> Thanks,
> NeilBrown
> 
> 
> 
> ---
> 
> NeilBrown (5):
>       autofs4: allow RCU-walk to walk through autofs4.
>       autofs4: factor should_expire() out of autofs4_expire_indirect.
>       autofs4: avoid taking fs_lock during rcu-walk
>       autofs4: d_manage() should return -EISDIR when appropriate in rcu-walk mode.
>       autofs: the documentation I wanted to read
> 
> 
>  Documentation/filesystems/autofs4.txt |  520 +++++++++++++++++++++++++++++++++
>  fs/autofs4/autofs_i.h                 |    6 
>  fs/autofs4/dev-ioctl.c                |    2 
>  fs/autofs4/expire.c                   |  200 ++++++++-----
>  fs/autofs4/root.c                     |   62 +++-
>  5 files changed, 694 insertions(+), 96 deletions(-)
>  create mode 100644 Documentation/filesystems/autofs4.txt
> 



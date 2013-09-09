Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753359Ab3IIObq (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Sep 2013 10:31:46 -0400
Received: from mail-ve0-f173.google.com ([209.85.128.173]:44936 "EHLO
	mail-ve0-f173.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751237Ab3IIObp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Sep 2013 10:31:45 -0400
MIME-Version: 1.0
In-Reply-To: <20130908084606.GA3938@cantor.Home>
References: <20130908084606.GA3938@cantor.Home>
Date: Mon, 9 Sep 2013 07:31:44 -0700
X-Google-Sender-Auth: 0Wnl0yJCCucjTPa7qzyjtQ6wzWg
Message-ID: <CA+55aFyvmOTb9J55c5D_0O0ydaf9ZYaaph1Y0ZVjpiDwU9fv6w@mail.gmail.com>
Subject: Re: suspicious RCU usage with unlazy_walk()
From: Linus Torvalds <torvalds@linux-foundation.org>
To: Jerry Snitselaar <jerry.snitselaar@oracle.com>
Cc: Waiman Long <Waiman.Long@hp.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Sep 8, 2013 at 1:46 AM, Jerry Snitselaar
<jerry.snitselaar@oracle.com> wrote:
> Running 3.11.0-07547-g44598f9 I hit the following last night. I have
> not had it reproduce since then. Should there be some lock cleanup in
> the error path prior to the dput() call like unlock_rcu_walk()?

Heh. I should have read more email yesterday, but I was too busy
looking at the dentry code, so I didn't get to some of my mailbox
until now.

Happily, the reason I was too busy was that I had noticed that my
d_rcu_to_refcount() changes were bad, and spent that time cleaning it
up and fixing this bug.

So this should be fixed in the current tree (current top of tree,
commit e5c832d55588 in particular).

               Linus

Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752346Ab3FBHOU (ORCPT <rfc822;w@1wt.eu>);
	Sun, 2 Jun 2013 03:14:20 -0400
Received: from ozlabs.org ([203.10.76.45]:33043 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750711Ab3FBHOS (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 2 Jun 2013 03:14:18 -0400
From: Rusty Russell <rusty@rustcorp.com.au>
To: Ben Greear <greearb@candelatech.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Cc: stable@kenel.org, Joe Lawrence <joe.lawrence@stratus.com>
Subject: Re: Please add to stable:  module: don't unlink the module until we've removed all exposure.
In-Reply-To: <51A8E884.1080009@candelatech.com>
References: <51A8E884.1080009@candelatech.com>
User-Agent: Notmuch/0.15.2+81~gd2c8818 (http://notmuchmail.org) Emacs/23.4.1 (i686-pc-linux-gnu)
Date: Sun, 02 Jun 2013 14:39:52 +0930
Message-ID: <87ehclumhr.fsf@rustcorp.com.au>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Ben Greear <greearb@candelatech.com> writes:

> It turns out, the bug I spent yesterday chasing in various 3.9 kernels is apparently
> fixed by the commit in the title (c9c390bb5535380d40614571894ef0c00bc026ff).

Apparently being the operative word.

This commit avoids the entire "module insert failed due to sysfs race"
path in the common case, it doesn't fix any actual problem.

I think the real commit you want is Linus' kobject fix
a49b7e82cab0f9b41f483359be83f44fbb6b4979 "kobject: fix kset_find_obj()
race with concurrent last kobject_put()".

Or is that already in stable?

Cheers,
Rusty.

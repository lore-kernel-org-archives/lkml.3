Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754052AbaBZVSw (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 Feb 2014 16:18:52 -0500
Received: from mail-pd0-f169.google.com ([209.85.192.169]:46834 "EHLO
	mail-pd0-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752867AbaBZVSv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 Feb 2014 16:18:51 -0500
MIME-Version: 1.0
Date: Wed, 26 Feb 2014 23:18:50 +0200
Message-ID: <CAJZOPZKLcFC5Wqv7VS7AyovaeHw3PYSWEz9t9sZ4AMhG+dS1+A@mail.gmail.com>
Subject: Re: [PATCH] mlx4: Use GFP_NOFS calls during the ipoib TX path when
 creating the QP
From: Or Gerlitz <or.gerlitz@gmail.com>
To: Jiri Kosina <jkosina@suse.cz>
Cc: Roland Dreier <roland@kernel.org>, Amir Vadai <amirv@mellanox.com>,
        Eli Cohen <eli@dev.mellanox.co.il>, Or Gerlitz <ogerlitz@mellanox.com>,
        Eugenia Emantayev <eugenia@mellanox.com>,
        "David S. Miller" <davem@davemloft.net>, Mel Gorman <mgorman@suse.de>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        linux-kernel <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Feb 26, 2014 at 12:55 AM, Jiri Kosina <jkosina@suse.cz> wrote:
> On Wed, 26 Feb 2014, Or Gerlitz wrote:
[...]
> That definitely can be verified, and I am putting it on my TODO list.

OK, thanks


> But let's make sure that we don't diverge from the original problem too
> much. Simple fact is that the deadlock is there when using connected mode,
> and there is nothing preventing users from using it this way, therefore I
> believe it should be fixed one way or another.

the patch is titled with "mlx4:" -- do you expect the problem to come
into play only when ipoib connected mode runs over the mlx4 driver?
what's about mlx5 or other upstream IB drivers?

I'll be looking on the details of the problem/solution, but this way
or another the API being module param sounds more like a hack....

Do we have a way to tell a net-device instance they should do their
memory allocations in a NOFS manner? if not, shouldn't we come up with
more general injection method?

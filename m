Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751734Ab3HTHHu (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Aug 2013 03:07:50 -0400
Received: from canardo.mork.no ([148.122.252.1]:39153 "EHLO canardo.mork.no"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751251Ab3HTHHs convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Aug 2013 03:07:48 -0400
From: =?utf-8?Q?Bj=C3=B8rn_Mork?= <bjorn@mork.no>
To: Miles Lane <miles.lane@gmail.com>
Cc: LKML <linux-kernel@vger.kernel.org>
Subject: Re: 3.11.0-rc6+: INFO: possible circular locking dependency detected
Organization: m
References: <CAHFgRy9p2vMjTm+1KTZKei5i66dvD6FP1xW2XrRxkrHvCHPAvw@mail.gmail.com>
Date: Tue, 20 Aug 2013 09:07:38 +0200
In-Reply-To: <CAHFgRy9p2vMjTm+1KTZKei5i66dvD6FP1xW2XrRxkrHvCHPAvw@mail.gmail.com>
	(Miles Lane's message of "Mon, 19 Aug 2013 22:26:06 -0700")
Message-ID: <8761v0j0w5.fsf@nemi.mork.no>
User-Agent: Gnus/5.11002 (No Gnus v0.20) Emacs/23.4 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Miles Lane <miles.lane@gmail.com> writes:

> [   24.990076] [ INFO: possible circular locking dependency detected ]
> [   24.990086] 3.11.0-rc6+ #154 Not tainted
> [   24.990094] -------------------------------------------------------
> [   24.990103] crda/1159 is trying to acquire lock:
> [   24.990111]  (genl_mutex){+.+.+.}, at: [<ffffffff812ff7e6>]
> genl_lock+0x12/0x14
> [   24.990134]
> [   24.990134] but task is already holding lock:
> [   24.990144]  (nlk->cb_mutex){+.+.+.}, at: [<ffffffff812fdab8>]
> netlink_dump+0x1c/0x1da

Yes, me too...  This is already discussed on netdev:
http://www.spinics.net/lists/stable/msg18179.html

But the fix is still out in the blue as far as I understand.  Reverting
58ad436fc will fix it, but leave the original problem (missing locking)
unfixed.


Bjørn


Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753972AbaCaSbG (ORCPT <rfc822;w@1wt.eu>);
	Mon, 31 Mar 2014 14:31:06 -0400
Received: from mail-vc0-f169.google.com ([209.85.220.169]:49057 "EHLO
	mail-vc0-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752803AbaCaSbD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 31 Mar 2014 14:31:03 -0400
MIME-Version: 1.0
In-Reply-To: <20140331175957.606100208@openvz.org>
References: <20140331175407.400476950@openvz.org>
	<20140331175957.606100208@openvz.org>
Date: Mon, 31 Mar 2014 22:31:02 +0400
Message-ID: <CANaxB-wY_=1QRAfvJxZjKPY6ZkgHuZOQvRm0FVktbj6-tL1CbA@mail.gmail.com>
Subject: Re: [rfc 2/2] docs: procfs -- Document timerfd output
From: Andrey Wagin <avagin@gmail.com>
To: Cyrill Gorcunov <gorcunov@openvz.org>
Cc: LKML <linux-kernel@vger.kernel.org>, Shawn Landden <shawn@churchofgit.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Andrew Morton <akpm@linux-foundation.org>,
        =?KOI8-R?B?8MHXxcwg5c3FzNjRzs/X?= <xemul@parallels.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2014-03-31 21:54 GMT+04:00 Cyrill Gorcunov <gorcunov@openvz.org>:
> CC: Shawn Landden <shawn@churchofgit.com>
> CC: Thomas Gleixner <tglx@linutronix.de>
> CC: Andrew Morton <akpm@linux-foundation.org>
> CC: Andrey Vagin <avagin@openvz.org>
> CC: Pavel Emelyanov <xemul@parallels.com>
> Signed-off-by: Cyrill Gorcunov <gorcunov@openvz.org>
> ---
>  Documentation/filesystems/proc.txt |    9 +++++++++
>  1 file changed, 9 insertions(+)
>
> Index: linux-2.6.git/Documentation/filesystems/proc.txt
> ===================================================================
> --- linux-2.6.git.orig/Documentation/filesystems/proc.txt
> +++ linux-2.6.git/Documentation/filesystems/proc.txt
> @@ -1741,6 +1741,15 @@ pair provide additional information part
>         While the first three lines are mandatory and always printed, the rest is
>         optional and may be omitted if no marks created yet.
>
> +       Timerfd files
> +       ~~~~~~~~~~~~~
> +       pos:    0
> +       flags:  02
> +       mnt_id: 9
> +       clockid: 0 ticks: 0

I would prefer to print "tick" on a separate line.

And we can print the current setting of the timer here. It can be
useful not only for CRIU but for other users too.

it_value: (5, 149234)
it_interval: (10, 0)

> +
> +       where 'clockid' is the clock type and 'ticks' is the number of the timer expirations
> +       that have occurred [see timerfd_create(2) for details].
>
>  ------------------------------------------------------------------------------
>  Configuring procfs
>

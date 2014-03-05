Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756977AbaCETq3 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Mar 2014 14:46:29 -0500
Received: from mail-pa0-f54.google.com ([209.85.220.54]:57785 "EHLO
	mail-pa0-f54.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756229AbaCETq1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Mar 2014 14:46:27 -0500
MIME-Version: 1.0
In-Reply-To: <alpine.LNX.2.00.1402252307130.5180@pobox.suse.cz>
References: <alpine.LNX.2.00.1402211450410.1192@pobox.suse.cz>
	<CAJZOPZK4Ah+nKPWnX3=yM43jbf586GYJ+fh0-OL4bOnqKK8v8A@mail.gmail.com>
	<alpine.LNX.2.00.1402252307130.5180@pobox.suse.cz>
Date: Wed, 5 Mar 2014 21:46:26 +0200
Message-ID: <CAJZOPZ+xKFwjrpWnBQDU=CU2XbjP00Qfgj8AYJ1SGHhf8U9O-A@mail.gmail.com>
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

On Wed, Feb 26, 2014 at 12:11 AM, Jiri Kosina <jkosina@suse.cz> wrote:
> The problem encountered was described as follows:
>         It's not memory reclamation that is the problem as such. There is
>         an indirect dependency between network filesystems writing back
>         pages and ipoib_cm_tx_init() due to how a kworker is used. Page
>         reclaim cannot make forward progress until ipoib_cm_tx_init()
>         succeeds and it is stuck in page reclaim itself waiting for network
>         transmission. Ordinarily this sitaution may be avoided by having
>         the caller use GFP_NOFS but ipoib_cm_tx_init() does not have
>         that information.

So to hit the bug, one just needs to attempt doing NFS client mount
over an IP subnet served by IPoIB NIC that uses connected-mode and
runs over mlx4 device?  Or this happens when  the connection is going
through teardown/re-establishment or something else?

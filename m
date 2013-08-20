Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751732Ab3HTTDD (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Aug 2013 15:03:03 -0400
Received: from s3.sipsolutions.net ([144.76.43.152]:56132 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750933Ab3HTTDC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Aug 2013 15:03:02 -0400
Message-ID: <1377025368.13829.21.camel@jlt4.sipsolutions.net>
Subject: Re: 3.11-rc6 genetlink locking fix offends lockdep
From: Johannes Berg <johannes@sipsolutions.net>
To: Hugh Dickins <hughd@google.com>
Cc: Ding Tianhong <dingtianhong@huawei.com>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Greg KH <gregkh@linuxfoundation.org>,
        "David S. Miller" <davem@davemloft.net>,
        "Otcheretianski, Andrei" <andrei.otcheretianski@intel.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "stable@vger.kernel.org" <stable@vger.kernel.org>,
        Pravin B Shelar <pshelar@nicira.com>, Thomas Graf <tgraf@suug.ch>
Date: Tue, 20 Aug 2013 21:02:48 +0200
In-Reply-To: <1376987338.13829.7.camel@jlt4.sipsolutions.net>
References: <alpine.LNX.2.00.1308182143370.906@eggly.anvils>
	 <1376899214.14734.6.camel@jlt4.sipsolutions.net>
	 <5211FAB3.7080400@huawei.com>
	 <1376911362.14734.11.camel@jlt4.sipsolutions.net>
	 <alpine.LNX.2.00.1308191147350.1505@eggly.anvils>
	 (sfid-20130819_205317_938941_E76DFECF) <1376987338.13829.7.camel@jlt4.sipsolutions.net>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.6.3-1 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2013-08-20 at 10:28 +0200, Johannes Berg wrote:

> The only way to fix this that I see right now (that doesn't rewrite the
> locking completely) would be to make genetlink use parallel_ops itself,
> thereby removing the genl_lock() in genl_rcv_msg() and breaking all
> those lock chains that lockdep reported. After that, it should be safe
> to use genl_lock() inside all the operations. Something like the patch
> below, perhaps? Completely untested so far.

Tested now, and it still causes lockdep to complain, though that's a
lockdep issue I believe, it thinks that genl_mutex and nlk->cb_mutex can
be inverted although nlk->cb_mutex exists per family, so we need to
annotate lockdep there.

johannes


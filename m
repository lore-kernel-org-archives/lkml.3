Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932647AbaJUTGU (ORCPT <rfc822;w@1wt.eu>);
	Tue, 21 Oct 2014 15:06:20 -0400
Received: from s3.sipsolutions.net ([5.9.151.49]:45303 "EHLO sipsolutions.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932402AbaJUTGS (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 21 Oct 2014 15:06:18 -0400
Message-ID: <1413918366.1998.10.camel@jlt4.sipsolutions.net>
Subject: Re: [PATCH 1/1 net-next] mac80211: remove unnecessary null test
 before debugfs_remove
From: Johannes Berg <johannes@sipsolutions.net>
To: Fabian Frederick <fabf@skynet.be>
Cc: linux-kernel@vger.kernel.org, "John W. Linville" <linville@tuxdriver.com>,
        "David S. Miller" <davem@davemloft.net>,
        linux-wireless@vger.kernel.org, netdev@vger.kernel.org
Date: Tue, 21 Oct 2014 21:06:06 +0200
In-Reply-To: <1413908412-5177-1-git-send-email-fabf@skynet.be>
References: <1413908412-5177-1-git-send-email-fabf@skynet.be>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.12.2-1+b1 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2014-10-21 at 18:20 +0200, Fabian Frederick wrote:
> Fix checkpatch warnings:
> 
>     WARNING: debugfs_remove(NULL) is safe this check is probably not required

I'll apply this; however, I think that checkpatch is a just tool, and
the commit message should reflect why you're changing the code.
Presumably you're not doing it to make the tool happy, but to address an
issue that the tool pointed out, so I think in most cases the commit
message should state the former, not the latter.

Note that in this particular case the NULL check check could be there to
avoid a memory write (which can be significant depending on the context)
so blindly doing what the tool suggested wouldn't always be a good idea.

johannes


Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751846AbaDAVeA (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 Apr 2014 17:34:00 -0400
Received: from shards.monkeyblade.net ([149.20.54.216]:55893 "EHLO
	shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751655AbaDAVd6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 Apr 2014 17:33:58 -0400
Date: Tue, 01 Apr 2014 17:33:54 -0400 (EDT)
Message-Id: <20140401.173354.1207821556865053650.davem@davemloft.net>
To: rgb@redhat.com
Cc: linux-audit@redhat.com, linux-kernel@vger.kernel.org,
        netfilter-devel@vger.kernel.org, netdev@vger.kernel.org,
        eparis@redhat.com, sgrubb@redhat.com, hadi@mojatatu.com
Subject: Re: [PATCH 0/3] netlink: per-protocol bind fixup/enhancement set
From: David Miller <davem@davemloft.net>
In-Reply-To: <cover.1396317747.git.rgb@redhat.com>
References: <20140324183406.GE28666@madcap2.tricolour.ca>
	<cover.1396317747.git.rgb@redhat.com>
X-Mailer: Mew version 6.5 on Emacs 24.3 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.7 (shards.monkeyblade.net [149.20.54.216]); Tue, 01 Apr 2014 14:33:58 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Richard Guy Briggs <rgb@redhat.com>
Date: Tue,  1 Apr 2014 10:14:55 -0400

> This set provides a way for per-protocol bind functions to signal an error and
> to be able to clean up after themselves.
> 
> The first patch has already been accepted, but is included just in case to
> avoid a merge error.
> 
> The second patch adds the per-protocol bind return code to signal to the
> netlink code that no further processing should be done and to undo the work
> already done.  This rev has fixed DaveM's last issue and flattened the
> intentation as requested by Patrick McHardy by two by reworking the logic.
> 
> The third provides a way per protocol to undo actions on DROP.
> 
> Thanks for the feedback.

I would like to defer this to the next merge window.

I'd also like to see how the AUDIT code is going to use this, provide
the user in your next submission.

Right now the only user is nfnetlink and it's merely to do a
(sub-)module request.

Therefore it's no surprise that we've never had any real well thought
out semantics defined for the bind method, and it's also why we never
thought of adding an unbind method before.

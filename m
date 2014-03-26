Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754821AbaCZARS (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Mar 2014 20:17:18 -0400
Received: from shards.monkeyblade.net ([149.20.54.216]:32922 "EHLO
	shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751482AbaCZARQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Mar 2014 20:17:16 -0400
Date: Tue, 25 Mar 2014 20:17:12 -0400 (EDT)
Message-Id: <20140325.201712.1651156258234145348.davem@davemloft.net>
To: dborkman@redhat.com
Cc: ast@plumgrid.com, netdev@vger.kernel.org, hagen@jauu.net,
        keescook@chromium.org, pmoore@redhat.com, mingo@kernel.org,
        hpa@linux.intel.com, linux-kernel@vger.kernel.org
Subject: Re: [PATCH net-next v2 8/9] net: filter: rework/optimize internal
 BPF interpreter's instruction set
From: David Miller <davem@davemloft.net>
In-Reply-To: <1395749457-16178-9-git-send-email-dborkman@redhat.com>
References: <1395749457-16178-1-git-send-email-dborkman@redhat.com>
	<1395749457-16178-9-git-send-email-dborkman@redhat.com>
X-Mailer: Mew version 6.5 on Emacs 24.3 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.7 (shards.monkeyblade.net [149.20.54.216]); Tue, 25 Mar 2014 17:17:16 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Daniel Borkmann <dborkman@redhat.com>
Date: Tue, 25 Mar 2014 13:10:56 +0100

>   - Conditional jt/jf targets replaced with jt/fall-through,
>     and forward/backward jumps now possible as well

Ummm... does anyone even remember why backwards jumps were not allowed
in the original BPF?

It's to guarentee forward progress in the filter.

Allowing branching backward would allow endless loops.

Please remove this feature.

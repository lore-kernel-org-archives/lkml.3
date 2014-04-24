Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754172AbaDXVMA (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Apr 2014 17:12:00 -0400
Received: from shards.monkeyblade.net ([149.20.54.216]:34753 "EHLO
	shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753343AbaDXVL6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Apr 2014 17:11:58 -0400
Date: Thu, 24 Apr 2014 17:11:55 -0400 (EDT)
Message-Id: <20140424.171155.806959282091051918.davem@davemloft.net>
To: vgoyal@redhat.com
Cc: luto@amacapital.net, tj@kernel.org, dwalsh@redhat.com,
        linux-kernel@vger.kernel.org, lpoetter@redhat.com, ssorce@redhat.com,
        cgroups@vger.kernel.org, kay@redhat.com, netdev@vger.kernel.org
Subject: Re: [PATCH 2/2] net: Implement SO_PASSCGROUP to enable passing
 cgroup path
From: David Miller <davem@davemloft.net>
In-Reply-To: <20140424210429.GD19091@redhat.com>
References: <20140424203427.GC19091@redhat.com>
	<20140424.164820.1543648508330465096.davem@davemloft.net>
	<20140424210429.GD19091@redhat.com>
X-Mailer: Mew version 6.5 on Emacs 24.1 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.7 (shards.monkeyblade.net [149.20.54.216]); Thu, 24 Apr 2014 14:11:58 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Vivek Goyal <vgoyal@redhat.com>
Date: Thu, 24 Apr 2014 17:04:29 -0400

> Does it really matter.

Good question, if it doesn't matter, you might as well log garbage.

There are a lot of logical holes in this discussion.

Real UIDs are always reported at sendmsg() time, not effective ones
(the UID "at sendmsg() time").

Therefore if we were to add CGROUP passing at sendmsg() time it should
report the "real cgroup", the one the task has at the time the file
descriptor / socket was "created".

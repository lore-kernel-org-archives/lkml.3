Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751660AbaAOURd (ORCPT <rfc822;w@1wt.eu>);
	Wed, 15 Jan 2014 15:17:33 -0500
Received: from shards.monkeyblade.net ([149.20.54.216]:38549 "EHLO
	shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750933AbaAOURc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 15 Jan 2014 15:17:32 -0500
Date: Wed, 15 Jan 2014 12:17:30 -0800 (PST)
Message-Id: <20140115.121730.1984913330507219167.davem@davemloft.net>
To: jkaluza@redhat.com
Cc: linux-kernel@vger.kernel.org, netdev@vger.kernel.org, eparis@redhat.com,
        rgb@redhat.com, tj@kernel.org, lizefan@huawei.com,
        containers@lists.linux-foundation.org, cgroups@vger.kernel.org,
        viro@zeniv.linux.org.uk
Subject: Re: [PATCH v4 0/3] Send audit/procinfo/cgroup data in socket-level
 control message
From: David Miller <davem@davemloft.net>
In-Reply-To: <1389600109-30739-1-git-send-email-jkaluza@redhat.com>
References: <1377614400-27122-1-git-send-email-jkaluza@redhat.com>
	<1389600109-30739-1-git-send-email-jkaluza@redhat.com>
X-Mailer: Mew version 6.5 on Emacs 24.1 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Jan Kaluza <jkaluza@redhat.com>
Date: Mon, 13 Jan 2014 09:01:46 +0100

> Changes introduced in this patchset can also increase performance
> of such server-like processes, because current way of opening and
> parsing /proc/$PID/* files is much more expensive than receiving these
> metadata using SCM.

The problem with this line of reasoning is that these changes will
hurt everyone else, because these new control messages are sent
unconditionally, whether the application is interested in them or not.

I really don't like this cost tradeoff, it's terrible, and therefore
I'm really not inclined to apply these patches, sorry.

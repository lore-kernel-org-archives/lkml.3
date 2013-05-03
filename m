Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932306Ab3ECAIV (ORCPT <rfc822;w@1wt.eu>);
	Thu, 2 May 2013 20:08:21 -0400
Received: from mail-qe0-f44.google.com ([209.85.128.44]:56133 "EHLO
	mail-qe0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752264Ab3ECAIS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 2 May 2013 20:08:18 -0400
Date: Thu, 2 May 2013 17:08:12 -0700
From: Tejun Heo <tj@kernel.org>
To: Colin Cross <ccross@android.com>
Cc: linux-pm@vger.kernel.org, linux-kernel@vger.kernel.org,
        "Rafael J. Wysocki" <rjw@sisk.pl>, arve@android.com,
        Oleg Nesterov <oleg@redhat.com>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>, Al Viro <viro@zeniv.linux.org.uk>,
        "Eric W. Biederman" <ebiederm@xmission.com>,
        Gao feng <gaofeng@cn.fujitsu.com>, netdev@vger.kernel.org
Subject: Re: [PATCH v2 10/10] af_unix: use freezable blocking calls in read
Message-ID: <20130503000812.GY19814@mtj.dyndns.org>
References: <1367458508-9133-1-git-send-email-ccross@android.com>
 <1367458508-9133-11-git-send-email-ccross@android.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1367458508-9133-11-git-send-email-ccross@android.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, May 01, 2013 at 06:35:08PM -0700, Colin Cross wrote:
> Avoid waking up every thread sleeping in read call on an AF_UNIX
> socket during suspend and resume by calling a freezable blocking
> call.  Previous patches modified the freezer to avoid sending
> wakeups to threads that are blocked in freezable blocking calls.
> 
> This call was selected to be converted to a freezable call because
> it doesn't hold any locks or release any resources when interrupted
> that might be needed by another freezing task or a kernel driver
> during suspend, and is a common site where idle userspace tasks are
> blocked.

Heh, so you are aware of the deadlock possibilities.  Good selection
of spots.  For all the conversion patches.

 Acked-by: Tejun Heo <tj@kernel.org>

Thanks.

-- 
tejun

Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756160AbaCEEJK (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Mar 2014 23:09:10 -0500
Received: from mail.linuxfoundation.org ([140.211.169.12]:45749 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755007AbaCEEJI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Mar 2014 23:09:08 -0500
Date: Tue, 4 Mar 2014 20:09:29 -0800
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: Roland Dreier <roland@kernel.org>
Cc: linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>,
        Shaohua Li <shaohua.li@intel.com>,
        Arjan van de Ven <arjan@infradead.org>
Subject: Re: [PATCH] Revert "driver core: synchronize device shutdown"
Message-ID: <20140305040929.GA31130@kroah.com>
References: <1393991871-1743-1-git-send-email-roland@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <1393991871-1743-1-git-send-email-roland@kernel.org>
User-Agent: Mutt/1.5.22 (2013-10-16)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Mar 04, 2014 at 07:57:51PM -0800, Roland Dreier wrote:
> From: Roland Dreier <roland@purestorage.com>
> 
> This reverts commit 401097ea4b89846d66ac78f7f108d49c2e922d9c.  The
> original changelog said:
> 
>     A patch series to make .shutdown execute asynchronously.  Some drivers's
>     shutdown can take a lot of time.  The patches can help save some shutdown
>     time.  The patches use Arjan's async API.
> 
>     This patch:
> 
>     synchronize all tasks submitted by .shutdown
> 
> However, I'm not able to find any evidence that any other patches from
> this series were applied, nor am I able to find any async tasks that are
> scheduled in a .shutdown context.
> 
> On the other hand, we see occasional hangs on shutdown that appear to be
> caused by the async_synchronize_full() in device_shutdown() waiting
> forever for the async probing in sd if a SCSI disk shows up at just the
> wrong time — the system starts the probe, but begins shutting down and
> tears down too much of the SCSI driver to finish the probe.
> 
> If we had any async shutdown tasks, I guess the right fix would be to
> create a "shutdown" async domain and have device_shutdown() only wait
> for that domain.  But since there apparently are no async shutdown
> tasks, we can just revert the waiting.
> 
> Signed-off-by: Roland Dreier <roland@purestorage.com>

Hm, no one seems to have said anything for the past 5 years about this.

Shaohua and Arjan, any objection to this being applied?

thanks,

greg k-h

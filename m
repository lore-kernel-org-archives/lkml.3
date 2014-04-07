Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755737AbaDGRTi (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 Apr 2014 13:19:38 -0400
Received: from smtp02.citrix.com ([66.165.176.63]:25958 "EHLO
	SMTP02.CITRIX.COM" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753310AbaDGRTe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 Apr 2014 13:19:34 -0400
X-IronPort-AV: E=Sophos;i="4.97,811,1389744000"; 
   d="scan'208";a="117567944"
Message-ID: <5342DE24.8080804@citrix.com>
Date: Mon, 7 Apr 2014 18:19:32 +0100
From: David Vrabel <david.vrabel@citrix.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.16) Gecko/20121215 Iceowl/1.0b1 Icedove/3.0.11
MIME-Version: 1.0
To: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
CC: <boris.ostrovsky@oracle.com>, <xen-devel@lists.xenproject.org>,
        <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 2/2] xen/manage: Poweroff forcefully if user-space is
 not yet up.
References: <1396637621-30113-1-git-send-email-konrad.wilk@oracle.com> <1396637621-30113-3-git-send-email-konrad.wilk@oracle.com>
In-Reply-To: <1396637621-30113-3-git-send-email-konrad.wilk@oracle.com>
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.80.2.76]
X-DLP: MIA2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 04/04/14 19:53, Konrad Rzeszutek Wilk wrote:
> The user can launch the guest in this sequence:
> 
> xl create -p /vm.cfg	[launch, but pause it]
> xl shutdown latest	[sets control/shutdown=poweroff]
> xl unpause latest
> xl console latest	[and see that the guest has completely
> ignored the shutdown request]
> 
> In reality the guest hasn't ignored it. It registers a watch
> and gets a notification that there is value. It then calls
> the shutdown_handler which ends up calling orderly_shutdown.
> 
> Unfortunately that is so early in the bootup that there
> are no user-space. Which means that the orderly_shutdown fails.
> But since the force flag was set to false it continues on without
> reporting.
> 
> What we really want to is to use the force when we are in the
> SYSTEM_BOOTING state and not use the 'force' when SYSTEM_RUNNING.
> 
> However, if we are in the running state - and the shutdown command
> has been given before the user-space has been setup, there is nothing
> we can do. Worst yet, we stop ignoring the 'xl shutdown' requests!
> 
> As such, the other part of this patch is to only stop ignoring
> the 'xl shutdown' when we are truly in the power off sequence.
> 
> That means the user can do multiple 'xl shutdown' and we will try
> to act on them instead of ignoring them.

Applied to devel/for-linus-3.15

> Fixes-Bug: http://bugs.xenproject.org/xen/bug/6
> Reported-by:  Alex Bligh <alex@alex.org.uk>
> Signed-off-by: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
> [v2: Add switch statement]
> [v3: Add a reboot notifier]

Can you put this version information after the --- in future?

Thanks.

David

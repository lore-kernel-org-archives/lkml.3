Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755509AbaDGR0W (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 Apr 2014 13:26:22 -0400
Received: from aserp1040.oracle.com ([141.146.126.69]:43368 "EHLO
	aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754044AbaDGRZ7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 Apr 2014 13:25:59 -0400
Date: Mon, 7 Apr 2014 13:25:52 -0400
From: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
To: David Vrabel <david.vrabel@citrix.com>
Cc: boris.ostrovsky@oracle.com, xen-devel@lists.xenproject.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 2/2] xen/manage: Poweroff forcefully if user-space is not
 yet up.
Message-ID: <20140407172552.GA3718@phenom.dumpdata.com>
References: <1396637621-30113-1-git-send-email-konrad.wilk@oracle.com>
 <1396637621-30113-3-git-send-email-konrad.wilk@oracle.com>
 <5342DE24.8080804@citrix.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <5342DE24.8080804@citrix.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Source-IP: acsinet22.oracle.com [141.146.126.238]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Apr 07, 2014 at 06:19:32PM +0100, David Vrabel wrote:
> On 04/04/14 19:53, Konrad Rzeszutek Wilk wrote:
> > The user can launch the guest in this sequence:
> > 
> > xl create -p /vm.cfg	[launch, but pause it]
> > xl shutdown latest	[sets control/shutdown=poweroff]
> > xl unpause latest
> > xl console latest	[and see that the guest has completely
> > ignored the shutdown request]
> > 
> > In reality the guest hasn't ignored it. It registers a watch
> > and gets a notification that there is value. It then calls
> > the shutdown_handler which ends up calling orderly_shutdown.
> > 
> > Unfortunately that is so early in the bootup that there
> > are no user-space. Which means that the orderly_shutdown fails.
> > But since the force flag was set to false it continues on without
> > reporting.
> > 
> > What we really want to is to use the force when we are in the
> > SYSTEM_BOOTING state and not use the 'force' when SYSTEM_RUNNING.
> > 
> > However, if we are in the running state - and the shutdown command
> > has been given before the user-space has been setup, there is nothing
> > we can do. Worst yet, we stop ignoring the 'xl shutdown' requests!
> > 
> > As such, the other part of this patch is to only stop ignoring
> > the 'xl shutdown' when we are truly in the power off sequence.
> > 
> > That means the user can do multiple 'xl shutdown' and we will try
> > to act on them instead of ignoring them.
> 
> Applied to devel/for-linus-3.15
> 
> > Fixes-Bug: http://bugs.xenproject.org/xen/bug/6
> > Reported-by:  Alex Bligh <alex@alex.org.uk>
> > Signed-off-by: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
> > [v2: Add switch statement]
> > [v3: Add a reboot notifier]
> 
> Can you put this version information after the --- in future?

Aye.
> 
> Thanks.
> 
> David

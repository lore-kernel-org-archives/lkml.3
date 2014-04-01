Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751552AbaDAODp (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 Apr 2014 10:03:45 -0400
Received: from aserp1040.oracle.com ([141.146.126.69]:46630 "EHLO
	aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751171AbaDAODn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 Apr 2014 10:03:43 -0400
Date: Tue, 1 Apr 2014 10:03:19 -0400
From: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
To: David Vrabel <david.vrabel@citrix.com>
Cc: Ian.Campbell@citrix.com, xen-devel@lists.xenproject.org,
        linux-kernel@vger.kernel.org, JBeulich@suse.com,
        boris.ostrovsky@oracle.com
Subject: Re: [PATCH 3/4] xen/manage: Guard against user-space initiated
 poweroff and XenBus.
Message-ID: <20140401140319.GA8207@phenom.dumpdata.com>
References: <1383932286-25080-1-git-send-email-konrad.wilk@oracle.com>
 <1383932286-25080-4-git-send-email-konrad.wilk@oracle.com>
 <533ABC8A.5080405@citrix.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <533ABC8A.5080405@citrix.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Source-IP: ucsinet21.oracle.com [156.151.31.93]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Apr 01, 2014 at 02:18:02PM +0100, David Vrabel wrote:
> On 08/11/13 17:38, Konrad Rzeszutek Wilk wrote:
> > There is a race case where the user does 'poweroff'
> > and at the same time the system admin does 'xl shutdown'.
> > 
> > Depending on the race, the system_state will be SYSTEM_RUNNING or
> > SYSTEM_POWER_OFF. If SYSTEM_RUNNING we just end up making
> > a duplicate call to 'poweroff' (while it is running).
> > 
> > That will fail or execute (And if executed then it will be
> > stuck in the reboot_mutex mutex). But nobody will care b/c the
> > machine is in poweroff sequence.
> 
> If this race isn't a problem...
> 
> > If the system_state is SYSTEM_POWER_OFF then we end up making
> > a duplicate call to kernel_power_off. There is no locking
> > there so we walk in the same steps as what 'poweroff'
> > has been doing.
> 
> ... and this one doesn't happen because do_power_off() calls
> orderly_poweroff(false) so does not call kernel_power_off().
> 
> Then isn't the patch unnecessary?

Yup :-)

I realized that once I wrote up the race condition.
> 
> David

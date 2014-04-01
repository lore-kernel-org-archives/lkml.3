Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751759AbaDANSI (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 Apr 2014 09:18:08 -0400
Received: from smtp02.citrix.com ([66.165.176.63]:46144 "EHLO
	SMTP02.CITRIX.COM" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751322AbaDANSG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 Apr 2014 09:18:06 -0400
X-IronPort-AV: E=Sophos;i="4.97,772,1389744000"; 
   d="scan'208";a="115679865"
Message-ID: <533ABC8A.5080405@citrix.com>
Date: Tue, 1 Apr 2014 14:18:02 +0100
From: David Vrabel <david.vrabel@citrix.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.16) Gecko/20121215 Iceowl/1.0b1 Icedove/3.0.11
MIME-Version: 1.0
To: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
CC: <Ian.Campbell@citrix.com>, <xen-devel@lists.xenproject.org>,
        <linux-kernel@vger.kernel.org>, <JBeulich@suse.com>,
        <boris.ostrovsky@oracle.com>
Subject: Re: [PATCH 3/4] xen/manage: Guard against user-space initiated poweroff
 and XenBus.
References: <1383932286-25080-1-git-send-email-konrad.wilk@oracle.com> <1383932286-25080-4-git-send-email-konrad.wilk@oracle.com>
In-Reply-To: <1383932286-25080-4-git-send-email-konrad.wilk@oracle.com>
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.80.2.76]
X-DLP: MIA1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 08/11/13 17:38, Konrad Rzeszutek Wilk wrote:
> There is a race case where the user does 'poweroff'
> and at the same time the system admin does 'xl shutdown'.
> 
> Depending on the race, the system_state will be SYSTEM_RUNNING or
> SYSTEM_POWER_OFF. If SYSTEM_RUNNING we just end up making
> a duplicate call to 'poweroff' (while it is running).
> 
> That will fail or execute (And if executed then it will be
> stuck in the reboot_mutex mutex). But nobody will care b/c the
> machine is in poweroff sequence.

If this race isn't a problem...

> If the system_state is SYSTEM_POWER_OFF then we end up making
> a duplicate call to kernel_power_off. There is no locking
> there so we walk in the same steps as what 'poweroff'
> has been doing.

... and this one doesn't happen because do_power_off() calls
orderly_poweroff(false) so does not call kernel_power_off().

Then isn't the patch unnecessary?

David

Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755785AbaIWOBA (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Sep 2014 10:01:00 -0400
Received: from mail-qa0-f45.google.com ([209.85.216.45]:57114 "EHLO
	mail-qa0-f45.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754040AbaIWOA6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Sep 2014 10:00:58 -0400
Date: Tue, 23 Sep 2014 10:00:53 -0400
From: Tejun Heo <tj@kernel.org>
To: Chuansheng Liu <chuansheng.liu@intel.com>
Cc: rjw@rjwysocki.net, linux-ide@vger.kernel.org, linux-kernel@vger.kernel.org,
        mister.freeman@laposte.net, rui.zhang@intel.com
Subject: Re: [PATCH] ata: Disabling the async PM for JMicron chips
Message-ID: <20140923140053.GG14905@mtj.dyndns.org>
References: <1411450671-2367-1-git-send-email-chuansheng.liu@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1411450671-2367-1-git-send-email-chuansheng.liu@intel.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Sep 23, 2014 at 01:37:51PM +0800, Chuansheng Liu wrote:
> Be similar with commit (ata: Disabling the async PM for JMicron chip 363/361),

Please use 12_DIGIT_SHA1_PREFIX ("SUBJ") format when referring to
commits.

> Barto found the similar issue for JMicron chip 368, that 363/368 has no
> parent-children relationship, but they have the power dependency.
> 
> So here we can exclude the JMicron chips out of pm_async method directly,
> to avoid further similar issues.
> 
> Details in:
> https://bugzilla.kernel.org/show_bug.cgi?id=84861
> 
> Reported-and-tested-by: Barto <mister.freeman@laposte.net>
> Signed-off-by: Chuansheng Liu <chuansheng.liu@intel.com>
> ---
>  drivers/ata/ahci.c         |    6 +++---
>  drivers/ata/pata_jmicron.c |    6 +++---
>  2 files changed, 6 insertions(+), 6 deletions(-)
> 
> diff --git a/drivers/ata/ahci.c b/drivers/ata/ahci.c
> index a0cc0ed..c096d49 100644
> --- a/drivers/ata/ahci.c
> +++ b/drivers/ata/ahci.c
> @@ -1345,10 +1345,10 @@ static int ahci_init_one(struct pci_dev *pdev, const struct pci_device_id *ent)
>  	 * follow the sequence one by one, otherwise one of them can not be
>  	 * powered on successfully, so here we disable the async suspend
>  	 * method for these chips.
> +	 * Jmicron chip 368 has been found has the similar issue, here we can
> +	 * exclude the Jmicron family directly to avoid other similar issues.

Let's update the comment as a whole instead of appending to it.

Thanks.

-- 
tejun

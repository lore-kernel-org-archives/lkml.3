Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934255AbaEFHyG (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 May 2014 03:54:06 -0400
Received: from atrey.karlin.mff.cuni.cz ([195.113.26.193]:37316 "EHLO
	atrey.karlin.mff.cuni.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934069AbaEFHyC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 May 2014 03:54:02 -0400
Date: Tue, 6 May 2014 09:53:53 +0200
From: Pavel Machek <pavel@ucw.cz>
To: Lv Zheng <lv.zheng@intel.com>
Cc: "Rafael J. Wysocki" <rafael.j.wysocki@intel.com>,
        Len Brown <len.brown@intel.com>, Lv Zheng <zetalog@gmail.com>,
        linux-kernel@vger.kernel.org, linux-acpi@vger.kernel.org,
        Bob Moore <robert.moore@intel.com>
Subject: Re: [PATCH 02/27] ACPICA: Utilities: Deploy ACPI_DEBUGGER_EXEC for
 ACPI_DEBUGGER enabled code in utglobal.c.
Message-ID: <20140506075353.GA20931@xo-6d-61-c0.localdomain>
References: <cover.1398817612.git.lv.zheng@intel.com>
 <53dbe352c16de24ea99d00af21eb01750af90074.1398817612.git.lv.zheng@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <53dbe352c16de24ea99d00af21eb01750af90074.1398817612.git.lv.zheng@intel.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed 2014-04-30 10:03:39, Lv Zheng wrote:
> This patch deploys ACPI_DEBUGGER_EXEC usage to utglobal.c to reduce "ifdef"
> of ACPI_DEBUGGER.  No functional changes.  Lv Zheng.
> 
> Signed-off-by: Lv Zheng <lv.zheng@intel.com>
> Signed-off-by: Bob Moore <robert.moore@intel.com>
> ---
>  drivers/acpi/acpica/utglobal.c |    4 +---
>  1 file changed, 1 insertion(+), 3 deletions(-)
> 
> diff --git a/drivers/acpi/acpica/utglobal.c b/drivers/acpi/acpica/utglobal.c
> index f3abeae..825b064 100644
> --- a/drivers/acpi/acpica/utglobal.c
> +++ b/drivers/acpi/acpica/utglobal.c
> @@ -377,9 +377,7 @@ acpi_status acpi_ut_init_globals(void)
>  	acpi_gbl_disable_mem_tracking = FALSE;
>  #endif
>  
> -#ifdef ACPI_DEBUGGER
> -	acpi_gbl_db_terminate_threads = FALSE;
> -#endif
> +	ACPI_DEBUGGER_EXEC(acpi_gbl_db_terminate_threads = FALSE);
>  
>  	return_ACPI_STATUS(AE_OK);

Is it just me or is this incredibly ugly?

									Pavel
-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html

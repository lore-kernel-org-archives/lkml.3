Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751322AbaALRS4 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 12 Jan 2014 12:18:56 -0500
Received: from cassarossa.samfundet.no ([193.35.52.29]:53838 "EHLO
	cassarossa.samfundet.no" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751054AbaALRSx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 12 Jan 2014 12:18:53 -0500
Date: Sun, 12 Jan 2014 18:18:48 +0100
From: Hans-Christian Egtvedt <egtvedt@samfundet.no>
To: Paul Gortmaker <paul.gortmaker@windriver.com>
Cc: linux-kernel@vger.kernel.org, Fengguang Wu <fengguang.wu@intel.com>,
        Haavard Skinnemoen <hskinnemoen@gmail.com>
Subject: Re: [PATCH] avr32: fix missing module.h causing build failure in
 mimc200/fram.c
Message-ID: <20140112171848.GB3773@samfundet.no>
References: <1389364179-18228-1-git-send-email-paul.gortmaker@windriver.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1389364179-18228-1-git-send-email-paul.gortmaker@windriver.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Around Fri 10 Jan 2014 09:29:39 -0500 or thereabout, Paul Gortmaker wrote:
> Causing this:
> 
> In file included from arch/avr32/boards/mimc200/fram.c:13:
> include/linux/miscdevice.h:51: error: field 'list' has incomplete type
> include/linux/miscdevice.h:55: error: expected specifier-qualifier-list before 'mode_t'
> arch/avr32/boards/mimc200/fram.c:42: error: 'THIS_MODULE' undeclared here (not in a function)
> 
> Reported-by: Fengguang Wu <fengguang.wu@intel.com>
> Cc: Haavard Skinnemoen <hskinnemoen@gmail.com>
> Cc: Hans-Christian Egtvedt <egtvedt@samfundet.no>
> Signed-off-by: Paul Gortmaker <paul.gortmaker@windriver.com>

Thank you for fixing, almost identical to Sergei Trofimovich patch, which
appeared first in my inbox.

Fix appended to the AVR32 tree.

> diff --git a/arch/avr32/boards/mimc200/fram.c b/arch/avr32/boards/mimc200/fram.c
> index 9764a1a1073e..c1466a872b9c 100644
> --- a/arch/avr32/boards/mimc200/fram.c
> +++ b/arch/avr32/boards/mimc200/fram.c
> @@ -11,6 +11,7 @@
>  #define FRAM_VERSION	"1.0"
>  
>  #include <linux/miscdevice.h>
> +#include <linux/module.h>
>  #include <linux/proc_fs.h>
>  #include <linux/mm.h>
>  #include <linux/io.h>
-- 
mvh
Hans-Christian Egtvedt

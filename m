Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753048AbaIZDLz (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Sep 2014 23:11:55 -0400
Received: from bombadil.infradead.org ([198.137.202.9]:39956 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752437AbaIZDLx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Sep 2014 23:11:53 -0400
Date: Thu, 25 Sep 2014 20:11:51 -0700
From: Darren Hart <dvhart@infradead.org>
To: Azael Avalos <coproscefalo@gmail.com>
Cc: platform-driver-x86@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 3/4] toshiba_acpi: Change HCI/SCI functions return code
 type
Message-ID: <20140926031151.GB40523@vmdeb7>
References: <1411518268-2773-1-git-send-email-coproscefalo@gmail.com>
 <1411518268-2773-4-git-send-email-coproscefalo@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1411518268-2773-4-git-send-email-coproscefalo@gmail.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Sep 23, 2014 at 06:24:27PM -0600, Azael Avalos wrote:
> Currently the HCI/SCI read/write functions are returning
> the status of the ACPI call and also assigning the
> returned value of the HCI/SCI function.
> 
> This patch changes such functions, returning the value
> of the HCI/SCI function instead of the ACPI call status.
> 
> The next patch will change all the HCI/SCI functions
> to reflect the change made in this patch.

If you are changing what the functions return in this patch, you also need to
update the call sites at the same time (same patch).

> 
> Signed-off-by: Azael Avalos <coproscefalo@gmail.com>
> ---
>  drivers/platform/x86/toshiba_acpi.c | 51 ++++++++++++++++++++-----------------
>  1 file changed, 27 insertions(+), 24 deletions(-)
> 
> diff --git a/drivers/platform/x86/toshiba_acpi.c b/drivers/platform/x86/toshiba_acpi.c
> index 5b16d11..43385f7 100644
> --- a/drivers/platform/x86/toshiba_acpi.c
> +++ b/drivers/platform/x86/toshiba_acpi.c
> @@ -316,47 +316,49 @@ static acpi_status tci_raw(struct toshiba_acpi_dev *dev,
>   * may be useful (such as "not supported").
>   */

The full text of the comment above is:

/* common hci tasks (get or set one or two value)
 *
 * In addition to the ACPI status, the HCI system returns a result which
 * may be useful (such as "not supported").
 */

Is this no longer relevant?

I agree that the return and status approach seems suboptimal, but I'm not clear on the motivation for the change. Is there something besides cleanup you're attempting to work toward with this series?

-- 
Darren Hart
Intel Open Source Technology Center

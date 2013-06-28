Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755610Ab3F1QFl (ORCPT <rfc822;w@1wt.eu>);
	Fri, 28 Jun 2013 12:05:41 -0400
Received: from userp1040.oracle.com ([156.151.31.81]:31790 "EHLO
	userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754229Ab3F1QFj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 28 Jun 2013 12:05:39 -0400
Date: Fri, 28 Jun 2013 12:05:13 -0400
From: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
To: Ben Guthro <benjamin.guthro@citrix.com>
Cc: Jan Beulich <jbeulich@suse.com>, "Rafael J . Wysocki" <rjw@sisk.pl>,
        linux-kernel@vger.kernel.org, linux-acpi@vger.kernel.org,
        xen-devel@lists.xen.org, tboot-devel@lists.sourceforge.net,
        Gang Wei <gang.wei@intel.com>
Subject: Re: [PATCH v5 4/5] x86/tboot: Fail extended mode reduced hardware
 sleep
Message-ID: <20130628160513.GC13468@phenom.dumpdata.com>
References: <1372427184-6197-1-git-send-email-benjamin.guthro@citrix.com>
 <1372427184-6197-5-git-send-email-benjamin.guthro@citrix.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1372427184-6197-5-git-send-email-benjamin.guthro@citrix.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Source-IP: ucsinet22.oracle.com [156.151.31.94]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jun 28, 2013 at 09:46:23AM -0400, Ben Guthro wrote:
> As tboot currently does not support the reduced hardware sleep
> interface, fail this extended call.
> 
> Signed-off-by: Jan Beulich <jbeulich@suse.com>
> Signed-off-by: Ben Guthro <benjamin.guthro@citrix.com>
> Cc: tboot-devel@lists.sourceforge.net
> Cc: Gang Wei <gang.wei@intel.com>
> ---
>  arch/x86/kernel/tboot.c |    3 +++
>  1 file changed, 3 insertions(+)
> 
> diff --git a/arch/x86/kernel/tboot.c b/arch/x86/kernel/tboot.c
> index d578c9c..57383b2 100644
> --- a/arch/x86/kernel/tboot.c
> +++ b/arch/x86/kernel/tboot.c
> @@ -285,6 +285,9 @@ static int tboot_sleep(u8 sleep_state, u32 pm1a_control, u32 pm1b_control,
>  	if (!tboot_enabled())
>  		return 0;
>  
> +	if (extended)
> +		return -1;

I would add WARN_ON just so that the user is aware of.
Perhaps

	if (WARN(extended,"tboot is not able to suspend on ACPI extended platforms. Contact
tboot-something mailing list please."))
		return -1

Otherwise
Reviewed-by: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>

> +
>  	tboot_copy_fadt(&acpi_gbl_FADT);
>  	tboot->acpi_sinfo.pm1a_cnt_val = pm1a_control;
>  	tboot->acpi_sinfo.pm1b_cnt_val = pm1b_control;
> -- 
> 1.7.9.5
> 

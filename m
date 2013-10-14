Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755579Ab3JNBK6 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 13 Oct 2013 21:10:58 -0400
Received: from mga14.intel.com ([143.182.124.37]:48126 "EHLO mga14.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755400Ab3JNBK4 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 13 Oct 2013 21:10:56 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.93,488,1378882800"; 
   d="scan'208";a="374232855"
Message-ID: <525B44C0.3010204@intel.com>
Date: Mon, 14 Oct 2013 09:11:28 +0800
From: Aaron Lu <aaron.lu@intel.com>
MIME-Version: 1.0
To: Lennart Poettering <lennart@poettering.net>, Len Brown <lenb@kernel.org>,
        "Rafael J. Wysocki" <rjw@sisk.pl>
CC: linux-acpi@vger.kernel.org, linux-kernel@vger.kernel.org,
        "Rafael J. Wysocki" <rjw@rjwysocki.net>
Subject: Re: [PATCH] acpi/video: Add Lenovo IdeaPad Yoga 13 to acpi video
 detect blacklist
References: <20131014005505.GA30503@tango.0pointer.de>
In-Reply-To: <20131014005505.GA30503@tango.0pointer.de>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 10/14/2013 08:55 AM, Lennart Poettering wrote:
> On the Yoga 13 the backlight control doesn't work via ACPI. (And doesn't
> work either with the low-level platform driver ideapad_laptop; but
> works correctly via the intel video driver).  This patch hence adds the
> Yoga 13 to the ACPI video detect blacklist, to make sure the broken ACPI
> backlight device is never exposed to userspace.
> 
> Note that this appears unrelated to the Windows 8 backlight issues tracked
> here:
> 
> https://bugzilla.kernel.org/show_bug.cgi?id=51231
> https://bugzilla.kernel.org/show_bug.cgi?id=60682
> 
> The Yoga's ACPI backlight controls work neither with nor without
> acpi_osi="!Windows 2012" on the kernel command line. It appears that
> backlight control via the EC simply is not available at all, regardless
> whether done via ACPI or via the vendor driver.

Just a side note, if the firmware of Yoga 13 has a _OSI("Windows 2012")
query, then it should be solved with the patch proposed here:
https://lkml.org/lkml/2013/10/11/409, Fix Win8 backlight issue.

We are still discussing a proper default behaviour in that patchset.

Thanks,
Aaron

> 
> Signed-off-by: Lennart Poettering <lennart@poettering.net>
> ---
>  drivers/acpi/video_detect.c | 8 ++++++++
>  1 file changed, 8 insertions(+)
> 
> diff --git a/drivers/acpi/video_detect.c b/drivers/acpi/video_detect.c
> index 940edbf..a88e8f7 100644
> --- a/drivers/acpi/video_detect.c
> +++ b/drivers/acpi/video_detect.c
> @@ -168,6 +168,14 @@ static struct dmi_system_id video_detect_dmi_table[] = {
>  		DMI_MATCH(DMI_PRODUCT_NAME, "UL30A"),
>  		},
>  	},
> +	{
> +	.callback = video_detect_force_vendor,
> +	.ident = "Lenovo Yoga 13",
> +	.matches = {
> +		DMI_MATCH(DMI_SYS_VENDOR, "LENOVO"),
> +		DMI_MATCH(DMI_PRODUCT_VERSION, "Lenovo IdeaPad Yoga 13"),
> +		},
> +	},
>  	{ },
>  };
>  
> 


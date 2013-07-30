Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755774Ab3G3NvZ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Jul 2013 09:51:25 -0400
Received: from hydra.sisk.pl ([212.160.235.94]:47459 "EHLO hydra.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753494Ab3G3NvW (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Jul 2013 09:51:22 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: tianyu.lan@intel.com
Cc: lenb@kernel.org, linux-acpi@vger.kernel.org,
        jan.christian.hoffmann@gmail.com, LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] ACPI/Battery: Fix parsing _BIX return value
Date: Tue, 30 Jul 2013 16:01:33 +0200
Message-ID: <14636369.9qhdcKOf8e@vostro.rjw.lan>
User-Agent: KMail/4.9.5 (Linux/3.10.0+; KDE/4.9.5; x86_64; ; )
In-Reply-To: <1375149298-28206-1-git-send-email-tianyu.lan@intel.com>
References: <1375149298-28206-1-git-send-email-tianyu.lan@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="utf-8"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday, July 30, 2013 09:54:58 AM tianyu.lan@intel.com wrote:
> From: Lan Tianyu <tianyu.lan@intel.com>
> 
> The _BIX method returns extended battery info as a package. According
> ACPI spec 10.2.2.2, the first member should be "Revision". However,
> current acpi battery driver treats the first member as "Power Unit"
> which should be the second member. So the parsing operation is mismatch.
> This patch is to fix it.
> 
> Reported-and-tested-by: Jan Hoffmann <jan.christian.hoffmann@gmail.com>
> Reference: http://bugzilla.kernel.org/show_bug.cgi?id=60519
> CC: stable@vger.kernel.org  #v2.6.34+
> Signed-off-by: Lan Tianyu <tianyu.lan@intel.com>

Well, that's one of the most embarrassing bugs I've ever seen. :-)

Queued up as a fix for 3.11.

Thanks,
Rafael


> ---
>  drivers/acpi/battery.c | 2 ++
>  1 file changed, 2 insertions(+)
> 
> diff --git a/drivers/acpi/battery.c b/drivers/acpi/battery.c
> index c760b61..2c9958c 100644
> --- a/drivers/acpi/battery.c
> +++ b/drivers/acpi/battery.c
> @@ -117,6 +117,7 @@ struct acpi_battery {
>  	struct acpi_device *device;
>  	struct notifier_block pm_nb;
>  	unsigned long update_time;
> +	int revision;
>  	int rate_now;
>  	int capacity_now;
>  	int voltage_now;
> @@ -359,6 +360,7 @@ static struct acpi_offsets info_offsets[] = {
>  };
>  
>  static struct acpi_offsets extended_info_offsets[] = {
> +	{offsetof(struct acpi_battery, revision), 0},
>  	{offsetof(struct acpi_battery, power_unit), 0},
>  	{offsetof(struct acpi_battery, design_capacity), 0},
>  	{offsetof(struct acpi_battery, full_charge_capacity), 0},
> 
-- 
I speak only for myself.
Rafael J. Wysocki, Intel Open Source Technology Center.

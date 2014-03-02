Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753416AbaCBAYq (ORCPT <rfc822;w@1wt.eu>);
	Sat, 1 Mar 2014 19:24:46 -0500
Received: from v094114.home.net.pl ([79.96.170.134]:56650 "HELO
	v094114.home.net.pl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1753320AbaCBAYo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 1 Mar 2014 19:24:44 -0500
From: "Rafael J. Wysocki" <rjw@rjwysocki.net>
To: "Li, Aubrey" <aubrey.li@linux.intel.com>
Cc: linux-kernel@vger.kernel.org, linux-acpi@vger.kernel.org,
        Len.Brown@intel.com, "alan@linux.intel.com" <alan@linux.intel.com>,
        "Raj, Ashok" <ashok.raj@intel.com>
Subject: Re: [PATCH] ACPI/Sleep: pm_power_off need more sanity check to be installed
Date: Sun, 02 Mar 2014 01:39:49 +0100
Message-ID: <2386234.LOj9mo4PX0@vostro.rjw.lan>
User-Agent: KMail/4.11.5 (Linux/3.13.0+; KDE/4.11.5; x86_64; ; )
In-Reply-To: <53110C97.3040207@linux.intel.com>
References: <530D558D.6090607@linux.intel.com> <53101FAB.3080609@linux.intel.com> <53110C97.3040207@linux.intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="utf-8"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Saturday, March 01, 2014 06:24:23 AM Li, Aubrey wrote:
> On 2014/2/28 13:33, Li, Aubrey wrote:
> > On 2014/2/27 7:50, Rafael J. Wysocki wrote:
> >> On Wednesday, February 26, 2014 10:46:37 AM Li, Aubrey wrote:
> >>> Sleep control and status registers need santity check before ACPI
> >>> install acpi_power_off to pm_power_off hook. The checking code in
> >>> acpi_enter_sleep_state() is too late, we should not allow a not-working
> >>> pm_power_off function hooked.
> >>>
> >>> Signed-off-by: Aubrey Li <aubrey.li@intel.com>
> >>> ---
> >>>  drivers/acpi/sleep.c |    7 +++++--
> >>>  1 file changed, 5 insertions(+), 2 deletions(-)
> >>>
> >>> diff --git a/drivers/acpi/sleep.c b/drivers/acpi/sleep.c
> >>> index b718806..0284d22 100644
> >>> --- a/drivers/acpi/sleep.c
> >>> +++ b/drivers/acpi/sleep.c
> >>> @@ -809,8 +809,11 @@ int __init acpi_sleep_init(void)
> >>>  	status = acpi_get_sleep_type_data(ACPI_STATE_S5, &type_a, &type_b);
> >>>  	if (ACPI_SUCCESS(status)) {
> >>>  		sleep_states[ACPI_STATE_S5] = 1;
> >>
> >> Do we still want to set this if the check below fails?  If so, then why?
> > 
> > We know \_S5_ is valid. The fault is sleep registers, not S5 ACPI object
> 
> Hi Rafael, do you still have any concern?

Well, I simply don't think we should say that it is "supported" if we aren't
going to do anything with it.


> >>
> >>> -		pm_power_off_prepare = acpi_power_off_prepare;
> >>> -		pm_power_off = acpi_power_off;
> >>> +		if (acpi_gbl_FADT.sleep_control.address &&
> >>> +			acpi_gbl_FADT.sleep_status.address) {
> >>> +			pm_power_off_prepare = acpi_power_off_prepare;
> >>> +			pm_power_off = acpi_power_off;
> >>> +		}
> >>>  	}
> >>>
> >>>  	supported[0] = 0;
> >>>
> >>
> > 
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-acpi" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html

-- 
I speak only for myself.
Rafael J. Wysocki, Intel Open Source Technology Center.

Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754143Ab3G2CWg (ORCPT <rfc822;w@1wt.eu>);
	Sun, 28 Jul 2013 22:22:36 -0400
Received: from mga03.intel.com ([143.182.124.21]:38184 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752258Ab3G2CWb convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 28 Jul 2013 22:22:31 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.89,766,1367996400"; 
   d="scan'208";a="274586292"
From: "Zheng, Lv" <lv.zheng@intel.com>
To: konrad wilk <konrad.wilk@oracle.com>
CC: Ben Guthro <benjamin.guthro@citrix.com>,
        "Moore, Robert" <robert.moore@intel.com>,
        Jan Beulich <jbeulich@suse.com>, "Rafael J . Wysocki" <rjw@sisk.pl>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-acpi@vger.kernel.org" <linux-acpi@vger.kernel.org>,
        "xen-devel@lists.xen.org" <xen-devel@lists.xen.org>
Subject: RE: [PATCH v3 1/3] acpi: Call acpi_os_prepare_sleep hook in reduced
 hardware sleep path
Thread-Topic: [PATCH v3 1/3] acpi: Call acpi_os_prepare_sleep hook in
 reduced hardware sleep path
Thread-Index: AQHOcnac189PXIyTT0GA11YOlMneHJlQ7d+w///Zo4CAIr75sP//2WoAgAAVrYCAAAE8AIAAFSaAgAAJ4gCAABXVAIABGJaQ//9/24AAETff8AAEqI4AAC+Ir5AAD09bgACGQwHg
Date: Mon, 29 Jul 2013 02:22:25 +0000
Message-ID: <1AE640813FDE7649BE1B193DEA596E88024362B4@SHSMSX101.ccr.corp.intel.com>
References: <1AE640813FDE7649BE1B193DEA596E88024352D2@SHSMSX101.ccr.corp.intel.com>
 <51EFC1FE.5000609@citrix.com>
 <94F2FBAB4432B54E8AACC7DFDE6C92E36FEA87FF@ORSMSX103.amr.corp.intel.com>
 <51EFD536.8070209@citrix.com>
 <94F2FBAB4432B54E8AACC7DFDE6C92E36FEA884D@ORSMSX103.amr.corp.intel.com>
 <51EFEF3E.8020001@citrix.com> <20130724163214.GB6308@phenom.dumpdata.com>
 <1AE640813FDE7649BE1B193DEA596E88024356ED@SHSMSX101.ccr.corp.intel.com>
 <CAOvdn6WZFu7TssoML3J9SPpqH_AKSi4cjvZ7Tb0zdBtq46QO0Q@mail.gmail.com>
 <1AE640813FDE7649BE1B193DEA596E8802435734@SHSMSX101.ccr.corp.intel.com>
 <20130725120414.GA22964@konrad-lan.dumpdata.com>
 <1AE640813FDE7649BE1B193DEA596E8802435C4C@SHSMSX101.ccr.corp.intel.com>
 <51F2B9FB.2070402@oracle.com>
In-Reply-To: <51F2B9FB.2070402@oracle.com>
Accept-Language: zh-CN, en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [10.239.127.40]
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

We can find the maintainer's reply that the patch set will be merged.
So let me just do a top-based reply here.

The examples I showed in the previous emails are just examples that could be used to demonstrate the difficulties on the future ACPICA development that brought by the hooks.
Since all what we are talking about are the future, we can just live with the current approaches.
We can find a way in the future when the conflicts do happen.

Thanks and best regards
-Lv

> On Saturday, July 27, 2013 2:04 AM konrad wilk
>> On 7/25/2013 10:51 PM, Zheng, Lv wrote:
> >> From: Konrad Rzeszutek Wilk [mailto:konrad.wilk@oracle.com]
> >> Sent: Thursday, July 25, 2013 8:04 PM
> >>
> >> CC-ing some of the tboot maintainers.
> >>> As what I've said, it's up to the others to determine if the patch is OK.
> >>> I just need to make my concerns visible in the community. :-)
> >> If I understand your concerns you don't want the hook to depend on any
> >> of the bit manipulations the existing code does for the pm1 values. The
> >> hook should do it itself case it needs to tweak them or what not.
> >>
> >> And it also frees you from altering the ACPICA code without having to
> >> worry about being dependent on what the input values the hook requires?
> >>
> >> Is this what you had in mind? (not compile tested nor tested).
> > Actually I've drafted such a patch that had conflicts with the Xen/tboot hooks.
> 
> Ok, so the idea patch is not yet what you had in mind I surmise?
> 
> Looking at the patch "ACPICA: Hardware: Modify sleep hardware
> interfaces" from said
> bugzilla I believe you could still retain the hook. You could even add
> it as part of the
> state machine (before the values are written to the respective area).
> > Then the patchset has to first delete the hooks to make test possible for
> testers.
> > It is here:
> > https://bugzilla.kernel.org/show_bug.cgi?id=54181
> I must be missing something obvious but the patches just say "Removes
> the hook for debugging purpose."
> I think the reason you did that is b/c you were not sure were it would
> fit in your "ACPICA: Hardware: Modify sleep hardware interfaces" patch.
> But as I said - I am probably missing something obvious.
> 
> >
> >> I am not even sure if outside the drivers/acpi you can call
> >> acpi_hw_get_bit_register_info ..
> > If we want this patch to be accepted without modification, then someone can
> help to do such cleanup in the future when ACPICA change happens.
> How would you expose said functions to non-ACPICA drivers?
> >
> >> And since the Xen bits would do the same exact bit manipulation it
> >> probably could use a library to do pm1* stuff so both tboot and Xen
> >> can use it.
> > This sounds better.
> > I think Xen and tboot will need such a library to atomically accessing PM
> register fields.
> 
> The sad part is that it would mirror the same exact code paths that the
> existing ACPICA code does. Which is why
> it was just passing in the pm* registers. But I understand that you
> prefer to have a generic API so that you don't have to worry about
> low-level implementations of platform hooks.
> 
> What if this hook was allowed to be turned in the state machine? That is
> the acpi_sleep_dispatch and
> it over-wrote part of the "write to PM1" state? The goal of the hook is
> to redirect the write using a different mechanism - so if the 'write to
> PM1' is accomplished then that is good.
> >
> > Thanks and best regards
> > -Lv
> >
> >> diff --git a/arch/x86/kernel/tboot.c b/arch/x86/kernel/tboot.c
> >> index f84fe00..59570b1 100644
> >> --- a/arch/x86/kernel/tboot.c
> >> +++ b/arch/x86/kernel/tboot.c
> >> @@ -273,20 +273,75 @@ static void tboot_copy_fadt(const struct
> >> acpi_table_fadt *fadt)
> >>   		offsetof(struct acpi_table_facs, firmware_waking_vector);
> >>   }
> >>
> >> -static int tboot_sleep(u8 sleep_state, u32 pm1a_control, u32
> pm1b_control)
> >> +static int tboot_get_pm_control(bool legacy)
> >> +{
> >> +	u32 pm1a_control;
> >> +	u32 pm1b_control;
> >> +	u32 in_value;
> >> +	acpi_status status;
> >> +	struct acpi_bit_register_info *sleep_type_reg_info;
> >> +	struct acpi_bit_register_info *sleep_enable_reg_info;
> >> +
> >> +	if (!legacy)
> >> +		return -ENOSPC;
> >> +
> >> +	status = acpi_hw_register_read(ACPI_REGISTER_PM1_CONTROL,
> >> +				       &pm1a_control);
> >> +	if (ACPI_FAILURE(status)) {
> >> +		return -EXXX /* something */;
> >> +	}
> >> +	sleep_type_reg_info =
> >> acpi_hw_get_bit_register_info(ACPI_BITREG_SLEEP_TYPE);
> >> +	sleep_enable_reg_info =
> >> acpi_hw_get_bit_register_info(ACPI_BITREG_SLEEP_ENABLE);
> >> +	/* Clear the SLP_EN and SLP_TYP fields */
> >> +
> >> +	pm1a_control &= ~(sleep_type_reg_info->access_bit_mask |
> >> +			  sleep_enable_reg_info->access_bit_mask);
> >> +	pm1b_control = pm1a_control;
> >> +
> >> +	/* Insert the SLP_TYP bits */
> >> +
> >> +	pm1a_control |=
> >> +	    (acpi_gbl_sleep_type_a << sleep_type_reg_info->bit_position);
> >> +	pm1b_control |=
> >> +	    (acpi_gbl_sleep_type_b << sleep_type_reg_info->bit_position);
> >> +
> >> +	/*
> >> +	 * We split the writes of SLP_TYP and SLP_EN to workaround
> >> +	 * poorly implemented hardware.
> >> +	 */
> >> +
> >> +	/* Write #1: write the SLP_TYP data to the PM1 Control registers */
> >> +
> >> +	status = acpi_hw_write_pm1_control(pm1a_control, pm1b_control);
> >> +	if (ACPI_FAILURE(status)) {
> >> +		return -EXXX /* something */;
> >> +	}
> >> +
> >> +	/* Insert the sleep enable (SLP_EN) bit */
> >> +
> >> +	pm1a_control |= sleep_enable_reg_info->access_bit_mask;
> >> +	pm1b_control |= sleep_enable_reg_info->access_bit_mask;
> >> +	tboot->acpi_sinfo.pm1a_cnt_val = pm1a_control;
> >> +	tboot->acpi_sinfo.pm1b_cnt_val = pm1b_control;
> >> +	return 0;
> >> +}
> >> +static int tboot_sleep(u8 sleep_state);
> >>   {
> >>   	static u32 acpi_shutdown_map[ACPI_S_STATE_COUNT] = {
> >>   		/* S0,1,2: */ -1, -1, -1,
> >>   		/* S3: */ TB_SHUTDOWN_S3,
> >>   		/* S4: */ TB_SHUTDOWN_S4,
> >>   		/* S5: */ TB_SHUTDOWN_S5 };
> >> +	int rc;
> >>
> >>   	if (!tboot_enabled())
> >>   		return 0;
> >>
> >>   	tboot_copy_fadt(&acpi_gbl_FADT);
> >> -	tboot->acpi_sinfo.pm1a_cnt_val = pm1a_control;
> >> -	tboot->acpi_sinfo.pm1b_cnt_val = pm1b_control;
> >> +
> >> +	rc = tboot_get_pm_control();
> >> +	if (rc < 0)
> >> +		return -1;
> >>   	/* we always use the 32b wakeup vector */
> >>   	tboot->acpi_sinfo.vector_width = 32;
> >>
> >> diff --git a/drivers/acpi/acpica/hwesleep.c b/drivers/acpi/acpica/hwesleep.c
> >> index 5e5f762..a8e98f9 100644
> >> --- a/drivers/acpi/acpica/hwesleep.c
> >> +++ b/drivers/acpi/acpica/hwesleep.c
> >> @@ -113,6 +113,15 @@ acpi_status acpi_hw_extended_sleep(u8
> >> sleep_state)
> >>   	    !acpi_gbl_FADT.sleep_status.address) {
> >>   		return_ACPI_STATUS(AE_NOT_EXIST);
> >>   	}
> >> +       /*
> >> +        * If using tboot or other platforms that need tweaks then
> >> +        * do them here, and also bail out if neccessary.
> >> +        */
> >> +       status = acpi_os_prepare_sleep(sleep_state);
> >> +       if (ACPI_SKIP(status))
> >> +               return_ACPI_STATUS(AE_OK);
> >> +       if (ACPI_FAILURE(status))
> >> +               return_ACPI_STATUS(status);
> >>
> >>   	/* Clear wake status (WAK_STS) */
> >>
> >> diff --git a/drivers/acpi/acpica/hwsleep.c b/drivers/acpi/acpica/hwsleep.c
> >> index e3828cc..909b23b 100644
> >> --- a/drivers/acpi/acpica/hwsleep.c
> >> +++ b/drivers/acpi/acpica/hwsleep.c
> >> @@ -108,6 +108,16 @@ acpi_status acpi_hw_legacy_sleep(u8
> sleep_state)
> >>   		return_ACPI_STATUS(status);
> >>   	}
> >>
> >> +	/*
> >> +	 * If using tboot or other platforms that need tweaks then
> >> +	 * do them here, and also bail out if neccessary.
> >> +	 */
> >> +	status = acpi_os_prepare_sleep(sleep_state);
> >> +	if (ACPI_SKIP(status))
> >> +		return_ACPI_STATUS(AE_OK);
> >> +	if (ACPI_FAILURE(status))
> >> +		return_ACPI_STATUS(status);
> >> +
> >>   	/* Get current value of PM1A control */
> >>
> >>   	status = acpi_hw_register_read(ACPI_REGISTER_PM1_CONTROL,
> >> @@ -152,12 +162,6 @@ acpi_status acpi_hw_legacy_sleep(u8
> sleep_state)
> >>
> >>   	ACPI_FLUSH_CPU_CACHE();
> >>
> >> -	status = acpi_os_prepare_sleep(sleep_state, pm1a_control,
> >> -				       pm1b_control);
> >> -	if (ACPI_SKIP(status))
> >> -		return_ACPI_STATUS(AE_OK);
> >> -	if (ACPI_FAILURE(status))
> >> -		return_ACPI_STATUS(status);
> >>   	/* Write #2: Write both SLP_TYP + SLP_EN */
> >>
> >>   	status = acpi_hw_write_pm1_control(pm1a_control, pm1b_control);
> >> diff --git a/drivers/acpi/osl.c b/drivers/acpi/osl.c
> >> index e721863..ffcc364 100644
> >> --- a/drivers/acpi/osl.c
> >> +++ b/drivers/acpi/osl.c
> >> @@ -77,8 +77,7 @@ EXPORT_SYMBOL(acpi_in_debugger);
> >>   extern char line_buf[80];
> >>   #endif				/*ENABLE_DEBUGGER */
> >>
> >> -static int (*__acpi_os_prepare_sleep)(u8 sleep_state, u32 pm1a_ctrl,
> >> -				      u32 pm1b_ctrl);
> >> +static int (*__acpi_os_prepare_sleep)(u8 sleep_state);
> >>
> >>   static acpi_osd_handler acpi_irq_handler;
> >>   static void *acpi_irq_context;
> >> @@ -1757,13 +1756,11 @@ acpi_status acpi_os_terminate(void)
> >>   	return AE_OK;
> >>   }
> >>
> >> -acpi_status acpi_os_prepare_sleep(u8 sleep_state, u32 pm1a_control,
> >> -				  u32 pm1b_control)
> >> +acpi_status acpi_os_prepare_sleep(u8 sleep_state)
> >>   {
> >>   	int rc = 0;
> >>   	if (__acpi_os_prepare_sleep)
> >> -		rc = __acpi_os_prepare_sleep(sleep_state,
> >> -					     pm1a_control, pm1b_control);
> >> +		rc = __acpi_os_prepare_sleep(sleep_state);
> >>   	if (rc < 0)
> >>   		return AE_ERROR;
> >>   	else if (rc > 0)
> >> @@ -1772,8 +1769,7 @@ acpi_status acpi_os_prepare_sleep(u8
> sleep_state,
> >> u32 pm1a_control,
> >>   	return AE_OK;
> >>   }
> >>
> >> -void acpi_os_set_prepare_sleep(int (*func)(u8 sleep_state,
> >> -			       u32 pm1a_ctrl, u32 pm1b_ctrl))
> >> +void acpi_os_set_prepare_sleep(int (*func)(u8 sleep_state))
> >>   {
> >>   	__acpi_os_prepare_sleep = func;
> >>   }
> >> diff --git a/include/linux/acpi.h b/include/linux/acpi.h
> >> index 17b5b59..8de1043 100644
> >> --- a/include/linux/acpi.h
> >> +++ b/include/linux/acpi.h
> >> @@ -480,8 +480,7 @@ static inline bool acpi_driver_match_device(struct
> >> device *dev,
> >>   void acpi_os_set_prepare_sleep(int (*func)(u8 sleep_state,
> >>   			       u32 pm1a_ctrl,  u32 pm1b_ctrl));
> >>
> >> -acpi_status acpi_os_prepare_sleep(u8 sleep_state,
> >> -				  u32 pm1a_control, u32 pm1b_control);
> >> +acpi_status acpi_os_prepare_sleep(u8 sleep_state);
> >>   #ifdef CONFIG_X86
> >>   void arch_reserve_mem_area(acpi_physical_address addr, size_t size);
> >>   #else
> >>
> >> .. massive snip..
> >>>>> On 07/24/2013 10:38 AM, Moore, Robert wrote:
> >>>>>> I haven't found a high-level description of "acpi_os_prepare_sleep",
> >>>> perhaps I missed it.
> >>>>>> Can someone point me to the overall description of this change and
> why
> >> it is
> >>>> being considered?
> >>>>> Hi Bob,
> >>>>>
> >>>>> For this series, the v6 of this series does a decent job of what it is
> >>>>> trying to accomplish:
> >>>>> https://lkml.org/lkml/2013/7/1/205
> >>>>>
> >>>>> However, I recognize that this does not really describe *why*
> >>>>> acpi_os_prepare_sleep is necessary to begin with. For that, we need to
> >>>>> go back a little more.
> >>>>>
> >>>>> The summary for the series that introduced it is a good description,
> >>>>> of the reasons it is necessary:
> >>>>> http://lkml.indiana.edu/hypermail/linux/kernel/1112.2/00450.html
> >>>>>
> >>>>> In summary though - in the case of Xen (and I believe this is also
> >>>>> true in tboot) a value inappropriate for a VM (which dom0 is a special
> >>>>> case
> >>>>> of) was being written to cr3, and the physical machine would never
> >>>>> come out of S3.
> >>>>>
> >>>>> This mechanism gives an os specific hook to do something else down at
> >>>>> the lower levels, while still being able to take advantage of the
> >>>>> large amount of OS independent code in ACPICA.
> >>>> It might be also prudent to look at original 'hook' that was added by Intel
> in
> >> the
> >>>> Linux code to support TXT:
> >>>>
> >>>>
> >>>> commit 86886e55b273f565935491816c7c96b82469d4f8
> >>>> Author: Joseph Cihula <joseph.cihula@intel.com>
> >>>> Date:   Tue Jun 30 19:31:07 2009 -0700
> >>>>
> >>>>      x86, intel_txt: Intel TXT Sx shutdown support
> >>>>
> >>>>      Support for graceful handling of sleep states (S3/S4/S5) after an
> >> Intel(R)
> >>>> TXT launch.
> >>>>
> >>>>      Without this patch, attempting to place the system in one of the
> ACPI
> >>>> sleep
> >>>>      states (S3/S4/S5) will cause the TXT hardware to treat this as an
> >> attack
> >>>> and
> >>>>      will cause a system reset, with memory locked.  Not only may the
> >>>> subsequent
> >>>>      memory scrub take some time, but the platform will be unable to
> >> enter
> >>>> the
> >>>>      requested power state.
> >>>>
> >>>>      This patch calls back into the tboot so that it may properly and
> >> securely
> >>>> clean
> >>>>      up system state and clear the secrets-in-memory flag, after which
> it
> >> will
> >>>> place
> >>>>      the system into the requested sleep state using ACPI information
> >> passed
> >>>> by the kernel.
> >>>>
> >>>>       arch/x86/kernel/smpboot.c     |    2 ++
> >>>>       drivers/acpi/acpica/hwsleep.c |    3 +++
> >>>>       kernel/cpu.c                  |    7 ++++++-
> >>>>       3 files changed, 11 insertions(+), 1 deletion(-)
> >>>>
> >>>>      Signed-off-by: Joseph Cihula <joseph.cihula@intel.com>
> >>>>      Signed-off-by: Shane Wang <shane.wang@intel.com>
> >>>>      Signed-off-by: H. Peter Anvin <hpa@zytor.com>
> >>>>
> >>>> I suspect that if tboot was used with a different OS (Solaris?) it would hit
> the
> >>>> same case and a similar hook would be needed.
> >>>>
> >>>> Said 'hook' (which was a call to tboot_sleep) was converted to be a more
> >>>> neutral 'acpi_os_prepare_sleep' which tboot can use (and incidently Xen
> >> too).
> >>>> I think what Bob is saying that if said hook is neccessary (and I believe it is
> -
> >> and
> >>>> Intel TXT maintainer thinks so too since he added it in the first place),
> then
> >> the
> >>>> right way of adding it is via the ACPICA tree.
> >>>>
> >>>> Should the discussion for this be moved there ?
> >> (https://acpica.org/community)
> >>>> and an generic 'os_prepare_sleep' patch added in
> >>>> git://github.com/acpica/acpica.git?
> >>>>
> >>>> --
> >>>> To unsubscribe from this list: send the line "unsubscribe linux-acpi" in the
> >> body
> >>>> of a message to majordomo@vger.kernel.org More majordomo info at
> >>>> http://vger.kernel.org/majordomo-info.html
> >>> --
> >>> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> >>> the body of a message to majordomo@vger.kernel.org
> >>> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> >>> Please read the FAQ at  http://www.tux.org/lkml/
> >>>


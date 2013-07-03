Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933044Ab3GCVsP (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Jul 2013 17:48:15 -0400
Received: from hydra.sisk.pl ([212.160.235.94]:57689 "EHLO hydra.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932221Ab3GCVsN (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Jul 2013 17:48:13 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Aaron Lu <aaron.lu@intel.com>
Cc: Matthew Garrett <matthew.garrett@nebula.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-acpi@vger.kernel.org" <linux-acpi@vger.kernel.org>,
        "seth.forshee@canonical.com" <seth.forshee@canonical.com>,
        "joeyli.kernel@gmail.com" <joeyli.kernel@gmail.com>,
        "daniel.vetter@ffwll.ch" <daniel.vetter@ffwll.ch>,
        "lenb@kernel.org" <lenb@kernel.org>,
        Bob Moore <robert.moore@intel.com>
Subject: Re: [PATCH 2/2] ACPI / OSL: add a wrapper function to return OSI version
Date: Wed, 03 Jul 2013 23:57:52 +0200
Message-ID: <3141401.j726us1HYg@vostro.rjw.lan>
User-Agent: KMail/4.9.5 (Linux/3.10.0-rc5+; KDE/4.9.5; x86_64; ; )
In-Reply-To: <51D2DD37.2040000@intel.com>
References: <1370818899-8595-1-git-send-email-matthew.garrett@nebula.com> <51D2DC1D.60101@intel.com> <51D2DD37.2040000@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="utf-8"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday, July 02, 2013 10:01:27 PM Aaron Lu wrote:
> Drivers may need to make policy decisions based on the OS that the firmware
> believes it's interacting with. ACPI firmware will make a series of _OSI
> calls, starting from the oldest OS version they support and ending with the
> most recent. This patchset adds a function in ACPI OSL layer to return the
> last successful call so that drivers know what the firmware's expecting.
> 
> Based on a patch by Matthew Garrett <matthew.garrett@nebula.com>, which
> is again based on a patch by Seth Forshee <seth.forshee@canonical.com>.
> 
> Changelog-by: Matthew Garrett <matthew.garrett@nebula.com>
> Signed-off-by: Aaron Lu <aaron.lu@intel.com>
> Cc: Matthew Garrett <matthew.garrett@nebula.com>
> Cc: Seth Forshee <seth.forshee@canonical.com>
> ---
>  drivers/acpi/osl.c   | 6 ++++++
>  include/linux/acpi.h | 6 ++++++
>  2 files changed, 12 insertions(+)
> 
> diff --git a/drivers/acpi/osl.c b/drivers/acpi/osl.c
> index 6ab2c35..7ebf07d 100644
> --- a/drivers/acpi/osl.c
> +++ b/drivers/acpi/osl.c
> @@ -1799,3 +1799,9 @@ void alloc_acpi_hp_work(acpi_handle handle, u32 type, void *context,
>  		kfree(hp_work);
>  }
>  EXPORT_SYMBOL_GPL(alloc_acpi_hp_work);
> +
> +u8 acpi_osi_version(void)
> +{
> +	return acpi_gbl_osi_data;
> +}

Actually, is there a reason not to make this static inline and put it into
the header?

Rafael


> +EXPORT_SYMBOL_GPL(acpi_osi_version);
> diff --git a/include/linux/acpi.h b/include/linux/acpi.h
> index 353ba25..fc3b5c2 100644
> --- a/include/linux/acpi.h
> +++ b/include/linux/acpi.h
> @@ -578,4 +578,10 @@ acpi_handle_printk(const char *level, void *handle, const char *fmt, ...) {}
>  })
>  #endif
>  
> +#ifdef CONFIG_ACPI
> +u8 acpi_osi_version(void);
> +#else
> +static inline u8 acpi_osi_version(void) { return 0; }
> +#endif
> +
>  #endif	/*_LINUX_ACPI_H*/
> 
-- 
I speak only for myself.
Rafael J. Wysocki, Intel Open Source Technology Center.

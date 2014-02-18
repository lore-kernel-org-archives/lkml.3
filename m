Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754899AbaBRK1Z (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Feb 2014 05:27:25 -0500
Received: from mga03.intel.com ([143.182.124.21]:54571 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754030AbaBRK1W (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Feb 2014 05:27:22 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.97,501,1389772800"; 
   d="scan'208";a="476956177"
Date: Tue, 18 Feb 2014 12:34:42 +0200
From: Mika Westerberg <mika.westerberg@linux.intel.com>
To: Aaron Lu <aaron.lu@intel.com>
Cc: "Rafael J. Wysocki" <rjw@rjwysocki.net>, Takashi Iwai <tiwai@suse.de>,
        Igor Gnatenko <i.gnatenko.brain@gmail.com>,
        Theodore Tso <tytso@mit.edu>, Peter Weber <bugs@ttyhoney.com>,
        Lennart Poettering <lennart@poettering.net>,
        Kevin Smith <thirdwiggin@gmail.com>,
        Rinat Ibragimov <ibragimovrinat@mail.ru>, sov.info@mail.ru,
        Thomas Christensen <christensenthomas@gmail.com>,
        Vladimir Sherenkov <a_12300@mail.ru>,
        ACPI Devel Mailing List <linux-acpi@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "platform-driver-x86@vger.kernel.org" 
	<platform-driver-x86@vger.kernel.org>,
        Matthew Garrett <mjg59@srcf.ucam.org>, Daniel Vetter <daniel@ffwll.ch>,
        Jani Nikula <jani.nikula@linux.intel.com>,
        "intel-gfx@lists.freedesktop.org" <intel-gfx@lists.freedesktop.org>
Subject: Re: [PATCH v4] ACPI / video: Add systems that should favour native
 backlight interface
Message-ID: <20140218103442.GS5018@intel.com>
References: <5302F58C.1080001@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <5302F58C.1080001@intel.com>
Organization: Intel Finland Oy - BIC 0357606-4 - Westendinkatu 7, 02160 Espoo
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Feb 18, 2014 at 01:54:20PM +0800, Aaron Lu wrote:
> +	{
> +	.callback = video_set_use_native_backlight,
> +	.ident = "HP EliteBook 2013 models",
> +	.matches = {
> +		DMI_MATCH(DMI_SYS_VENDOR, "Hewlett-Packard"),
> +		DMI_MATCH(DMI_PRODUCT_NAME, "HP EliteBook "),
> +		DMI_MATCH(DMI_PRODUCT_NAME, " G1"),
> +		},
> +	},

I see my device is listed here but the above doesn't really use native
backlight because it is still in acpi_osi blacklist. Tried this and I can
see both acpi_video0 and intel_backlight listed under /sys/class/backlight.
Was this the intention?

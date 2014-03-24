Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753548AbaCXRpm (ORCPT <rfc822;w@1wt.eu>);
	Mon, 24 Mar 2014 13:45:42 -0400
Received: from service87.mimecast.com ([91.220.42.44]:56744 "EHLO
	service87.mimecast.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753617AbaCXRpf convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 24 Mar 2014 13:45:35 -0400
Date: Mon, 24 Mar 2014 17:45:28 +0000
From: Javi Merino <javi.merino@arm.com>
To: Rasmus Villemoes <linux@rasmusvillemoes.dk>
Cc: Zhang Rui <rui.zhang@intel.com>, Len Brown <lenb@kernel.org>,
        "Rafael J. Wysocki" <rjw@rjwysocki.net>,
        Corentin Chary <corentin.chary@gmail.com>,
        Matthew Garrett <matthew.garrett@nebula.com>,
        Sujith Thomas <sujith.thomas@intel.com>,
        Eduardo Valentin <eduardo.valentin@ti.com>,
        "linux-acpi@vger.kernel.org" <linux-acpi@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "acpi4asus-user@lists.sourceforge.net" 
	<acpi4asus-user@lists.sourceforge.net>,
        "platform-driver-x86@vger.kernel.org" 
	<platform-driver-x86@vger.kernel.org>,
        "linux-pm@vger.kernel.org" <linux-pm@vger.kernel.org>,
        Joe Perches <joe@perches.com>
Subject: Re: [PATCH] linux/thermal.h: Rename KELVIN_TO_CELSIUS to
 DECI_KELVIN_TO_CELSIUS
Message-ID: <20140324174528.GC22346@e102654-lin.cambridge.arm.com>
References: <1395682149-16563-1-git-send-email-linux@rasmusvillemoes.dk>
MIME-Version: 1.0
In-Reply-To: <1395682149-16563-1-git-send-email-linux@rasmusvillemoes.dk>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-OriginalArrivalTime: 24 Mar 2014 17:45:44.0145 (UTC) FILETIME=[E1807410:01CF4788]
X-MC-Unique: 114032417453200901
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Mar 24, 2014 at 05:29:09PM +0000, Rasmus Villemoes wrote:
> The macros KELVIN_TO_CELSIUS and CELSIUS_TO_KELVIN actually work on
> decikelvins, so rename them to reflect their actual semantics.
> 
> Signed-off-by: Rasmus Villemoes <linux@rasmusvillemoes.dk>
> ---
>  drivers/acpi/thermal.c              | 12 ++++++------
>  drivers/platform/x86/asus-wmi.c     |  2 +-
>  drivers/platform/x86/intel_menlow.c |  8 ++++----
>  include/linux/thermal.h             |  6 +++---
>  4 files changed, 14 insertions(+), 14 deletions(-)

[snip]

> diff --git a/include/linux/thermal.h b/include/linux/thermal.h
> index f7e11c7..c978aa3 100644
> --- a/include/linux/thermal.h
> +++ b/include/linux/thermal.h
> @@ -41,9 +41,9 @@
>  #define THERMAL_NO_LIMIT	THERMAL_CSTATE_INVALID
>  
>  /* Unit conversion macros */
> -#define KELVIN_TO_CELSIUS(t)	(long)(((long)t-2732 >= 0) ?	\
> -				((long)t-2732+5)/10 : ((long)t-2732-5)/10)
> -#define CELSIUS_TO_KELVIN(t)	((t)*10+2732)
> +#define DECI_KELVIN_TO_CELSIUS(t)	(long)(((long)t-2732 >= 0) ?	\
> +					((long)t-2732+5)/10 : ((long)t-2732-5)/10)
> +#define CELSIUS_TO_DECI_KELVIN(t)	((t)*10+2732)

While you are at it, you could also make it use a statement expression
as Joe Perches suggested earlier:

http://thread.gmane.org/gmane.linux.power-management.general/43978/focus=1671955

Cheers,
Javi


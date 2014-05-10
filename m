Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757694AbaEJVBl (ORCPT <rfc822;w@1wt.eu>);
	Sat, 10 May 2014 17:01:41 -0400
Received: from merlin.infradead.org ([205.233.59.134]:55159 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757055AbaEJVBj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 10 May 2014 17:01:39 -0400
Message-ID: <536E9390.5060404@infradead.org>
Date: Sat, 10 May 2014 14:01:04 -0700
From: Randy Dunlap <rdunlap@infradead.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.3.0
MIME-Version: 1.0
To: Guenter Roeck <linux@roeck-us.net>
CC: linux-watchdog@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        Wim Van Sebroeck <wim@iguana.be>,
        Catalin Marinas <catalin.marinas@arm.com>,
        Maxime Ripard <maxime.ripard@free-electrons.com>,
        Will Deacon <will.deacon@arm.com>, Arnd Bergmann <arnd@arndb.de>,
        Heiko Stuebner <heiko@sntech.de>,
        Russell King <linux@arm.linux.org.uk>,
        Jonas Jensen <jonas.jensen@gmail.com>, linux-kernel@vger.kernel.org,
        linux-doc@vger.kernel.org
Subject: Re: [PATCH 6/5] watchdog: Document reboot API
References: <1399681883-891-1-git-send-email-linux@roeck-us.net> <536D74E3.8010609@infradead.org> <20140510162329.GA19884@roeck-us.net>
In-Reply-To: <20140510162329.GA19884@roeck-us.net>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 05/10/2014 09:23 AM, Guenter Roeck wrote:
> Document the new reboot API functionality.
> 
> Signed-off-by: Guenter Roeck <linux@roeck-us.net>
> ---
>  Documentation/watchdog/watchdog-kernel-api.txt | 14 ++++++++++++++
>  1 file changed, 14 insertions(+)
> 
> diff --git a/Documentation/watchdog/watchdog-kernel-api.txt b/Documentation/watchdog/watchdog-kernel-api.txt
> index a0438f3..f8f0f18 100644
> --- a/Documentation/watchdog/watchdog-kernel-api.txt
> +++ b/Documentation/watchdog/watchdog-kernel-api.txt
> @@ -90,6 +90,8 @@ struct watchdog_ops {
>  	int (*stop)(struct watchdog_device *);
>  	/* optional operations */
>  	int (*ping)(struct watchdog_device *);
> +	void (*reboot)(struct watchdog_device *, enum reboot_mode,
> +		       const char *);
>  	unsigned int (*status)(struct watchdog_device *);
>  	int (*set_timeout)(struct watchdog_device *, unsigned int);
>  	unsigned int (*get_timeleft)(struct watchdog_device *);
> @@ -148,6 +150,10 @@ they are supported. These optional routines/operations are:
>    info structure).
>  * status: this routine checks the status of the watchdog timer device. The
>    status of the device is reported with watchdog WDIOF_* status flags/bits.
> +* reboot: if this routine is present, it may be called to reboot the system.
> +  Parameters are the pointer to the watchdog device, the reboot mode, and a
> +  command string. The latter two parameters are the system reboot mode
> +  and the cmd parameter passed to machine_restart().
>  * set_timeout: this routine checks and changes the timeout of the watchdog
>    timer device. It returns 0 on success, -EINVAL for "parameter out of range"
>    and -EIO for "could not write value to the watchdog". On success this
> @@ -224,3 +230,11 @@ the device tree (if the module timeout parameter is invalid). Best practice is
>  to set the default timeout value as timeout value in the watchdog_device and
>  then use this function to set the user "preferred" timeout value.
>  This routine returns zero on success and a negative errno code for failure.
> +
> +The watchdog_do_reboot function can be used reboot the system. This is intended

                                               to reboot

> +to be used in systems which do not have an explicit reboot capability, but
> +implement reboot by programming the watchdog to expire immediately. If the
> +function is called, and a watchdog driver with reboot functionality was
> +previously registered, the reboot function of that driver will be called.
> +Architecture code should call watchdog_do_reboot from its machine_reboot
> +function after other means to reboot the system failed.
> 

Thanks for the Doc patch.

-- 
~Randy

Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753373AbaBZAW7 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Feb 2014 19:22:59 -0500
Received: from v094114.home.net.pl ([79.96.170.134]:55393 "HELO
	v094114.home.net.pl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1752142AbaBZAW5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Feb 2014 19:22:57 -0500
From: "Rafael J. Wysocki" <rjw@rjwysocki.net>
To: Sebastian Capella <sebastian.capella@linaro.org>
Cc: linux-kernel@vger.kernel.org, linux-pm@vger.kernel.org,
        linaro-kernel@lists.linaro.org, linux-arm-kernel@lists.infradead.org,
        Russ Dill <Russ.Dill@ti.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Subject: Re: [PATCH v3 1/3] Fix hibernation restore hang in freeze_processes
Date: Wed, 26 Feb 2014 01:37:57 +0100
Message-ID: <3879011.h2KX4caCrF@vostro.rjw.lan>
User-Agent: KMail/4.11.5 (Linux/3.13.0+; KDE/4.11.5; x86_64; ; )
In-Reply-To: <1393372920-3896-2-git-send-email-sebastian.capella@linaro.org>
References: <1393372920-3896-1-git-send-email-sebastian.capella@linaro.org> <1393372920-3896-2-git-send-email-sebastian.capella@linaro.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="utf-8"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday, February 25, 2014 04:01:58 PM Sebastian Capella wrote:
> During restore, pm_notifier chain are called with
> PM_RESTORE_PREPARE.  The firmware_class driver handler
> fw_pm_notify does not have a handler for this.  As a result,
> it keeps a reader on the kmod.c umhelper_sem.  During
> freeze_processes, the call to __usermodehelper_disable tries to
> take a write lock on this semaphore and hangs waiting.
> 
> Signed-off-by: Sebastian Capella <sebastian.capella@linaro.org>
> Acked-by: Ming Lei <ming.lei@canonical.com>
> Cc: Russ Dill <Russ.Dill@ti.com>
> Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

Since this is a -stable candidate patch, I've queued it up as a fix for 3.14.

The other two patches are ARM mostly, so I'd prefer them to be merged through
the ARM arch tree.  The changes in suspend.h made by [3/3] are fine by me.

Thanks!

> ---
>  drivers/base/firmware_class.c |    1 +
>  1 file changed, 1 insertion(+)
> 
> diff --git a/drivers/base/firmware_class.c b/drivers/base/firmware_class.c
> index eb8fb94..e2b51f8 100644
> --- a/drivers/base/firmware_class.c
> +++ b/drivers/base/firmware_class.c
> @@ -1541,6 +1541,7 @@ static int fw_pm_notify(struct notifier_block *notify_block,
>  	switch (mode) {
>  	case PM_HIBERNATION_PREPARE:
>  	case PM_SUSPEND_PREPARE:
> +	case PM_RESTORE_PREPARE:
>  		kill_requests_without_uevent();
>  		device_cache_fw_images();
>  		break;
> 

-- 
I speak only for myself.
Rafael J. Wysocki, Intel Open Source Technology Center.

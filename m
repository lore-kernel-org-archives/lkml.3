Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1161013AbaJ3O5J (ORCPT <rfc822;w@1wt.eu>);
	Thu, 30 Oct 2014 10:57:09 -0400
Received: from www.linutronix.de ([62.245.132.108]:35769 "EHLO
	Galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932954AbaJ3O5H (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 30 Oct 2014 10:57:07 -0400
Date: Thu, 30 Oct 2014 15:57:04 +0100 (CET)
From: Thomas Gleixner <tglx@linutronix.de>
To: "pang.xunlei" <pang.xunlei@linaro.org>
cc: linux-kernel@vger.kernel.org, rtc-linux@googlegroups.com,
        xen-devel@lists.xenproject.org, John Stultz <john.stultz@linaro.org>,
        Alessandro Zummo <a.zummo@towertech.it>,
        Stefano Stabellini <stefano.stabellini@eu.citrix.com>
Subject: Re: [RFC PATCH v2 09/11] time: Convert pvclock_read_wallclock() to
 use timespec64
In-Reply-To: <1414667745-7703-10-git-send-email-pang.xunlei@linaro.org>
Message-ID: <alpine.DEB.2.11.1410301553040.5308@nanos>
References: <1414667745-7703-1-git-send-email-pang.xunlei@linaro.org> <1414667745-7703-10-git-send-email-pang.xunlei@linaro.org>
User-Agent: Alpine 2.11 (DEB 23 2013-08-11)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-Linutronix-Spam-Score: -1.0
X-Linutronix-Spam-Level: -
X-Linutronix-Spam-Status: No , -1.0 points, 5.0 required,  ALL_TRUSTED=-1,SHORTCIRCUIT=-0.0001
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 30 Oct 2014, pang.xunlei wrote:
>  	/* get wallclock at system boot */
>  	do {
>  		version = wall_clock->version;
>  		rmb();		/* fetch version before time */
> -		now.tv_sec  = wall_clock->sec;
> +		/* TODO: [2038 safety] wall_clock->sec uses time64_t */

Wrong. This is part of the hypervisor ABI and you can add as many
TODOs here as you want. They will not change the ABI ever. If XEN
wants to fix that it needs to implement a new hypervisor interface.

> +		now.tv_sec  = (time64_t)wall_clock->sec;

copy & paste does not solve all these problems magically.

Thanks,

	tglx

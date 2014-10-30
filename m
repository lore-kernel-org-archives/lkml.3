Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934073AbaJ3OwN (ORCPT <rfc822;w@1wt.eu>);
	Thu, 30 Oct 2014 10:52:13 -0400
Received: from www.linutronix.de ([62.245.132.108]:35731 "EHLO
	Galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933696AbaJ3OwK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 30 Oct 2014 10:52:10 -0400
Date: Thu, 30 Oct 2014 15:52:07 +0100 (CET)
From: Thomas Gleixner <tglx@linutronix.de>
To: "pang.xunlei" <pang.xunlei@linaro.org>
cc: linux-kernel@vger.kernel.org, rtc-linux@googlegroups.com,
        xen-devel@lists.xenproject.org, John Stultz <john.stultz@linaro.org>,
        Alessandro Zummo <a.zummo@towertech.it>,
        Stefano Stabellini <stefano.stabellini@eu.citrix.com>
Subject: Re: [RFC PATCH v2 07/11] time: Convert alarm_set_rtc() to use
 timespec64
In-Reply-To: <1414667745-7703-8-git-send-email-pang.xunlei@linaro.org>
Message-ID: <alpine.DEB.2.11.1410301550010.5308@nanos>
References: <1414667745-7703-1-git-send-email-pang.xunlei@linaro.org> <1414667745-7703-8-git-send-email-pang.xunlei@linaro.org>
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
> +/*
> +* TODO: [2038 safety] alarm_do_ioctl() should be fixed to use timespec64,
> +*  once timespec64 is promoted to userspace.

Nonsense. You CANNOT 'FIX' this. The ioctl needs to stay as is because
you need to preserve the user space ABI.

It needs a new ioctl variant which handles timespec64.

Thanks,

	tglx


Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754750AbaCZR2t (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 Mar 2014 13:28:49 -0400
Received: from www.linutronix.de ([62.245.132.108]:33860 "EHLO
	Galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751054AbaCZR2r (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 Mar 2014 13:28:47 -0400
Date: Wed, 26 Mar 2014 18:28:54 +0100 (CET)
From: Thomas Gleixner <tglx@linutronix.de>
To: Viresh Kumar <viresh.kumar@linaro.org>
cc: linaro-kernel@lists.linaro.org, linux-kernel@vger.kernel.org,
        fweisbec@gmail.com, linaro-networking@linaro.org
Subject: Re: [PATCH 11/14] hrtimer: remove active_bases field from struct
 hrtimer_cpu_base
In-Reply-To: <dc479af0df0a087f24719237e7af687caa71e0d1.1395832156.git.viresh.kumar@linaro.org>
Message-ID: <alpine.DEB.2.02.1403261827020.21095@ionos.tec.linutronix.de>
References: <cover.1395832156.git.viresh.kumar@linaro.org> <dc479af0df0a087f24719237e7af687caa71e0d1.1395832156.git.viresh.kumar@linaro.org>
User-Agent: Alpine 2.02 (DEB 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-Linutronix-Spam-Score: -1.0
X-Linutronix-Spam-Level: -
X-Linutronix-Spam-Status: No , -1.0 points, 5.0 required,  ALL_TRUSTED=-1,SHORTCIRCUIT=-0.0001
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On Wed, 26 Mar 2014, Viresh Kumar wrote:

> Active_bases field of struct hrtimer_cpu_base is used at only one place, i.e.
> hrtimer_interrupt() and at that place too we can easily use timerqueue_getnext()
> instead to achieve the same result. I don't think this will have any performance
> degradation issues and so removing this field.

Instead of removing it we should actually use ffs and avoid the whole
looping. That was the intention in the first place, but I never wrote
the patch...

Thanks,

	tglx

 

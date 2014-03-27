Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752232AbaC0Eaw (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 Mar 2014 00:30:52 -0400
Received: from mail-oa0-f54.google.com ([209.85.219.54]:35951 "EHLO
	mail-oa0-f54.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750940AbaC0Eav (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 Mar 2014 00:30:51 -0400
MIME-Version: 1.0
In-Reply-To: <alpine.DEB.2.02.1403261827020.21095@ionos.tec.linutronix.de>
References: <cover.1395832156.git.viresh.kumar@linaro.org>
	<dc479af0df0a087f24719237e7af687caa71e0d1.1395832156.git.viresh.kumar@linaro.org>
	<alpine.DEB.2.02.1403261827020.21095@ionos.tec.linutronix.de>
Date: Thu, 27 Mar 2014 10:00:50 +0530
Message-ID: <CAKohpokLD35f7hgmhWk+7kAqnWem1qRd-P8xMeVPvdeQ51VFjw@mail.gmail.com>
Subject: Re: [PATCH 11/14] hrtimer: remove active_bases field from struct hrtimer_cpu_base
From: Viresh Kumar <viresh.kumar@linaro.org>
To: Thomas Gleixner <tglx@linutronix.de>
Cc: Lists linaro-kernel <linaro-kernel@lists.linaro.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        =?ISO-8859-1?Q?Fr=E9d=E9ric_Weisbecker?= <fweisbec@gmail.com>,
        Linaro Networking <linaro-networking@linaro.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 26 March 2014 22:58, Thomas Gleixner <tglx@linutronix.de> wrote:
> Instead of removing it we should actually use ffs and avoid the whole
> looping. That was the intention in the first place, but I never wrote
> the patch...

I thought about that and then using ffs for a field of which only 4 bits
are useful didn't looked too convincing to me :)

But, probably it will make things slightly better in case this routine is
heavily used.

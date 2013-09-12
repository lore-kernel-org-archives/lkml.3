Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756932Ab3ILUrE (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Sep 2013 16:47:04 -0400
Received: from terminus.zytor.com ([198.137.202.10]:39933 "EHLO mail.zytor.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756468Ab3ILUrA (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Sep 2013 16:47:00 -0400
Message-ID: <52322835.8040803@zytor.com>
Date: Thu, 12 Sep 2013 13:46:45 -0700
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130625 Thunderbird/17.0.7
MIME-Version: 1.0
To: "Theodore Ts'o" <tytso@mit.edu>, John Stultz <john.stultz@linaro.org>,
        Stephan Mueller <smueller@chronox.de>,
        LKML <linux-kernel@vger.kernel.org>, dave.taht@bufferbloat.net,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Thomas Gleixner <tglx@linutronix.de>
Subject: Re: [PATCH] /dev/random: Insufficient of entropy on many architectures
References: <10005394.BRCyBMYWy3@tauon> <CANcMJZAHuXNQ4eUx+qpVnfJTg625HkJU_9pgBP24ykkmBww3yw@mail.gmail.com> <20130910203853.GG29237@thunk.org> <522F851D.1040101@linaro.org> <20130910211009.GI29237@thunk.org> <522F984C.2070909@linaro.org> <20130910223326.GD11063@thunk.org> <522FB9F1.3070905@linaro.org> <20130911005047.GA13315@thunk.org>
In-Reply-To: <20130911005047.GA13315@thunk.org>
X-Enigmail-Version: 1.5.2
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 09/10/2013 05:50 PM, Theodore Ts'o wrote:
> 
> Right now, if get_cycles() returns 0, we fall back to only mixing in
> the IP register from the interrupt plus the jiffies counter.  The
> platforms where get_cycles returns 0 is:
> 
> - User mode Linux

UML (on x86) should be able to use RDTSC just fine; it might be
meaningless for anything *other* than random though...

	-hpa



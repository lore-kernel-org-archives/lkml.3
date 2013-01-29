Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753701Ab3A2KLu (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Jan 2013 05:11:50 -0500
Received: from caramon.arm.linux.org.uk ([78.32.30.218]:57410 "EHLO
	caramon.arm.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753202Ab3A2KLr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Jan 2013 05:11:47 -0500
Date: Tue, 29 Jan 2013 10:06:21 +0000
From: Russell King - ARM Linux <linux@arm.linux.org.uk>
To: Santosh Shilimkar <santosh.shilimkar@ti.com>
Cc: John Stultz <john.stultz@linaro.org>, Arnd Bergmann <arnd@arndb.de>,
        Tony Lindgren <tony@atomide.com>,
        Peter Zijlstra <peterz@infradead.org>,
        Matt Sealey <matt@genesi-usa.com>, LKML <linux-kernel@vger.kernel.org>,
        Ben Dooks <ben@simtec.co.uk>, Ingo Molnar <mingo@redhat.com>,
        Linux ARM Kernel ML <linux-arm-kernel@lists.infradead.org>
Subject: Re: One of these things (CONFIG_HZ) is not like the others..
Message-ID: <20130129100621.GO23505@n2100.arm.linux.org.uk>
References: <CAKGA1bkiowcO7OPSfPmaB6eRj_3FNr+4ONnaQHEZkpxB2XfduQ@mail.gmail.com> <20130121232322.GK15361@atomide.com> <50FE307F.9000701@ti.com> <201301220931.24570.arnd@arndb.de> <50FE666B.10902@ti.com> <20130122145113.GK23505@n2100.arm.linux.org.uk> <50FEAABA.6050307@ti.com> <510615F8.7010203@ti.com> <5107114C.4070307@linaro.org> <51076FA2.9070002@ti.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <51076FA2.9070002@ti.com>
User-Agent: Mutt/1.5.19 (2009-01-05)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jan 29, 2013 at 12:13:46PM +0530, Santosh Shilimkar wrote:
> To avoid the server latency, we didn't do continuous sync. The time was  
> synced in the beginning and after 62.5 hours (#ntpd -qg) and the drift
> of about 174 ms was observed. As you said this could be because of
> server sync time along with probably some addition from system calls
> from #ntpd. As mentioned, the other run with HZ = 128 which started
> 15 hours 20 mins is already showing about 24 mS drift now. I will
> let it run for couple of more days just to have similar duration run.

Hmm.  I wonder if ntpd -qg will cause ntp to read the drift file and
adjust the kernel time keeping using that information...

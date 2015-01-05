Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753569AbbAEO1s (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Jan 2015 09:27:48 -0500
Received: from smtp-out4.electric.net ([192.162.216.182]:50493 "EHLO
	smtp-out4.electric.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753215AbbAEO1r convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Jan 2015 09:27:47 -0500
From: David Laight <David.Laight@ACULAB.COM>
To: "'Richard Cochran'" <richardcochran@gmail.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>
CC: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "David Miller" <davem@davemloft.net>,
        Jeff Kirsher <jeffrey.t.kirsher@intel.com>,
        John Stultz <john.stultz@linaro.org>,
        Thomas Gleixner <tglx@linutronix.de>
Subject: RE: [PATCH net-next 1/7] timecounter: provide a macro to initialize
 the cyclecounter mask field.
Thread-Topic: [PATCH net-next 1/7] timecounter: provide a macro to
 initialize the cyclecounter mask field.
Thread-Index: AQHQJbAIrcENDEKocU+B733cx3sBSZyxh57Q
Date: Mon, 5 Jan 2015 13:20:57 +0000
Message-ID: <063D6719AE5E284EB5DD2968C1650D6D1CAC09D7@AcuExch.aculab.com>
References: <cover.1420108214.git.richardcochran@gmail.com>
 <1f1bee3e2aa0cc530d006d99a621992a1497a442.1420108214.git.richardcochran@gmail.com>
In-Reply-To: <1f1bee3e2aa0cc530d006d99a621992a1497a442.1420108214.git.richardcochran@gmail.com>
Accept-Language: en-GB, en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [10.202.99.200]
Content-Type: text/plain; charset="Windows-1252"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
X-Outbound-IP: 213.249.233.130
X-Env-From: David.Laight@ACULAB.COM
X-PolicySMART: 3396946, 3397078
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> There is no need for users of the timecounter/cyclecounter code to include
> clocksource.h just for a single macro.
> 
> Signed-off-by: Richard Cochran <richardcochran@gmail.com>
> ---
>  include/linux/timecounter.h |    5 ++++-
>  1 file changed, 4 insertions(+), 1 deletion(-)
> 
> diff --git a/include/linux/timecounter.h b/include/linux/timecounter.h
> index 74f4549..4382035 100644
> --- a/include/linux/timecounter.h
> +++ b/include/linux/timecounter.h
> @@ -19,6 +19,9 @@
> 
>  #include <linux/types.h>
> 
> +/* simplify initialization of mask field */
> +#define CYCLECOUNTER_MASK(bits) (cycle_t)((bits) < 64 ? ((1ULL<<(bits))-1) : -1)

That has me chasing through the C integer promotion rules.
Better might be:
	((bits) < 64 ? (1ULL << (bits)) - 1 : (((1ULL << 63) - 1) << 1) + 1)
I actually suspect there is a standard definition somewhere?

	David 

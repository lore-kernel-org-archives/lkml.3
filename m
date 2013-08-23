Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756225Ab3HWUVf (ORCPT <rfc822;w@1wt.eu>);
	Fri, 23 Aug 2013 16:21:35 -0400
Received: from smtp2.Stanford.EDU ([171.67.219.82]:53252 "EHLO
	smtp.stanford.edu" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1755198Ab3HWUVe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 23 Aug 2013 16:21:34 -0400
Message-ID: <5217C43D.6090909@localhost>
Date: Fri, 23 Aug 2013 13:21:17 -0700
From: Fernando Lopez-Lezcano <nando@ccrma.Stanford.EDU>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130625 Thunderbird/17.0.7
MIME-Version: 1.0
To: Sebastian Andrzej Siewior <bigeasy@linutronix.de>
CC: Fernando Lopez-Lezcano <nando@ccrma.Stanford.EDU>,
        linux-rt-users <linux-rt-users@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>,
        Thomas Gleixner <tglx@linutronix.de>, rostedt@goodmis.org,
        John Kacur <jkacur@redhat.com>
Subject: Re: [ANNOUNCE] 3.10.9-rt5
References: <20130822182127.GA7606@linutronix.de> <5216F81A.4050203@localhost> <52170A6F.6040009@linutronix.de> <52179950.6010601@localhost> <20130823175628.GA9130@linutronix.de>
In-Reply-To: <20130823175628.GA9130@linutronix.de>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 08/23/2013 10:56 AM, Sebastian Andrzej Siewior wrote:
> * Fernando Lopez-Lezcano | 2013-08-23 10:18:08 [-0700]:
>
>> Please post a patch when/if you have it so I can retry the build...
>> Thanks for taking a look at this!
>
> Does this fix your trobule?

Yes, it does, thanks! Builds, installs and boots the x86_64 kernel (I 
did not test the i686 build, I don't have a 32 machine to test).

-- Fernando


> diff --git a/drivers/misc/hwlat_detector.c b/drivers/misc/hwlat_detector.c
> index 0bfa40d..6f61d5f 100644
> --- a/drivers/misc/hwlat_detector.c
> +++ b/drivers/misc/hwlat_detector.c
> @@ -220,7 +220,7 @@ static struct sample *buffer_get_sample(struct sample *sample)
>   #else
>   #define time_type	u64
>   #define time_get()	trace_clock_local()
> -#define time_to_us(x)	((x) / 1000)
> +#define time_to_us(x)	div_u64(x, 1000)
>   #define time_sub(a, b)	((a) - (b))
>   #define init_time(a, b)	a = b
>   #define time_u64(a)	a

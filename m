Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754051AbaFMRh6 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 13 Jun 2014 13:37:58 -0400
Received: from terminus.zytor.com ([198.137.202.10]:50908 "EHLO mail.zytor.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753488AbaFMRh4 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 13 Jun 2014 13:37:56 -0400
Message-ID: <539B36B2.8090701@zytor.com>
Date: Fri, 13 Jun 2014 10:36:50 -0700
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.5.0
MIME-Version: 1.0
To: Kees Cook <keescook@chromium.org>, Pavel Machek <pavel@ucw.cz>
CC: LKML <linux-kernel@vger.kernel.org>, Randy Dunlap <rdunlap@infradead.org>,
        Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>,
        "x86@kernel.org" <x86@kernel.org>,
        "Rafael J. Wysocki" <rjw@rjwysocki.net>,
        Len Brown <len.brown@intel.com>,
        Wei Yongjun <yongjun_wei@trendmicro.com.cn>,
        "linux-doc@vger.kernel.org" <linux-doc@vger.kernel.org>,
        linux-pm@vger.kernel.org
Subject: Re: [PATCH 0/2] make kASLR vs hibernation boot-time selectable
References: <1402602419-27934-1-git-send-email-keescook@chromium.org>	<539A0422.9010000@zytor.com>	<CAGXu5jLvAr=f2MRP4Ni86-jbM7h3Mx3RQo=7coveE8ZEt12N=Q@mail.gmail.com>	<539A0DC2.1010203@zytor.com>	<CAGXu5jKanRjK66P9dFYctXfQxT+da_9z8vqy8s+WqgW1cw17-Q@mail.gmail.com>	<20140613105135.GA4876@amd.pavel.ucw.cz> <CAGXu5jJTSqtOMBNeOGEXfj_1iWGbE7p_YooeHT9wc4WRDjcGyQ@mail.gmail.com>
In-Reply-To: <CAGXu5jJTSqtOMBNeOGEXfj_1iWGbE7p_YooeHT9wc4WRDjcGyQ@mail.gmail.com>
X-Enigmail-Version: 1.6
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 06/13/2014 10:32 AM, Kees Cook wrote:
>>
>> x86-64 can resume from different kernel that did the suspend. kASLR
>> should not be too different from that. (You just include kernel text
>> in the hibernation image. It is small enough to do that.)
> 
> Oooh, that's very exciting! How does that work (what happens to the
> kernel that booted first, etc)? I assume physical memory layout can't
> change between hibernation and resume? Or, where should I be reading
> code that does this?
> 

"Give me a lever and a place to stand, and I shall move the world."
Reshuffling memory in an arbitrary or near-arbitrary way really isn't
all that hard.  The exact data structures you need depends on if you
have any kind of page alignment you can rely on (makes it easier) and
how much spare memory you have (in case of hibernation, there is usually
tons of unused memory as it doesn't make sense to hibernate clean pages.)

	-hpa



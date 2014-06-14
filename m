Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754817AbaFNQmV (ORCPT <rfc822;w@1wt.eu>);
	Sat, 14 Jun 2014 12:42:21 -0400
Received: from terminus.zytor.com ([198.137.202.10]:60519 "EHLO mail.zytor.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754713AbaFNQmS (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 14 Jun 2014 12:42:18 -0400
Message-ID: <539C7B2F.9070800@zytor.com>
Date: Sat, 14 Jun 2014 09:41:19 -0700
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.5.0
MIME-Version: 1.0
To: "Rafael J. Wysocki" <rjw@rjwysocki.net>, Kees Cook <keescook@chromium.org>
CC: Pavel Machek <pavel@ucw.cz>, LKML <linux-kernel@vger.kernel.org>,
        Randy Dunlap <rdunlap@infradead.org>,
        Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>,
        "x86@kernel.org" <x86@kernel.org>, Len Brown <len.brown@intel.com>,
        Wei Yongjun <yongjun_wei@trendmicro.com.cn>,
        "linux-doc@vger.kernel.org" <linux-doc@vger.kernel.org>,
        linux-pm@vger.kernel.org
Subject: Re: [PATCH 0/2] make kASLR vs hibernation boot-time selectable
References: <1402602419-27934-1-git-send-email-keescook@chromium.org> <1517175.iyVMqh7r2z@vostro.rjw.lan> <CAGXu5jJSqV2MeuofJP4OEiDytQBqKMgC3cj+tguiwTmpRX1wSQ@mail.gmail.com> <13135927.OjVm86GPrt@vostro.rjw.lan>
In-Reply-To: <13135927.OjVm86GPrt@vostro.rjw.lan>
X-Enigmail-Version: 1.6
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 06/13/2014 05:39 PM, Rafael J. Wysocki wrote:
>  
> -#define RESTORE_MAGIC	0x0123456789ABCDEFUL
> +#define RESTORE_MAGIC	0x0123456789ABCDF0UL
>  

<bikeshed>

Please don't pick numbers like this for magic numbers... *everyone else
does, too.*  In general, picking a random number is a good starting
point; for extra bonus make sure it has at least one invalid UTF-8
sequence in it (so it cannot be confused with either ASCII or UTF-8 text.)

</bikeshed>

	-hpa


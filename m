Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752120Ab3LLSi1 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Dec 2013 13:38:27 -0500
Received: from mail-oa0-f44.google.com ([209.85.219.44]:64278 "EHLO
	mail-oa0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751611Ab3LLSiX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Dec 2013 13:38:23 -0500
MIME-Version: 1.0
In-Reply-To: <20131212182831.GM1939@saruman.home>
References: <1385506004-14943-1-git-send-email-caesarxuchao@gmail.com>
	<1386477638-6331-1-git-send-email-caesarxuchao@gmail.com>
	<CACRpkdaD13JnGetD-GLpxSoaf_LkRKYFjis7Tftc6U38E1ES5A@mail.gmail.com>
	<20131212182831.GM1939@saruman.home>
Date: Thu, 12 Dec 2013 19:38:22 +0100
Message-ID: <CACRpkdb4pF9-rB_zzXgzOnuAc_z=ZN+XHRq6i_Dd76FK08wdkg@mail.gmail.com>
Subject: Re: [RFC/RFT/PATCH V3] gpio: omap: refresh patch "be more aggressive
 with pm_runtime" against v3.12-rc5
From: Linus Walleij <linus.walleij@linaro.org>
To: Felipe Balbi <balbi@ti.com>
Cc: Chao Xu <caesarxuchao@gmail.com>, Linux-OMAP <linux-omap@vger.kernel.org>,
        "santosh.shilimkar@ti.com" <santosh.shilimkar@ti.com>,
        ext Kevin Hilman <khilman@deeprootsystems.com>,
        "linux-gpio@vger.kernel.org" <linux-gpio@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        ext Tony Lindgren <tony@atomide.com>,
        Kevin Hilman <khilman@linaro.org>, Nishanth Menon <nm@ti.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Dec 12, 2013 at 7:28 PM, Felipe Balbi <balbi@ti.com> wrote:
> On Thu, Dec 12, 2013 at 07:19:35PM +0100, Linus Walleij wrote:

>> One thing caught my eye, you add:
>>
>> > +static void _aggressive_pm_runtime_get_sync(struct gpio_bank *bank)
>> > +static void _aggressive_pm_runtime_put(struct gpio_bank *bank)
>> (..)
>>
>> Then everywhere:
>>
>> > +       _aggressive_pm_runtime_get_sync(bank);
>> (...)
>> > +       _aggressive_pm_runtime_put(bank);
>>
>> Aggressive, argh, runtime PM is agressive by definition. If you
>> want to switch this on and off use the compile option
>> to enable/disable runtime PM altogether and do not wrap it
>> like this.
>
> heh, OMAP doesn't work without pm_runtime.

Hm then maybe that needs to be fixed ... or the runtime PM
people need to be convinced to support different levels of
aggressiveness in the core?

Yours,
Linus Walleij

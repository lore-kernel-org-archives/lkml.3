Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756179Ab3C1Nno (ORCPT <rfc822;w@1wt.eu>);
	Thu, 28 Mar 2013 09:43:44 -0400
Received: from mail-la0-f42.google.com ([209.85.215.42]:53768 "EHLO
	mail-la0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755724Ab3C1Nnn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 28 Mar 2013 09:43:43 -0400
MIME-Version: 1.0
In-Reply-To: <20130328074507.GC24433@gmail.com>
References: <1364398359-21990-1-git-send-email-fweisbec@gmail.com>
	<1364398359-21990-5-git-send-email-fweisbec@gmail.com>
	<20130328074507.GC24433@gmail.com>
Date: Thu, 28 Mar 2013 14:43:41 +0100
Message-ID: <CAFTL4hzQfodVP4O+nir1XwQ2QkUUqrfr_dBpWL0635f0u4oRBA@mail.gmail.com>
Subject: Re: [PATCH 4/4] nohz: New option to force all CPUs in full dynticks range
From: Frederic Weisbecker <fweisbec@gmail.com>
To: Ingo Molnar <mingo@kernel.org>
Cc: LKML <linux-kernel@vger.kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Chris Metcalf <cmetcalf@tilera.com>, Christoph Lameter <cl@linux.com>,
        Geoff Levand <geoff@infradead.org>,
        Gilad Ben Yossef <gilad@benyossef.com>,
        Hakan Akkan <hakanakkan@gmail.com>, Kevin Hilman <khilman@linaro.org>,
        Li Zhong <zhong@linux.vnet.ibm.com>,
        Namhyung Kim <namhyung.kim@lge.com>,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
        Paul Gortmaker <paul.gortmaker@windriver.com>,
        Peter Zijlstra <peterz@infradead.org>,
        Steven Rostedt <rostedt@goodmis.org>,
        Thomas Gleixner <tglx@linutronix.de>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2013/3/28 Ingo Molnar <mingo@kernel.org>:
>
> * Frederic Weisbecker <fweisbec@gmail.com> wrote:
>
>> +config NO_HZ_EXTENDED_ALL
>> +       bool "Full dynticks system on all CPUs"
>> +       depends on NO_HZ_EXTENDED
>> +       help
>> +      Force all CPUs to be full dynticks. The range specified in the
>> +      nohz_extended boot option will then be ignored.
>> +
>> +      Note the boot CPU will still be kept outside the range to handle
>> +      the timekeeping duty.
>
> In most cases this will be the first time users doing 'make oldconfig'
> will hear about this feature, so I'd not mention noh_extended in such a
> primary way at all.
>
> Instead I'd suggest to explain, in a few simple sentences, what 'full
> dynticks' _is_. Then maybe mention this near the end of the next:
>
>    ( Alternatively this feature can also be enabled via the
>      nohz_extended=<cpulist> boot option. If this kernel config option is
>      enabled then the nohz_extended boot parameter is ignored. )

Ok. Hmm, concerning what full dynticks is, those who run make
oldconfig should have passed through CONFIG_NO_HZ_EXTENDED help first
so they should know what this is all about, right? I can improve its
help text if you think something need more details. Or you think I
should add some more reminder in the new config? Also nohz_extended is
not mentioned there so I indeed need to fix that. And then do a
reminder in the new config. I'll reuse a bit your above sentence.

>
> Btw., while at it - I think the nohz_extended boot parameter should _not_
> be ignored. The .config option should simply provide a default, for the
> case that the user does not have any boot option specified.

Agreed.

>
> If the user specifies a boot option - say to work around a rare installer
> hang in a distro install kernel - then we very much _dont_ want to ignore
> it.
>
> So please put some effort into how this feature is going to interface with
> and be represented to actual users and distro kernel maintainers.

Ok, will improve that.

Thanks.

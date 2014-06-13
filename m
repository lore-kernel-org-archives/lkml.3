Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754062AbaFMWGW (ORCPT <rfc822;w@1wt.eu>);
	Fri, 13 Jun 2014 18:06:22 -0400
Received: from mail-lb0-f173.google.com ([209.85.217.173]:56288 "EHLO
	mail-lb0-f173.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753926AbaFMWGU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 13 Jun 2014 18:06:20 -0400
MIME-Version: 1.0
In-Reply-To: <1402695712.27369.10.camel@buesod1.americas.hpqcorp.net>
References: <1402684097-5731-1-git-send-email-mcgrof@do-not-panic.com> <1402695712.27369.10.camel@buesod1.americas.hpqcorp.net>
From: "Luis R. Rodriguez" <mcgrof@do-not-panic.com>
Date: Fri, 13 Jun 2014 15:05:59 -0700
X-Google-Sender-Auth: YqL-Tpkaydwdd-q9iVdmKJzYDW8
Message-ID: <CAB=NE6XZENSV1ZnpEURd9ZbBwKUnUdzqoO8ufG846nVEEpA92Q@mail.gmail.com>
Subject: Re: [PATCH v3] printk: allow increasing the ring buffer depending on
 the number of CPUs
To: Davidlohr Bueso <davidlohr@hp.com>
Cc: hpa@linux.intel.com, Andrew Morton <akpm@linux-foundation.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Michal Hocko <mhocko@suse.cz>, Petr Mladek <pmladek@suse.cz>,
        Joe Perches <joe@perches.com>, Arun KS <arunks.linux@gmail.com>,
        Kees Cook <keescook@chromium.org>, Chris Metcalf <cmetcalf@tilera.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jun 13, 2014 at 2:41 PM, Davidlohr Bueso <davidlohr@hp.com> wrote:
> On Fri, 2014-06-13 at 11:28 -0700, Luis R. Rodriguez wrote:
>> +     /*
>> +      * If you set log_buf_len=n kernel parameter LOG_CPU_MIN_BUF_SHIFT will
>> +      * be ignored. LOG_CPU_MIN_BUF_SHIFT is a proactive measure for large
>> +      * systems. With a LOG_BUF_SHIFT of 18 and LOG_CPU_MIN_BUF_SHIFT 12 at
>> +      * we'd require more than 64 CPUs to trigger an increase from the
>> +      * default.
>> +      */
>> +     if (!new_log_buf_len && (cpu_extra > __LOG_BUF_LEN / 2))
>              ^ that ! looks wrong.

That check is there so that we ignore the cpu_extra stuff if the
kernel parameter was passed, given that in that case new_log_buf_len
would be set.

> We should be checking for log_buf_len set instead.

When log_buf_len=n is set as a kernel parameter log_buf_len_setup()
will set new_log_buf_len to something, the sanity test to not update
the ring buffer unless the value passed is greater than the default
value is checked by log_buf_len_setup().

>> +             new_log_buf_len = __LOG_BUF_LEN + cpu_extra;
>
> You could also move the whole thing below the return statement, that way
> we can avoid double checking new_log_buf_len. Otherwise looks kinda
> weird.

If we did we'd be forcing the kernel parameter to be used to enable
this functionality, but we don't want that.

  Luis

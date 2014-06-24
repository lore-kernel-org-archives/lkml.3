Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753139AbaFXUNy (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Jun 2014 16:13:54 -0400
Received: from mail-lb0-f180.google.com ([209.85.217.180]:58413 "EHLO
	mail-lb0-f180.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751413AbaFXUNx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Jun 2014 16:13:53 -0400
MIME-Version: 1.0
In-Reply-To: <1403639030.29061.37.camel@joe-AO725>
References: <1403477209-14612-1-git-send-email-minipli@googlemail.com>
	<1403477209-14612-2-git-send-email-minipli@googlemail.com>
	<1403639030.29061.37.camel@joe-AO725>
Date: Tue, 24 Jun 2014 22:13:52 +0200
Message-ID: <CA+rthh_-i2z3hrsefD2dTXitoSfbMcnqmWS17T8jweHQPA2FWQ@mail.gmail.com>
Subject: Re: [RFC PATCH 1/3] init.h: Add __init_str / __exit_str macros
From: Mathias Krause <minipli@googlemail.com>
To: Joe Perches <joe@perches.com>
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Steven Rostedt <rostedt@goodmis.org>,
        "Rafael J. Wysocki" <rjw@rjwysocki.net>,
        Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>,
        "H. Peter Anvin" <hpa@zytor.com>, Jason Baron <jbaron@redhat.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 24 June 2014 21:43, Joe Perches <joe@perches.com> wrote:
> On Mon, 2014-06-23 at 00:46 +0200, Mathias Krause wrote:
>> Add macros to be able to mark string literals used in __init / __exit
>> functions.
> []
>> diff --git a/include/linux/init.h b/include/linux/init.h
> []
>> +#define __init_str(str)      __mark_str(str, __UNIQUE_ID(_init_str_), __initconst)
>> +#define __exit_str(str)      __mark_str(str, __UNIQUE_ID(_exit_str_), __exitdata)
>> +#define __mark_str(str, var, __section) \
>> +     ({ static const char var[] __section __aligned(1) = str; var; })
>> +
>
> You probably want to make these strings vanish
> completely when !CONFIG_PRINTK.
>
> As is, they will always exist in the image.

They will not. They are vanished as printk() is an empty static inline
function for the !CONFIG_PRINTK case. gcc is clever enough to optimize
the variables away in this case.

Thanks,
Mathias

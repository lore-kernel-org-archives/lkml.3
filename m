Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751882AbaGFQci (ORCPT <rfc822;w@1wt.eu>);
	Sun, 6 Jul 2014 12:32:38 -0400
Received: from mail-oa0-f48.google.com ([209.85.219.48]:65489 "EHLO
	mail-oa0-f48.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751543AbaGFQch (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 6 Jul 2014 12:32:37 -0400
MIME-Version: 1.0
In-Reply-To: <1404663787.27043.33.camel@joe-AO725>
References: <1404663138-21333-1-git-send-email-fabio.falzoi84@gmail.com>
	<1404663138-21333-3-git-send-email-fabio.falzoi84@gmail.com>
	<1404663787.27043.33.camel@joe-AO725>
Date: Sun, 6 Jul 2014 18:32:36 +0200
Message-ID: <CACar8Ln_8+EQGf8z7kNqRPxOcheUuKj5bOg3TJ+xTF_SQFVGQQ@mail.gmail.com>
Subject: Re: [PATCH 2/4] Staging: rts5208: Use standard print_hex_dump_debug
From: Fabio Falzoi <fabio.falzoi84@gmail.com>
To: Joe Perches <joe@perches.com>
Cc: gregkh@linuxfoundation.org, devel@driverdev.osuosl.org,
        linux-kernel@vger.kernel.org, wei_wang@realsil.com.cn,
        micky_ching@realsil.com.cn
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Have I to fix just the commit message or is this behaviour not suitable?
In the latter case, could you please suggest a way to fix this?

Thank you,
Fabio

On Sun, Jul 6, 2014 at 6:23 PM, Joe Perches <joe@perches.com> wrote:
> On Sun, 2014-07-06 at 18:12 +0200, Fabio Falzoi wrote:
>> Use print_hex_dump_debug to have memory properly dumped only when dynamic
>> debug is enabled.
>
> Not true.
> Now it prints all the time when !CONFIG_DYNAMIC_DEBUG
> and CONFIG_PRINTK.
>
>> diff --git a/drivers/staging/rts5208/trace.h b/drivers/staging/rts5208/trace.h
> []
>> -#ifdef CONFIG_RTS5208_DEBUG
>> -#define RTSX_DUMP(buf, buf_len)                                      \
>> -     print_hex_dump(KERN_DEBUG, KBUILD_MODNAME ": ",         \
>> -                    DUMP_PREFIX_NONE, 16, 1, (buf), (buf_len), false)
>> -#else
>> -#define RTSX_DUMP(buf, buf_len)
>> -#endif
>> -
>>  #endif  /* __REALTEK_RTSX_TRACE_H */
>
> Before it would not print at all if !CONFIG_RTS5208_DEBUG.
>

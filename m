Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752547Ab3IRPXT (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Sep 2013 11:23:19 -0400
Received: from science.horizon.com ([71.41.210.146]:54890 "HELO
	science.horizon.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1751497Ab3IRPXR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Sep 2013 11:23:17 -0400
Date: 18 Sep 2013 11:22:09 -0400
Message-ID: <20130918152209.16302.qmail@science.horizon.com>
From: "George Spelvin" <linux@horizon.com>
To: dan.carpenter@oracle.com, penguin-kernel@I-love.SAKURA.ne.jp
Subject: Re: [PATCH 0/2] vsprintf: ignore %n again
Cc: akpm@linux-foundation.org, JBeulich@suse.com, joe@perches.com,
        keescook@chromium.org, kosaki.motohiro@gmail.com,
        linux-kernel@vger.kernel.org, linux@horizon.com,
        viro@zeniv.linux.org.uk
In-Reply-To: <20130918141104.GT19256@mwanda>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> +#define printk(fmt, ...) do {				  \
> +	compiletime_assert(__builtin_constant_p(fmt),     \
> +			   "Non-constant format string"); \
> +	printk(fmt, ##__VA_ARGS__);			  \
> +} while (0)

May I recommend __builtin_constant_p(*fmt).  Since:

char buf[OVERFLOW_VULNERABILITY];
strcpy(buf, malicious_format);
printk(buf, args)

has __builtin_constant_p(buf), but it's not a constant format string.

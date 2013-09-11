Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754823Ab3IKFTW (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Sep 2013 01:19:22 -0400
Received: from mail-ob0-f175.google.com ([209.85.214.175]:43750 "EHLO
	mail-ob0-f175.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752773Ab3IKFTS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Sep 2013 01:19:18 -0400
MIME-Version: 1.0
In-Reply-To: <1378875632.606.5.camel@joe-AO722>
References: <20130911044116.GA17294@www.outflux.net>
	<1378875632.606.5.camel@joe-AO722>
Date: Tue, 10 Sep 2013 22:19:17 -0700
X-Google-Sender-Auth: o40sdLgaGrOIMSSUIXG4feT0EEE
Message-ID: <CAGXu5jLm1RNp4mB2KfeRumTqeWgcAsZ4CpQQQGA67WukERefXQ@mail.gmail.com>
Subject: Re: [PATCH] staging: dgnc: fix potential format string flaw
From: Kees Cook <keescook@chromium.org>
To: Joe Perches <joe@perches.com>
Cc: LKML <linux-kernel@vger.kernel.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Lidza Louina <lidza.louina@gmail.com>,
        Tushar Behera <tushar.behera@linaro.org>, devel@driverdev.osuosl.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Sep 10, 2013 at 10:00 PM, Joe Perches <joe@perches.com> wrote:
> On Tue, 2013-09-10 at 21:41 -0700, Kees Cook wrote:
>> Make sure that format strings cannot leak into printk() calls from the
>> msgbuf string.
>
>         printf(string);
> vs
>         printf("%s", string);
>
> How does this help?

In the former case, format characters will get processed by the
sprintf logic. In the latter, they are printed as-is. In this specific
case, if there was a way to inject strings like "ohai %n" into the
msgbuf string, the former would actually attempt to resolve the %n. In
the simple case, this could lead to Oopses, and in the unlucky case,
it could allow arbitrary memory writing and execution control.

http://en.wikipedia.org/wiki/Uncontrolled_format_string

-Kees

-- 
Kees Cook
Chrome OS Security

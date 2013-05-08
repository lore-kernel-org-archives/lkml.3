Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755040Ab3EHPfo (ORCPT <rfc822;w@1wt.eu>);
	Wed, 8 May 2013 11:35:44 -0400
Received: from mail-ie0-f176.google.com ([209.85.223.176]:64148 "EHLO
	mail-ie0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753336Ab3EHPfm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 8 May 2013 11:35:42 -0400
MIME-Version: 1.0
In-Reply-To: <1367997761.10764.23.camel@mattotaupa>
References: <20130507193216.GA2214@www.outflux.net>
	<1367997761.10764.23.camel@mattotaupa>
Date: Wed, 8 May 2013 08:35:42 -0700
X-Google-Sender-Auth: qp9dpv0QashDvP60CXb59d-dOp4
Message-ID: <CAGXu5j+93SVX4qPgRQrmoKpqyVKsptYVsmQSgZkgvqovnpVE9A@mail.gmail.com>
Subject: Re: [PATCH] drm: refactor call to request_module
From: Kees Cook <keescook@chromium.org>
To: Paul Menzel <paulepanter@users.sourceforge.net>
Cc: LKML <linux-kernel@vger.kernel.org>, dri-devel@lists.freedesktop.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, May 8, 2013 at 12:22 AM, Paul Menzel
<paulepanter@users.sourceforge.net> wrote:
> Am Dienstag, den 07.05.2013, 12:32 -0700 schrieb Kees Cook:
>> This reduces the size of the stack frame when calling request_module().
>> Performing the sprintf before the call is not needed.
>
> Good fine. Do you have any hard numbers for the record?
>
> Did you find this just by reading the code or are there any problems
> with stack sizes on some systems?
>
> (This patch would be good alone for decreasing the number of code
> lines. ;-))

No hard numbers; I just saw it while reviewing callers to request_module(). :)

>> Signed-off-by: Kees Cook <keescook@chromium.org>
>> ---
>>  drivers/gpu/drm/drm_encoder_slave.c |    6 +-----
>>  1 file changed, 1 insertion(+), 5 deletions(-)
>
> Acked-by: Paul Menzel <paulepanter@users.sourceforge.net>

Thanks!

-Kees

--
Kees Cook
Chrome OS Security

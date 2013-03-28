Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755860Ab3C1NTa (ORCPT <rfc822;w@1wt.eu>);
	Thu, 28 Mar 2013 09:19:30 -0400
Received: from mail-da0-f42.google.com ([209.85.210.42]:53042 "EHLO
	mail-da0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754922Ab3C1NT3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 28 Mar 2013 09:19:29 -0400
Message-ID: <51544367.2020904@linaro.org>
Date: Thu, 28 Mar 2013 07:19:35 -0600
From: Mathieu Poirier <mathieu.poirier@linaro.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/17.0 Thunderbird/17.0
MIME-Version: 1.0
To: Jiri Slaby <jslaby@suse.cz>
CC: Linus Torvalds <torvalds@linux-foundation.org>,
        LKML <linux-kernel@vger.kernel.org>,
        Dmitry Torokhov <dmitry.torokhov@gmail.com>
Subject: Re: Out-of-bound access in sysrq
References: <51541C9B.4000802@suse.cz>
In-Reply-To: <51541C9B.4000802@suse.cz>
X-Enigmail-Version: 1.4.6
Content-Type: text/plain; charset=ISO-8859-2
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 13-03-28 04:34 AM, Jiri Slaby wrote:
> Guys,
> 
> how is this supposed to work?
> 
> #define SYSRQ_KEY_RESET_MAX     20 /* Should be plenty */
> static unsigned short sysrq_reset_seq[SYSRQ_KEY_RESET_MAX];
> ...
> unsigned short platform_sysrq_reset_seq[] __weak = { KEY_RESERVED };
> ...
> static inline void sysrq_register_handler(void)
> {
> ...
>         for (i = 0; i < ARRAY_SIZE(sysrq_reset_seq); i++) {
>                 key = platform_sysrq_reset_seq[i];
>                 if (key == KEY_RESERVED || key > KEY_MAX)
> ...
> 
> 
> 
> 
> i runs from 0 to 19 incl., but platform_sysrq_reset_seq, if not
> overriden, is of size 1, so?
> 
> thanks,
> 

Unless I'm missing something, 'i' won't go higher than '0' since the
first element of platform_sysrq_reset_seq is set to KEY_RESERVED and in
such case the 'break' is executed.



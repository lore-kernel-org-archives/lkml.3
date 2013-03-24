Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754680Ab3CXTbS (ORCPT <rfc822;w@1wt.eu>);
	Sun, 24 Mar 2013 15:31:18 -0400
Received: from mail-ea0-f173.google.com ([209.85.215.173]:54769 "EHLO
	mail-ea0-f173.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754556Ab3CXTbQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 24 Mar 2013 15:31:16 -0400
Message-ID: <514F5480.6040501@suse.cz>
Date: Sun, 24 Mar 2013 20:31:12 +0100
From: Jiri Slaby <jslaby@suse.cz>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:19.0) Gecko/20130124 Thunderbird/19.0
MIME-Version: 1.0
To: Sebastian Gottschall <s.gottschall@dd-wrt.com>,
        linux-kernel@vger.kernel.org
CC: stable@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>,
        keescook@chromium.org
Subject: Build breakage in 3.8.4 [was: Linux 3.8.4]
References: <20130320201554.GA18281@kroah.com> <kidd01$2o6$1@ger.gmane.org>
In-Reply-To: <kidd01$2o6$1@ger.gmane.org>
X-Enigmail-Version: 1.6a1pre
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 03/20/2013 11:25 PM, Sebastian Gottschall wrote:

> Am 20.03.2013 21:15, schrieb Greg KH:
>> I'm announcing the release of the 3.8.4 kernel.
...
>>        signal: always clear sa_restorer on execve
> consider that this kernel is not compileable on mips targets due the
> patch in kernel/signal.c
>
> SA_RESTORER is defined in mips, but sa_restorer does not exist on that
> platform

The same for ia64...

kernel/signal.c: In function 'flush_signal_handlers':
kernel/signal.c:441: error: 'struct sigaction' has no member named
'sa_restorer'

Do we need this in 3.0, 3.4, 3.8 too?
commit 522cff142d7d2f9230839c9e1f21a4d8bcc22a4a
Author: Andrew Morton <akpm@linux-foundation.org>
Date:   Wed Mar 13 14:59:34 2013 -0700

    kernel/signal.c: use __ARCH_HAS_SA_RESTORER instead of SA_RESTORER

    __ARCH_HAS_SA_RESTORER is the preferred conditional for use in 3.9 and
    later kernels, per Kees.

thanks,
-- 
js
suse labs

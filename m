Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752423Ab3KNBTj (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Nov 2013 20:19:39 -0500
Received: from mail-pa0-f44.google.com ([209.85.220.44]:41208 "EHLO
	mail-pa0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750889Ab3KNBTc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Nov 2013 20:19:32 -0500
Date: Wed, 13 Nov 2013 17:19:29 -0800
From: Guenter Roeck <linux@roeck-us.net>
To: "H. Peter Anvin" <hpa@zytor.com>
Cc: Kees Cook <keescook@chromium.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        linux-kernel@vger.kernel.org, Jan Beulich <JBeulich@suse.com>
Subject: Re: [PATCH] gcc4: Disable __compiletime_object_size for GCC 4.6+
Message-ID: <20131114011929.GA13835@roeck-us.net>
References: <1365821348-7177-1-git-send-email-linux@roeck-us.net>
 <20131113183913.GK4994@outflux.net>
 <5283E7A9.6090706@zytor.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <5283E7A9.6090706@zytor.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Nov 13, 2013 at 12:57:13PM -0800, H. Peter Anvin wrote:
> On 11/13/2013 10:39 AM, Kees Cook wrote:
> > Hi Guenter,
> > 
> > On Fri, Apr 12, 2013 at 07:49:08PM -0700, Guenter Roeck wrote:
> >> __builtin_object_size is known to be broken on gcc 4.6+.
> >> See http://gcc.gnu.org/bugzilla/show_bug.cgi?id=48880 for details.
> >>
> >> This causes unnecssary build warnings and errors such as
> >>
> >> In function 'copy_from_user', inlined from 'sb16_copy_from_user'
> >> 	at sound/oss/sb_audio.c:878:22:
> >> arch/x86/include/asm/uaccess_32.h:211:26: error: call to 'copy_from_user_overflow'
> >> 	declared with attribute error: copy_from_user() buffer size is not provably correct
> >> make[3]: [sound/oss/sb_audio.o] Error 1 (ignored)
> >>
> >> Disable it where broken.
> > 
> > Is there an alternative? This means that things like
> > DEBUG_STRICT_USER_COPY_CHECKS are being rendered useless. I don't think
> > this is _always_ broken, just under certain situations, right?
> > 
> 
> It would be one thing to block it for, say, gcc 4.6 and 4.7 only, but
> without an upper cap I don't think this is at all okay.
> 
Also please have a look into https://lkml.org/lkml/2013/10/21/52.
That patch has been accepted (3df7b41aa5e); maybe above commit
(2fb0815c9) is now unnecessary and can be reverted.

I don't know about parisc (Jan was concerned about that), but at least
on x86 I don't see above warning anymore after reverting my patch.

Guenter

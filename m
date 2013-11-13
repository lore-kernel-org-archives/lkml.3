Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751164Ab3KMUYm (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Nov 2013 15:24:42 -0500
Received: from mail-pb0-f45.google.com ([209.85.160.45]:52582 "EHLO
	mail-pb0-f45.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750881Ab3KMUYg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Nov 2013 15:24:36 -0500
Date: Wed, 13 Nov 2013 12:24:35 -0800
From: Guenter Roeck <linux@roeck-us.net>
To: Kees Cook <keescook@chromium.org>
Cc: Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] gcc4: Disable __compiletime_object_size for GCC 4.6+
Message-ID: <20131113202435.GB5322@roeck-us.net>
References: <1365821348-7177-1-git-send-email-linux@roeck-us.net>
 <20131113183913.GK4994@outflux.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20131113183913.GK4994@outflux.net>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Nov 13, 2013 at 10:39:13AM -0800, Kees Cook wrote:
> Hi Guenter,
> 
> On Fri, Apr 12, 2013 at 07:49:08PM -0700, Guenter Roeck wrote:
> > __builtin_object_size is known to be broken on gcc 4.6+.
> > See http://gcc.gnu.org/bugzilla/show_bug.cgi?id=48880 for details.
> > 
> > This causes unnecssary build warnings and errors such as
> > 
> > In function 'copy_from_user', inlined from 'sb16_copy_from_user'
> > 	at sound/oss/sb_audio.c:878:22:
> > arch/x86/include/asm/uaccess_32.h:211:26: error: call to 'copy_from_user_overflow'
> > 	declared with attribute error: copy_from_user() buffer size is not provably correct
> > make[3]: [sound/oss/sb_audio.o] Error 1 (ignored)
> > 
> > Disable it where broken.
> 
> Is there an alternative? This means that things like
> DEBUG_STRICT_USER_COPY_CHECKS are being rendered useless. I don't think
> this is _always_ broken, just under certain situations, right?
> 
There was a recent proposal to address the problem differently and then revert
this patch. Not sure what happened with it. I can try digging it up if necessary.

Guenter

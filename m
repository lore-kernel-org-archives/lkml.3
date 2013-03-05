Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752371Ab3CEKrK (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Mar 2013 05:47:10 -0500
Received: from mail-pb0-f46.google.com ([209.85.160.46]:37419 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750729Ab3CEKrJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Mar 2013 05:47:09 -0500
Date: Tue, 5 Mar 2013 18:47:27 +0800
From: Greg KH <gregkh@linuxfoundation.org>
To: Serban Constantinescu <Serban.Constantinescu@arm.com>
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "kernel-team@android.com" <kernel-team@android.com>,
        "arve@android.com" <arve@android.com>,
        "john.stultz@linaro.org" <john.stultz@linaro.org>,
        Dave Butcher <Dave.Butcher@arm.com>
Subject: Re: [PATCH] staging: android: ashmem: Add support for 32bit ashmem
 calls in a 64bit kernel
Message-ID: <20130305104727.GA3654@kroah.com>
References: <20130305083707.GA7513@kroah.com>
 <1362478708-26946-1-git-send-email-serban.constantinescu@arm.com>
 <20130305102745.GA3327@kroah.com>
 <5135CB38.1030201@arm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <5135CB38.1030201@arm.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Mar 05, 2013 at 10:38:48AM +0000, Serban Constantinescu wrote:
> On 05/03/13 10:27, Greg KH wrote:
> >On Tue, Mar 05, 2013 at 10:18:27AM +0000, Serban Constantinescu wrote:
> >>Android's shared memory subsystem, Ashmem, does not support calls from a
> >>32bit userspace in a 64 bit kernel. This patch adds support for syscalls
> >>coming from a 32bit userspace in a 64bit kernel.
> >>
> >>The patch has been successfully tested on ARMv8 AEM(64bit
> >>platform model) and Versatile Express A9(32bit platform).
> >>
> >>Signed-off-by: Serban Constantinescu <serban.constantinescu@arm.com>
> >>---
> >>  drivers/staging/android/ashmem.c |   22 +++++++++++++++++++++-
> >>  drivers/staging/android/ashmem.h |    6 ++++++
> >>  2 files changed, 27 insertions(+), 1 deletion(-)
> >
> >Ok, what has changed from your previous version that I rejected that is
> >going to actually allow this to build?
> 
> I had to add <linux/compat.h> for a successful build on x86_64. The
> attached hunk is the only change added.

Ok, please say that.  I deal with over 7000 patches a year, there is no
way I can remember what the difference is between this one, and the
previous one I rejected.  Especially as I reviewed about 30 patches
inbetween the time I rejected it and you sent this update.

> >diff --git a/drivers/staging/android/ashmem.c b/drivers/staging/android/ashmem.c
> >index 72064fc..e96f381 100644
> >--- a/drivers/staging/android/ashmem.c
> >+++ b/drivers/staging/android/ashmem.c
> >@@ -31,6 +31,7 @@
> > #include <linux/bitops.h>
> > #include <linux/mutex.h>
> > #include <linux/shmem_fs.h>
> >+#include <linux/compat.h>
> > #include "ashmem.h"
> >
> > #define ASHMEM_NAME_PREFIX "dev/ashmem/"
> 
> 
> >
> >Hint, you gotta tell me what version of the patch this is, and what
> >changed, otherwise I'll just assume this is a resend of the previous
> >patch and go ahead and delete it from my queue.
> 
> Sorry - same patch as before, the one that had John and Arve's ack,
> plus the above hunk.

That is not what I meant, please go read Section 2 of the
Documentation/SubmittingPatches file for what I need to see here.

thanks,

greg k-h

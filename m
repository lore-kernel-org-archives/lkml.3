Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762479Ab3IDMEz (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Sep 2013 08:04:55 -0400
Received: from mail-ee0-f51.google.com ([74.125.83.51]:35721 "EHLO
	mail-ee0-f51.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756580Ab3IDMEw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Sep 2013 08:04:52 -0400
Date: Wed, 4 Sep 2013 14:05:04 +0200
From: Daniel Vetter <daniel@ffwll.ch>
To: Martin Peres <martin.peres@free.fr>
Cc: Christopher James Halse Rogers 
	<christopher.halse.rogers@canonical.com>,
        linux-arch@vger.kernel.org, linux-kernel@vger.kernel.org,
        dri-devel@lists.freedesktop.org, linaro-mm-sig@lists.linaro.org,
        robclark@gmail.com, linux-media@vger.kernel.org
Subject: Re: [PATCH] dma-buf: Expose buffer size to userspace (v2)
Message-ID: <20130904120504.GB28675@phenom.ffwll.local>
Mail-Followup-To: Martin Peres <martin.peres@free.fr>,
	Christopher James Halse Rogers <christopher.halse.rogers@canonical.com>,
	linux-arch@vger.kernel.org, linux-kernel@vger.kernel.org,
	dri-devel@lists.freedesktop.org, linaro-mm-sig@lists.linaro.org,
	robclark@gmail.com, linux-media@vger.kernel.org
References: <1378264549-9185-1-git-send-email-christopher.halse.rogers@canonical.com>
 <52270A5B.2040600@free.fr>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <52270A5B.2040600@free.fr>
X-Operating-System: Linux phenom 3.10-2-amd64
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Sep 04, 2013 at 12:24:27PM +0200, Martin Peres wrote:
> Hi Christopher,
> Le 04/09/2013 05:15, Christopher James Halse Rogers a écrit :
> >Each dma-buf has an associated size and it's reasonable for userspace
> >to want to know what it is.
> >
> >Since userspace already has an fd, expose the size using the
> >size = lseek(fd, SEEK_END, 0); lseek(fd, SEEK_CUR, 0);
> >idiom.
> >
> >v2: Added Daniel's sugeested documentation, with minor fixups
> >
> >Signed-off-by: Christopher James Halse Rogers <christopher.halse.rogers@canonical.com>
> >Reviewed-by: Daniel Vetter <daniel.vetter@ffwll.ch>
> >Tested-by: Daniel Vetter <daniel.vetter@ffwll.ch>
> >---
> >  Documentation/dma-buf-sharing.txt | 12 ++++++++++++
> >  drivers/base/dma-buf.c            | 28 ++++++++++++++++++++++++++++
> >  2 files changed, 40 insertions(+)
> >
> >diff --git a/Documentation/dma-buf-sharing.txt b/Documentation/dma-buf-sharing.txt
> >index 0b23261..849e982 100644
> >--- a/Documentation/dma-buf-sharing.txt
> >+++ b/Documentation/dma-buf-sharing.txt
> >@@ -407,6 +407,18 @@ Being able to mmap an export dma-buf buffer object has 2 main use-cases:
> >     interesting ways depending upong the exporter (if userspace starts depending
> >     upon this implicit synchronization).
> >+Other Interfaces Exposed to Userspace on the dma-buf FD
> >+------------------------------------------------------
> >+
> >+- Since kernel 3.12 the dma-buf FD supports the llseek system call, but only
> >+  with offset=0 and whence=SEEK_END|SEEK_SET. SEEK_SET is supported to allow
> >+  the usual size discover pattern size = SEEK_END(0); SEEK_SET(0). Every other
> >+  llseek operation will report -EINVAL.
> >+
> >+  If llseek on dma-buf FDs isn't support the kernel will report -ESPIPE for all
> Shouldn't it be "supported" instead of "support"?
> 
> Anyway, I'm just curious, in which case is it important to know the size?
> Do we already have a way to get the dimensions (x, y and stripe)?

Size is an invariant part of a dma-buf. Everything else wrt metadata isn't
tracked in the kernel, so doesn't make much sense to expose it ;-)
-Daniel
-- 
Daniel Vetter
Software Engineer, Intel Corporation
+41 (0) 79 365 57 48 - http://blog.ffwll.ch

Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934726Ab3DSXHc (ORCPT <rfc822;w@1wt.eu>);
	Fri, 19 Apr 2013 19:07:32 -0400
Received: from mail-vc0-f171.google.com ([209.85.220.171]:49501 "EHLO
	mail-vc0-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934183Ab3DSXHb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 19 Apr 2013 19:07:31 -0400
MIME-Version: 1.0
In-Reply-To: <CANN689Ey14vPAiENzRaW19wTzYcJrWmX9GeBcOpGLTQg_gHRsw@mail.gmail.com>
References: <CA+55aFyK2EEPuBPrqu3AGRbW+8TdP=kLLz4opvynNRcrSWC2ww@mail.gmail.com>
	<CANN689Ey14vPAiENzRaW19wTzYcJrWmX9GeBcOpGLTQg_gHRsw@mail.gmail.com>
Date: Fri, 19 Apr 2013 16:07:29 -0700
X-Google-Sender-Auth: Z16OMMLTGTyIQuckDNia1SEjcig
Message-ID: <CA+55aFyVYBzOaTq2VTf2pZdV5Z=O94-Q+ZELYRJcQR3DPzC23A@mail.gmail.com>
Subject: Re: Device driver memory 'mmap()' function helper cleanup
From: Linus Torvalds <torvalds@linux-foundation.org>
To: Michel Lespinasse <walken@google.com>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Clemens Ladisch <clemens@ladisch.de>, Arnd Bergmann <arnd@arndb.de>,
        Takashi Iwai <tiwai@suse.de>,
        Mauro Carvalho Chehab <mchehab@redhat.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Apr 19, 2013 at 8:43 AM, Michel Lespinasse <walken@google.com> wrote:
>
> Just a suggestion: when file->f_op->mmap returns an error code,
> mmap_region() currently has to call unmap_region() to undo any partial
> mappings that might have been created by the device driver. Would it
> make more sense to ask that the few drivers that create such messes to
> clean up after themselves on their error paths ?

No. We basically want to assume the least competence humanly
(simianly?) possible from driver writers. The problem the helper is
trying to solve is exactly the fact that driver writers shouldn't have
to even know about all the subtleties with page offsets etc.

So if a driver returns an error code, we should assume they screwed up
potentially half-way and clean up. We should *not* assume that we
don't need to.

                   Linus

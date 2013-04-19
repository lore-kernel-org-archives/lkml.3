Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030863Ab3DSPny (ORCPT <rfc822;w@1wt.eu>);
	Fri, 19 Apr 2013 11:43:54 -0400
Received: from mail-ia0-f182.google.com ([209.85.210.182]:39725 "EHLO
	mail-ia0-f182.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1030656Ab3DSPnw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 19 Apr 2013 11:43:52 -0400
MIME-Version: 1.0
In-Reply-To: <CA+55aFyK2EEPuBPrqu3AGRbW+8TdP=kLLz4opvynNRcrSWC2ww@mail.gmail.com>
References: <CA+55aFyK2EEPuBPrqu3AGRbW+8TdP=kLLz4opvynNRcrSWC2ww@mail.gmail.com>
Date: Fri, 19 Apr 2013 08:43:52 -0700
Message-ID: <CANN689Ey14vPAiENzRaW19wTzYcJrWmX9GeBcOpGLTQg_gHRsw@mail.gmail.com>
Subject: Re: Device driver memory 'mmap()' function helper cleanup
From: Michel Lespinasse <walken@google.com>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Clemens Ladisch <clemens@ladisch.de>, Arnd Bergmann <arnd@arndb.de>,
        Takashi Iwai <tiwai@suse.de>,
        Mauro Carvalho Chehab <mchehab@redhat.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Apr 16, 2013 at 8:12 PM, Linus Torvalds
<torvalds@linux-foundation.org> wrote:
> Guys, I just pushed out a new helper function intended for cleaning up
> various device driver mmap functions, because they are rather messy,
> and at least part of the problem was the bad impedance between what a
> driver author would want to have, and the VM interfaces to map a
> memory range into user space with mmap.

I have not had a detailed look yet (am at LSF/MM workshop right now).

Just a suggestion: when file->f_op->mmap returns an error code,
mmap_region() currently has to call unmap_region() to undo any partial
mappings that might have been created by the device driver. Would it
make more sense to ask that the few drivers that create such messes to
clean up after themselves on their error paths ?

-- 
Michel "Walken" Lespinasse
A program is never fully debugged until the last user dies.

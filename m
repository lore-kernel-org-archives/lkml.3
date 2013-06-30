Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753384Ab3F3ALh (ORCPT <rfc822;w@1wt.eu>);
	Sat, 29 Jun 2013 20:11:37 -0400
Received: from mail-ve0-f182.google.com ([209.85.128.182]:57367 "EHLO
	mail-ve0-f182.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751672Ab3F3ALf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 29 Jun 2013 20:11:35 -0400
MIME-Version: 1.0
In-Reply-To: <CA+QCeVSA+hAzoxXMcEVaUAaqsMpDoe22AGpKg538mytQXQgyEg@mail.gmail.com>
References: <CA+55aFz1yMZ1q5daHdTA91pW5QtQ1Yids1dLD9b2JC-ruicNQw@mail.gmail.com>
	<CA+QCeVR=+2vpFdW_LcjZUdNd+udY4dZEWXxevONTnbs8Y6oECQ@mail.gmail.com>
	<CA+55aFy8XfmbhaEFUvy5ToLuSSxw5dhw5vXbJ28QpA0sBZgYoQ@mail.gmail.com>
	<CA+QCeVTOQks+s7YEK1Sd-aKdg2ce=Jxchb5ATqW0fiZVebFMBw@mail.gmail.com>
	<CA+55aFx54EDTS0R7E8JpPzqfx8M5c-0Q5Q_z0ybnM1mmBvA=ig@mail.gmail.com>
	<CA+QCeVSA+hAzoxXMcEVaUAaqsMpDoe22AGpKg538mytQXQgyEg@mail.gmail.com>
Date: Sat, 29 Jun 2013 17:11:34 -0700
X-Google-Sender-Auth: Il5KvkIBXglNfwD13ackLq_TgMk
Message-ID: <CA+55aFx9zHkCPUujYMaFUCbRhX5w3LeUL7UrVtMEz7W60Sz3FQ@mail.gmail.com>
Subject: Re: Linux 3.10-rc7
From: Linus Torvalds <torvalds@linux-foundation.org>
To: Sergey Meirovich <rathamahata@gmail.com>
Cc: David Airlie <airlied@linux.ie>, Alex Deucher <alexander.deucher@amd.com>,
        Jerome Glisse <jglisse@redhat.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        DRI <dri-devel@lists.freedesktop.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Jun 29, 2013 at 4:52 PM, Sergey Meirovich <rathamahata@gmail.com> wrote:
>
> There was overheating issue, that caused forced power off in the
> middle of the first compile.

Ok, then the thing is easily explained by simply the filesystem being
shut down in an incomplete state. Sounds like the mkregtable binary
had been created but not written out, and the kernel (or rather,
shell) considers an empty executable to the same as "true", so after
the machine came back, that counts as a "successful" binary, it just
obviously doesn't write anything to stdout, which in turn then
explains the empty r200_reg_safe.h file.

So basically it boils down to: if the machine shuts down in the middle
of a build, without "make" having time to clean up partially built
files etc, you can get into strange inconsistent build trees and you
might want to do a "git clean -dqfx" to get rid of everything
generated.

But in your case it was probably just that one file. Might be a good
idea to do a clean rebuild anyway.

(Side note: I've seen 'ccache' have odd stale caches too after unclean
shutdowns, and then it's not sufficient to clean the build tree, you
need to do "ccache -C" too).

            Linus

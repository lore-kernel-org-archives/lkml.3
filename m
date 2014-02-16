Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752586AbaBPOkJ (ORCPT <rfc822;w@1wt.eu>);
	Sun, 16 Feb 2014 09:40:09 -0500
Received: from mail-la0-f45.google.com ([209.85.215.45]:37042 "EHLO
	mail-la0-f45.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752280AbaBPOkG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 16 Feb 2014 09:40:06 -0500
MIME-Version: 1.0
In-Reply-To: <1391862850-24620-1-git-send-email-ard.biesheuvel@linaro.org>
References: <1391862850-24620-1-git-send-email-ard.biesheuvel@linaro.org>
Date: Sun, 16 Feb 2014 15:40:04 +0100
Message-ID: <CAKv+Gu_cVcT_796qnxEi2uSmXBpiptgjL2tc3t4TVHryEu9tvw@mail.gmail.com>
Subject: Re: [PATCH v2 0/2] generic CPU feature based udev module autoprobing
From: Ard Biesheuvel <ard.biesheuvel@linaro.org>
To: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "gregkh@linuxfoundation.org" <gregkh@linuxfoundation.org>,
        Andrew Morton <akpm@linux-foundation.org>, linux-arch@vger.kernel.org
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
        Ard Biesheuvel <ard.biesheuvel@linaro.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Ping?

On 8 February 2014 13:34, Ard Biesheuvel <ard.biesheuvel@linaro.org> wrote:
> This series implements a generic way to wire up udev module autoprobing to
> optional CPU features.
>
> Patch #1 implements the actual generic part. It relies on the include file
> <asm/cpufeature.h> to be supplied by the architecture to map CPU features to
> the number based scheme used by modalias.
>
> Patch #2 aligns x86 with the generic code. As x86 allows matching on CPU vendor,
> family and model IDs, it still retains much of the original code for creating
> the module metadata.
>
> Changes since v1:
> - squashed into 2 patches, all the generic bits are now added in patch #1 and
>   all alignment of the x86 code with the newly introduced generic code is done
>   in patch #2
> - add more elaborate commit message for patch #1
> - added hpa's ack on patch #2
>
> Ard Biesheuvel (2):
>   cpu: add generic support for CPU feature based module autoloading
>   x86: align x86 arch with generic CPU modalias handling
>
>  arch/x86/Kconfig                  |  4 +--
>  arch/x86/include/asm/cpufeature.h |  7 +++++
>  arch/x86/kernel/cpu/match.c       | 42 ---------------------------
>  drivers/base/Kconfig              |  3 ++
>  drivers/base/cpu.c                | 46 ++++++++++++++++++++++++++----
>  include/linux/cpu.h               |  7 -----
>  include/linux/cpufeature.h        | 60 +++++++++++++++++++++++++++++++++++++++
>  include/linux/mod_devicetable.h   |  9 ++++++
>  scripts/mod/devicetable-offsets.c |  3 ++
>  scripts/mod/file2alias.c          | 20 +++++++++----
>  10 files changed, 139 insertions(+), 62 deletions(-)
>  create mode 100644 include/linux/cpufeature.h
>
> --
> 1.8.3.2
>

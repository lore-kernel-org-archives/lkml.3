Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751645AbaCaXuJ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 31 Mar 2014 19:50:09 -0400
Received: from mail-qa0-f52.google.com ([209.85.216.52]:58321 "EHLO
	mail-qa0-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751463AbaCaXuH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 31 Mar 2014 19:50:07 -0400
MIME-Version: 1.0
In-Reply-To: <CALCETrWuUcinbJ5v2LzaFWEg1vkBAB2H8rD9x0jccawwRwb4pQ@mail.gmail.com>
References: <CALCETrWuUcinbJ5v2LzaFWEg1vkBAB2H8rD9x0jccawwRwb4pQ@mail.gmail.com>
From: Andy Lutomirski <luto@amacapital.net>
Date: Mon, 31 Mar 2014 16:49:45 -0700
Message-ID: <CALCETrVG=49tVCFDfgQ=2EMJrV582JxGzfadGM+JxfL59JxG0A@mail.gmail.com>
Subject: Re: OOPS in hvc / virtconsole
To: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        linuxppc-dev@lists.ozlabs.org, virtio-dev@lists.oasis-open.org,
        virtualization@lists.linux-foundation.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Mar 31, 2014 at 3:31 PM, Andy Lutomirski <luto@amacapital.net> wrote:
> I'm running a Fedora distro kernel (3.13.7-200.fc20.x86_64) in kvm
> with these options:
>
> -chardev null,id=hvc0,signal=off
> -device virtio-serial-pci
> -device virtconsole,chardev=hvc0,name=virtme_console
> -append console=hvc0 console=ttyS0
> -nographic
>
> (There are more, but these are the interesting ones, I think.)

You can reproduce it by downloading this:

https://git.kernel.org/cgit/utils/kernel/virtme/virtme.git/commit/?h=crash-virtconsole&id=c55df415154e6331a1dc96a5e2ffcf5c684fc2f9

and running:

./virtme-run --installed-kernel 3.13.7-200.fc20.x86_64 --console
--qemu-opts -m 2048 -smp 2

Adjust the requested kernel version as appropriate.

--Andy

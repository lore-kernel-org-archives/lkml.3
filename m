Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751817Ab3KYUqK (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 Nov 2013 15:46:10 -0500
Received: from mail-pb0-f47.google.com ([209.85.160.47]:41153 "EHLO
	mail-pb0-f47.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751088Ab3KYUqF convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 Nov 2013 15:46:05 -0500
MIME-Version: 1.0
In-Reply-To: <CA+r1Zhh83TzjeJJWqtBADD807FYw-LPdq4nzyoE5xN2mf9Hniw@mail.gmail.com>
References: <CA+r1Zhh83TzjeJJWqtBADD807FYw-LPdq4nzyoE5xN2mf9Hniw@mail.gmail.com>
Date: Mon, 25 Nov 2013 21:46:04 +0100
X-Google-Sender-Auth: RiXEUACOYx164NrXOVt0jia7LwE
Message-ID: <CAMuHMdXGXKUHw8jVrn-_n0Y9QPaWA5hQ9Mim+W1t+-LGezuh3A@mail.gmail.com>
Subject: Re: randconfig build error in next-20131125, in drivers/video/kyro
From: Geert Uytterhoeven <geert@linux-m68k.org>
To: Jim Davis <jim.epost@gmail.com>
Cc: Stephen Rothwell <sfr@canb.auug.org.au>,
        Linux-Next <linux-next@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Jean-Christophe PLAGNIOL-VILLARD <plagnioj@jcrosoft.com>,
        Linux Fbdev development list <linux-fbdev@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Nov 25, 2013 at 8:49 PM, Jim Davis <jim.epost@gmail.com> wrote:
> /home/jim/linux/arch/x86/include/asm/uaccess.h: In function ‘kyrofb_ioctl’:
> /home/jim/linux/arch/x86/include/asm/uaccess.h:633: error: call to
> ‘copy_to_user_overflow’ declared with attribute error: copy_to_user()
> buffer size is too small

Cool!

        case KYRO_IOCTL_UVSTRIDE:
                if (copy_to_user(argp, &deviceInfo.ulOverlayUVStride,
sizeof(unsigned long)))

ulOverlayUVStride is u32, while unsigned long is 8 bytes on 64 bit.

I guess it should use "sizeof(u32)", or better
"sizeof(deviceInfo.ulOverlayUVStride)"
instead.

Gr{oetje,eeting}s,

                        Geert

--
Geert Uytterhoeven -- There's lots of Linux beyond ia32 -- geert@linux-m68k.org

In personal conversations with technical people, I call myself a hacker. But
when I'm talking to journalists I just say "programmer" or something like that.
                                -- Linus Torvalds

Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754229AbaILKKq (ORCPT <rfc822;w@1wt.eu>);
	Fri, 12 Sep 2014 06:10:46 -0400
Received: from mail-la0-f43.google.com ([209.85.215.43]:65105 "EHLO
	mail-la0-f43.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752108AbaILKKl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 12 Sep 2014 06:10:41 -0400
MIME-Version: 1.0
In-Reply-To: <20140912095821.GB1930@katana>
References: <1410274470-12712-1-git-send-email-wsa@the-dreams.de>
	<9935938.eKOCvCAtLt@fb07-iapwap2>
	<20140912083348.GA1289@katana>
	<7627175.tG5quZH0VN@fb07-iapwap2>
	<20140912095821.GB1930@katana>
Date: Fri, 12 Sep 2014 12:10:37 +0200
X-Google-Sender-Auth: V1MGY5w7ql1hIO_oWFCjHHQFtPI
Message-ID: <CAMuHMdVi+6TXH68ddQ-UWfUif0Mv=ETu6dnpiy1Apike6zfAbg@mail.gmail.com>
Subject: Re: [RFC 4/4] ARM: shmobile: r8a7790: adapt DTS for I2C slave support
From: Geert Uytterhoeven <geert@linux-m68k.org>
To: Wolfram Sang <wsa@the-dreams.de>
Cc: Marc Dietrich <marvin24@gmx.de>, Linux I2C <linux-i2c@vger.kernel.org>,
        Linux-sh list <linux-sh@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        Jean Delvare <jdelvare@suse.de>, Magnus Damm <magnus.damm@gmail.com>,
        Andrey Danin <danindrey@mail.ru>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        Stephen Warren <swarren@wwwdotorg.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Wolfram,

On Fri, Sep 12, 2014 at 11:58 AM, Wolfram Sang <wsa@the-dreams.de> wrote:
> 2) Slave mode is needed for board bringup
>
> Some other components need a specific I2C slave to be present before
> userspace is available, otherwise the system is unusable. This is IMO
> then a hardware description and justifies DT entries:

OK, I didn't think this case, which is similar to an external device requiring
a GPIO to be at a specific level.

> DT pseudocode:
>
>         i2c {
>                 compatible = "nvidia, tegra-i2c";
>
>                 ec-slave@42 {
>                         compatible = "nvidia, ax100-ec-slave";
>                         reg = <0x42>;
>                 };
>         };

So distinguishing between drivers providing slave services (using slave
mode) and drivers driving actual slave hardware (using master mode) is
done based on the compatible-property.

Gr{oetje,eeting}s,

                        Geert

--
Geert Uytterhoeven -- There's lots of Linux beyond ia32 -- geert@linux-m68k.org

In personal conversations with technical people, I call myself a hacker. But
when I'm talking to journalists I just say "programmer" or something like that.
                                -- Linus Torvalds

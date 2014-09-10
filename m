Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753022AbaIJObH (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Sep 2014 10:31:07 -0400
Received: from mout.kundenserver.de ([212.227.17.13]:54788 "EHLO
	mout.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752252AbaIJObB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Sep 2014 10:31:01 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: sundeep subbaraya <sundeep.lkml@gmail.com>
Cc: "balbi@ti.com" <balbi@ti.com>, Daniel Mack <daniel@zonque.org>,
        Subbaraya Sundeep Bhatta <subbaraya.sundeep.bhatta@xilinx.com>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Michal Simek <michals@xilinx.com>,
        "linux-usb@vger.kernel.org" <linux-usb@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        svemula@xilinx.com, anirudh@xilinx.com,
        Subbaraya Sundeep Bhatta <sbhatta@xilinx.com>
Subject: Re: [PATCH v4 2/2] usb: gadget: Add xilinx usb2 device support
Date: Wed, 10 Sep 2014 16:30:50 +0200
Message-ID: <8798156.X6RhQq9Iqm@wuerfel>
User-Agent: KMail/4.11.5 (Linux/3.16.0-10-generic; KDE/4.11.5; x86_64; ; )
In-Reply-To: <CALHRZuqt-XJ5mPczzGJtSN=iq7TPut0=54r90QHWR+w-Lwwtyg@mail.gmail.com>
References: <1406020130-20467-1-git-send-email-sbhatta@xilinx.com> <20140821140040.GE9608@saruman.home> <CALHRZuqt-XJ5mPczzGJtSN=iq7TPut0=54r90QHWR+w-Lwwtyg@mail.gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
X-Provags-ID: V02:K0:lOmpO6y3jmx1Nqso84NAxw5wjCxf3guL5qyaCOCR6gd
 XFEp4CuLQyqnq5Hv/U9u+Tk2KAqSPXD6CQfz64+DmxEeYG1vGh
 zZ15vUSdHBBJEGwqVd94LaitOSgdiw33QmtIDG64IEoC3SRYPO
 v478dm4E8G2zchqFPNqkg8+6MASZvPEyAIoHRFcltlhNWwAM8F
 D3RaUDQZxzbiz5PBsSqa5tl4XKEH2ogggKVXu/O5n8fGY5hW57
 vlP38KAv/f69tvnVnlZtVeTTBSYOc3MHhalEjZJssNlPDF+VdR
 XalV/iz4jL1BSwjJSkSSQ7RHSo+Ecl7WXgfCDbkEY03d3NWyYu
 F09SyPhkelmYGF1q3jfQ=
X-UI-Out-Filterresults: notjunk:1;
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wednesday 10 September 2014 19:25:11 sundeep subbaraya wrote:
> > that's not exactly what I asked  Usually you only add COMPILE_TEST
> > when you have an ARCH dependency. So something like:
> >
> >         depends on ARCH_ARM || COMPILE_TEST
> >
> > would make it clear that this driver is only available on ARM, but when
> > doing my build tests, I'd still be able to compile it on x86.
> 
> Ok got it 

Most of the xilinx stuff also applies to MICROBLAZE however, so it
may need to be

	ARM || MICROBLAZE || COMPILE_TEST

(not ARCH_ARM, btw).

> >> > Also, your code uses device tree functions unconditionally, which is
> >> > fine, but it must hence depend on 'OF'.
> >>
> >> Ok will add OF along with COMPILE_TEST
> >
> > so this would be:
> >
> >         depends on OF || COMPILE_TEST

If it requires OF to build, you can use 'OF && (ARM || COMPILE_TEST)',
but if there is no compile-time dependency, you can just leave out
the 'depends on OF' completely. You can't even build a Zynq machine
without OF enabled.

	Arnd

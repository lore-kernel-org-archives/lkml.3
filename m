Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1162700Ab3DEUEA (ORCPT <rfc822;w@1wt.eu>);
	Fri, 5 Apr 2013 16:04:00 -0400
Received: from avon.wwwdotorg.org ([70.85.31.133]:56759 "EHLO
	avon.wwwdotorg.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1162677Ab3DEUD6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 5 Apr 2013 16:03:58 -0400
Message-ID: <515F2E28.2090105@wwwdotorg.org>
Date: Fri, 05 Apr 2013 14:03:52 -0600
From: Stephen Warren <swarren@wwwdotorg.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130106 Thunderbird/17.0.2
MIME-Version: 1.0
To: Wolfram Sang <wsa@the-dreams.de>
CC: Simon Glass <sjg@chromium.org>,
        "linux-doc@vger.kernel.org" <linux-doc@vger.kernel.org>,
        Daniel Kurtz <djkurtz@chromium.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-i2c@vger.kernel.org" <linux-i2c@vger.kernel.org>,
        Kukjin Kim <kgene.kim@samsung.com>,
        Stephen Warren <swarren@nvidia.com>,
        Ben Dooks <ben.dooks@codethink.co.uk>, u.kleine-koenig@pengutronix.de,
        Grant Grundler <grundler@chromium.org>,
        Devicetree Discuss <devicetree-discuss@lists.ozlabs.org>,
        Rob Herring <rob.herring@calxeda.com>,
        Jean Delvare <khali@linux-fr.org>,
        "Ben Dooks (embedded platforms)" <ben-linux@fluff.org>,
        Girish Shivananjappa <girish.shivananjappa@linaro.org>,
        "bhushan.r" <bhushan.r@samsung.com>,
        Naveen Krishna Chatradhi <ch.naveen@samsung.com>,
        "sreekumar.c" <sreekumar.c@samsung.com>,
        Mark Brown <broonie@opensource.wolfsonmicro.com>,
        Peter Korsgaard <peter.korsgaard@barco.com>,
        Yuvaraj Kumar <yuvaraj.cd@gmail.com>,
        Prashanth G <prashanth.g@samsung.com>
Subject: Re: [PATCH v4 1/3] i2c: mux: Add i2c-arbitrator-cros-ec 'mux' driver
References: <1360957573-864-1-git-send-email-dianders@chromium.org> <1363192583-26363-1-git-send-email-dianders@chromium.org> <CAD=FV=UW4wGFqsg2B3MmC24jhnba5PSvCh8Wck-V6iuYk+Xifw@mail.gmail.com> <20130329115821.GC6359@the-dreams.de> <CAD=FV=XyBZXD1dsOy4kY3CjkFiJXCO+taAJ-zZ8op6V-z9J8jQ@mail.gmail.com> <20130403191938.GA7875@the-dreams.de> <CAPnjgZ0bt+ppAMAB1RtoeUKrzUjxxZ3+=GQwHqxByce7fmOLDg@mail.gmail.com>
In-Reply-To: <CAPnjgZ0bt+ppAMAB1RtoeUKrzUjxxZ3+=GQwHqxByce7fmOLDg@mail.gmail.com>
X-Enigmail-Version: 1.4.6
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 04/05/2013 01:37 PM, Simon Glass wrote:
> HI Wolfram,
> 
> On Wed, Apr 3, 2013 at 12:19 PM, Wolfram Sang <wsa@the-dreams.de> wrote:
>> Doug,
>>
>>> Separately from a discussion of the technical merits, I'd say that
>>> this patch is needed because the Embedded Controller (EC) on the ARM
>>> Chromebook shipped expecting to communicate with this scheme.  While
>>
>> Uhrm, with all respect, "we already shipped it" is not a convincing
>> argument regarding inclusion. Benefit for the kernel is.

I'm not quite sure why that isn't a convincing argument.

The hardware has shipped. I don't know whether the EC microcode can be
updated in the field; it seems risky to do so even if it's possible. So,
it either gets supported or not; the HW/ucode isn't going to change I
suspect.

Hence, it seems that the decision would be:

a) Disallow the implementation of the arbitration scheme in the kernel,
and hence don't support this board in the kernel. (or at least some very
core features of this board)

b) Allow the implementation of the arbitration scheme in the kernel, and
hence make possible support this board in the kernel.

>From that perspective, the benefit for the kernel question comes down
to: do we see a benefit for the kernel to support this board? I can't
see why that wouldn't be a benefit.

The only disadvantage would be having to carrying code to support that
board. That same argument can be made for any board, and I think
typically doesn't cause any issue. The code for this I2C mux seems
pretty self-contained, so even if it was absolutely terrible (which I
don't think it is), it still wouldn't cause any wide-spread issues, I think.

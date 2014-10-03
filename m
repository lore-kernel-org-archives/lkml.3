Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754303AbaJCUEx (ORCPT <rfc822;w@1wt.eu>);
	Fri, 3 Oct 2014 16:04:53 -0400
Received: from mail-vc0-f180.google.com ([209.85.220.180]:46103 "EHLO
	mail-vc0-f180.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751437AbaJCUEu convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 3 Oct 2014 16:04:50 -0400
MIME-Version: 1.0
In-Reply-To: <20141003150544.435e323f@recife.lan>
References: <20141003150544.435e323f@recife.lan>
Date: Fri, 3 Oct 2014 13:04:48 -0700
X-Google-Sender-Auth: fJD-uc9P3gKL1BbIIkK-fd7wjjc
Message-ID: <CA+55aFz+CRAP7UeuEpiOLJLBjZKLx_7qM0Tw=qG1RpZ=kXhAng@mail.gmail.com>
Subject: Re: [GIT PULL for v3.17] si2165 firmware changes
From: Linus Torvalds <torvalds@linux-foundation.org>
To: Mauro Carvalho Chehab <mchehab@osg.samsung.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,
        Linux Media Mailing List <linux-media@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Yeah, this is pure crap. It doesn't even compile.

  drivers/media/dvb-frontends/si2165.c:1063:17: error: expected ‘,’ or
‘;’ before ‘SI2165_FIRMWARE’
   MODULE_FIRMWARE(SI2165_FIRMWARE);

because it should presumably say "SI2165_FIRMWARE_REV_D" now.

Why the f*ck do you send me totally untested crap?

                 Linus

On Fri, Oct 3, 2014 at 11:05 AM, Mauro Carvalho Chehab
<mchehab@osg.samsung.com> wrote:
> Hi Linus,
>
> Please pull from:
>   git://git.kernel.org/pub/scm/linux/kernel/git/mchehab/linux-media tags/media/topic/si2165-v3.17-rc8
>
> For some changes at the si2165 firmware name and the removal of an extra
> unneeded header added artificially via the script that extracts it from
> the original driver provided by the manufacturer.
>
> The si2165 is a new driver that was added for v3.17. There are two issues
> with the current firmware format:
>
> - The firmware only covers one specific revision of the chipset
>   (Rev. D). We'll be adding support for another revision for v3.18, so
>   it would be better to rename the firmware file to reflect the revision
>   on its name:
>
>         -#define SI2165_FIRMWARE "dvb-demod-si2165.fw"
>         +#define SI2165_FIRMWARE_REV_D "dvb-demod-si2165-d.fw"
>
> - Instead of containing a single blob with the firmware, the file
>   also contains some meta-data that could be determined on some other way
>   directly by the driver.
>
> The script that gets the firmware from the Internet was also updated
> accordingly to not add the extra header.
>
> Thanks!
> Mauro
>
>
>
> The following changes since commit 90a5dbef1a66e9f55b76ccb83c0ef27c0bd87c27:
>
>   Revert "[media] media: em28xx - remove reset_resume interface" (2014-09-28 22:25:24 -0300)
>
> are available in the git repository at:
>
>   git://git.kernel.org/pub/scm/linux/kernel/git/mchehab/linux-media tags/media/topic/si2165-v3.17-rc8
>
> for you to fetch changes up to 3173fbdce9e41fc4fabe0b3dedd99c615f47dbdd:
>
>   [media] [V2,2/2] si2165: do load firmware without extra header (2014-10-02 18:18:52 -0300)
>
> ----------------------------------------------------------------
> topic/si2165 fixes for v3.17-rc8
>
> ----------------------------------------------------------------
> Matthias Schwarzott (2):
>       [media] [V2, 1/2] get_dvb_firmware: si2165: drop the extra header from the firmware
>       [media] [V2,2/2] si2165: do load firmware without extra header
>
>  Documentation/dvb/get_dvb_firmware        |  20 ++----
>  drivers/media/dvb-frontends/Kconfig       |   1 +
>  drivers/media/dvb-frontends/si2165.c      | 107 ++++++++++++++++++------------
>  drivers/media/dvb-frontends/si2165_priv.h |   2 +-
>  4 files changed, 71 insertions(+), 59 deletions(-)
>
>

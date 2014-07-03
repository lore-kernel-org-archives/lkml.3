Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751898AbaGCGjH (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Jul 2014 02:39:07 -0400
Received: from mail-ie0-f170.google.com ([209.85.223.170]:58003 "EHLO
	mail-ie0-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750824AbaGCGjF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Jul 2014 02:39:05 -0400
Date: Thu, 3 Jul 2014 07:38:58 +0100
From: Lee Jones <lee.jones@linaro.org>
To: Doug Anderson <dianders@chromium.org>
Cc: Wolfram Sang <wsa@the-dreams.de>, Mark Brown <broonie@kernel.org>,
        Vincent Palatin <vpalatin@chromium.org>,
        Bill Richardson <wfrichar@chromium.org>,
        Randall Spangler <rspangler@chromium.org>,
        Simon Glass <sjg@chromium.org>,
        Andreas =?iso-8859-1?Q?F=E4rber?= <afaerber@suse.de>,
        Stephan van Schaik <stephan@synkhronix.com>,
        Olof Johansson <olof@lixom.net>, Samuel Ortiz <sameo@linux.intel.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 2/3] mfd: cros_ec: Use the proper size when looking at
 the cros_ec_i2c result
Message-ID: <20140703063858.GD17665@lee--X1>
References: <1403898973-19571-1-git-send-email-dianders@chromium.org>
 <1403898973-19571-3-git-send-email-dianders@chromium.org>
 <20140702072338.GC10311@lee--X1>
 <CAD=FV=VRA-WLgxqQ37naFLcoBM3fBM8FWPcLv8X_wZ89wiV4KA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CAD=FV=VRA-WLgxqQ37naFLcoBM3fBM8FWPcLv8X_wZ89wiV4KA@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 02 Jul 2014, Doug Anderson wrote:
> On Wed, Jul 2, 2014 at 12:23 AM, Lee Jones <lee.jones@linaro.org> wrote:
> > On Fri, 27 Jun 2014, Doug Anderson wrote:
> >
> >> We know how many bytes the EC should be sending us (which is also the
> >> number of bytes transferred) and also how many bytes the EC actually
> >> wanted to send to us.  When computing the checksum and copying back
> >> data let's make sure we take the lesser of the two of those.  We'll
> >> also complain if the EC tried to send us too many bytes.  The EC
> >> sending us too few bytes is legit for when we send the EC an invalid
> >> command.
> >>
> >> This is based on similar code in cros_ec_spi.
> >>
> >> Signed-off-by: Doug Anderson <dianders@chromium.org>
> >> ---
> >>  drivers/mfd/cros_ec_i2c.c | 15 ++++++++++++---
> >>  1 file changed, 12 insertions(+), 3 deletions(-)
> >
> > Acked-by: Lee Jones <lee.jones@linaro.org>
> >
> > Is this patch orthogonal i.e. can it be applied without the other two
> > patches?
> 
> Yes.  If patch 3/3 had worked out then it would have required patch #1
> for proper functioning and patch #2 (this patch) to avoid an ugly
> error message in the log.  ...but patch #1 and this patch both can
> stand on their own and can be applied.

Very well, patch applied than.

Clause: There is a chance that this patch might not be seen in -next
for ~24-48hrs.  If it's not there by 72hrs, feel free to poke.

-- 
Lee Jones
Linaro STMicroelectronics Landing Team Lead
Linaro.org │ Open source software for ARM SoCs
Follow Linaro: Facebook | Twitter | Blog

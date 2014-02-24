Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753384AbaBXTdK (ORCPT <rfc822;w@1wt.eu>);
	Mon, 24 Feb 2014 14:33:10 -0500
Received: from mail-ig0-f174.google.com ([209.85.213.174]:48047 "EHLO
	mail-ig0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753366AbaBXTdF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 24 Feb 2014 14:33:05 -0500
Date: Mon, 24 Feb 2014 14:33:01 -0500
From: Matt Porter <mporter@linaro.org>
To: Tim Kryger <tim.kryger@linaro.org>
Cc: Christian Daudt <bcm@fixthebug.org>, Chris Ball <cjb@laptop.org>,
        Axel Lin <axel.lin@ingics.com>, Alex Elder <elder@linaro.org>,
        Linux ARM Kernel List <linux-arm-kernel@lists.infradead.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Linux MMC List <linux-mmc@vger.kernel.org>,
        Ulf Hansson <ulf.hansson@linaro.org>
Subject: Re: [PATCH v4 5/8] mmc: sdhci-bcm-kona: Add basic use of clocks
Message-ID: <20140224193301.GW5038@beef>
References: <1386271244-3927-1-git-send-email-tim.kryger@linaro.org>
 <1386271244-3927-6-git-send-email-tim.kryger@linaro.org>
 <CAEPRUYrPXf7QNzput0bz_UPfytRy1eYgyOJYnH5v2v4DCEKSNA@mail.gmail.com>
 <CAAYSxhoCrveHd5Wkc7Z0qzpGr41qG6-neYSSsuHQuC7AcuJmZQ@mail.gmail.com>
 <CAAYSxhrBSv8_Z1SfB-b3iGgq218Gttny4FEgYJnLtSFhJd2UFg@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAAYSxhrBSv8_Z1SfB-b3iGgq218Gttny4FEgYJnLtSFhJd2UFg@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

[trimmed cc]

On Fri, Jan 24, 2014 at 09:07:24AM -0800, Tim Kryger wrote:
> On Tue, Jan 7, 2014 at 11:37 AM, Tim Kryger <tim.kryger@linaro.org> wrote:
> > On Sat, Dec 14, 2013 at 12:14 AM, Christian Daudt <bcm@fixthebug.org> wrote:
> >> On Thu, Dec 5, 2013 at 11:20 AM, Tim Kryger <tim.kryger@linaro.org> wrote:
> >>> Enable the external clock needed by the host controller during the
> >>> probe and disable it during the remove.
> >>>
> >>> Signed-off-by: Tim Kryger <tim.kryger@linaro.org>
> >>> Reviewed-by: Markus Mayer <markus.mayer@linaro.org>
> >>> Reviewed-by: Matt Porter <matt.porter@linaro.org>
> >>
> >> Reviewed-by: Christian Daudt <bcm@fixthebug.org>
> >>
> >> Chris,
> >>  Are you ok with me pulling this patch along with the rest of the
> >> patchset into the bcm tree?
> >>
> >>  Thanks,
> >>    csd
> >
> > Chris,
> >
> > Can you please provide an answer to csd?
> >
> > Thanks,
> > Tim Kryger
> 
> Chris,
> 
> I haven't heard back so this patch has been dropped for 3.14 to allow
> the remaining patches in the series to move forward.   As such, I will
> be re-posting this patch for 3.15.  It is essential for the
> bcm28155_ap board to transition away from fake fixed clocks to the
> real clock driver.  This is because the bcm281xx clock driver does not
> set the CLK_IGNORE_UNUSED flag for the SDHCI peripheral clocks and the
> common clock code will shut them off in late init unless the SDHCI
> driver has asked for them to be enabled.

I just queued Alex's patch for 3.15 that decouples the dependency
between this patch and the bcm kona common clock driver.

Chris: we no longer need this to be taken through arm-soc since removing
the dependency. Could you please take this patch through your tree for
3.15?

Thanks,
Matt

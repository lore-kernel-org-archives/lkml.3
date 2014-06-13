Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752877AbaFMII3 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 13 Jun 2014 04:08:29 -0400
Received: from cpsmtpb-ews02.kpnxchange.com ([213.75.39.5]:58356 "EHLO
	cpsmtpb-ews02.kpnxchange.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750979AbaFMIIZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 13 Jun 2014 04:08:25 -0400
Message-ID: <1402646902.28881.15.camel@x220>
Subject: Re: [PATCH v3 5/7] mfd: cros_ec: Sync to the latest
 cros_ec_commands.h from EC sources
From: Paul Bolle <pebolle@tiscali.nl>
To: Doug Anderson <dianders@chromium.org>
Cc: Bill Richardson <wfrichar@chromium.org>, Simon Glass <sjg@chromium.org>,
        Lee Jones <lee.jones@linaro.org>, Stephen Warren <swarren@nvidia.com>,
        Wolfram Sang <wsa@the-dreams.de>,
        Andrew Bresticker <abrestic@chromium.org>,
        Dylan Reid <dgreid@chromium.org>, Olof Johansson <olof@lixom.net>,
        Samuel Ortiz <sameo@linux.intel.com>,
        linux-samsung-soc <linux-samsung-soc@vger.kernel.org>,
        "linux-tegra@vger.kernel.org" <linux-tegra@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Date: Fri, 13 Jun 2014 10:08:22 +0200
In-Reply-To: <CAD=FV=XL9tnEqza8Zx8mt_Z7-bj8TCzdeyHMhnpewKp_1CR-ig@mail.gmail.com>
References: <1398879850-9111-1-git-send-email-dianders@chromium.org>
	 <1398879850-9111-6-git-send-email-dianders@chromium.org>
	 <20140520084602.GF24991@lee--X1> <1402483068.3798.82.camel@x220>
	 <CAD=FV=XL9tnEqza8Zx8mt_Z7-bj8TCzdeyHMhnpewKp_1CR-ig@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.10.4 (3.10.4-2.fc20) 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 13 Jun 2014 08:08:22.0518 (UTC) FILETIME=[A4F16960:01CF86DE]
X-RcptDomain: vger.kernel.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Doug,

On Wed, 2014-06-11 at 08:11 -0700, Doug Anderson wrote:
> On Wed, Jun 11, 2014 at 3:37 AM, Paul Bolle <pebolle@tiscali.nl> wrote:
> > On Tue, 2014-05-20 at 09:46 +0100, Lee Jones wrote:
> >> On Wed, 30 Apr 2014, Doug Anderson wrote:
> >> > From: Bill Richardson <wfrichar@chromium.org>
> >> >
> >> > This just updates include/linux/mfd/cros_ec_commands.h to match the
> >> > latest EC version (which is the One True Source for such things).  See
> >> > <https://chromium.googlesource.com/chromiumos/platform/ec>
> 
> I believe most of your questions are answered by checking out the git
> tree referenced above.  ...but see below for details.  This header is
> a common interface between the kernel and the EC.

I didn't realize that this was a link to a tree.

> > CONFIG_CHARGER_PROFILE_OVERRIDE doesn't match anything in linux-next. Is
> > a Kconfig symbol CHARGER_PROFILE_OVERRIDE perhaps queued somewhere?
> 
> This is a config option on the ChromeOS EC
> <https://chromium.googlesource.com/chromiumos/platform/ec>.  Doing a
> grep there:
> 
> board/samus/board.h:#define CONFIG_CHARGER_PROFILE_OVERRIDE
> common/charge_state_v2.c:#ifdef CONFIG_CHARGER_PROFILE_OVERRIDE
> common/charge_state_v2.c:#ifdef CONFIG_CHARGER_PROFILE_OVERRIDE
> common/charge_state_v2.c:#ifdef CONFIG_CHARGER_PROFILE_OVERRIDE
> driver/battery/samus.c:#ifdef CONFIG_CHARGER_PROFILE_OVERRIDE
> driver/battery/samus.c:#endif   /* CONFIG_CHARGER_PROFILE_OVERRIDE */
> include/config.h:#undef CONFIG_CHARGER_PROFILE_OVERRIDE
> include/ec_commands.h:  /* Range for CONFIG_CHARGER_PROFILE_OVERRIDE params */
> test/test_config.h:#define CONFIG_CHARGER_PROFILE_OVERRIDE

I see. So this is not a Kconfig macro but a general macro with a CONFIG_
prefix. There are quite a bit of those in the tree already, but still,
would another prefix also do?

Thanks,


Paul Bolle


Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755543AbaFQIx2 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Jun 2014 04:53:28 -0400
Received: from cpsmtpb-ews04.kpnxchange.com ([213.75.39.7]:49634 "EHLO
	cpsmtpb-ews04.kpnxchange.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753641AbaFQIxZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Jun 2014 04:53:25 -0400
Message-ID: <1402995202.1984.22.camel@x220>
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
Date: Tue, 17 Jun 2014 10:53:22 +0200
In-Reply-To: <CAD=FV=XcK5R1sdNwoJkFPapwWQ9vqxvmQi_L3BqTSt8EKRTNHw@mail.gmail.com>
References: <1398879850-9111-1-git-send-email-dianders@chromium.org>
	 <1398879850-9111-6-git-send-email-dianders@chromium.org>
	 <20140520084602.GF24991@lee--X1> <1402483068.3798.82.camel@x220>
	 <CAD=FV=XL9tnEqza8Zx8mt_Z7-bj8TCzdeyHMhnpewKp_1CR-ig@mail.gmail.com>
	 <1402646902.28881.15.camel@x220>
	 <CAD=FV=XcK5R1sdNwoJkFPapwWQ9vqxvmQi_L3BqTSt8EKRTNHw@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.10.4 (3.10.4-2.fc20) 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 17 Jun 2014 08:53:23.0047 (UTC) FILETIME=[983C6F70:01CF8A09]
X-RcptDomain: vger.kernel.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Doug,

On Fri, 2014-06-13 at 08:22 -0700, Doug Anderson wrote:
> On Fri, Jun 13, 2014 at 1:08 AM, Paul Bolle <pebolle@tiscali.nl> wrote:
> > On Wed, 2014-06-11 at 08:11 -0700, Doug Anderson wrote:
> >> This is a config option on the ChromeOS EC
> >> <https://chromium.googlesource.com/chromiumos/platform/ec>.  Doing a
> >> grep there:
> >>
> >> board/samus/board.h:#define CONFIG_CHARGER_PROFILE_OVERRIDE
> >> common/charge_state_v2.c:#ifdef CONFIG_CHARGER_PROFILE_OVERRIDE
> >> common/charge_state_v2.c:#ifdef CONFIG_CHARGER_PROFILE_OVERRIDE
> >> common/charge_state_v2.c:#ifdef CONFIG_CHARGER_PROFILE_OVERRIDE
> >> driver/battery/samus.c:#ifdef CONFIG_CHARGER_PROFILE_OVERRIDE
> >> driver/battery/samus.c:#endif   /* CONFIG_CHARGER_PROFILE_OVERRIDE */
> >> include/config.h:#undef CONFIG_CHARGER_PROFILE_OVERRIDE
> >> include/ec_commands.h:  /* Range for CONFIG_CHARGER_PROFILE_OVERRIDE params */
> >> test/test_config.h:#define CONFIG_CHARGER_PROFILE_OVERRIDE
> >
> > I see. So this is not a Kconfig macro but a general macro with a CONFIG_
> > prefix. There are quite a bit of those in the tree already, but still,
> > would another prefix also do?
> 
> Given that it's an entirely separate project and this is a valid
> CONFIG option in that project, it seems a lot to ask them not to use
> the CONFIG_ prefix.  Also: the part you are objecting to is only a
> comment, right?

So all the hits you quoted above are actually from code that's never
going to be included in the kernel tree, right? If so, then yes, we're
only discussing a single comment.

> We could certainly add extra wording in the comment to make it obvious
> that this is a CONFIG option for the EC and not the kernel.  Would
> that be enough?  ...or are you trying to use some scripts to
> automatically process files to look for CONFIG options?

Yes, I'm using a script to check for Kconfig macros, among other things.
It doesn't care about comments (because every now and then mistakes are
made in comments too, and some of those can get surprisingly confusing).

Anyhow, the CONFIG_ prefix used in the kernel tree is quite generic, but
we're stuck with it. Would it be bothersome to drop it in that comment?
Mentioning a preprocessor macro from a separate project is a bit
confusing to begin with. How is one supposed to know that this is a
reference to something out of tree?

So, in summary, while we're apparently only discussing a single comment,
I would appreciate it if it could be reworded, preferably by dropping
that the CONFIG_ prefix. But other people might care very little, as
they don't share this particular pet peeve.

Thanks,


Paul Bolle


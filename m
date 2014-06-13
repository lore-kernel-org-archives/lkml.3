Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753266AbaFMPWN (ORCPT <rfc822;w@1wt.eu>);
	Fri, 13 Jun 2014 11:22:13 -0400
Received: from mail-vc0-f174.google.com ([209.85.220.174]:36027 "EHLO
	mail-vc0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752788AbaFMPWL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 13 Jun 2014 11:22:11 -0400
MIME-Version: 1.0
In-Reply-To: <1402646902.28881.15.camel@x220>
References: <1398879850-9111-1-git-send-email-dianders@chromium.org>
	<1398879850-9111-6-git-send-email-dianders@chromium.org>
	<20140520084602.GF24991@lee--X1>
	<1402483068.3798.82.camel@x220>
	<CAD=FV=XL9tnEqza8Zx8mt_Z7-bj8TCzdeyHMhnpewKp_1CR-ig@mail.gmail.com>
	<1402646902.28881.15.camel@x220>
Date: Fri, 13 Jun 2014 08:22:09 -0700
X-Google-Sender-Auth: mEnxVA-km9mzgjGBFIwxh5Rg9Go
Message-ID: <CAD=FV=XcK5R1sdNwoJkFPapwWQ9vqxvmQi_L3BqTSt8EKRTNHw@mail.gmail.com>
Subject: Re: [PATCH v3 5/7] mfd: cros_ec: Sync to the latest
 cros_ec_commands.h from EC sources
From: Doug Anderson <dianders@chromium.org>
To: Paul Bolle <pebolle@tiscali.nl>
Cc: Bill Richardson <wfrichar@chromium.org>, Simon Glass <sjg@chromium.org>,
        Lee Jones <lee.jones@linaro.org>, Stephen Warren <swarren@nvidia.com>,
        Wolfram Sang <wsa@the-dreams.de>,
        Andrew Bresticker <abrestic@chromium.org>,
        Dylan Reid <dgreid@chromium.org>, Olof Johansson <olof@lixom.net>,
        Samuel Ortiz <sameo@linux.intel.com>,
        linux-samsung-soc <linux-samsung-soc@vger.kernel.org>,
        "linux-tegra@vger.kernel.org" <linux-tegra@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Paul,

On Fri, Jun 13, 2014 at 1:08 AM, Paul Bolle <pebolle@tiscali.nl> wrote:
> Doug,
>
> On Wed, 2014-06-11 at 08:11 -0700, Doug Anderson wrote:
>> On Wed, Jun 11, 2014 at 3:37 AM, Paul Bolle <pebolle@tiscali.nl> wrote:
>> > On Tue, 2014-05-20 at 09:46 +0100, Lee Jones wrote:
>> >> On Wed, 30 Apr 2014, Doug Anderson wrote:
>> >> > From: Bill Richardson <wfrichar@chromium.org>
>> >> >
>> >> > This just updates include/linux/mfd/cros_ec_commands.h to match the
>> >> > latest EC version (which is the One True Source for such things).  See
>> >> > <https://chromium.googlesource.com/chromiumos/platform/ec>
>>
>> I believe most of your questions are answered by checking out the git
>> tree referenced above.  ...but see below for details.  This header is
>> a common interface between the kernel and the EC.
>
> I didn't realize that this was a link to a tree.
>
>> > CONFIG_CHARGER_PROFILE_OVERRIDE doesn't match anything in linux-next. Is
>> > a Kconfig symbol CHARGER_PROFILE_OVERRIDE perhaps queued somewhere?
>>
>> This is a config option on the ChromeOS EC
>> <https://chromium.googlesource.com/chromiumos/platform/ec>.  Doing a
>> grep there:
>>
>> board/samus/board.h:#define CONFIG_CHARGER_PROFILE_OVERRIDE
>> common/charge_state_v2.c:#ifdef CONFIG_CHARGER_PROFILE_OVERRIDE
>> common/charge_state_v2.c:#ifdef CONFIG_CHARGER_PROFILE_OVERRIDE
>> common/charge_state_v2.c:#ifdef CONFIG_CHARGER_PROFILE_OVERRIDE
>> driver/battery/samus.c:#ifdef CONFIG_CHARGER_PROFILE_OVERRIDE
>> driver/battery/samus.c:#endif   /* CONFIG_CHARGER_PROFILE_OVERRIDE */
>> include/config.h:#undef CONFIG_CHARGER_PROFILE_OVERRIDE
>> include/ec_commands.h:  /* Range for CONFIG_CHARGER_PROFILE_OVERRIDE params */
>> test/test_config.h:#define CONFIG_CHARGER_PROFILE_OVERRIDE
>
> I see. So this is not a Kconfig macro but a general macro with a CONFIG_
> prefix. There are quite a bit of those in the tree already, but still,
> would another prefix also do?

Given that it's an entirely separate project and this is a valid
CONFIG option in that project, it seems a lot to ask them not to use
the CONFIG_ prefix.  Also: the part you are objecting to is only a
comment, right?

We could certainly add extra wording in the comment to make it obvious
that this is a CONFIG option for the EC and not the kernel.  Would
that be enough?  ...or are you trying to use some scripts to
automatically process files to look for CONFIG options?

-Doug

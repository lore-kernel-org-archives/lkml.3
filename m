Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S964893AbaFQQUm (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Jun 2014 12:20:42 -0400
Received: from avon.wwwdotorg.org ([70.85.31.133]:52188 "EHLO
	avon.wwwdotorg.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933321AbaFQQUk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Jun 2014 12:20:40 -0400
Message-ID: <53A06AD4.3000704@wwwdotorg.org>
Date: Tue, 17 Jun 2014 10:20:36 -0600
From: Stephen Warren <swarren@wwwdotorg.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.5.0
MIME-Version: 1.0
To: Paul Bolle <pebolle@tiscali.nl>, Doug Anderson <dianders@chromium.org>
CC: Bill Richardson <wfrichar@chromium.org>, Simon Glass <sjg@chromium.org>,
        Lee Jones <lee.jones@linaro.org>, Stephen Warren <swarren@nvidia.com>,
        Wolfram Sang <wsa@the-dreams.de>,
        Andrew Bresticker <abrestic@chromium.org>,
        Dylan Reid <dgreid@chromium.org>, Olof Johansson <olof@lixom.net>,
        Samuel Ortiz <sameo@linux.intel.com>,
        linux-samsung-soc <linux-samsung-soc@vger.kernel.org>,
        "linux-tegra@vger.kernel.org" <linux-tegra@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH v3 5/7] mfd: cros_ec: Sync to the latest cros_ec_commands.h
 from EC sources
References: <1398879850-9111-1-git-send-email-dianders@chromium.org>	 <1398879850-9111-6-git-send-email-dianders@chromium.org>	 <20140520084602.GF24991@lee--X1> <1402483068.3798.82.camel@x220>	 <CAD=FV=XL9tnEqza8Zx8mt_Z7-bj8TCzdeyHMhnpewKp_1CR-ig@mail.gmail.com>	 <1402646902.28881.15.camel@x220>	 <CAD=FV=XcK5R1sdNwoJkFPapwWQ9vqxvmQi_L3BqTSt8EKRTNHw@mail.gmail.com> <1402995202.1984.22.camel@x220>
In-Reply-To: <1402995202.1984.22.camel@x220>
X-Enigmail-Version: 1.5.2
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 06/17/2014 02:53 AM, Paul Bolle wrote:
> Doug,
> 
> On Fri, 2014-06-13 at 08:22 -0700, Doug Anderson wrote:
>> On Fri, Jun 13, 2014 at 1:08 AM, Paul Bolle <pebolle@tiscali.nl> wrote:
>>> On Wed, 2014-06-11 at 08:11 -0700, Doug Anderson wrote:
>>>> This is a config option on the ChromeOS EC
>>>> <https://chromium.googlesource.com/chromiumos/platform/ec>.  Doing a
>>>> grep there:
>>>>
>>>> board/samus/board.h:#define CONFIG_CHARGER_PROFILE_OVERRIDE
>>>> common/charge_state_v2.c:#ifdef CONFIG_CHARGER_PROFILE_OVERRIDE
>>>> common/charge_state_v2.c:#ifdef CONFIG_CHARGER_PROFILE_OVERRIDE
>>>> common/charge_state_v2.c:#ifdef CONFIG_CHARGER_PROFILE_OVERRIDE
>>>> driver/battery/samus.c:#ifdef CONFIG_CHARGER_PROFILE_OVERRIDE
>>>> driver/battery/samus.c:#endif   /* CONFIG_CHARGER_PROFILE_OVERRIDE */
>>>> include/config.h:#undef CONFIG_CHARGER_PROFILE_OVERRIDE
>>>> include/ec_commands.h:  /* Range for CONFIG_CHARGER_PROFILE_OVERRIDE params */
>>>> test/test_config.h:#define CONFIG_CHARGER_PROFILE_OVERRIDE
>>>
>>> I see. So this is not a Kconfig macro but a general macro with a CONFIG_
>>> prefix. There are quite a bit of those in the tree already, but still,
>>> would another prefix also do?
>>
>> Given that it's an entirely separate project and this is a valid
>> CONFIG option in that project, it seems a lot to ask them not to use
>> the CONFIG_ prefix.  Also: the part you are objecting to is only a
>> comment, right?
> 
> So all the hits you quoted above are actually from code that's never
> going to be included in the kernel tree, right? If so, then yes, we're
> only discussing a single comment.
> 
>> We could certainly add extra wording in the comment to make it obvious
>> that this is a CONFIG option for the EC and not the kernel.  Would
>> that be enough?  ...or are you trying to use some scripts to
>> automatically process files to look for CONFIG options?
> 
> Yes, I'm using a script to check for Kconfig macros, among other things.
> It doesn't care about comments (because every now and then mistakes are
> made in comments too, and some of those can get surprisingly confusing).
> 
> Anyhow, the CONFIG_ prefix used in the kernel tree is quite generic, but
> we're stuck with it. Would it be bothersome to drop it in that comment?
> Mentioning a preprocessor macro from a separate project is a bit
> confusing to begin with. How is one supposed to know that this is a
> reference to something out of tree?
> 
> So, in summary, while we're apparently only discussing a single comment,
> I would appreciate it if it could be reworded, preferably by dropping
> that the CONFIG_ prefix. But other people might care very little, as
> they don't share this particular pet peeve.

Can't your tool maintain a whitelist or ignore list? There are many
cases where the kernel can pull in headers/data from other projects
(Firmware interfaces to an arbitrarily large set of HW, Device trees,
IO/network protocools, perhaps more). It feels quite unreasonable for
the kernel to decide that it exclusively owns the CONFIG_* namespace
even in comments, and that every other project it interacts with must
not use that namespace.

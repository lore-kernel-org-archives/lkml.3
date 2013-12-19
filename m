Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754856Ab3LSRav (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Dec 2013 12:30:51 -0500
Received: from smtp4-g21.free.fr ([212.27.42.4]:54545 "EHLO smtp4-g21.free.fr"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754089Ab3LSR3N (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Dec 2013 12:29:13 -0500
X-Greylist: delayed 3252 seconds by postgrey-1.27 at vger.kernel.org; Thu, 19 Dec 2013 12:29:11 EST
From: arno@natisbad.org (Arnaud Ebalard)
To: Alessandro Zummo <a.zummo@towertech.it>
Cc: Andrew Morton <akpm@linux-foundation.org>,
        Stephen Rothwell <sfr@canb.auug.org.au>,
        Jason Cooper <jason@lakedaemon.net>, linux-kernel@vger.kernel.org,
        Mark Rutland <mark.rutland@arm.com>,
        Peter Huewe <peter.huewe@infineon.com>,
        Linus Walleij <linus.walleij@linaro.org>,
        Thierry Reding <treding@nvidia.com>, Mark Brown <broonie@kernel.org>,
        Rob Herring <rob.herring@calxeda.com>, Pawel Moll <pawel.moll@arm.com>,
        Stephen Warren <swarren@wwwdotorg.org>,
        Ian Campbell <ijc+devicetree@hellion.org.uk>,
        Grant Likely <grant.likely@linaro.org>, Rob Landley <rob@landley.net>,
        rtc-linux@googlegroups.com, Guenter Roeck <linux@roeck-us.net>,
        Jason Gunthorpe <jgunthorpe@obsidianresearch.com>,
        Kumar Gala <galak@codeaurora.org>,
        linux-arm-kernel@lists.infradead.org
Subject: Re: Can someone Ack and queue a patch for RTC subsytem?
References: <87siton6ke.fsf@natisbad.org>
	<20131219173857.0a546b99@linux.lan.towertech.it>
X-PGP-Key-URL: http://natisbad.org/arno@natisbad.org.asc
X-Fingerprint: D3A5 B68A 839B 38A5 815A 781B B77C 0748 A7AE 341B
X-Hashcash: 1:20:131219:galak@codeaurora.org::QxheWfDAu3BDk59s:000000000000000000000000000000000000000000Ycg
X-Hashcash: 1:20:131219:treding@nvidia.com::W+AXMlW1lKjRFF5L:00000000000000000000000000000000000000000000g8S
X-Hashcash: 1:20:131219:linux-arm-kernel@lists.infradead.org::J9n3X1bJHly1alDy:00000000000000000000000000i1D
X-Hashcash: 1:20:131219:rob@landley.net::kKkWBuJlSTjxNbBZ:0014lG
X-Hashcash: 1:20:131219:sfr@canb.auug.org.au::uci2IYbJ0psP1tBt:000000000000000000000000000000000000000001Efz
X-Hashcash: 1:20:131219:jgunthorpe@obsidianresearch.com::/IDGqJC3E1JhVKi+:0000000000000000000000000000001Ag5
X-Hashcash: 1:20:131219:linux@roeck-us.net::WWzobj7hYlg6foPg:00000000000000000000000000000000000000000001GKD
X-Hashcash: 1:20:131219:broonie@kernel.org::v1LlBh+GnNK6HR2I:00000000000000000000000000000000000000000001F+2
X-Hashcash: 1:20:131219:grant.likely@linaro.org::8GVFM3il3DpmJ6o3:000000000000000000000000000000000000003Um/
X-Hashcash: 1:20:131219:peter.huewe@infineon.com::crYiqkqrZ+TdmDCj:00000000000000000000000000000000000002C+M
X-Hashcash: 1:20:131219:linux-kernel@vger.kernel.org::iVPT4VpK6a5oY8zY:0000000000000000000000000000000003zNz
X-Hashcash: 1:20:131219:mark.rutland@arm.com::41MHfKDNX3iPm0G0:000000000000000000000000000000000000000002czu
X-Hashcash: 1:20:131219:ijc+devicetree@hellion.org.uk::bhsO6tEUadj3j00L:000000000000000000000000000000004tSf
X-Hashcash: 1:20:131219:akpm@linux-foundation.org::S0YTl9SeZ9nBLyfO:00000000000000000000000000000000000044x2
X-Hashcash: 1:20:131219:linus.walleij@linaro.org::kBp9srUn0Nw2psYd:00000000000000000000000000000000000005XNx
X-Hashcash: 1:20:131219:pawel.moll@arm.com::PvBPeIfFwUmi31Zo:00000000000000000000000000000000000000000008WXn
X-Hashcash: 1:20:131219:jason@lakedaemon.net::RWrm9YqkS8zqhSop:0000000000000000000000000000000000000000073V5
X-Hashcash: 1:20:131219:swarren@wwwdotorg.org::4jFEO3JJYhFBp8Qm:00000000000000000000000000000000000000008jYI
X-Hashcash: 1:20:131219:a.zummo@towertech.it::QW6e8v7GHs5DbjK9:000000000000000000000000000000000000000008CE4
X-Hashcash: 1:20:131219:rtc-linux@googlegroups.com::CCbXX25jgTVfQzXl:00000000000000000000000000000000000A0Z+
X-Hashcash: 1:20:131219:rob.herring@calxeda.com::eY/yt8+bUlcSPZ+z:00000000000000000000000000000000000000Ay2x
Date: Thu, 19 Dec 2013 18:28:16 +0100
In-Reply-To: <20131219173857.0a546b99@linux.lan.towertech.it> (Alessandro
	Zummo's message of "Thu, 19 Dec 2013 17:38:57 +0100")
Message-ID: <87d2kslphr.fsf@natisbad.org>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/24.3 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

Alessandro Zummo <a.zummo@towertech.it> writes:

> On Thu, 19 Dec 2013 17:34:09 +0100
> arno@natisbad.org (Arnaud Ebalard) wrote:
>
>> I never heard of *listed* RTC maintainer during all the review process
>> on rtc-linux list (v0 sent in october); I dug the list archives and when
>> this previously happened, someone else (e.g. Andrew Morton) was kind
>> enough to handle the patches:
>
>  Yes, Andrew usually pick those. 

I guess he should be put in the MAINTAINERS file then. Otherwise,
get_maintainer.pl script can not do its job correctly and people
end up thinking you should be the one handling those.


> I do not maintain a separate tree due to most RTCs being specifit to a
> subsytem. 

I do not understand: the chip is generic, i.e. this is not a RTC chip
specific to a given SoC (like rtc-mv.c is for instance). Can you be
more specific?


>>   http://www.spinics.net/lists/arm-kernel/msg292187.html
>
>  Regarding your patch, please do not add entries to /proc.
>  Use sysfs if you need.

Well, this is what is currently described in the documentation
(Documentation/rtc.txt), in drivers/rtc/rtc-test.c driver and what
many drivers do (AFAICT, 22/125).

Additionally, I only provide some additional info for an existing
file: the /proc entry is created by the drivers/rtc/class.c as
soon as someone selects CONFIG_RTC_INTF_PROC.

Do you want me to send a v7 w/ the .proc helper removed or leave
things as they are and Ack the patch as is?

Cheers,

a+

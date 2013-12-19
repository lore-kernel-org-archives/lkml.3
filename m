Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754444Ab3LSRrT (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Dec 2013 12:47:19 -0500
Received: from smtp6-g21.free.fr ([212.27.42.6]:38741 "EHLO smtp6-g21.free.fr"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752612Ab3LSRrR (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Dec 2013 12:47:17 -0500
From: arno@natisbad.org (Arnaud Ebalard)
To: Jason Cooper <jason@lakedaemon.net>
Cc: Mark Rutland <mark.rutland@arm.com>,
        Stephen Rothwell <sfr@canb.auug.org.au>,
        Ian Campbell <ijc+devicetree@hellion.org.uk>,
        rtc-linux@googlegroups.com, Pawel Moll <pawel.moll@arm.com>,
        Alessandro Zummo <a.zummo@towertech.it>,
        Linus Walleij <linus.walleij@linaro.org>,
        Stephen Warren <swarren@wwwdotorg.org>, linux-kernel@vger.kernel.org,
        Rob Herring <rob.herring@calxeda.com>,
        Jason Gunthorpe <jgunthorpe@obsidianresearch.com>,
        Mark Brown <broonie@kernel.org>, linux-arm-kernel@lists.infradead.org,
        Rob Landley <rob@landley.net>, Kumar Gala <galak@codeaurora.org>,
        Grant Likely <grant.likely@linaro.org>,
        Peter Huewe <peter.huewe@infineon.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Thierry Reding <treding@nvidia.com>,
        Guenter Roeck <linux@roeck-us.net>
Subject: Re: Can someone Ack and queue a patch for RTC subsytem?
References: <87siton6ke.fsf@natisbad.org>
	<20131219164624.GV2609@titan.lakedaemon.net>
X-PGP-Key-URL: http://natisbad.org/arno@natisbad.org.asc
X-Fingerprint: D3A5 B68A 839B 38A5 815A 781B B77C 0748 A7AE 341B
X-Hashcash: 1:20:131219:a.zummo@towertech.it::DQZ2iAJ0jeozp7KD:000000000000000000000000000000000000000000c7B
X-Hashcash: 1:20:131219:swarren@wwwdotorg.org::yrH4Akdy2r9Y3GjD:00000000000000000000000000000000000000000YiU
X-Hashcash: 1:20:131219:mark.rutland@arm.com::qIbuRw67TdPk2Lsf:000000000000000000000000000000000000000000dtQ
X-Hashcash: 1:20:131219:grant.likely@linaro.org::na1wnP81+20+ZhxZ:000000000000000000000000000000000000000mqT
X-Hashcash: 1:20:131219:akpm@linux-foundation.org::efRToJ8kAybUswnU:0000000000000000000000000000000000000p3v
X-Hashcash: 1:20:131219:jgunthorpe@obsidianresearch.com::jpdTmHnWXfgwKHla:0000000000000000000000000000000yUU
X-Hashcash: 1:20:131219:pawel.moll@arm.com::7X83WGdCCy/ndbtJ:000000000000000000000000000000000000000000016IV
X-Hashcash: 1:20:131219:rob.herring@calxeda.com::7raIx5IFbkxaIyCU:000000000000000000000000000000000000001W4r
X-Hashcash: 1:20:131219:linux-arm-kernel@lists.infradead.org::TxD3IZy0VtPQf5ei:00000000000000000000000001ZeO
X-Hashcash: 1:20:131219:jason@lakedaemon.net::2892NSMUQRyEjlxg:000000000000000000000000000000000000000001hcf
X-Hashcash: 1:20:131219:ijc+devicetree@hellion.org.uk::KxjQLaVMCfKQiRyc:0000000000000000000000000000000021SC
X-Hashcash: 1:20:131219:rob@landley.net::PFBB4ZLSRhFSPzIq:002YsH
X-Hashcash: 1:20:131219:linus.walleij@linaro.org::ashD3R6nZ9s0vc6l:00000000000000000000000000000000000002ok+
X-Hashcash: 1:20:131219:broonie@kernel.org::xGGjSomfG36WoxXv:00000000000000000000000000000000000000000003DZ/
X-Hashcash: 1:20:131219:sfr@canb.auug.org.au::UUfQSoGw4lwD97NP:000000000000000000000000000000000000000005HLA
X-Hashcash: 1:20:131219:galak@codeaurora.org::3B3vLK625XJMKq/O:000000000000000000000000000000000000000005B1t
X-Hashcash: 1:20:131219:rtc-linux@googlegroups.com::5vLL/wTPSrbGbvaK:000000000000000000000000000000000005p4m
X-Hashcash: 1:20:131219:linux-kernel@vger.kernel.org::Mn5ur2w43ZWUIs4A:0000000000000000000000000000000006Evx
X-Hashcash: 1:20:131219:linux@roeck-us.net::7QtOgm8k1SFfbiHY:00000000000000000000000000000000000000000007CiU
X-Hashcash: 1:20:131219:peter.huewe@infineon.com::+XMUKoaHeLLsZLx0:00000000000000000000000000000000000006Kq2
X-Hashcash: 1:20:131219:treding@nvidia.com::+KL+iFCnyGHq+pcv:00000000000000000000000000000000000000000008sAH
Date: Thu, 19 Dec 2013 18:46:18 +0100
In-Reply-To: <20131219164624.GV2609@titan.lakedaemon.net> (Jason Cooper's
	message of "Thu, 19 Dec 2013 11:46:24 -0500")
Message-ID: <87sitoka39.fsf@natisbad.org>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/24.3 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

Jason Cooper <jason@lakedaemon.net> writes:

> On Thu, Dec 19, 2013 at 05:34:09PM +0100, Arnaud Ebalard wrote:
>> I have a very simple driver (support for reading and setting the time)
>> for a RTC chip (Intersil ISL 12057) but cannot find anyone to get it
>> Acked and queued for v3.14. In v3.14, there should be at least three
>> users of the driver (ReadyNAS 102, 104 and 2120) if I meet -rc5 cutoff
>> for associated .dts changes.
>
> The -rc5 cutoff isn't a hard line.  It's also mvebu-specific.  eg, We
> need things _posted_ a week or so before arm-soc's cutoff of -rc6 so we
> have time to get the pull request in.  If it needs to go through
> mvebu/arm-soc, once it's posted, you're good.

I understand. But I guess you will not (for valid reason) accept .dts
changes to reference a rtc driver that is not on good track towards
-next. This is the issue I try and solve.


>> I never heard of *listed* RTC maintainer during all the review process
>> on rtc-linux list (v0 sent in october); I dug the list archives and when
>> this previously happened, someone else (e.g. Andrew Morton) was kind
>> enough to handle the patches:
>> 
>>   http://www.spinics.net/lists/arm-kernel/msg292187.html
>
> Unfortunately, it doesn't look like Alessandro has been active for a
> while and Andrew Morton has indeed been picking up the slack.  S-o-B's
> confirm this.
>
> I haven't worked with Andrew enough to know his workflow, but I imagine
> he can take patches much closer to the merge window than we can.
>
>> I wonder if someone (Andrew? Stephen? Jason?) would be kind enough to
>> take care of the v6 I just sent [1].
>
> I don't mind routing it though mvebu/arm-soc since the only consumers
> are currently mvebu boards, but I'd like to hear from Andrew that this
> is ok.

I will do what you think is the best.

Cheers,

a+

Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753909Ab3IJMyw (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Sep 2013 08:54:52 -0400
Received: from hqemgate16.nvidia.com ([216.228.121.65]:15963 "EHLO
	hqemgate16.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753117Ab3IJMyu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Sep 2013 08:54:50 -0400
X-PGP-Universal: processed;
	by hqnvupgp07.nvidia.com on Tue, 10 Sep 2013 05:54:49 -0700
Message-ID: <522F1B40.3040801@nvidia.com>
Date: Tue, 10 Sep 2013 18:44:40 +0530
From: Laxman Dewangan <ldewangan@nvidia.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:16.0) Gecko/20121028 Thunderbird/16.0.2
MIME-Version: 1.0
To: Mark Brown <broonie@kernel.org>
CC: "rob.herring@calxeda.com" <rob.herring@calxeda.com>,
        "mark.rutland@arm.com" <mark.rutland@arm.com>,
        "swarren@wwwdotorg.org" <swarren@wwwdotorg.org>,
        "rob@landley.net" <rob@landley.net>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        "linux-doc@vger.kernel.org" <linux-doc@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "lgirdwood@gmail.com" <lgirdwood@gmail.com>
Subject: Re: [PATCH 2/2] regulator: core: add support for configuring turn-on
 time through constraints
References: <1378811888-2268-1-git-send-email-ldewangan@nvidia.com> <1378811888-2268-2-git-send-email-ldewangan@nvidia.com> <20130910120922.GH29403@sirena.org.uk>
In-Reply-To: <20130910120922.GH29403@sirena.org.uk>
Content-Type: text/plain; charset="ISO-8859-1"; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday 10 September 2013 05:39 PM, Mark Brown wrote:
> * PGP Signed by an unknown key
>
> On Tue, Sep 10, 2013 at 04:48:08PM +0530, Laxman Dewangan wrote:
>
>> +- regulator-enable-time: Turn ON time for regulator(in uS)
> This is unclear - what is a "turn on time" and is this in addition to or
> separate from the underlying enable time of the device?  It needs to be
> clear that this is the time taken for the voltage to ramp to spec.  I'd
> also expect it to be clear that this is not something that should need
> to be provided normally.

Here my intention for turn-on time is the time from OFF state to ON 
state and the ON voltage settled on this time.
This time is separate from underlying enable time of the device i.e. 
will not get added.
We observe in some of platform that some of regulator is taking more 
time than time given as per datasheet.
Yes, completely agree that this is not the data provided normally, just 
we observe on scope that some of platform shows  more than the datasheet 
value and hence this patch.

The same rail on other design does not show the enable time more than 
datasheet and on that case, we will not provide this value.



> Please ALSO avoid capitalising words FOR no reason.
>
>
My bad, will take care.

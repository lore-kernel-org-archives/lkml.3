Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752934AbaJTULK (ORCPT <rfc822;w@1wt.eu>);
	Mon, 20 Oct 2014 16:11:10 -0400
Received: from bhuna.collabora.co.uk ([93.93.135.160]:40284 "EHLO
	bhuna.collabora.co.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751688AbaJTULE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 20 Oct 2014 16:11:04 -0400
Message-ID: <54456C4E.9090303@collabora.co.uk>
Date: Mon, 20 Oct 2014 22:10:54 +0200
From: Javier Martinez Canillas <javier.martinez@collabora.co.uk>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Icedove/31.0
MIME-Version: 1.0
To: Mark Brown <broonie@kernel.org>
CC: Doug Anderson <dianders@chromium.org>, Kukjin Kim <kgene.kim@samsung.com>,
        Lee Jones <lee.jones@linaro.org>, Tomasz Figa <tomasz.figa@gmail.com>,
        Chanwoo Choi <cw00.choi@samsung.com>,
        linux-samsung-soc <linux-samsung-soc@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Chris Zhong <zyw@rock-chips.com>,
        "Rafael J. Wysocki" <rjw@rjwysocki.net>
Subject: Re: [PATCH v2 2/2] ARM: EXYNOS: Call regulator core suspend prepare
 and finish functions
References: <1413454410-23396-1-git-send-email-javier.martinez@collabora.co.uk> <1413454410-23396-3-git-send-email-javier.martinez@collabora.co.uk> <CAD=FV=UtwNjyx56QtRrEo=jbX_PeMRAYZJVXzxqeS-vs4JyGRg@mail.gmail.com> <54453F2E.1080401@collabora.co.uk> <CAD=FV=WJfjhb9pfNhQwpToddR67NpA+m6kkj5oUVE5ewEhzvVQ@mail.gmail.com> <544567A1.2060006@collabora.co.uk> <20141020195641.GT18557@sirena.org.uk>
In-Reply-To: <20141020195641.GT18557@sirena.org.uk>
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello Mark,

On 10/20/2014 09:56 PM, Mark Brown wrote:
> On Mon, Oct 20, 2014 at 09:50:57PM +0200, Javier Martinez Canillas wrote:
>> On 10/20/2014 07:36 PM, Doug Anderson wrote:
> 
>> > I guess I was just trying to follow the suggestion that was in the
>> > regulator code:
>> > http://lxr.free-electrons.com/source/drivers/regulator/core.c#L3699
>> > that says "This will usually be called by machine suspend code prior
>> > to supending."
> 
>> I see, but still I feel as if it may be a lot of duplication since most
>> platforms will likely want to call the regulator core suspend prepare
> 
> Note that architectures are an example of a platform.  It really depends
> what's responsible for final poweroff, we want this called as late as we
> possibly can.
> 

Got it. Thanks for the explanation.

>> and finish functions. Maybe it can be added as a Kconfig option so each
>> platform can choose at the config level if they want those to be called?
> 
> No, that's obviously not going to do anything useful for multiplatform.
> 

Ok, then let's keep to do it per-platform as is proposed on $subject for
Exynos and what Chris proposed for Rockchip in [0] since it seems that's
the place where these calls belong.

Best regards,
Javier

[0]: http://www.spinics.net/lists/devicetree/msg53640.html

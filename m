Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752361Ab3LETkJ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Dec 2013 14:40:09 -0500
Received: from 10.mo4.mail-out.ovh.net ([188.165.33.109]:53683 "EHLO
	mo4.mail-out.ovh.net" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1750723Ab3LETkG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Dec 2013 14:40:06 -0500
X-Greylist: delayed 4199 seconds by postgrey-1.27 at vger.kernel.org; Thu, 05 Dec 2013 14:40:06 EST
Message-ID: <52A0AEB4.7090909@bracey.fi>
Date: Thu, 05 Dec 2013 18:49:56 +0200
From: Kevin Bracey <kevin@bracey.fi>
User-Agent: Mozilla/5.0 (Windows NT 6.0; WOW64; rv:17.0) Gecko/20130215 Thunderbird/17.0.3
MIME-Version: 1.0
To: Tomasz Figa <t.figa@samsung.com>
CC: Mark Brown <broonie@kernel.org>, Linus Walleij <linus.walleij@linaro.org>,
        Kyungmin Park <kmpark@infradead.org>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        linux-samsung-soc <linux-samsung-soc@vger.kernel.org>,
        =?ISO-8859-1?Q?Heiko_St=FCbner?= <heiko@sntech.de>,
        Stephen Warren <swarren@wwwdotorg.org>,
        Doug Anderson <dianders@chromium.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Kukjin Kim <kgene.kim@samsung.com>,
        Thomas Abraham <thomas.abraham@linaro.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        Marek Szyprowski <m.szyprowski@samsung.com>
Subject: Re: [PATCH] pinctrl: samsung: Allow pin value to be initialized using
 pinfunc.
References: <1384881351-10782-1-git-send-email-t.figa@samsung.com> <CACRpkdYrPd9tnO48bA_5n+-k=KEDyhY7czkCNhTZfpgF3ar+LQ@mail.gmail.com> <20131205150747.GW29268@sirena.org.uk> <1502243.eRBlCfUhTO@amdc1227>
In-Reply-To: <1502243.eRBlCfUhTO@amdc1227>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-Ovh-Tracer-Id: 12704654549761495205
X-Ovh-Remote: 62.183.157.30 (62-183-157-30.bb.dnainternet.fi)
X-Ovh-Local: 213.186.33.20 (ns0.ovh.net)
X-OVH-SPAMSTATE: OK
X-OVH-SPAMSCORE: -100
X-OVH-SPAMCAUSE: gggruggvucftvghtrhhoucdtuddrfeeiledrkeejucetufdoteggodetrfcurfhrohhfihhlvgemucfqggfjnecuuegrihhlohhuthemuceftddtnecusecvtfgvtghiphhivghnthhsucdlqddutddtmd
X-Spam-Check: DONE|U 0.5/N
X-VR-SPAMSTATE: OK
X-VR-SPAMSCORE: -100
X-VR-SPAMCAUSE: gggruggvucftvghtrhhoucdtuddrfeeiledrkeejucetufdoteggodetrfcurfhrohhfihhlvgemucfqggfjnecuuegrihhlohhuthemuceftddtnecusecvtfgvtghiphhivghnthhsucdlqddutddtmd
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 05/12/2013 17:11, Tomasz Figa wrote:
> On Thursday 05 of December 2013 15:07:47 Mark Brown wrote:
>> On Tue, Dec 03, 2013 at 10:29:42AM +0100, Linus Walleij wrote:
>>
>>> So a suggested patch to support weak hogs would be interesting
>>> to look at. Can you provide details on how you think this would
>>> work?
>> Or should we be going and applying the default state to all devices on
>> init without worrying about a driver appearing?
> If a device isn't used, then it's often better to configure the pins for
> a different function, such as GPIO, to minimize leakage current.
>

And there can also be mutually-exclusive drivers choosing different 
default states for the same pin. I think you do need a separate "safe" 
indicator.

My current thought is that  a late-init "make safe all unclaimed pins" 
pass would make sense - you can't really mess with pins in an automated 
fashion on init, as it can mess up bootloader->driver handover.   There 
already exist late-init "turn off all unclaimed clocks" (at least on 
shmobile) and "turn off all unclaimed regulators", and it would fit that 
model.

Kevin


Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761029Ab3LIKuh (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Dec 2013 05:50:37 -0500
Received: from 15.mo6.mail-out.ovh.net ([188.165.39.161]:35741 "EHLO
	mo6.mail-out.ovh.net" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752098Ab3LIKug (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Dec 2013 05:50:36 -0500
Message-ID: <52A59C9A.6000306@overkiz.com>
Date: Mon, 09 Dec 2013 11:34:02 +0100
From: boris brezillon <b.brezillon@overkiz.com>
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:24.0) Gecko/20100101 Thunderbird/24.1.1
MIME-Version: 1.0
To: Linus Walleij <linus.walleij@linaro.org>
CC: Jean-Christophe PLAGNIOL-VILLARD <plagnioj@jcrosoft.com>,
        Rob Herring <rob.herring@calxeda.com>, Pawel Moll <pawel.moll@arm.com>,
        Mark Rutland <mark.rutland@arm.com>,
        Stephen Warren <swarren@wwwdotorg.org>,
        Ian Campbell <ian.campbell@citrix.com>,
        Russell King <linux@arm.linux.org.uk>,
        Nicolas Ferre <nicolas.ferre@atmel.com>,
        Joachim Eastwood <manabian@gmail.com>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>
Subject: Re: [PATCH 5/9] ARM: at91/dt: add mmc0 slot0 support to at91rm9200ek
 board
References: <1377687640-10529-1-git-send-email-b.brezillon@overkiz.com>	<1377687995-10758-1-git-send-email-b.brezillon@overkiz.com>	<20131120145926.GE14627@ns203013.ovh.net>	<528CDFFB.1020601@overkiz.com>	<CACRpkdboBg4YOnMNiar0DDBVnoky=zNky+Pzyp1=P_POtH15qQ@mail.gmail.com>	<528DE1C4.6060900@overkiz.com>	<CACRpkdZdweyWJefttiuiYAJ9qhahLbnj7eHUiLV_83UA41X_uQ@mail.gmail.com>	<5294D64D.7000100@overkiz.com>	<CACRpkdZoAjuWVpWZfvPgOAd7qB1ZBtC+45nD3SYay3SrMhqwVA@mail.gmail.com>	<52986CA8.3010601@overkiz.com> <CACRpkdag5=QYsWe81ocpkMp2APaoBAOOn2r0iAVdf9DHTKrSXA@mail.gmail.com>
In-Reply-To: <CACRpkdag5=QYsWe81ocpkMp2APaoBAOOn2r0iAVdf9DHTKrSXA@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-Ovh-Tracer-Id: 11310508990137071837
X-Ovh-Remote: 80.245.18.66 ()
X-Ovh-Local: 213.186.33.20 (ns0.ovh.net)
X-OVH-SPAMSTATE: OK
X-OVH-SPAMSCORE: -100
X-OVH-SPAMCAUSE: gggruggvucftvghtrhhoucdtuddrfeeiledrkeekucetufdoteggodetrfcurfhrohhfihhlvgemucfqggfjnecuuegrihhlohhuthemuceftddtnecusecvtfgvtghiphhivghnthhsucdlqddutddtmd
X-Spam-Check: DONE|U 0.5/N
X-VR-SPAMSTATE: OK
X-VR-SPAMSCORE: -100
X-VR-SPAMCAUSE: gggruggvucftvghtrhhoucdtuddrfeeiledrkeekucetufdoteggodetrfcurfhrohhfihhlvgemucfqggfjnecuuegrihhlohhuthemuceftddtnecusecvtfgvtghiphhivghnthhsucdlqddutddtmd
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello Linus,

On 29/11/2013 14:31, Linus Walleij wrote:
> On Fri, Nov 29, 2013 at 11:30 AM, boris brezillon
> <b.brezillon@overkiz.com> wrote:
>> On 29/11/2013 11:03, Linus Walleij wrote:
>>> I guess one way is to obtain this GPIO in board code and just
>>> flick it depending on which device you register.
> (...)
>> The whole goal of moving from board files to dt is to drop all board
>> specific processing or initialization and only keep a common description
>> with generic drivers capable of handling common use cases.
>>
>> I'm not sure providing new board specific drivers is a good solution
>> (even if it is the simplest way to achieve our goal).
>>
>> Could we have something similar to pinctrl but with gpios :
>> when the device is probed the device/driver core code request the gpio
>> configure it appropriately and set it to the requested value (if configured
>> as output).
> This has been suggested under the name "GPIO hogs" in the past.
>
> It would work similar to how pinctrl hogs work by associating the
> GPIO line the controller itself, using some specific string
> like gpio-input-hogs = <...> / gpio-output-hogs = <...>;
>
> The gpiolib core will then grab and set up these before
> returning from the registration call so noone ever gets a chance
> to use them.
One more question, and I'm done :).

In which case should we use output-high or output-low config
instead of gpio-output-hogs ?


Best Regards,

Boris
>> These are just thoughts, and I guess introducing new code in the
>> device/driver core
>> code is not that easy, especially when this code is here to handle specific
>> case
>> like ours.
> It is very easy, just write the patch, iterate it (these patches get
> a lot of scrutiny as it is core code, so expect some work and time
> to get it done), and then unless there is a blocker, I would merge it.
> The concept is entirely sound, just that someone needs to step
> up and do the work...
> Yours,
> Linus Walleij


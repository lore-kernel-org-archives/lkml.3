Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756775Ab3HZRCv (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 Aug 2013 13:02:51 -0400
Received: from 8.mo3.mail-out.ovh.net ([87.98.172.249]:52287 "EHLO
	mo3.mail-out.ovh.net" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752317Ab3HZRCu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 Aug 2013 13:02:50 -0400
Message-ID: <521B89D1.6010902@overkiz.com>
Date: Mon, 26 Aug 2013 19:01:05 +0200
From: boris brezillon <b.brezillon@overkiz.com>
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:17.0) Gecko/20130803 Thunderbird/17.0.8
MIME-Version: 1.0
To: Stephen Warren <swarren@wwwdotorg.org>
CC: Rob Herring <rob.herring@calxeda.com>, Pawel Moll <pawel.moll@arm.com>,
        Mark Rutland <mark.rutland@arm.com>,
        Ian Campbell <ian.campbell@citrix.com>, Rob Landley <rob@landley.net>,
        Russell King <linux@arm.linux.org.uk>,
        Linus Walleij <linus.walleij@linaro.org>,
        Jean-Christophe Plagniol-Villard <plagnioj@jcrosoft.com>,
        Jiri Kosina <jkosina@suse.cz>, Masanari Iida <standby24x7@gmail.com>,
        Nicolas Ferre <nicolas.ferre@atmel.com>,
        Richard Genoud <richard.genoud@gmail.com>,
        Heiko Stuebner <heiko@sntech.de>, James Hogan <james.hogan@imgtec.com>,
        devicetree@vger.kernel.org, linux-doc@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org
X-Ovh-Mailout: 178.32.228.3 (mo3.mail-out.ovh.net)
Subject: Re: [RFC PATCH 1/3] pinctrl: add new generic pinconf config for deglitch
 filter
References: <1377379926-11163-1-git-send-email-b.brezillon@overkiz.com> <1377380109-11247-1-git-send-email-b.brezillon@overkiz.com> <521B875E.1010605@wwwdotorg.org>
In-Reply-To: <521B875E.1010605@wwwdotorg.org>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-Ovh-Tracer-Id: 9944510928858478669
X-Ovh-Remote: 80.245.18.66 ()
X-Ovh-Local: 213.186.33.20 (ns0.ovh.net)
X-OVH-SPAMSTATE: OK
X-OVH-SPAMSCORE: -100
X-OVH-SPAMCAUSE: gggruggvucftvghtrhhoucdtuddrfeeikedrheefucetufdoteggodetrfcurfhrohhfihhlvgemucfqggfjnecuuegrihhlohhuthemuceftddtnecusecvtfgvtghiphhivghnthhsucdlqddutddtmd
X-Spam-Check: DONE|U 0.500002/N
X-VR-SPAMSTATE: OK
X-VR-SPAMSCORE: -100
X-VR-SPAMCAUSE: gggruggvucftvghtrhhoucdtuddrfeeikedrheefucetufdoteggodetrfcurfhrohhfihhlvgemucfqggfjnecuuegrihhlohhuthemuceftddtnecusecvtfgvtghiphhivghnthhsucdlqddutddtmd
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello Stephen,

On 26/08/2013 18:50, Stephen Warren wrote:
> On 08/24/2013 03:35 PM, Boris BREZILLON wrote:
>> Add a new parameter to support deglitch filter configuration.
>> A deglitch filter works like a debounce filter but with a smaller
>> delay (nanoseconds).
> Why not use the existing debounce property, just with a small delay
> specified. It seems like that's exactly what the property is for?
That's one of the question I asked in my cover letter :-)

Indeed the at91 deglitch filter delay is not configurable and is statically
assigned to half a master clk cycle (if master clk = 133MHz -> 8 ns).
The debounce property argument is currently expressed in usecs.

This will result in always selecting the debounce filter (which is also
available on at91 SoCs) over the deglitch filter.

Could we add a flag in the deglitch argument to specify the delay unit
(nsecs or usecs) ?


Best Regards,

Boris

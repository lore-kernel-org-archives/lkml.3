Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753092Ab3H0Dzy (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 Aug 2013 23:55:54 -0400
Received: from avon.wwwdotorg.org ([70.85.31.133]:53791 "EHLO
	avon.wwwdotorg.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752090Ab3H0Dzw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 Aug 2013 23:55:52 -0400
Message-ID: <521C2347.4080702@wwwdotorg.org>
Date: Mon, 26 Aug 2013 21:55:51 -0600
From: Stephen Warren <swarren@wwwdotorg.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130510 Thunderbird/17.0.6
MIME-Version: 1.0
To: boris brezillon <b.brezillon@overkiz.com>
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
Subject: Re: [RFC PATCH 1/3] pinctrl: add new generic pinconf config for deglitch
 filter
References: <1377379926-11163-1-git-send-email-b.brezillon@overkiz.com> <1377380109-11247-1-git-send-email-b.brezillon@overkiz.com> <521B875E.1010605@wwwdotorg.org> <521B89D1.6010902@overkiz.com>
In-Reply-To: <521B89D1.6010902@overkiz.com>
X-Enigmail-Version: 1.4.6
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 08/26/2013 11:01 AM, boris brezillon wrote:
> Hello Stephen,
> 
> On 26/08/2013 18:50, Stephen Warren wrote:
>> On 08/24/2013 03:35 PM, Boris BREZILLON wrote:
>>> Add a new parameter to support deglitch filter configuration.
>>> A deglitch filter works like a debounce filter but with a smaller
>>> delay (nanoseconds).
>> Why not use the existing debounce property, just with a small delay
>> specified. It seems like that's exactly what the property is for?
> That's one of the question I asked in my cover letter :-)
> 
> Indeed the at91 deglitch filter delay is not configurable and is statically
> assigned to half a master clk cycle (if master clk = 133MHz -> 8 ns).
> The debounce property argument is currently expressed in usecs.
> 
> This will result in always selecting the debounce filter (which is also
> available on at91 SoCs) over the deglitch filter.
> 
> Could we add a flag in the deglitch argument to specify the delay unit
> (nsecs or usecs) ?

If the value is hard-coded in HW, why not use non-zero (or 1) to enable
and zero to disable?

(this kind of thing is why I'm not convinced that generic pinconf works
so well... What if we need psecs in the future?)

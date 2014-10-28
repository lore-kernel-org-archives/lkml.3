Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754088AbaJ1Lfq (ORCPT <rfc822;w@1wt.eu>);
	Tue, 28 Oct 2014 07:35:46 -0400
Received: from gw-1.arm.linux.org.uk ([78.32.30.217]:47073 "EHLO
	pandora.arm.linux.org.uk" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1751517AbaJ1Lfo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 28 Oct 2014 07:35:44 -0400
Date: Tue, 28 Oct 2014 11:35:31 +0000
From: Russell King - ARM Linux <linux@arm.linux.org.uk>
To: Marek Szyprowski <m.szyprowski@samsung.com>
Cc: linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-samsung-soc@vger.kernel.org, Tomasz Figa <tomasz.figa@gmail.com>,
        Kyungmin Park <kyungmin.park@samsung.com>,
        Kukjin Kim <kgene.kim@samsung.com>, lauraa@codeaurora.org,
        linux-omap@vger.kernel.org, linus.walleij@linaro.org,
        santosh.shilimkar@ti.com, tony@atomide.com, drake@endlessm.com,
        loeliger@gmail.com, Mark Rutland <mark.rutland@arm.com>
Subject: Re: [PATCH v6 4/7] ARM: l2c: Add support for overriding prefetch
	settings
Message-ID: <20141028113531.GZ12379@n2100.arm.linux.org.uk>
References: <1414407950-3029-1-git-send-email-m.szyprowski@samsung.com> <1414407950-3029-5-git-send-email-m.szyprowski@samsung.com> <20141027111404.GW12379@n2100.arm.linux.org.uk> <544E2A46.7070106@samsung.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <544E2A46.7070106@samsung.com>
User-Agent: Mutt/1.5.19 (2009-01-05)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Oct 27, 2014 at 12:19:34PM +0100, Marek Szyprowski wrote:
> Hello,
>
> On 2014-10-27 12:14, Russell King - ARM Linux wrote:
>> On Mon, Oct 27, 2014 at 12:05:47PM +0100, Marek Szyprowski wrote:
>>> From: Tomasz Figa <t.figa@samsung.com>
>>>
>>> Firmware on certain boards (e.g. ODROID-U3) can leave incorrect L2C prefetch
>>> settings configured in registers leading to crashes if L2C is enabled
>>> without overriding them. This patch introduces bindings to enable
>>> prefetch settings to be specified from DT and necessary support in the
>>> driver.
>>>
>>> Signed-off-by: Tomasz Figa <t.figa@samsung.com>
>>> [mszyprow: rebased onto v3.18-rc1, added error messages when property value
>>>   is missing]
>> Why?  What if the boot loader has already set these up appropriately?  Why
>> should we force people to list these in the DT?
>
> The error message is displayed only when user provided prefetch related
> properties without any value (empty properties). Something that Mark Rutland
> requested here: https://lkml.org/lkml/2014/9/24/426 I'm sorry if I didn't
> describe it clearly enough.

Ok.

I'd ask for one change.  Please make all these messages start with
"L2C-310 OF" not "PL310 OF:".  The device is described in ARM
documentation as a L2C-310 not PL310.  (Also note the : is dropped
too - most of the other messages don't have the : either.)

The:

"PL310 OF: cache setting yield illegal associativity
PL310 OF: -1073346556 calculated, only 8 and 16 legal"

message could also be changed to something like:

"L2C-310 OF cache associativity %d invalid, only 8 or 16 permitted\n"

Thanks.

-- 
FTTC broadband for 0.8mile line: currently at 9.5Mbps down 400kbps up
according to speedtest.net.

Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751865AbaDANTq (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 Apr 2014 09:19:46 -0400
Received: from ducie-dc1.codethink.co.uk ([185.25.241.215]:50142 "EHLO
	ducie-dc1.codethink.co.uk" rhost-flags-OK-FAIL-OK-FAIL)
	by vger.kernel.org with ESMTP id S1751397AbaDANTn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 Apr 2014 09:19:43 -0400
Message-ID: <533ABCEC.8040701@codethink.co.uk>
Date: Tue, 01 Apr 2014 14:19:40 +0100
From: Ben Dooks <ben.dooks@codethink.co.uk>
Organization: Codethink Limited.
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Icedove/24.3.0
MIME-Version: 1.0
To: Greg KH <gregkh@linuxfoundation.org>,
        Sylwester Nawrocki <s.nawrocki@samsung.com>
CC: devicetree@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, mturquette@linaro.org,
        linux@arm.linux.org.uk, robh+dt@kernel.org, grant.likely@linaro.org,
        mark.rutland@arm.com, galak@codeaurora.org, kyungmin.park@samsung.com,
        sw0312.kim@samsung.com, m.szyprowski@samsung.com, t.figa@samsung.com,
        laurent.pinchart@ideasonboard.com, s.hauer@pengutronix.de
Subject: Re: [PATCH RFC v4 2/2] clk: Add handling of clk parent and rate assigned
 from DT
References: <1396284116-19178-1-git-send-email-s.nawrocki@samsung.com> <1396284116-19178-3-git-send-email-s.nawrocki@samsung.com> <20140331200620.GA13881@kroah.com>
In-Reply-To: <20140331200620.GA13881@kroah.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 31/03/14 21:06, Greg KH wrote:
> On Mon, Mar 31, 2014 at 06:41:56PM +0200, Sylwester Nawrocki wrote:
>> This function adds a helper function to configure clock parents and rates
>> as specified in clock-parents, clock-rates DT properties for a consumer
>> device and a call to it before driver is bound to a device.
>>
>> Signed-off-by: Sylwester Nawrocki <s.nawrocki@samsung.com>

[snip]

>
> I don't understand why you need the driver core to initialize this one
> type of thing?  That should be in a driver, or in a class, or at worse
> case, the platform code.
>
> What makes clocks so "unique" here?

I suppose the issue here is that a lot of drivers currently use
clocks and a number of systems have badly setup default clock trees
at start time.

Mark Brown and others have argued that the management of clocks which
is common to all devices should not live in the driver.

-- 
Ben Dooks				http://www.codethink.co.uk/
Senior Engineer				Codethink - Providing Genius

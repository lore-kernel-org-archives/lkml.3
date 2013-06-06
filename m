Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932505Ab3FFKkx (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Jun 2013 06:40:53 -0400
Received: from kdh-gw.itdev.co.uk ([89.21.227.133]:3475 "EHLO
	hermes.kdh.itdev.co.uk" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S932141Ab3FFKkw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Jun 2013 06:40:52 -0400
Message-ID: <51B06732.2050701@itdev.co.uk>
Date: Thu, 06 Jun 2013 11:40:50 +0100
From: Nick Dyer <nick.dyer@itdev.co.uk>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130510 Thunderbird/17.0.6
MIME-Version: 1.0
To: Mark Brown <broonie@kernel.org>
CC: Dmitry Torokhov <dmitry.torokhov@gmail.com>,
        Daniel Kurtz <djkurtz@chromium.org>,
        Henrik Rydberg <rydberg@euromail.se>,
        Joonyoung Shim <jy0922.shim@samsung.com>, Alan.Bowens@atmel.com,
        linux-input@vger.kernel.org, linux-kernel@vger.kernel.org,
        pmeerw@pmeerw.net, bleung@chromium.org, olofj@chromium.org
Subject: Re: [PATCH 10/53] Input: atmel_mxt_ts - Add memory access interface
 via sysfs
References: <1370453866-16534-1-git-send-email-nick.dyer@itdev.co.uk> <7380889.l4hHqCT0mm@dtor-d630.eng.vmware.com> <51AF8730.4010507@itdev.co.uk> <1717403.GgHsbyUkDZ@dtor-d630.eng.vmware.com> <51AFA02B.3000604@itdev.co.uk> <20130605210715.GA16013@core.coreip.homeip.net> <20130606094822.GB1883@sirena.org.uk>
In-Reply-To: <20130606094822.GB1883@sirena.org.uk>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Mark Brown wrote:
> On Wed, Jun 05, 2013 at 02:07:15PM -0700, Dmitry Torokhov wrote:
>> On Wed, Jun 05, 2013 at 09:31:39PM +0100, Nick Dyer wrote:
> 
>>> It's partly path dependence - it was implemented like this because regmap
>>> wasn't in mainline at the point when I wrote it. Having a dependency on
>>> regmap would now be a API break complicating support of customers using
>>> older kernels than mainline. I would also have to update a bunch of
> 
>> This was never a good argument for introducing an interface into the
>> kernel.
> 
> Indeed, and regmap is very easy to backport - it demands little from the
> rest of the kernel and most of that is bus specific so you can pretty
> much just copy it into an older kernel.

That is good news. It would still be an extra thing to add to the docs, but
not a blocking point.

I am more worried about the address pointer handling and the I2C retries.

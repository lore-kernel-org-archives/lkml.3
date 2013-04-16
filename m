Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965025Ab3DPPmY (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Apr 2013 11:42:24 -0400
Received: from avon.wwwdotorg.org ([70.85.31.133]:36041 "EHLO
	avon.wwwdotorg.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S965002Ab3DPPmW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Apr 2013 11:42:22 -0400
Message-ID: <516D7156.3050807@wwwdotorg.org>
Date: Tue, 16 Apr 2013 09:42:14 -0600
From: Stephen Warren <swarren@wwwdotorg.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130106 Thunderbird/17.0.2
MIME-Version: 1.0
To: Wolfram Sang <wsa@the-dreams.de>
CC: Doug Anderson <dianders@chromium.org>, Kukjin Kim <kgene.kim@samsung.com>,
        Simon Glass <sjg@chromium.org>,
        Naveen Krishna Chatradhi <ch.naveen@samsung.com>,
        grant.likely@secretlab.ca, yuvaraj.cd@gmail.com,
        ben.dooks@codethink.co.uk, u.kleine-koenig@pengutronix.de,
        broonie@opensource.wolfsonmicro.com, girish.shivananjappa@linaro.org,
        bhushan.r@samsung.com, sreekumar.c@samsung.com,
        prashanth.g@samsung.com, olof@lixom.net, djkurtz@chromium.org,
        linux@roeck-us.net, Rob Herring <rob.herring@calxeda.com>,
        Rob Landley <rob@landley.net>,
        "Ben Dooks (embedded platforms)" <ben-linux@fluff.org>,
        Stephen Warren <swarren@nvidia.com>, Jean Delvare <khali@linux-fr.org>,
        Peter Korsgaard <peter.korsgaard@barco.com>,
        Guenter Roeck <guenter.roeck@ericsson.com>,
        devicetree-discuss@lists.ozlabs.org, linux-doc@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-i2c@vger.kernel.org
Subject: Re: [PATCH v5 1/3] i2c: mux: Add i2c-arb-gpio-challenge 'mux' driver
References: <1363192583-26363-1-git-send-email-dianders@chromium.org> <1365543270-10736-1-git-send-email-dianders@chromium.org> <20130416093633.GC16978@the-dreams.de>
In-Reply-To: <20130416093633.GC16978@the-dreams.de>
X-Enigmail-Version: 1.4.6
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 04/16/2013 03:36 AM, Wolfram Sang wrote:
> Doug,
> 
> On Tue, Apr 09, 2013 at 02:34:28PM -0700, Doug Anderson wrote:
>> The i2c-arb-gpio-challenge driver implements an I2C arbitration scheme
>> where masters need to claim the bus with a GPIO before they can start
>> a transcation.  This should generally only be used when standard I2C
>> multimaster isn't appropriate for some reason (errata/bugs).
>>
>> This driver is based on code that Simon Glass added to the i2c-s3c2410
>> driver in the Chrome OS kernel 3.4 tree.  The current incarnation as a
>> mux driver is as suggested by Grant Likely.  See
>> <https://patchwork.kernel.org/patch/1877311/> for some history.

>> diff --git a/Documentation/devicetree/bindings/i2c/i2c-arb-gpio-challenge.txt b/Documentation/devicetree/bindings/i2c/i2c-arb-gpio-challenge.txt

>> +GPIO-based I2C Arbitration
>> +==========================
>> +This uses GPIO lines to arbitrate who is the master of an I2C bus in a
>> +multimaster situation.
> 
> "uses GPIO lines and a challange & response mechanism" or something like
> that. There might be other GPIO based arbitrations in the future (though
> I hope there won't).

The existing text appears clearer to me; this document should spell out
the exact details of the protocol in later paragraphs, so there's no
need to try and spell it out here.

>> +- their-claim-gpios: The GPIOs that the other sides use the claim the bus.
>> +  Note that some implementations may only support a single other master.
> 
> Stronger? "Currently, only one other master is supported"?

The DT binding documentation, which should be OS-/driver-agnostic,
should describe the binding, not the implementation. The limitation that
Linux imposes is OS-specific and hence should not be mentioned here as
an absolute, or perhaps even at all.

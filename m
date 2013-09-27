Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754089Ab3I0N3W (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 Sep 2013 09:29:22 -0400
Received: from eu1sys200aog114.obsmtp.com ([207.126.144.137]:52107 "EHLO
	eu1sys200aog114.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753495Ab3I0N3R (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 Sep 2013 09:29:17 -0400
Message-ID: <52458774.1060909@st.com>
Date: Fri, 27 Sep 2013 14:26:12 +0100
From: Srinivas KANDAGATLA <srinivas.kandagatla@st.com>
Reply-To: srinivas.kandagatla@st.com
Organization: STMicroelectronics
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:17.0) Gecko/20130308 Thunderbird/17.0.4
MIME-Version: 1.0
To: Mark Rutland <mark.rutland@arm.com>
Cc: "linux-media@vger.kernel.org" <linux-media@vger.kernel.org>,
        "rob.herring@calxeda.com" <rob.herring@calxeda.com>,
        Pawel Moll <Pawel.Moll@arm.com>,
        Stephen Warren <swarren@wwwdotorg.org>,
        Ian Campbell <ijc+devicetree@hellion.org.uk>,
        Rob Landley <rob@landley.net>,
        Mauro Carvalho Chehab <m.chehab@samsung.com>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        "linux-doc@vger.kernel.org" <linux-doc@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH RFC] media: rc: OF: Add Generic bindings for remote-control
References: <1380274391-26577-1-git-send-email-srinivas.kandagatla@st.com> <20130927113458.GB18672@e106331-lin.cambridge.arm.com>
In-Reply-To: <20130927113458.GB18672@e106331-lin.cambridge.arm.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 27/09/13 12:34, Mark Rutland wrote:

>> > +	- rx-mode: Can be "infrared" or "uhf". rx-mode should be present iff
>> > +	  the rx pins are wired up.
> I'm unsure on this. What if the device has multiple receivers that can
> be independently configured? What if it supports something other than
> "infrared" or "uhf"? What if a device can only be wired up as
> "infrared"? 
> 
> I'm not sure how generic these are, though we should certainly encourage
> bindings that can be described this way to be described in the same way.
> 
>> > +	- tx-mode: Can be "infrared" or "uhf". tx-mode should be present iff
>> > +	  the tx pins are wired up.
> I have similar concerns here to those for the rx-mode property.
> 
Initially rx-mode and tx-mode sounded like more generic properties
that's the reason I ended up in this route. But after this discussion it
looks like its not really generic enough to cater all the use cases.

It make sense for me to perfix "st," for these properties in the st-rc
driver rather than considering them as generic properties.

> I think what we actually need to document is the process of creating a
> binding in such a way as to encourage uniformity. Something like the
> following steps:
I agree, It will help.. :-)
> 
> 1. Look to see if a binding already exists. If so, use it.
> 
> 2. Is there a binding for a compatible device? If so, use/extend it.
> 
> 3. Is there a binding for a similar (but incompatible) device? Use it as
>    a template, possibly factor out portions into a class binding if
>    those portions are truly general.
> 
> 4. Is there a binding for the class of device? If so, build around that,
>    possibly extending it.
> 
> 5. If there's nothing relevant, create a binding aiming for as much
>    commonality as possible with other devices of that class that may
>    have bindings later.

Thanks for this little guide...

--srini

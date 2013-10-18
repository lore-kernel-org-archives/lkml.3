Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754156Ab3JRMan (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Oct 2013 08:30:43 -0400
Received: from eu1sys200aog111.obsmtp.com ([207.126.144.131]:39285 "EHLO
	eu1sys200aog111.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753925Ab3JRMaj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Oct 2013 08:30:39 -0400
Message-ID: <5261284D.4020506@st.com>
Date: Fri, 18 Oct 2013 13:23:41 +0100
From: srinivas kandagatla <srinivas.kandagatla@st.com>
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:17.0) Gecko/20130308 Thunderbird/17.0.4
MIME-Version: 1.0
To: Mark Rutland <mark.rutland@arm.com>
Cc: Mauro Carvalho Chehab <m.chehab@samsung.com>,
        "linux-media@vger.kernel.org" <linux-media@vger.kernel.org>,
        "rob.herring@calxeda.com" <rob.herring@calxeda.com>,
        Pawel Moll <Pawel.Moll@arm.com>,
        Stephen Warren <swarren@wwwdotorg.org>,
        Ian Campbell <ijc+devicetree@hellion.org.uk>,
        Rob Landley <rob@landley.net>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        "linux-doc@vger.kernel.org" <linux-doc@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH RFC] media: rc: OF: Add Generic bindings for remote-control
References: <1380274391-26577-1-git-send-email-srinivas.kandagatla@st.com> <20130927113458.GB18672@e106331-lin.cambridge.arm.com> <20130927104719.6637368f@samsung.com> <20130930165125.GE22259@e106331-lin.cambridge.arm.com> <5255495A.6040704@st.com> <20131018113742.GF29779@e106331-lin.cambridge.arm.com>
In-Reply-To: <20131018113742.GF29779@e106331-lin.cambridge.arm.com>
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.65.51.59]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Thanks Mark,

The blocking issue for st-rc driver is now closed.

On 18/10/13 12:37, Mark Rutland wrote:
>>
>> Mauro C. had an option that this is not a real use-case and let's not
>> overdesign the API, thinking on a possible scenario that may never happen.
>>
>> Do you still think that this use case should be considered in this
>> discussion?
> 
> Given how simple a device we're attempting to describe, I'm not even
> sure it makes sense to have a class of binding. We could leave this to
> individual device bindings for the moment.

Its clear.
>>
>> my_keymap: keymap {
>> 	rc-keymap-name = "my-keymap";
>> 	rc-codes	= 	<0x12, KEY_POWER,
>> 				0x01, KEY_TV,
>> 				0x15, KEY_DVD>;
>> 		...
>>  };
>>
>> my-rc-device {
>> 	compatible = "my,rc-device";
>> 	rc-keymap = <&my_keymap>;
>> 	rx-mode  = "infrared";
>> };
> 
> This may be ok, but we'll need to nail down the kaymap binding..

Yes, If Mauro thinks that rc keymaps from device tree is good feature we
can start a new discussion on this.

>> == Remote control Keymaps ==
>>
>> properties:
>> 	- rc-keymap-name: 	Should be the name of the keymap.
>> 	- rc-keymaps:		Should be an array of pair of scan code and actual key
>> code with first cell representing rc scan code and second cell
>> representing actual keycode.
> 
> Is one cell always enough for any scan code (or any actual keycode)?
> 
> As the format of the scan code will be device-specific, should this be
> under the node for the device? Are we likely to have multiple rc devices
> in a single system that can share a keymap?

I will let Mauro answer this.
> 
> What's the format of the actual keycode? What values are valid?
> 
>>
>> example:
>>
>> my_keymap: keymap {
>> 	rc-keymap-name = "my-keymap";
>> 	rc-keymaps	= 	<0x12, KEY_POWER,
>> 				0x01, KEY_TV,
>> 				0x15, KEY_DVD>;
>> 		...
>>  };
> 
> Please bracket list entries individually (it makes it far easier for
> humans to read arbitrary lists in dt, regardless of how consistent this
> may be).
> 
> Also, commas shouldn't be between brackets, dtc will barf if they're
> there.
> 
> So this should be something like:
> 
> 	rc-keymaps = <0x12 KEY_POWER>,
> 	             <0x01 KEY_TV>,
> 	             <0x15 KEY_DVD>;
> 

I agree this is much readable.

>>
>> my-rc-device {
>> 	compatible = "my,rc-device";
>> 	rc-keymap = <&my_keymap>;
>> 	rx-mode  = "infrared";
>> };
> 
> Thanks,
> Mark.
> 
> 


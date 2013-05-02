Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762000Ab3EBSwk (ORCPT <rfc822;w@1wt.eu>);
	Thu, 2 May 2013 14:52:40 -0400
Received: from avon.wwwdotorg.org ([70.85.31.133]:58301 "EHLO
	avon.wwwdotorg.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1761987Ab3EBSwi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 2 May 2013 14:52:38 -0400
Message-ID: <5182B5F1.7090800@wwwdotorg.org>
Date: Thu, 02 May 2013 12:52:33 -0600
From: Stephen Warren <swarren@wwwdotorg.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130106 Thunderbird/17.0.2
MIME-Version: 1.0
To: Christian Ruppert <christian.ruppert@abilis.com>
CC: linux-kernel@vger.kernel.org, Linus Walleij <linus.walleij@linaro.org>,
        Grant Likely <grant.likely@secretlab.ca>,
        Rob Herring <rob.herring@calxeda.com>, Rob Landley <rob@landley.net>,
        Sascha Leuenberger <sascha.leuenberger@abilis.com>,
        Pierrick Hascoet <pierrick.hascoet@abilis.com>,
        devicetree-discuss@lists.ozlabs.org, linux-doc@vger.kernel.org
Subject: Re: [PATCH 1/2] pinmux: Add TB10x pinmux driver
References: <1365608728-30494-1-git-send-email-christian.ruppert@abilis.com> <516EEAA0.10906@wwwdotorg.org> <20130418090310.GA17636@ab42.lan>
In-Reply-To: <20130418090310.GA17636@ab42.lan>
X-Enigmail-Version: 1.4.6
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 04/18/2013 03:03 AM, Christian Ruppert wrote:
> Dear Stephen and Linus,
> 
> I am responding to this message because it touches the core issue I was
> wondering about when integrating pinctrl with GPIO. I think all
> unrelated comments in your other messages are valid and will be
> addressed in the next iteration of both drivers.
> 
> On Wed, Apr 17, 2013 at 12:32:00PM -0600, Stephen Warren wrote:
>> On 04/10/2013 09:45 AM, Christian Ruppert wrote:
>>> The pinmux driver of the Abilis Systems TB10x platform based on ARC700 CPUs.
>>> Used to control the pinmux and is a prerequisite for the GPIO driver.
>>
>> Linus already did a review of this, but I have a few extra comments:
>>
>>> diff --git a/Documentation/devicetree/bindings/pinctrl/abilis,tb10x-iomux.txt b/Documentation/devicetree/bindings/pinctrl/abilis,tb10x-iomux.txt
...
>> * A list of pins/groups to apply the settings to.
> 
> This is what the pingrp string refers to. We really don't want to expose
> Linux internal pin numbers!

I wasn't suggesting a particular naming/numbering scheme for the pins,
but simply that the document has to state what that naming/numbering
scheme is, so that people know how to fill in the DT. If the
naming/numbering scheme exactly matches some HW manual, then it should
be enough to say e.g. "see section X in Foo manual", to avoid
duplicating the information. If not, then the valid values should be
listed in the binding document.

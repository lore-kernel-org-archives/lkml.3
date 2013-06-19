Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935255Ab3FSVxN (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Jun 2013 17:53:13 -0400
Received: from avon.wwwdotorg.org ([70.85.31.133]:44038 "EHLO
	avon.wwwdotorg.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S935189Ab3FSVw6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Jun 2013 17:52:58 -0400
Message-ID: <51C22836.9090909@wwwdotorg.org>
Date: Wed, 19 Jun 2013 15:52:54 -0600
From: Stephen Warren <swarren@wwwdotorg.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130510 Thunderbird/17.0.6
MIME-Version: 1.0
To: =?ISO-8859-1?Q?Heiko_St=FCbner?= <heiko@sntech.de>
CC: Linus Walleij <linus.walleij@linaro.org>,
        Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
        Grant Likely <grant.likely@secretlab.ca>,
        Laurent Pinchart <laurent.pinchart+renesas@ideasonboard.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "devicetree-discuss@lists.ozlabs.org" 
	<devicetree-discuss@lists.ozlabs.org>,
        James Hogan <james.hogan@imgtec.com>,
        "linux-sh@vger.kernel.org" <linux-sh@vger.kernel.org>
Subject: Re: [RFC] pinctrl: generic: Add DT bindings
References: <1370988237-30593-1-git-send-email-laurent.pinchart+renesas@ideasonboard.com> <2555796.PtkImJGaK8@avalon> <CACRpkdaF7V3FGhNNj+N+Dc-NWhsfQ=bqh+ETx0wGBFbLmxfGTw@mail.gmail.com> <201306152216.14252.heiko@sntech.de>
In-Reply-To: <201306152216.14252.heiko@sntech.de>
X-Enigmail-Version: 1.4.6
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 06/15/2013 02:16 PM, Heiko Stübner wrote:
> Am Samstag, 15. Juni 2013, 21:56:05 schrieb Linus Walleij:
>> On Fri, Jun 14, 2013 at 12:39 AM, Laurent Pinchart
>>
>> <laurent.pinchart@ideasonboard.com> wrote:
>>>         mmcif_pins: mmcif {
>>>         
>>>                 mux {
>>>                 
>>>                         renesas,groups = "mmc0_data8_0", "mmc0_ctrl_0";
>>>                         renesas,function = "mmc0";
>>>                 
>>>                 };
>>>                 cfg {
>>>                 
>>>                         renesas,groups = "mmc0_data8_0";
>>>                         renesas,pins = "PORT279";
>>>                         bias-pull-up = <1>;
>>
>> If I understood your code correctly that last statement can *optionally*
>> be written like just:
>>
>>  bias-pull-up;
>>
>> Without the parameter?
>>
>> I think that Heiko's implementation does this anyway.
> 
> Yep, with the fixes-series from yesterday the bias-pull-* now have a better 
> default value of <1>.
> 
> so you can do
> 	bias-pull-up;
> which is then identical to the
> 	bias-pull-up = <1>;
> above (both are valid of course).

A property with a value is an integer. One without is a Boolean. The
same property shouldn't be both.

Regarding the value representing resistance: That feels pretty odd.
Enabling a pullup and selecting the pullup resistance feel like
orthogonal options which shouldn't be bound to each-other.


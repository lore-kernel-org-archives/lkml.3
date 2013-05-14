Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932093Ab3ENLwg (ORCPT <rfc822;w@1wt.eu>);
	Tue, 14 May 2013 07:52:36 -0400
Received: from mail-ie0-f169.google.com ([209.85.223.169]:51379 "EHLO
	mail-ie0-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755500Ab3ENLwf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 14 May 2013 07:52:35 -0400
MIME-Version: 1.0
In-Reply-To: <5183D262.7000107@imgtec.com>
References: <1366727607-27444-1-git-send-email-james.hogan@imgtec.com>
	<1366727607-27444-6-git-send-email-james.hogan@imgtec.com>
	<CACRpkdbYwDvF=gNurLzc+wE0BYpoqog7sPdRTY59BGS7yn3n9Q@mail.gmail.com>
	<517A6B01.5000708@imgtec.com>
	<CACRpkdYooPNgJuA-fZOiGJV03R_783uAOmR=QgYOahYdHcad9w@mail.gmail.com>
	<5183AC54.30503@imgtec.com>
	<CACRpkdYYhsY-2vQnxpM-rB9_6yXiY4XBNhb4eyNvK=eD=dxK5w@mail.gmail.com>
	<5183D262.7000107@imgtec.com>
Date: Tue, 14 May 2013 13:52:34 +0200
Message-ID: <CACRpkdbJpnpZwoCqtFk+U9fsJXPLw+AhPBSCxawS2-QwAjBftA@mail.gmail.com>
Subject: Re: [PATCH 5/8] pinctrl-tz1090: add TZ1090 pinctrl driver
From: Linus Walleij <linus.walleij@linaro.org>
To: James Hogan <james.hogan@imgtec.com>
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Grant Likely <grant.likely@secretlab.ca>,
        Rob Herring <rob.herring@calxeda.com>,
        "devicetree-discuss@lists.ozlabs.org" 
	<devicetree-discuss@lists.ozlabs.org>,
        Rob Landley <rob@landley.net>,
        "linux-doc@vger.kernel.org" <linux-doc@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, May 3, 2013 at 5:06 PM, James Hogan <james.hogan@imgtec.com> wrote:
> [me]
>> Thus this part of the problem (poking that "select" bit)
>> should be handled by the pinmux part of the driver.
>>
>> The pinconf part does not need to know about it.
>
> Okay, so how would you recommend handling the case of a pin in a muxing
> pingroup that shouldn't be put into peripheral mode?
>
> E.g. imagine an 18bit display is wired to the (24bit) tft pins (which
> are muxed as a group to "tft" function), and the least significant tft
> pins are used as GPIOs to control something like board power supplies.
>
> Without using pinconf I think the muxing pingroups would have to overlap
> like below (is that acceptable?):

I don't know if I understand your example correctly but are you after
this part of the documentation from Documentation/pinctrl.txt:

Pinmux conventions
==================
(...)
  It is possible to map several groups to the same combination of device,
  pin controller and function. This is for cases where a certain function on
  a certain pin controller may use different sets of pins in different
  configurations.

Yours,
Linus Walleij

Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755747AbaENNTP (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 May 2014 09:19:15 -0400
Received: from mail.active-venture.com ([67.228.131.205]:58939 "EHLO
	mail.active-venture.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755719AbaENNTN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 May 2014 09:19:13 -0400
X-Originating-IP: 108.223.40.66
Message-ID: <53736D42.1010302@roeck-us.net>
Date: Wed, 14 May 2014 06:18:58 -0700
From: Guenter Roeck <linux@roeck-us.net>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.4.0
MIME-Version: 1.0
To: Geert Uytterhoeven <geert@linux-m68k.org>,
        Grant Likely <grant.likely@secretlab.ca>
CC: Pantelis Antoniou <pantelis.antoniou@konsulko.com>,
        Rob Herring <robherring2@gmail.com>,
        Stephen Warren <swarren@wwwdotorg.org>,
        Matt Porter <matt.porter@linaro.org>,
        Koen Kooi <koen@dominion.thruhere.net>,
        Alison Chaiken <Alison_Chaiken@mentor.com>,
        Dinh Nguyen <dinh.linux@gmail.com>, Jan Lubbe <jluebbe@lasnet.de>,
        Alexander Sverdlin <alexander.sverdlin@nsn.com>,
        Michael Stickel <ms@mycable.de>, Dirk Behme <dirk.behme@gmail.com>,
        Alan Tull <delicious.quinoa@gmail.com>,
        Sascha Hauer <s.hauer@pengutronix.de>,
        Michael Bohan <mbohan@codeaurora.org>,
        Ionut Nicu <ioan.nicu.ext@nsn.com>, Michal Simek <monstr@monstr.eu>,
        Matt Ranostay <mranostay@gmail.com>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Pete Popov <pete.popov@konsulko.com>,
        Dan Malek <dan.malek@konsulko.com>,
        Georgi Vlaev <georgi.vlaev@konsulko.com>,
        Pantelis Antoniou <panto@antoniou-consulting.com>
Subject: Re: [PATCH v4 2/8] OF: Introduce DT overlay support.
References: <1396615441-29630-1-git-send-email-pantelis.antoniou@konsulko.com>	<1396615441-29630-3-git-send-email-pantelis.antoniou@konsulko.com>	<20140514100856.5198DC4153D@trevor.secretlab.ca> <CAMuHMdXfNXB7s71+joCpkZrzPCJQFyNv3+bj+=usORRScZsHZQ@mail.gmail.com>
In-Reply-To: <CAMuHMdXfNXB7s71+joCpkZrzPCJQFyNv3+bj+=usORRScZsHZQ@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 05/14/2014 06:03 AM, Geert Uytterhoeven wrote:
> On Wed, May 14, 2014 at 12:08 PM, Grant Likely
> <grant.likely@secretlab.ca> wrote:
>>> +config OF_OVERLAY
>>> +     bool "OF overlay support"
>>> +     depends on OF
>>> +     select OF_DYNAMIC
>>> +     select OF_DEVICE
>>> +     select OF_RESOLVE
>>> +     help
>>> +       OpenFirmware overlay support. Allows you to modify on runtime the
>>> +       live tree using overlays.
>>
>> Should not be a user-visable option. Drivers using it should select it
>
> Why not? It's up to the (final) user to use it, or not.
>
>> or otherwise cause it to be enabled.
>
> Why should this be driver-specific? Shouldn't this just work with all drivers?
>

It does once enabled.

I think what Grant refers to is that there has to be a driver which implements
the actual overlay insertion and removal (ie calls the new API functions),
and that the Kconfig option for this driver should select OF_OVERLAY
instead of depending on it.

Guenter


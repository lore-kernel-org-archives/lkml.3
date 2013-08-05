Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754064Ab3HEJps (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Aug 2013 05:45:48 -0400
Received: from service87.mimecast.com ([91.220.42.44]:60226 "EHLO
	service87.mimecast.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751528Ab3HEJpr convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Aug 2013 05:45:47 -0400
Message-ID: <51FF7445.9080602@arm.com>
Date: Mon, 05 Aug 2013 10:45:41 +0100
From: Jonathan Austin <jonathan.austin@arm.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130308 Thunderbird/17.0.4
MIME-Version: 1.0
To: =?UTF-8?B?VXdlIEtsZWluZS1Lw7ZuaWc=?= 
	<u.kleine-koenig@pengutronix.de>
CC: Olof Johansson <olof@lixom.net>,
        Russell King - ARM Linux <linux@arm.linux.org.uk>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>
Subject: Re: Build breakage due to latest ARM fixes
References: <CAOesGMgWeP-CdmOE-S7XZmJ-+1buP9a1cqavUns2gpgKrrhaxQ@mail.gmail.com> <20130803000731.GS23006@n2100.arm.linux.org.uk> <20130804125346.GH23006@n2100.arm.linux.org.uk> <CAOesGMhNr5-6T9s8Y9jr2pWy=baceuZwGFNj2HtnqU9DbwPLvw@mail.gmail.com> <20130804183708.GI23006@n2100.arm.linux.org.uk> <CAOesGMiDBT9NAhCiVe0mMTk4KXJZVynNaBHqk5+T9a6QYaFZvw@mail.gmail.com> <20130804193647.GD6104@pengutronix.de>
In-Reply-To: <20130804193647.GD6104@pengutronix.de>
X-OriginalArrivalTime: 05 Aug 2013 09:45:43.0713 (UTC) FILETIME=[8DAF0910:01CE91C0]
X-MC-Unique: 113080510454508601
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 04/08/13 20:36, Uwe Kleine-König wrote:
> Hello,
>
> On Sun, Aug 04, 2013 at 11:47:04AM -0700, Olof Johansson wrote:
>> On Sun, Aug 4, 2013 at 11:37 AM, Russell King - ARM Linux
>>> The only real testing I'm aware of is when I recreated the OKI67001
>>> support a while back and got my board to boot.
>>
>> Uwe has been busy pushing various patches for M3/M4 support, I don't
>> know how far it is from having some real hardware usable though. Uwe?
> On my efm32 devboard I have 3.11-rc running. The missing bits are
> available in my efm32 branch at
>
> 	git://git.pengutronix.de/git/ukl/linux.git efm32
> 	http://git.pengutronix.de/?p=ukl/linux.git;a=shortlog;h=refs/heads/efm32
>
> . It's not yet in a form ready for mainline but there isn't much
> missing. There is one problem I didn't debug yet (/proc/devicetree
> doesn't appear although I have the respective Kconfig symbol on); other
> than that I didn't notice any no-mmu problems. Also Jonathan Austin does
> some no-MMU work.
>

We use !MMU internally here for R-class stuff (see the recently added 
Cortex-R7 support).

Our CONFIG_MMU=n testing all happens on Versatile Express, and it should 
even be possible to run !MMU on TC2 (IE with an A-class processor). 
Perhaps if we feel that it isn't easy enough for people to test these 
configurations I can submit a vexpress_nommu defconfig or similar? It 
might need some additional patches to complete the story, but if it 
makes it easier to catch these breakages early then maybe it is worth it?

Jonny



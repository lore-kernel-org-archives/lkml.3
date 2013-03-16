Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932331Ab3CPMj2 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 16 Mar 2013 08:39:28 -0400
Received: from bear.ext.ti.com ([192.94.94.41]:37794 "EHLO bear.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932080Ab3CPMjY (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 16 Mar 2013 08:39:24 -0400
Message-ID: <514467EF.4010604@ti.com>
Date: Sat, 16 Mar 2013 08:39:11 -0400
From: Eduardo Valentin <eduardo.valentin@ti.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:14.0) Gecko/20120714 Thunderbird/14.0
MIME-Version: 1.0
To: Dan Carpenter <dan.carpenter@oracle.com>
CC: <gregkh@linuxfoundation.org>, <devel@driverdev.osuosl.org>,
        <linux-omap@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <linux-pm@vger.kernel.org>
Subject: Re: [PATCH 09/50] staging: omap-thermal: make a omap_bandgap_power
 with only one exit point
References: <1363352438-15935-1-git-send-email-eduardo.valentin@ti.com> <1363352438-15935-10-git-send-email-eduardo.valentin@ti.com> <20130315212241.GL9138@mwanda>
In-Reply-To: <20130315212241.GL9138@mwanda>
Content-Type: text/plain; charset="ISO-8859-1"; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hey Dan,

On 15-03-2013 17:22, Dan Carpenter wrote:
> On Fri, Mar 15, 2013 at 08:59:57AM -0400, Eduardo Valentin wrote:
>> Change the way the omap_bandgap_power is written so that it has only
>> one exit entry (Documentation/CodingStyle).
>>
>
> It's only if there is an unlock or something that you should do
> this.  Otherwise the pointless bunny hop is misleading and annoying.

Well, if that is the case the Chapter 7 needs to be rewritten, don't you 
think? The way it is stated, it is clear that it is a design decision to 
use it for keeping only one exit point (quoting):

"Albeit deprecated by some people, the equivalent of the goto statement is
used frequently by compilers in form of the unconditional jump instruction.

The goto statement comes in handy when a function exits from multiple
locations and some common work such as cleanup has to be done.

The rationale is:

- unconditional statements are easier to understand and follow
- nesting is reduced
- errors by not updating individual exit points when making
     modifications are prevented
- saves the compiler work to optimize redundant code away ;)"

I believe this patch falls into at least three of the above rationale.


>
> regards,
> dan carpenter
>
>
>


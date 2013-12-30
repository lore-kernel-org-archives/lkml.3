Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932099Ab3L3SVa (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 Dec 2013 13:21:30 -0500
Received: from merlin.infradead.org ([205.233.59.134]:36210 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755867Ab3L3SV3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 Dec 2013 13:21:29 -0500
Message-ID: <52C1B99C.7040404@infradead.org>
Date: Mon, 30 Dec 2013 10:21:16 -0800
From: Randy Dunlap <rdunlap@infradead.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.0
MIME-Version: 1.0
To: Wang YanQing <udknight@gmail.com>, Greg KH <gregkh@linuxfoundation.org>,
        jslaby@suse.cz, airlied@redhat.com, akpm@linux-foundation.org,
        kilobyte@angband.pl, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] fonts:Kconfig: fix default enable FONT_8x8 and FONT_8x16
 at the same time
References: <20131230033745.GA5855@udknight> <20131230053430.GA11990@kroah.com> <20131230064842.GA6592@udknight>
In-Reply-To: <20131230064842.GA6592@udknight>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 12/29/13 22:48, Wang YanQing wrote:
> On Sun, Dec 29, 2013 at 09:34:30PM -0800, Greg KH wrote:
>> On Mon, Dec 30, 2013 at 11:37:45AM +0800, Wang YanQing wrote:
>>> FONT_8x8 and FONT_8x16 have the same default value line:
>>> "default y if !SPARC && !FONTS"
>>>
>>> I test run "make defconfig" for x86 will enable FONT_8x8 and FONT_8x16 at
>>> the same time.
>>>
>>> This patch fix it, because FONT_AUTOSELECT choice FONT_8x16, so
>>> I decide to disable FONT_8x8, this patch will reduce size of kernel.
>>>
>>> Signed-off-by: Wang YanQing <udknight@gmail.com>
>>> ---
>>>  lib/fonts/Kconfig | 1 -
>>>  1 file changed, 1 deletion(-)
>>
>> I am not the maintainer of this file, sorry.  Also, I don't think it's
>> correct, if you want, you can always disable this option on your own.
>>
> Hi Greg KH.
> 
> Sorry for confusion, the default behavior enable FONT_8x8 and FONT_8x16,
> FONT_8x8 eat ~50KB memory, but kernel never use it. I think this is not
> good default behavior.

If framebuffer console is enabled, then the user can select which compiled-in
font to use by using
  fbcon=font:<name>
See Documentation/fb/fbcon.txt for more info.


-- 
~Randy

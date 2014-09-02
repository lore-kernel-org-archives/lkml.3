Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753753AbaIBNrG (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Sep 2014 09:47:06 -0400
Received: from kdh-gw.itdev.co.uk ([89.21.227.133]:59169 "EHLO
	hermes.kdh.itdev.co.uk" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751500AbaIBNrE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Sep 2014 09:47:04 -0400
Message-ID: <5405CA4F.10507@itdev.co.uk>
Date: Tue, 02 Sep 2014 14:46:55 +0100
From: Nick Dyer <nick.dyer@itdev.co.uk>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Thunderbird/31.0
MIME-Version: 1.0
To: Javier Martinez Canillas <javier.martinez@collabora.co.uk>,
        =?ISO-8859-15?Q?Andreas_F=E4rber?= <afaerber@suse.de>
CC: Kukjin Kim <kgene.kim@samsung.com>, Doug Anderson <dianders@chromium.org>,
        Olof Johansson <olof@lixom.net>, Yufeng Shen <miletus@chromium.org>,
        linux-samsung-soc@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        Sjoerd Simons <sjoerd.simons@collabora.co.uk>,
        Tomasz Figa <tomasz.figa@gmail.com>,
        Daniel Stone <daniels@collabora.com>
Subject: Re: [PATCH v2 1/3] ARM: dts: Add Peach Pit dts entry for Atmel touchpad
References: <1409066937-3574-1-git-send-email-javier.martinez@collabora.co.uk> <1409066937-3574-2-git-send-email-javier.martinez@collabora.co.uk> <53FD1001.30701@suse.de> <53FD8528.7090504@collabora.co.uk> <53FDD914.5090208@suse.de> <53FDE9B2.4040001@collabora.co.uk>
In-Reply-To: <53FDE9B2.4040001@collabora.co.uk>
Content-Type: text/plain; charset=iso-8859-15
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 27/08/14 15:22, Javier Martinez Canillas wrote:
>>> If there was a BTN_NONE or KEY_UNUSED it would had been better but I think
>>> that making a distinction between these two cases (reserved pin vs GPIO
>>> available but not used) is useful.
>>
>> Maybe Nick can comment here.

Yes, this is probably useful to document. However, I fear that it's not
going to be obvious what the distinction is to someone who doesn't have the
Atmel docs. Perhaps it would be clearer to just do something like:

		linux,gpio-keymap = <KEY_RESERVED
		                     KEY_RESERVED
		                     KEY_RESERVED /* GPIO0 */
	        	             KEY_RESERVED /* GPIO1 */
		                     KEY_RESERVED /* GPIO2 */
		                     BTN_LEFT>;   /* GPIO3 */

If you omit any trailing KEY_RESERVED values it doesn't affect anything.

I was also going to suggest that you put something like "/* Atmel mXT224SL
*/" in your .dts file so it's clear what version of the maXTouch device you
are configuring.

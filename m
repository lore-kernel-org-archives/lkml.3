Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753266Ab3ELJWz (ORCPT <rfc822;w@1wt.eu>);
	Sun, 12 May 2013 05:22:55 -0400
Received: from mail-da0-f53.google.com ([209.85.210.53]:46676 "EHLO
	mail-da0-f53.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751982Ab3ELJWy convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 12 May 2013 05:22:54 -0400
Content-Type: text/plain; charset=us-ascii
Mime-Version: 1.0 (Mac OS X Mail 6.3 \(1503\))
Subject: Re: [RFC PATCHv3 1/6] arm: Initial TI-Nspire support
From: Daniel Tang <dt.tangr@gmail.com>
In-Reply-To: <20130512090610.GF18614@n2100.arm.linux.org.uk>
Date: Sun, 12 May 2013 19:22:45 +1000
Cc: linux-arm-kernel@lists.infradead.org,
        Linus Walleij <linus.walleij@linaro.org>,
        Arnd Bergmann <arnd@arndb.de>,
        "fabian@ritter-vogt.de Vogt" <fabian@ritter-vogt.de>,
        Lionel Debroux <lionel_debroux@yahoo.fr>, linux-kernel@vger.kernel.org
Content-Transfer-Encoding: 8BIT
Message-Id: <453A23B8-7FE0-42D6-BBEC-B6CC3604EE01@gmail.com>
References: <1368332581-94691-1-git-send-email-dt.tangr@gmail.com> <1368332581-94691-2-git-send-email-dt.tangr@gmail.com> <20130512090610.GF18614@n2100.arm.linux.org.uk>
To: Russell King - ARM Linux <linux@arm.linux.org.uk>
X-Mailer: Apple Mail (2.1503)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On 12/05/2013, at 7:06 PM, Russell King - ARM Linux <linux@arm.linux.org.uk> wrote:

> On Sun, May 12, 2013 at 02:22:56PM +1000, Daniel Tang wrote:
>> 
>> +	.bpp		= 8,
>> +	.grayscale	= 1
>> +};
> 
> Still no capabilities in the above - how does the CLCD controller know
> which of BGR or RGB output and which format these panels support?
> 
> Each entry needs a .caps = CLCD_CAP_xxx | CLCD_CAP_xxx listing the
> formats supported there.
> 
> Unless panels and the board have a .caps entry, the caps system won't
> be used.

Fair enough.

> 
>> +static struct clcd_board nspire_clcd_data = {
>> +       .name           = "LCD",
>> +       .caps           = CLCD_CAP_ALL,
> 
> Your board has logic to support the RGB444/BGR444 mode?  If not, setting
> CLCD_CAP_ALL is incorrect.

I believe the grayscale panel supports the xGx444 modes - unsure about the colour one. Since I'm using the same struct clcd_board for both panels, I thought I'd just set caps to work with both to simplify.

Should I set board caps to panel caps on setup?

Cheers,
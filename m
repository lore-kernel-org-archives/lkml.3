Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753334Ab3EPMSE (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 May 2013 08:18:04 -0400
Received: from moutng.kundenserver.de ([212.227.17.9]:64076 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752871Ab3EPMSA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 May 2013 08:18:00 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: Daniel Tang <dt.tangr@gmail.com>
Subject: Re: [RFC PATCHv3 3/6] clk: Add TI-Nspire clock drivers
Date: Thu, 16 May 2013 14:17:27 +0200
User-Agent: KMail/1.12.2 (Linux/3.8.0-18-generic; KDE/4.3.2; x86_64; ; )
Cc: linux-arm-kernel@lists.infradead.org, linux@arm.linux.org.uk,
        Linus Walleij <linus.walleij@linaro.org>,
        "fabian@ritter-vogt.de Vogt" <fabian@ritter-vogt.de>,
        Lionel Debroux <lionel_debroux@yahoo.fr>, linux-kernel@vger.kernel.org,
        Mike Turquette <mturquette@linaro.org>
References: <1368332581-94691-1-git-send-email-dt.tangr@gmail.com> <201305151607.54442.arnd@arndb.de> <15FD6543-D04A-4953-A56A-40B27F0026E4@gmail.com>
In-Reply-To: <15FD6543-D04A-4953-A56A-40B27F0026E4@gmail.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201305161417.28133.arnd@arndb.de>
X-Provags-ID: V02:K0:fQb2A2WJ/o3zw0rPQuSdySV6VpnJEhxv5N9ilpvlUQb
 3cTZcLihLt7IIZANZqsAURNMu+5BLtssLl0OFsikiFczPlLrUT
 OkOwJ+lXsniK7rL4E7RB9ZwWTW6ApZvO82BGxYvrQauo83cgSU
 rTGiIpPyp6PJ1jtNnDD05Vyz7yVLN5gAjenLHbYf5xyd/hUJJ/
 uFAAwzD91bk8IayR9dVuze3fmuuZptuiupEbnqJidqbR8/JYVR
 BrzhB4lBgVTsKtz043OrKiWUdfR0B0b/VpmAc7AfTSQFbDRbAA
 ZvLgpDojbRPtNsaqqjFzL8Kc359d74YFpwTH7B2fd66j65ZXl2
 2ZscMql/HWNLmeqLGxzY=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thursday 16 May 2013, Daniel Tang wrote:
> 
> On 16/05/2013, at 12:07 AM, Arnd Bergmann <arnd@arndb.de> wrote:
> 
> > You are missing a binding in Documentation/devicetree, same as for some of
> > the other drivers in this series.
> 
> Should we be adding a vendor prefix to it too? If so, we're not sure whether
> to use "ti," or not since this isn't an official port by TI.

The binding describes the hardware, it should not matter who does the port.
However, any part of the tree that is not actually from TI should have a
vendor prefix indicating who made that part. IIRC, the SoC used in there
is from TI, so you should use something else for the on-soc components.
 
> > It seems strange to assign the clk_name variable to node->name
> > first and then overriding it with the clock-output-names property.
> > Is that intentional? If so, please explain it in a comment.
> > 
> 
> I copied that bit of boilerplate from drivers/clk/clk-fixed-rate.c but
> I'm guessing it's to use the node name as the clock name unless there
> is a property called "clock-output-names"

Ah, I see. It seems you forgot to add the clock maintainer to Cc in the
mail. Mike is the one who will have to take you patch anyway, so I assume
he will comment on this if you did it wrong.

	Arnd

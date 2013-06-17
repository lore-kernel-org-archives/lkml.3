Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752219Ab3FQPBh (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Jun 2013 11:01:37 -0400
Received: from moutng.kundenserver.de ([212.227.126.171]:53849 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751610Ab3FQPBf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Jun 2013 11:01:35 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: Jonas Jensen <jonas.jensen@gmail.com>
Cc: Russell King - ARM Linux <linux@arm.linux.org.uk>,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        ulli.kroll@googlemail.com, arm@kernel.org,
        Florian Fainelli <florian@openwrt.org>, Imre Kaloz <kaloz@openwrt.org>
Subject: Re: [PATCH] ARM: mm: cpu_fa526_do_idle: remove WFI
Date: Mon, 17 Jun 2013 17:01:47 +0200
Message-ID: <3363106.HfAWgJLKER@wuerfel>
User-Agent: KMail/4.10.3 (Linux/3.9.0-2-generic; KDE/4.10.3; x86_64; ; )
In-Reply-To: <CACmBeS3_aqf42sCKeO9TNJSkOPYwvyAXOvYKjrU8_jV6yAKQ-g@mail.gmail.com>
References: <1371476360-8751-1-git-send-email-jonas.jensen@gmail.com> <20130617143021.GI2718@n2100.arm.linux.org.uk> <CACmBeS3_aqf42sCKeO9TNJSkOPYwvyAXOvYKjrU8_jV6yAKQ-g@mail.gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
X-Provags-ID: V02:K0:2h8qDgS88yFivxml/zIlG/Hcpspcw7bwytjJwqbjypP
 hykFawMexWryY+E/BMqeFOsIXJqsPj9nsHnh6vQaUUSFfMnCoj
 6G9bIrjnPAyyvVRFh/UN1r6efE4THVZGswFyZazXB9i2AUyYFW
 hwhBsfO2aua3GtpjURQ1vhImCwUFLP5V5PenxoRMhRpTDuqttS
 cnro8NVtiu/MQZ9EJEzTUVi8xm4VYKbuI2WrmSFK6I25Nm54RJ
 FaaJB3IrthYCuYXVQjTYB3C5jNy3Rg9/DEy4d27GorARIHRgnO
 vjvXxp4fDpyqpX51DKdotQBiOOje63PZnqy0XyukVvLX5Z0bAH
 oFvTG+KAAxDCZXFLGh+Q=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Monday 17 June 2013 16:58:14 Jonas Jensen wrote:
> On 17 June 2013 16:30, Russell King - ARM Linux <linux@arm.linux.org.uk> wrote:
> > It replaces the WFI and return with a pure nop, so we will fall through
> > to cpu_fa526_dcache_clean_area().  Do we really want to clean a random
> > D cache entry depending on what r0 happened to hold at this point?  I
> > think not...
> 
> I'm sorry for making the assumption that I know even the most basic
> ARM assembler...
> 
> This is not the sort of thing I deal with (and probably shouldn't) on
> a daily basis.
> 
> Can I make a guess, remove only mcr and replace it with nop?

No need for the nop, just remove the mcr instruction.

	Arnd

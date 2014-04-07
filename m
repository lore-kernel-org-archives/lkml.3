Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755300AbaDGMvv (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 Apr 2014 08:51:51 -0400
Received: from moutng.kundenserver.de ([212.227.126.187]:64366 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754274AbaDGMvt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 Apr 2014 08:51:49 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: Mike Looijmans <mike.looijmans@topic.nl>
Cc: Ben Dooks <ben.dooks@codethink.co.uk>, linux-mmc@vger.kernel.org,
        linux-kernel@vger.kernel.org, cjb@laptop.org, gdjakov@mm-sol.com
Subject: Re: [PATCH] sdhci: Forward EPROBE_DEFER on vmmc and vqmmc regulators
Date: Mon, 07 Apr 2014 14:51:41 +0200
Message-ID: <4902841.krZFXFDZqb@wuerfel>
User-Agent: KMail/4.11.5 (Linux/3.11.0-18-generic; KDE/4.11.5; x86_64; ; )
In-Reply-To: <53429AD4.7030508@topic.nl>
References: <1395991817-3503-1-git-send-email-mike.looijmans@topic.nl> <10471336.Pb8zVvW3Hp@wuerfel> <53429AD4.7030508@topic.nl>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
X-Provags-ID: V02:K0:NFa7/BGqkBTdlH84JxxKZ0Y7EOxRUfWM/8kWrRjpK2j
 vOOTYYeOfeTzxS6TmZaF7lTMEPiBobYQPeNBbL1mCE6eHwEYCP
 6t/b5yYZPrD1iYhUF2HYSInGtp3AaGmMsES9Y+7WOSOBoq7dnF
 kZFzNPLYtwEou3cch4jik2WzHmH+2V6PMeASawBiz3nbLDKqiO
 5Txgx4sXrPQf6otB4gQ9qzv2n6T4PW7P9kPl3AjmifbMfUKGPW
 62YQNo31/kkVaHSHeyXV4lYZOniLOpLJaoNWeZ8DAc+6lhQaeS
 kB6l/e+m7FB1dkLeuN6uiuMZMA1qmXu7mZv4uUJSmIXTAvHDtC
 AMwO/OI5BXe/gvlqeGIg=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Monday 07 April 2014 14:32:20 Mike Looijmans wrote:
> On 04/07/2014 02:25 PM, Arnd Bergmann wrote:
> 
> Judging from the kernel output, regulator_get_optional returns -ENODEV if the 
> supply wasn't found.
> 
> Maybe the API is confusing (or wrong?) here.
> 
> If you change the code as per your suggestion, the SD will not work unless you 
> explicitly assign supplies. And judging from what I've seen so far, I am the 
> first to have ever attached a power supply to this controller...

It's certainly not very "optional" if it returns an error here.

You could try to special-case the "-ENODEV" return here, but I think it
would be better to change the regulator interface to be less confusing.

	Arnd

Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751962AbaJJIaT (ORCPT <rfc822;w@1wt.eu>);
	Fri, 10 Oct 2014 04:30:19 -0400
Received: from mout.kundenserver.de ([212.227.126.187]:54001 "EHLO
	mout.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751786AbaJJIaP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 10 Oct 2014 04:30:15 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: linux-arm-kernel@lists.infradead.org
Cc: Wolfram Sang <wsa@the-dreams.de>, linux-kernel@vger.kernel.org,
        Greg KH <gregkh@linuxfoundation.org>, kernel-janitors@vger.kernel.org,
        cocci@systeme.lip6.fr
Subject: Re: [RFC] drop owner assignment from platform_drivers
Date: Fri, 10 Oct 2014 10:30:08 +0200
Message-ID: <2106140.DbuFLh1xav@wuerfel>
User-Agent: KMail/4.11.5 (Linux/3.16.0-10-generic; KDE/4.11.5; x86_64; ; )
In-Reply-To: <20141010072439.GA1741@katana>
References: <20141010072439.GA1741@katana>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
X-Provags-ID: V02:K0:Y4kIVLXK9p5um1bOKfTdGsMkbn7oOYiwXc7KAItgbfB
 6CotV57dwV9j/D9H71F53eq3ibM1h0eB8aymAXR7xMQsRexUVU
 UcMSjn3BjsrdpY7NQndtGekwm5DPI8paaLi7osJltVUMq4Qeka
 +9mNrxACLgQt+0MWAZUyel1hmFTG7Z5ieQhWznG3IABkXoYFBu
 7LIlU4L5dlGPxmA8wJWQ+oxpS3LRBcj+DjZUwE99KOhm/ZN//u
 nUSNgxRn0SvKKQhhzmkHPJe4x5U3yHTRPCPtxgXbr19Vs/xWXE
 /E79TGGw42EtxpxS7kK4WMHBdqhvn6aF2DVhOgvMzp9U4niOae
 laL8XGRAEkgyuohpEFmI=
X-UI-Out-Filterresults: notjunk:1;
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Friday 10 October 2014 09:24:39 Wolfram Sang wrote:
> people found out that for platform_driver, we don't need to set the
> .owner field because this is done by the platform driver core. So far,
> so good. However, now I got patches removing the .owner field for this
> single i2c driver or for that one. To prevent getting thousands of
> patches fixing single drivers, I used coccinelle to remove all instances
> from the kernel. The SmPL looks like this, it doesn't blindly remove all
> THIS_MODULE, but checks if the platform_driver struct was really used by
> a call actually setting the .owner field:

Is the intention just to save a few lines in the kernel source, or are
there any additional upsides to doing this?

While it looks like an obvious cleanup, it also seems to me that there
is zero effect in terms of functionality, code size or enabling future
changes.

I'm all for adding your semantic patch to scripts/coccinelle so it gets
picked up by anyone writing new drivers or doing code cleanup on their
driver, but I'm unsure about the value of applying all your patches
for the existing drivers.

	Arnd

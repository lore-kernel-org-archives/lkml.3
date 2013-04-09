Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935903Ab3DITNJ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Apr 2013 15:13:09 -0400
Received: from moutng.kundenserver.de ([212.227.126.171]:56447 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S935459Ab3DITNH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Apr 2013 15:13:07 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: Harvey Harrison <harvey.harrison@gmail.com>
Subject: Re: [PATCH 7/8] dmaengine: ste_dma40: Use the BIT macro to replace ugly '(1 << x)'s
Date: Tue, 9 Apr 2013 21:12:55 +0200
User-Agent: KMail/1.12.2 (Linux/3.8.0-16-generic; KDE/4.3.2; x86_64; ; )
Cc: Lee Jones <lee.jones@linaro.org>, linux-arm-kernel@lists.infradead.org,
        LKML <linux-kernel@vger.kernel.org>, linus.walleij@stericsson.com
References: <1365532783-27425-1-git-send-email-lee.jones@linaro.org> <1365532783-27425-7-git-send-email-lee.jones@linaro.org> <CAHLZz133b6kydVwh0_Cn2yg-Q_MeUF+Z-7+CMY7TkB7KK2ssAQ@mail.gmail.com>
In-Reply-To: <CAHLZz133b6kydVwh0_Cn2yg-Q_MeUF+Z-7+CMY7TkB7KK2ssAQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <201304092112.56039.arnd@arndb.de>
X-Provags-ID: V02:K0:0N1zWpL/uz6vYTb4qfDgpkLh23UI+e+xV4JHGqDS/Bt
 yb0T9gZo1HDKpyxtjOWB9I6c4bSolGrRIWZqCs/9EVK8xTNjoi
 yS6nqczU5Q7Syl9Vu2XnrzsONvYzHWYxTLKDgv+EF4n+/hFdSM
 7sB89NQfwAZarHPO8ozgycQAKKDaJTOpSw7mjSq/pP5gXGSDsN
 IhZAioiNllCeG37DGk3H6M0Ju2vqmyNdVyQSQ31ApBQ4Uemrqk
 s/7O9i0ibIZfxd4i/7EXwstbbS93IyRYzf21pjnl5qeUNKuwpT
 HV9/8buy9I6Av+8AATZO7AO8WkTWQiO//KaWAitbW2F+Jw3uAm
 XD47GCyswEZ3d/+jg8Ak=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday 09 April 2013, Harvey Harrison wrote:
> 
> On Tue, Apr 9, 2013 at 11:39 AM, Lee Jones <lee.jones@linaro.org> wrote:
> >
> > The aim is to make the code that little more readable.
> >
> > Signed-off-by: Lee Jones <lee.jones@linaro.org>
> > ---
> 
> >
> >  #define MAX(a, b) (((a) < (b)) ? (b) : (a))
> 
> Not part of your patch, but probably a good idea to switch to the
> generic MAX macro, this
> one is evaluating its args twice.

Yes, good point. The macro is only used in one place, to compare
two compile-time constant values, but we should define macros in
drivers that are already provided by the kernel.

	Arnd

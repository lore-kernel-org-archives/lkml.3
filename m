Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752993AbaCBUTr (ORCPT <rfc822;w@1wt.eu>);
	Sun, 2 Mar 2014 15:19:47 -0500
Received: from mail-ie0-f175.google.com ([209.85.223.175]:34152 "EHLO
	mail-ie0-f175.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752755AbaCBUTp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 2 Mar 2014 15:19:45 -0500
From: axel.rasmussen1@gmail.com
To: linux-kernel@vger.kernel.org
Subject: Re: [PATCH 7/9] drivers: staging: rtl8187se: fixed checkpatch.pl errors
Date: Sun, 02 Mar 2014 13:19:40 -0700
Message-ID: <2481284.M04WIiAyls@celine>
User-Agent: KMail/4.11.5 (Linux/3.12.9-gentoo; KDE/4.12.2; x86_64; ; )
In-Reply-To: <1393738591.31402.23.camel@joe-AO722>
References: <1393737773-13937-1-git-send-email-axel.rasmussen1@gmail.com> <1393737773-13937-8-git-send-email-axel.rasmussen1@gmail.com> <1393738591.31402.23.camel@joe-AO722>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Saturday 01 March 2014 9:36:31 PM Joe Perches wrote:
> On Sat, 2014-03-01 at 22:22 -0700, Axel Rasmussen wrote:
> > The definition of the driver's ChannelPlan array produced a large number
> > of checkpatch.pl errors. This patch fixes all of them by adding spaces
> > and wrapping the resulting overly-long lines.
> 
> I think the current code is better.
> 
> > diff --git a/drivers/staging/rtl8187se/r8180_core.c
> > b/drivers/staging/rtl8187se/r8180_core.c
> []
> 
> > @@ -2242,17 +2242,44 @@ static void watch_dog_adaptive(unsigned long data)
> 
> [for instance]
> 
> >  static struct rtl8187se_channel_list channel_plan_list[] = {
> > 
> > -	{{1,2,3,4,5,6,7,8,9,10,11,36,40,44,48,52,56,60,64},19},		/* FCC */
> 
> []
> 
> > +	/* FCC */
> > +	{{1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 36, 40,
> > +		44, 48, 52, 56, 60, 64}, 19},
> 
> If you really do this, it may be better to
> remove the len variable and test for != 0
> instead of channel_plan_list[].len
> 
> So instead of:
> 
> drivers/staging/rtl8187se/r8180_core.c:
> 			for (i = 0; i < channel_plan_list[channel_plan].len; i++) {
> Maybe:
> 			for (i = 0; channel_plan_list[channel_plan].channel[i]; i++) {

True, removing the length and using a 0 terminating element would simplify the channel plan list, allowing it to just be a list of arrays, rather than a list of structs. The one thing I'd be curious about is, judging by the driver's TODO file, it seems that its existing private ieee80211 implementation is going to be replaced with one that already exists elsewhere in the kernel, so the entire channel plan list may disappear at that point? If true, I'm not sure it's worth doing anything very complicated to the existing implementation.

Maybe someone can confirm that this channel plan list will go away once the driver is integrated with drivers/net/wireless/rtl818x? Otherwise, I can alter this patch to replace struct rtl8187se_channel_list with a simple array of channels.

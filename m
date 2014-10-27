Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751795AbaJ0Got (ORCPT <rfc822;w@1wt.eu>);
	Mon, 27 Oct 2014 02:44:49 -0400
Received: from mx1.redhat.com ([209.132.183.28]:39001 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751141AbaJ0Gos (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 27 Oct 2014 02:44:48 -0400
From: Jes Sorensen <Jes.Sorensen@redhat.com>
To: Joe Perches <joe@perches.com>
Cc: Paul McQuade <paulmcquad@gmail.com>, linux-kernel@vger.kernel.org,
        devel@driverdev.osuosl.org, linux-wireless@vger.kernel.org,
        gregkh@linuxfoundation.org, Larry.Finger@lwfinger.net
Subject: Re: [PATCH 2/2] staging: rtl8723au:core
References: <1414340332-4556-1-git-send-email-paulmcquad@gmail.com>
	<1414350250.15751.22.camel@perches.com> <wrfjegtucbgo.fsf@redhat.com>
	<1414389096.15751.34.camel@perches.com> <wrfj1tpuca0q.fsf@redhat.com>
	<1414390984.8884.0.camel@perches.com>
Date: Mon, 27 Oct 2014 07:44:37 +0100
In-Reply-To: <1414390984.8884.0.camel@perches.com> (Joe Perches's message of
	"Sun, 26 Oct 2014 23:23:04 -0700")
Message-ID: <wrfjd29eau5m.fsf@redhat.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/24.3 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Joe Perches <joe@perches.com> writes:
> On Mon, 2014-10-27 at 07:16 +0100, Jes Sorensen wrote:
>> Joe Perches <joe@perches.com> writes:
>> > On Mon, 2014-10-27 at 06:45 +0100, Jes Sorensen wrote:
>> >> Joe Perches <joe@perches.com> writes:
>> >> > On Sun, 2014-10-26 at 16:18 +0000, Paul McQuade wrote:
>> >> >> ERROR: spaces required around that ':' (ctx:VxE)
>> > []
>> >> >> diff --git a/drivers/staging/rtl8723au/core/rtw_ieee80211.c
>> >> >> b/drivers/staging/rtl8723au/core/rtw_ieee80211.c
>> > []
>> >> >> @@ -794,28 +794,28 @@ u16 rtw_mcs_rate23a(u8 rf_type, u8 bw_40MHz, u8 short_GI_20, u8 short_GI_40,
>> >> >>  
>> >> >>  	if (rf_type == RF_1T1R) {
>> >> >>  		if (mcs->rx_mask[0] & BIT(7))
>> >> >> -			max_rate = (bw_40MHz) ? ((short_GI_40)?1500:1350):
>> >> >> +			max_rate = (bw_40MHz) ? ((short_GI_40)?1500:1350) :
>> > []
>> >> >
>> >> > A macro could help intelligibility here - maybe something like:
>> >> >
>> >> > #define get_max_rate(r1, r2, r3, r4)					\
>> >> > 	(bw_40MHz ? (short_GI_40 ? r1 : r2) : (short_GI_20 ? r3 : r4))
>> >> > and:
>> >> >  		if (mcs->rx_mask[0] & BIT(7))
>> >> > 			max_rate = get_max_rate(1500, 1350, 722, 650);
>> >> 
>> >> Hiding a parameter to a macro like that is bad coding practice, so don't
>> >> do that please!
>> >
>> > Yes and no.
>> >
>> > Adding the other 3 arguments to the macro doesn't help legibility.
>> >
>> > Keeping the macro definition local to the place that it's used
>> > can help avoid typos.
>> 
>> It's wrong, so just don't do it here!
>
> It's not "wrong", you just don't like it.

I consider it wrong, and I am the co-maintainer of this driver .... and
I NACK it.

There's a gazillion real issues to fix in this driver, adding a bad
macro isn't on that list.

Jes

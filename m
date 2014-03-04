Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933365AbaCDVUl (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Mar 2014 16:20:41 -0500
Received: from mail-oa0-f53.google.com ([209.85.219.53]:56682 "EHLO
	mail-oa0-f53.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932941AbaCDVUc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Mar 2014 16:20:32 -0500
MIME-Version: 1.0
In-Reply-To: <20140228232223.GB23878@earth.universe>
References: <1393375569-21751-1-git-send-email-sre@debian.org>
	<1393375569-21751-2-git-send-email-sre@debian.org>
	<CAAfyv37B=xn3AktnUxPDpuey+5S73vW0PJnuUZtorP4rajPKiw@mail.gmail.com>
	<20140226215452.GA11468@earth.universe>
	<CAAfyv340pA2ihUAoFytBgevLtedvtj5Z0aw_=G9Rbx5occtyqw@mail.gmail.com>
	<20140228020536.GB5427@earth.universe>
	<CAAfyv36jJoMxZQ5e43pEC2rzNBHHW9Jt_4dg5O-fS8e+Aim7jA@mail.gmail.com>
	<20140228210857.GA17467@earth.universe>
	<CAAfyv34UB52FCDQGMWWgsdHH8ksTLmTg0iWQcC+dUbhk5nwuoQ@mail.gmail.com>
	<CAAfyv36RPCkUKLOC6yHRwaNjA16EeG_niyfZoaJ15LZ5_HdR7g@mail.gmail.com>
	<20140228232223.GB23878@earth.universe>
Date: Tue, 4 Mar 2014 22:20:32 +0100
Message-ID: <CAAfyv36LD_JmPfBFCkQo9pLbgM4vwqk_P0M_XOAnPTUppQ1Zug@mail.gmail.com>
Subject: Re: [PATCHv1 1/2] rx51_battery: convert to iio consumer
From: Belisko Marek <marek.belisko@gmail.com>
To: Sebastian Reichel <sre@debian.org>
Cc: LKML <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Sebastian,

On Sat, Mar 1, 2014 at 12:22 AM, Sebastian Reichel <sre@debian.org> wrote:
> Hi Marek,
>
> On Fri, Feb 28, 2014 at 11:32:22PM +0100, Belisko Marek wrote:
>> Seems I found issue. I have missing property ti,system-uses-second-madc-irq
>> as original twl4030_madc_battery used SW2 but this change doesn't fix completely
>> the problem.
>
> I remember adding this property because you requested it :) Good to
> know, that its really needed.
>
>> What it fixed completely is change:
>> -       req.raw = !(mask == IIO_CHAN_INFO_PROCESSED);
>> +       req.raw = 0;//!(mask == IIO_CHAN_INFO_PROCESSED);
>
> ok, that figures it. Instead of changing the twl4030-madc driver
> you should change the twl4030-madc-battery driver. You currently
> call iio_read_channel_raw(), which gives you raw values. Your
> driver wants processed data from twl4030-madc, so you should use
> iio_read_channel_processed() instead.
Yes this helps but also not completely :(. twl4030_madc_battery using
chanel 1, 10, 12. Channel 1 and 10 have flag IIO_CHAN_INFO_PROCESSED
set but channel 12 not and values from channel 12 are read as raw which is not
what I want. Can I simply add IIO_CHAN_INFO_PROCESSED also to channel 12?
>
> -- Sebastian

BR,

marek

-- 
as simple and primitive as possible
-------------------------------------------------
Marek Belisko - OPEN-NANDRA
Freelance Developer

Ruska Nova Ves 219 | Presov, 08005 Slovak Republic
Tel: +421 915 052 184
skype: marekwhite
twitter: #opennandra
web: http://open-nandra.com

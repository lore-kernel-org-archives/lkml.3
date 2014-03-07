Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752699AbaCGMjv (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Mar 2014 07:39:51 -0500
Received: from mail-ie0-f180.google.com ([209.85.223.180]:54561 "EHLO
	mail-ie0-f180.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751082AbaCGMju (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Mar 2014 07:39:50 -0500
Message-ID: <5319BE19.5000607@gmail.com>
Date: Fri, 07 Mar 2014 07:39:53 -0500
From: Austin S Hemmelgarn <ahferroin7@gmail.com>
User-Agent: Mozilla/5.0 (Windows NT 6.1; WOW64; rv:24.0) Gecko/20100101 Thunderbird/24.3.0
MIME-Version: 1.0
To: Richard Weinberger <richard.weinberger@gmail.com>,
        Jon Ringle <jringle@gridpoint.com>
CC: Greg KH <gregkh@linuxfoundation.org>,
        "Ringle, Jonathan" <Jonathan.Ringle@gridpoint.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] Add option to build with -O3
References: <1393977709-9809-1-git-send-email-jringle@gridpoint.com>	<20140305050927.GA8534@kroah.com>	<alpine.DEB.2.02.1403050019300.22601@jringle-ubuntu> <CAFLxGvyB0r2RgeFhKoWqgWHLKEMF=BEM8ThRr8Mq6nGtJWQm1w@mail.gmail.com>
In-Reply-To: <CAFLxGvyB0r2RgeFhKoWqgWHLKEMF=BEM8ThRr8Mq6nGtJWQm1w@mail.gmail.com>
X-Enigmail-Version: 1.6
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 2014-03-06 08:28, Richard Weinberger wrote:
> On Wed, Mar 5, 2014 at 6:37 AM, Jon Ringle <jringle@gridpoint.com>
> wrote:
>> 
>> 
>> On Wed, 5 Mar 2014, Greg KH wrote:
>> 
>>> On Tue, Mar 04, 2014 at 07:01:49PM -0500, Jon Ringle wrote:
>>>> +config CC_OPTIMIZE_FOR_SPEED +    bool "Optimze for speed
>>>> (-O3)" +    help +      Enabling this option will pass "-O3"
>>>> to gcc +      resulting in a larger kernel (but possibly
>>>> faster)
>>> 
>>> Are you sure about that?  Have you measured it?
>> 
>> I do know that there is an improvement performance-wise for my
>> particular use-case.
>> 
>> My target is an ARM board being built with gcc-4.8.2. My board
>> has on it a sc16is740 that is used as an RS-485 port. The
>> sc16is740 is on the i2c bus, so when an interrupt comes in to
>> indicate that there is data available to be read, I need to get
>> the data over the i2c bus. I do this on a kthread to do this
>> work. The i2c transactions (using i2c-davinci driver) are also 
>> interrupt driven. I was seeing a lot of lost packets when
>> receiving data at only 19200. Adding the -O3 compile option
>> helped in this regard in that I am now rarely seeing packet
>> loss.
> 
> Please also see: 
> http://www.gossamer-threads.com/lists/linux/kernel/1835761?do=post_view_threaded#1835761
>
> 
Ironically, combining these might achieve a significant performance
improvement over CONFIG_GENERIC_CPU and -O2.

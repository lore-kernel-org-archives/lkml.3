Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935222Ab3FSVpn (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Jun 2013 17:45:43 -0400
Received: from moutng.kundenserver.de ([212.227.126.171]:62619 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934858Ab3FSVpm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Jun 2013 17:45:42 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: Guenter Roeck <linux@roeck-us.net>
Subject: Re: Adding support for ARINC429 into the Linux kernel
Date: Wed, 19 Jun 2013 23:45:30 +0200
User-Agent: KMail/1.12.2 (Linux/3.8.0-22-generic; KDE/4.3.2; x86_64; ; )
Cc: linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
        "David S. Miller" <davem@davemloft.net>,
        "Greg Kroah-Hartman" <gregkh@linuxfoundation.org>
References: <20130619202954.GA5594@roeck-us.net>
In-Reply-To: <20130619202954.GA5594@roeck-us.net>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201306192345.31106.arnd@arndb.de>
X-Provags-ID: V02:K0:LKt2X0PrDEiLRrw16cfWPWgmpdiMJ1pl4uCaKx9eiMk
 lLLdAm/+ZssabwJaeN6pp6E+xD0G269OYRtH3OrRcAaOX5sxuz
 1GrOfNI0+KlsxOVcIu4J7C9POtV6sJvSAYGWy7qWS2ZMp9L839
 i5U3nHjgHMg1o+KJ4pE5efGoU44y7bf/STiC+pdKXhZEB/8iyY
 pm4wYrlUwN5DZMHAN0CSLsFFAK5094smY4Opl9CfI9wAvIKXd7
 O8fnM9m5bxCVXLvry9qXBvjILrBC3BOzIyVtN8wmhP9+ECJqB/
 edxSHXhkCoWqRD14DWceE6jGtAXGDvowK/F072whNI3QVwDHHR
 anqYyJndN7qjF/+fFBSQ=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wednesday 19 June 2013, Guenter Roeck wrote:
> I have been asked to explore options for adding ARINC 429 support [1]
> into the Linux kernel, primarily to support devices from Holt Integrated
> Circuits [2] (the request is unrelated to the chip manufacturer).
> 
> ARINC429 is a protocol which is widely used in commercial airplanes. 
> 
> There are various chips supporting this protocol available, as well as
> out-of-tree Linux support. The drivers I have looked at implement it
> either as character device or misc device and typically pass raw receive
> data to userspace.
> 
> I can see a number of options for going forward:
> 1) Implement as character device (or possibly misc device) and pass
>    raw data to/from user space
>    1a) Just implement a driver for the specific chips
>    2b) Implement some kind of generic infrastructure
> 2) Implement as network driver with a new address family, similar to,
>    say, AF_CAN.
> 
> Any thoughts / suggestions which approach would be better and, most of all,
> which approach might have a better chance of being accepted upstream ?

Since this is a standard protocol, a driver that just supports a specific
chip (1a) would be the worst option IMHO.

A character device and a network protocol both sound reasonable, but
it really depends on the use cases:

* Does Linux act both as the sender and receiver, or do you want to
  support just one of the cases (which?)?

* Would you expect to always just transfer a single 32-bit word, or
  are there larger chunks of logically contigous data? What are typical
  and maximum sizes for those?

* Would you expect the kernel to filter for specific data on the
  receiver side?

* Would a user space receiver want to always see all data from one
  sender, or only the latest word?

	Arnd

Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751322AbaIUNus (ORCPT <rfc822;w@1wt.eu>);
	Sun, 21 Sep 2014 09:50:48 -0400
Received: from mail-we0-f175.google.com ([74.125.82.175]:50951 "EHLO
	mail-we0-f175.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751107AbaIUNuq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 21 Sep 2014 09:50:46 -0400
Message-ID: <541ED7B3.6050306@gmail.com>
Date: Sun, 21 Sep 2014 15:50:43 +0200
From: Tobias Oberstein <tobias.oberstein@gmail.com>
User-Agent: Mozilla/5.0 (Windows NT 6.1; WOW64; rv:24.0) Gecko/20100101 Thunderbird/24.6.0
MIME-Version: 1.0
To: Eduardo Silva <edsiper@gmail.com>
CC: LKML <linux-kernel@vger.kernel.org>
Subject: Re: SO_REUSEPORT and Unix domain sockets
References: <538460FE.8030000@gmail.com> <CAMAQheOpXxa-ndT1EuOqJgae3yzEWbRTLMs+y800S930w-xKsw@mail.gmail.com>
In-Reply-To: <CAMAQheOpXxa-ndT1EuOqJgae3yzEWbRTLMs+y800S930w-xKsw@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Am 20.09.2014 03:44, schrieb Eduardo Silva:
>>
>> How can this be used for sockets of type AF_UNIX?
>>
>> I can only get it working with TCP sockets, not Unix domain sockets.
>>
>> When using TCP, the incoming clients will get nicely balanced to all
>> processes listening. With Unix domain sockets, the incoming clients all get
>> connected only to the last started process.
>>
>> The test code (Python) I was trying is here:
>>
>> http://stackoverflow.com/questions/23742368/can-so-reuseport-be-used-on-unix-domain-sockets
>>
>> Any hints appreciated,
>> /Tobias
>
>
> Looking at the original patch looks like the implementation is only
> done for TCP and UDP:
>
>       http://git.kernel.org/cgit/linux/kernel/git/torvalds/linux.git/commit/?id=c617f398edd4db2b8567a28e899a88f8f574798d
>

Ok, I see. Unfortunate.

> UNIX domain sockets use the file system as the address name space, so
> SO_REUSEPORT would not be applicable.
>

Yes, in case of Unix domain sockets, it's about "reusing paths", not ports.

Such an option for in-kernel load-balancing of Unix domain sockets would 
be useful ..

/Tobias

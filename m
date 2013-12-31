Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756573Ab3LaWGZ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 31 Dec 2013 17:06:25 -0500
Received: from a-pb-sasl-quonix.pobox.com ([208.72.237.25]:37387 "EHLO
	sasl.smtp.pobox.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756443Ab3LaWGY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 31 Dec 2013 17:06:24 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws; d=pobox.com; h=message-id:date
	:from:mime-version:to:cc:subject:references:in-reply-to
	:content-type:content-transfer-encoding; q=dns; s=sasl; b=kpcai/
	LelKlZHx9SCrKQzo+3FMhewm1OUJ5TAoXtgfunjCgdSMq27axh7V+uzPrdfa+D4a
	g1buuwvlxYF7l6kpieLzqaKod2yweOWlWbbuXhSnEJg4jPVQXXv/0pZ53di+B49r
	HmHDqPHVh9Bw1nIQSJoYeTJ8vfoqB79f0pM6o=
Message-ID: <52C33FD8.5090102@pobox.com>
Date: Tue, 31 Dec 2013 17:06:16 -0500
From: Mark Lord <mlord@pobox.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.1.1
MIME-Version: 1.0
To: walt <w41ter@gmail.com>, Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-kernel@vger.kernel.org
CC: stable@vger.kernel.org, David Laight <david.laight@aculab.com>,
        Sarah Sharp <sarah.a.sharp@linux.intel.com>, stable@vger.kernel.org
Subject: Re: [PATCH 3.12 033/118] usb: xhci: Link TRB must not occur within
 a USB payload burst
References: <20131218211219.461663463@linuxfoundation.org> <20131218211220.412278148@linuxfoundation.org> <52C32BB0.90600@gmail.com>
In-Reply-To: <52C32BB0.90600@gmail.com>
X-Enigmail-Version: 1.6
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Pobox-Relay-ID: C6006B50-7267-11E3-B4F7-873F0E5B5709-82205200!a-pb-sasl-quonix.pobox.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 13-12-31 03:40 PM, walt wrote:
> On 12/18/2013 01:11 PM, Greg Kroah-Hartman wrote:
>> 3.12-stable review patch.  If anyone has any objections, please let me know.
>>
>> ------------------
>>
>> From: David Laight <David.Laight@ACULAB.COM>
>>
>> commit 35773dac5f862cb1c82ea151eba3e2f6de51ec3e upstream.
>>
>> Section 4.11.7.1 of rev 1.0 of the xhci specification states that a link TRB
>> can only occur at a boundary between underlying USB frames (512 bytes for
>> high speed devices).
>>
>> If this isn't done the USB frames aren't formatted correctly and, for example,
>> the USB3 ethernet ax88179_178a card will stop sending...
> 
> 
> Unfortunately this patch causes a regression when copying large files to my
> outboard USB3 drive. (Nothing at all to do with networking.)
> 
> When I try to copy a large (20GB) file to the USB3 drive, the copy dies after
> about 7GB, the ext4 journal aborts and the drive is remounted read-only.
> 
> This bug is 100% reproducible (always pretty close to 7GB) and reverting this
> patch completely fixes the problem.
> 
> (Note to Sarah:  I recently emailed you about this problem, and I *wrongly*
> said that reverting the patch doesn't help.  That was a mistake, sorry.)
..


I have also had USB3 mass-storage issues with kernels since this patch.
Dunno if the patch itself is the problem, but just too much to do with USB3
is very flakey in the most recent 3.12.* kernels, as well as the 3.13-rc* ones.
So I have gone back to running older kernels and patching them.

Cheers
-- 
Mark Lord
Real-Time Remedies Inc.
mlord@pobox.com

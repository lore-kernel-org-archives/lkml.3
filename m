Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751613AbaGFPOI (ORCPT <rfc822;w@1wt.eu>);
	Sun, 6 Jul 2014 11:14:08 -0400
Received: from blu004-omc1s9.hotmail.com ([65.55.116.20]:57643 "EHLO
	BLU004-OMC1S9.hotmail.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751515AbaGFPOG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 6 Jul 2014 11:14:06 -0400
X-Greylist: delayed 307 seconds by postgrey-1.27 at vger.kernel.org; Sun, 06 Jul 2014 11:14:06 EDT
X-TMN: [w4zxAIC/YikUdIUXguZYgQHS8r0GULkb]
X-Originating-Email: [dave.anglin@bell.net]
Message-ID: <BLU436-SMTP16549AF626A4BCCDD6D82097020@phx.gbl>
From: John David Anglin <dave.anglin@bell.net>
To: Heiko Carstens <heiko.carstens@de.ibm.com>
In-Reply-To: <20140706091530.GA3589@osiris>
Subject: Re: [PATCH] fix fanotify_mark() breakage on big endian 32bit kernel
References: <20140704151235.GA22454@ls3530.dhcp.wdf.sap.corp> <20140706091530.GA3589@osiris>
Content-Type: text/plain; charset="US-ASCII"; format=flowed; delsp=yes
Content-Transfer-Encoding: 7bit
MIME-Version: 1.0 (Apple Message framework v936)
Date: Sun, 6 Jul 2014 11:08:41 -0400
CC: Helge Deller <deller@gmx.de>, Eric Paris <eparis@redhat.com>,
        Linux Kernel <linux-kernel@vger.kernel.org>,
        Heinrich Schuchardt <xypron.glpk@gmx.de>, linux-parisc@vger.kernel.org,
        James Bottomley <James.Bottomley@HansenPartnership.com>
X-Mailer: Apple Mail (2.936)
X-OriginalArrivalTime: 06 Jul 2014 15:08:57.0149 (UTC) FILETIME=[3574C6D0:01CF992C]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 6-Jul-14, at 5:15 AM, Heiko Carstens wrote:

>> But for the CONFIG_COMPAT=n case (32bit kernel & userspace),
>> compat_fanotify_mark() isn't used and the fanotify_mark syscall  
>> implementation
>> is used directly. In that case the upper and lower 32 bits of the  
>> 64bit mask
>> parameter is still swapped on big endian machines and thus leads to
>> fanotify_mark failing with -EINVAL.
>
> Why do you think upper and lower 32 bits are swapped on big endian  
> machines?
> At least an s390 the C ABI defines that 64 bit values are split into  
> an
> even odd register pair, where the most significant bits are in the  
> even numbered
> register.


On hppa, there is no specific rule as to which registers are used to  
hold 64-bit integer values
on 32-bit machines except for the first two call arguments which are  
passed in registers.
For example, r25 and r26 contain the first argument and the most  
significant bits are in r25
and the least significant bits in r26..

In GCC, we typically have an odd even register pair to hold 64-bit  
values as register
r0 is not usable.

The rules are different for float values.

Dave
--
John David Anglin	dave.anglin@bell.net




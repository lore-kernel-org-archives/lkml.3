Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752024AbaL3ER2 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Dec 2014 23:17:28 -0500
Received: from mail-ob0-f173.google.com ([209.85.214.173]:41298 "EHLO
	mail-ob0-f173.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751532AbaL3ER0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Dec 2014 23:17:26 -0500
Message-ID: <54A2275C.3030908@landley.net>
Date: Mon, 29 Dec 2014 22:17:32 -0600
From: Rob Landley <rob@landley.net>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.2.0
MIME-Version: 1.0
To: Mimi Zohar <zohar@linux.vnet.ibm.com>
CC: Christophe Fillot <cf@utc.fr>, linux-ima-user@lists.sourceforge.net,
        linux-security-module <linux-security-module@vger.kernel.org>,
        linux-kernel <linux-kernel@vger.kernel.org>
Subject: Re: [Linux-ima-user] Initramfs and IMA Appraisal
References: <5463ABC8.10308@utc.fr>	 <1415827252.18773.33.camel@dhcp-9-2-203-236.watson.ibm.com>	 <547617AF.6000604@utc.fr>	 <1417039941.26016.46.camel@dhcp-9-2-203-236.watson.ibm.com>	 <5476EBAC.8090103@utc.fr>	 <1419860736.14143.13.camel@dhcp-9-2-203-236.watson.ibm.com>	 <54A1BAEE.6000101@landley.net>	 <1419889608.14143.40.camel@dhcp-9-2-203-236.watson.ibm.com>	 <54A2062C.2030909@landley.net> <1419909649.14143.86.camel@dhcp-9-2-203-236.watson.ibm.com>
In-Reply-To: <1419909649.14143.86.camel@dhcp-9-2-203-236.watson.ibm.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 12/29/2014 09:20 PM, Mimi Zohar wrote:
> On Mon, 2014-12-29 at 19:55 -0600, Rob Landley wrote: 
>>> Thanks Rob for the explanation.  The problem is that ramfs does not
>>> support extended attributes, while tmpfs does.
>>
>> If you're _using_ initramfs/initmpfs, there's no reason to specify a root=.
> 
> The menu entry looks like:
> linux   /vmlinuz-3.17.0+ root=UUID=94595ff7-0fd4-4ea3-99f2-f7ddf8fbc91f
> ro  ...
> initrd  /initramfs-3.17.0+.img
> 
> Because "root=" is specified, rootfs is not using tmpfs.

Yes. Pilot error.

If you want tmpfs to switch to UUID $THINGY you can do ROOT= and have it
use that. You're asking for something to be interpreted by the kernel
sometimes and passed on to userspace other times and have no side
effects even though it's interpeted by the kernel.

>>> The boot loader could
>>> "measure" (trusted boot) the initramfs, but as the initramfs is
>>> generated on the target system, the initramfs is not signed, preventing
>>> it from being appraised (secure Boot). To close the initramfs integrity
>>> appraisal gap requires verifying the individual initramfs file
>>> signatures, which are stored as extended attributes.
>>
>> Faced with the phrases "trusted boot" and "integrity appraisal", I plead
>> the third.
> 
> Fine.  Bottom line, rootfs needs to support extended attributes.

I added a patch to make it work as tmpfs a year ago. You now know what
trivial configuration mistake you make that's preventing it from
working. If you'd like me to submit a documentation update patch to make
it easier to avoid in future, I can do that.

>> (In the wake of the Snowden infodump,
> 
> All the more reason to allow only those files that are properly signed
> to be read/executed.

Using the infrastructure the NSA provided, which is intentionally so
complicated that "you are not expected to understand this".

Good luck with that.

> Mimi

Rob

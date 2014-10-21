Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932416AbaJUMLb (ORCPT <rfc822;w@1wt.eu>);
	Tue, 21 Oct 2014 08:11:31 -0400
Received: from mailapp01.imgtec.com ([195.59.15.196]:46801 "EHLO
	mailapp01.imgtec.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932273AbaJUML1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 21 Oct 2014 08:11:27 -0400
Message-ID: <54464D6A.5000501@imgtec.com>
Date: Tue, 21 Oct 2014 13:11:22 +0100
From: Markos Chandras <Markos.Chandras@imgtec.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Thunderbird/31.2.0
MIME-Version: 1.0
To: Richard Cochran <richardcochran@gmail.com>
CC: <linux-mips@linux-mips.org>, Jonathan Corbet <corbet@lwn.net>,
        <netdev@vger.kernel.org>, <linux-doc@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] Documentation: ptp: Fix build failure on MIPS cross builds
References: <1413794538-28465-1-git-send-email-markos.chandras@imgtec.com> <20141021110724.GA16479@netboy>
In-Reply-To: <20141021110724.GA16479@netboy>
Content-Type: text/plain; charset="windows-1252"
Content-Transfer-Encoding: 7bit
X-Originating-IP: [192.168.154.141]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 10/21/2014 12:07 PM, Richard Cochran wrote:
> On Mon, Oct 20, 2014 at 09:42:18AM +0100, Markos Chandras wrote:
>> diff --git a/Documentation/ptp/Makefile b/Documentation/ptp/Makefile
>> index 293d6c09a11f..397c1cd2eda7 100644
>> --- a/Documentation/ptp/Makefile
>> +++ b/Documentation/ptp/Makefile
>> @@ -1,5 +1,15 @@
>>  # List of programs to build
>> +ifndef CROSS_COMPILE
>>  hostprogs-y := testptp
>> +else
>> +# MIPS system calls are defined based on the -mabi that is passed
>> +# to the toolchain which may or may not be a valid option
>> +# for the host toolchain. So disable testptp if target architecture
>> +# is MIPS but the host isn't.
>> +ifndef CONFIG_MIPS
>> +hostprogs-y := testptp
>> +endif
>> +endif
> 
> It seems like a shame to simply give up and not compile this at all.
> Is there no way to correctly cross compile this for MIPS?
> 
> Thanks,
> Richard
> 

As far as I can see you don't cross-compile the file. You use the host
toolchain. There is no clean way to build it for host if you have your
kernel configured for MIPS. Perhaps maybe you could define
__MIPS_SIM_{ABI64, ABI32, NABI32} in the gcc command line (-D...) but
this is a bit ugly. Or maybe use the host headers instead of the ones in
the kernel source.

-- 
markos

Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752838AbaDXTfH (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Apr 2014 15:35:07 -0400
Received: from top.free-electrons.com ([176.31.233.9]:40596 "EHLO
	mail.free-electrons.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752758AbaDXTfB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Apr 2014 15:35:01 -0400
Message-ID: <53596762.5070806@free-electrons.com>
Date: Thu, 24 Apr 2014 21:34:58 +0200
From: Michael Opdenacker <michael.opdenacker@free-electrons.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.4.0
MIME-Version: 1.0
To: Josh Triplett <josh@joshtriplett.org>
CC: akpm@linux-foundation.org, paulmck@linux.vnet.ibm.com, fweisbec@gmail.com,
        eparis@redhat.com, paul.gortmaker@windriver.com, vapier@gentoo.org,
        kyungsik.lee@lge.com, jslaby@suse.cz, dwight.engen@oracle.com,
        pefoley2@pefoley.com, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 0/1] init/Kconfig: improve CC_OPTIMIZE_FOR_SIZE documentation
References: <1398341254-4626-1-git-send-email-michael.opdenacker@free-electrons.com> <20140424145535.GA2969@jtriplet-mobl1>
In-Reply-To: <20140424145535.GA2969@jtriplet-mobl1>
X-Enigmail-Version: 1.5.2
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Josh,

Thank you for your review!

On 04/24/2014 04:55 PM, Josh Triplett wrote:
> On Thu, Apr 24, 2014 at 02:07:33PM +0200, Michael Opdenacker wrote:
>> This patch proposes to warn users about the negative performance
>> impact of CC_OPTIMIZE_FOR_SIZE (compiling with -Os instead of -O2).
>> For the moment, we are just advising users not to select this option,
>> but extra details would be useful.
>>
>> I made some experiments with this option. All of them yielded
>> degraded overall boot time. The kernel is smaller and hence is copied
>> and started earlier, but the benefits are quickly offset by the
>> slower kernel code. Even the total boot time is usually worse
>> than with a regular kernel.
>>
>> Here are my latest results, on Atmel SAMA5D3 Xplained (ARM),
>> Linux 3.10, gzip compressed kernel:
>>
>> Timestamp		O2		Os		Diff
>> Starting kernel 	4.307 s 	5.593 s 	-94 ms
>> Starting init		4.213 s 	5.549 s 	-44 ms
>> Login prompt		21.085 s	22.900 s 	+1.815 s 
> Did you get the times in the upper two rows transposed row/column?  Based
> on the diffs, I'd guess 4.213s goes in Os "Starting kernel", and 5.593s
> goes in O2 "Starting init".
Oops, yes I did. I shouldn't have tried to copy from a PDF file I
produced ;)

Thanks!

Michael.

-- 
Michael Opdenacker, CEO, Free Electrons
Embedded Linux, Kernel and Android engineering
http://free-electrons.com


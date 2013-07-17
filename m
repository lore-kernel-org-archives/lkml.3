Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932757Ab3GQRKL (ORCPT <rfc822;w@1wt.eu>);
	Wed, 17 Jul 2013 13:10:11 -0400
Received: from mailout1.w2.samsung.com ([211.189.100.11]:49211 "EHLO
	usmailout1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755780Ab3GQRKJ convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Jul 2013 13:10:09 -0400
X-AuditID: cbfec37d-b7f036d000004805-96-51e6cfef1ebb
From: Shuah Khan <shuah.kh@samsung.com>
To: Joe Perches <joe@perches.com>, "rostedt@goodmis.org" <rostedt@goodmis.org>
Cc: "rjw@sisk.pl" <rjw@sisk.pl>, "len.brown@intel.com" <len.brown@intel.com>,
        "pavel@ucw.cz" <pavel@ucw.cz>,
        "gregkh@linuxfoundation.org" <gregkh@linuxfoundation.org>,
        "fweisbec@gmail.com" <fweisbec@gmail.com>,
        "mingo@redhat.com" <mingo@redhat.com>,
        "paul.gortmaker@windriver.com" <paul.gortmaker@windriver.com>,
        "linux-pm@vger.kernel.org" <linux-pm@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "shuahkhan@gmail.com" <shuahkhan@gmail.com>,
        Shuah Khan <shuah.kh@samsung.com>
Subject: Re: [PATCH v2] power: new trace event to print device suspend and
 resume time
Thread-topic: [PATCH v2] power: new trace event to print device suspend and
 resume time
Thread-index: AQHOgwZvoT2AOKySMUq4xkXZjyv7jA==
Date: Wed, 17 Jul 2013 17:10:06 +0000
Message-id: <B8EFE96D1287C24090BAD9D858E15E6173CBA5@sisaex02sj>
References: <1374076659-3444-1-git-send-email-shuah.kh@samsung.com>
 <1374077325.1949.94.camel@joe-AO722>
 <B8EFE96D1287C24090BAD9D858E15E6173CA8D@sisaex02sj>
 <1374079268.1949.102.camel@joe-AO722>
Accept-Language: en-US
Content-language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
X-Originating-IP: [105.144.21.63]
Content-type: text/plain; charset=us-ascii
Content-transfer-encoding: 8BIT
MIME-version: 1.0
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFjrKIsWRmVeSWpSXmKPExsVy+t9hX933558FGqz5Ym0x83U3k0Xz4vVs
	FrPvP2axmDVlL5PF5V1z2Cw+9x5htLh0YAGTxbW9x5kt7p46ymbRv7CXyWJfxwMmi68/HRx4
	PHbOusvu0bLvFrvH4j0vmTz2z13D7vFl1TVmj/f7rrJ5PFrcwuixYvV3do/Pm+Q81m/ZyhTA
	FcVlk5Kak1mWWqRvl8CVcf73DfaC7VwVi34aNDCu5+hi5OSQEDCReP5wAiuELSZx4d56ti5G
	Lg4hgWWMEnuW7maFcHqZJLqfvYbKzGeU+H3nGTNIC5uAusTn1zvYQWwRAT+JL8f+M4MUMQv0
	skhs/fqbESQhLBAh0XN6IRtEUaTE+aUXoGw9iSe3J4PtZhFQleh5tYUFxOYVsJc4vH4XM8S2
	E4wS/35tYgJJMAId+P3UGjCbWUBcorn1JgvE4QISS/acZ4awRSVePv4HNJQDyFaU2L7aCqJc
	S2L9zuNQrdoST95dYIXYJSjxY/I9lgmMYrOQTJ2FpGUWkpZZSFoWMLKsYhQrLU4uKE5KT60w
	0StOzC0uzUvXS87P3cQIifraHYz3v9ocYhTgYFTi4Z0Q9jRQiDWxrLgy9xCjBAezkgjvwSXP
	AoV4UxIrq1KL8uOLSnNSiw8xMnFwSjUwHg+3EHkfvaQ/ReV0RvycDA/xzU0KdhpHZXaEnCiS
	D0l+8pvPtSyvY9FCPibule0+WyeJ9l8/p+S9O685ZUH8jxkTOJuvzTx56f2Fh8/VDWa+W/Dq
	7VebXdWa2V+NtpvtX8ERsdnV52HEnrmnTsjP19ot49fyV6tzjUWaEq+A3sO7In55D1/JKLEU
	ZyQaajEXFScCAA1CAzvYAgAA
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 07/17/2013 10:41 AM, Joe Perches wrote:

> I think the easiest way to "fix" it is to change
> the TP_printk format to:
>
> 	TP_printk("%s %s parent=%s state=%s ops=%susecs=%lld err=%d",

I will just adjust for the space and add a comment.

>
>> Hence, I chose to leave the extra space in. I also
>> didn't want to propagate that assumption that there is an extra space
>> into this new tracepoint.
>
> It's a big deal, it just seemed untidy.
>
> There are a couple of places in drivers/base/power/main.c
> where info is set to NULL.  I didn't look hard to see if
> any of those are propagated through to this point, but
> there are uses of 'info ?: ""' for some of the logging
> messages.  That _might_ an issue.
>
> It looks like all the other logging message uses of info
> have "%s%s" so that proper word spacing is done when
> info is "" or NULL.
>

Yeah that would be bad. The safe thing might me to add a info null 
check. Working on v3 that includes Steve's review comment as well.

thanks,
-- Shuah

Shuah Khan, Linux Kernel Developer - Open Source Group Samsung Research 
America (Silicon Valley) shuah.kh@samsung.com | (970) 672-0658

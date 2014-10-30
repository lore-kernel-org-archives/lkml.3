Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1422763AbaJ3XYw (ORCPT <rfc822;w@1wt.eu>);
	Thu, 30 Oct 2014 19:24:52 -0400
Received: from roy.gaast.net ([80.101.33.21]:36558 "EHLO mail.gaast.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1161211AbaJ3XYv (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 30 Oct 2014 19:24:51 -0400
Message-ID: <5452C8BE.3060206@gaast.net>
Date: Thu, 30 Oct 2014 23:24:46 +0000
From: Wilmer van der Gaast <wilmer@gaast.net>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130112 Icedove/17.0.2
MIME-Version: 1.0
To: Yinghai Lu <yinghai@kernel.org>
CC: Bjorn Helgaas <bhelgaas@google.com>,
        "Rafael J. Wysocki" <rjw@rjwysocki.net>, Pavel Machek <pavel@ucw.cz>,
        Rafael Wysocki <rafael.j.wysocki@intel.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: Machine crashes right *after* ~successful resume
References: <543F049F.5090605@gaast.net> <CAE9FiQWugqXZdZDhDyKofKRXH6EgVq6DJ0JphM6DZSdS5nMhbw@mail.gmail.com> <5446D2D8.2090203@gaast.net> <CAE9FiQWjvZapL0u5QSwD3gYTXisKrCgRcUYWAcy8onUYbkLHTg@mail.gmail.com> <20141022125354.GA3832@gaast.net> <CAE9FiQXF-6b4+y-BJmv7ekrCrXKYyhvZDBqVbLeXSPJa0_cToA@mail.gmail.com> <544E235C.5010908@gaast.net> <CAE9FiQVMaGs=2OMbk6M7x=EhhfaVn5xT_70Sr+rU2Z1HEfjXbw@mail.gmail.com> <544EC59D.9080303@gaast.net> <CAE9FiQXC7YfzPp43EX5r4KNPhF4jua_Jg_JLBnSTffzAmRaY=g@mail.gmail.com> <544EDD40.1040107@gaast.net> <CAE9FiQWfV+h5YGxKEg7kSdhD7_OVoEqNyZZqYr=vpDwz1Lnb_g@mail.gmail.com> <545027F9.1040703@gaast.net> <CAE9FiQXM=uAWPD04o8ic2juEaWVQ=seq=+CBjnPnFdrueY-RjQ@mail.gmail.com> <5450B55E.6010103@gaast.net> <CAE9FiQUH_Ce4ejnn_GG=QnG=R3jt7jHzYScPy-hqPzBMbFU=EQ@mail.gmail.com> <545214C5.6070004@gaast.net> <CAE9FiQVZV8xk0haCPo=nikBCNQfawPiw20kdEUGfJ_NdtSi5JQ@mail.gmail.com> <5452B3A6.7060100@gaast.net> <CAE9FiQUGm-gvqpzPymxqa6vdfV7xhv8-fb433irZE1AT-eNg9A@mail.gmai
 l.com>
In-Reply-To: <CAE9FiQUGm-gvqpzPymxqa6vdfV7xhv8-fb433irZE1AT-eNg9A@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On 30-10-14 23:02, Yinghai Lu wrote:
>> http://gaast.net/~wilmer/.lkml/good3.17-patched-megadebug.txt
>
> no difference except on 00:1c.3
>
> --- before.txt    2014-10-30 15:20:35.782886485 -0700
> +++ after.txt    2014-10-30 15:21:37.034882515 -0700
> @@ -49,10 +49,10 @@
>   02f0: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
>   0300: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
>   0310: 00 00 00 00 1b 36 3a 74 00 00 14 14 31 17 42 00
> -0320: 5b 60 09 00 00 20 00 0a ec 19 b8 04 eb 09 b9 06
> +0320: 5b 60 09 00 00 20 00 0a 33 1a b8 04 32 0a 00 07
>   0330: 16 00 00 28 bc b5 bc 4a 00 00 00 00 74 4c 85 00
> -0340: 33 03 33 00 64 03 3f 00 30 00 0c 00 45 02 b9 00
> -0350: 4b 02 c1 00 01 00 08 00 00 00 00 00 00 00 00 00
> +0340: 33 03 33 00 64 03 3f 00 30 00 0c 00 46 02 00 00
> +0350: 4c 02 08 00 01 00 08 00 00 00 00 00 00 00 00 00
>   0360: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
>   0370: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
>   0380: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
>
Those diffs are in exactly the same offsets like the dumps I was diffing 
a few days ago it seems.

> Please try attached patch on top of 3.17 without other patches.
>
Same problem like this morning: Failure after the second resume already. :-(

> If it is working, please dump acpi tables include dsdt.
> need to check if there extra work in _PRT.
>
Original files and iasl interpretations in: 
http://gaast.net/~wilmer/.lkml/tables/


Thanks,

Wilmer v/d Gaast.

-- 
+-------- .''`.     - -- ---+  +        - -- --- ---- ----- ------+
| wilmer : :'  :  gaast.net |  | OSS Programmer   www.bitlbee.org |
| lintux `. `~'  debian.org |  | Full-time geek  wilmer.gaast.net |
+--- -- -  ` ---------------+  +------ ----- ---- --- -- -        +

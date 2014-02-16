Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753344AbaBPXaE (ORCPT <rfc822;w@1wt.eu>);
	Sun, 16 Feb 2014 18:30:04 -0500
Received: from prod-mail-xrelay06.akamai.com ([96.6.114.98]:45508 "EHLO
	prod-mail-xrelay06.akamai.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752363AbaBPXaC convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 16 Feb 2014 18:30:02 -0500
X-Greylist: delayed 376 seconds by postgrey-1.27 at vger.kernel.org; Sun, 16 Feb 2014 18:30:02 EST
From: "Banerjee, Debabrata" <dbanerje@akamai.com>
To: Linus Torvalds <torvalds@linux-foundation.org>,
        Kay Sievers <kay.sievers@vrfy.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
CC: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Jeff Mahoney <jeffm@suse.com>,
        "dbavatar@gmail.com" <dbavatar@gmail.com>,
        "Hunt, Joshua" <johunt@akamai.com>, stable <stable@vger.kernel.org>
Date: Sun, 16 Feb 2014 18:23:43 -0500
Subject: Re: [PATCH] printk: Fix discarding of records
Thread-Topic: [PATCH] printk: Fix discarding of records
Thread-Index: Ac8rbiKUlWevkHVVRPm9wEHCByk4jA==
Message-ID: <CF26B239.2E7B4%dbanerje@akamai.com>
References: <1392352954-29905-1-git-send-email-dbanerje@akamai.com>
 <CA+55aFy7yrNuJaFLcLh5-DVFTzuFYeZ_K9s6CNGtemQDCO90mQ@mail.gmail.com>
In-Reply-To: <CA+55aFy7yrNuJaFLcLh5-DVFTzuFYeZ_K9s6CNGtemQDCO90mQ@mail.gmail.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
user-agent: Microsoft-MacOutlook/14.3.9.131030
acceptlanguage: en-US
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 2/16/14, 2:28 PM, "Linus Torvalds" <torvalds@linux-foundation.org>
wrote:

>Why are *those* particular two "prev = msg->flags" incorrect, when
>every other case where we walk the messages they are required?
>
>The code/logic makes no sense. You remove the "prev = msg->flags" at
>line 1070, when the *identical* loop just above it has it. So now the
>two loops count the number of characters differently. That makes no
>sense.
>
>So I don't think this fixes the fundamental problem. I'm more inclined
>to believe that LOG_CONT is wrongly set somewhere, for example because
>a continuation wasn't actually originally printed due to coming from
>different users or something like that.
>
>Or at the very least I want a coherent explanation why one loop would
>do this and the other would not, and why counting up *different*
>numbers could possibly make sense.

The explanation is: the loops look identical but they are not. When a
record is printed first, its size can expand due to adding the prefix and
timestamp. The second loop is calculating len with the first line printed
possibly changing every iteration.


>
>Because as it is, there clearly is some problem, but the patch does
>not look sensible to me.

You are right, the patch is still flawed, sending V2.


-Debabrata


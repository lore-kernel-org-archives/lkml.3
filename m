Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1161321AbaJ3VzT (ORCPT <rfc822;w@1wt.eu>);
	Thu, 30 Oct 2014 17:55:19 -0400
Received: from roy.gaast.net ([80.101.33.21]:36099 "EHLO mail.gaast.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1161234AbaJ3VzP convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 30 Oct 2014 17:55:15 -0400
Message-ID: <5452B3A6.7060100@gaast.net>
Date: Thu, 30 Oct 2014 21:54:46 +0000
From: Wilmer van der Gaast <wilmer@gaast.net>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130112 Icedove/17.0.2
MIME-Version: 1.0
To: Yinghai Lu <yinghai@kernel.org>
CC: Bjorn Helgaas <bhelgaas@google.com>,
        "Rafael J. Wysocki" <rjw@rjwysocki.net>, Pavel Machek <pavel@ucw.cz>,
        Rafael Wysocki <rafael.j.wysocki@intel.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: Machine crashes right *after* ~successful resume
References: <543F049F.5090605@gaast.net> <CAE9FiQW0x5uy_osjvVDOOMDaz2=2KL+TusQ8QqcHL5dWTPrK2w@mail.gmail.com> <5442FE58.5020700@gaast.net> <CAE9FiQWugqXZdZDhDyKofKRXH6EgVq6DJ0JphM6DZSdS5nMhbw@mail.gmail.com> <5446D2D8.2090203@gaast.net> <CAE9FiQWjvZapL0u5QSwD3gYTXisKrCgRcUYWAcy8onUYbkLHTg@mail.gmail.com> <20141022125354.GA3832@gaast.net> <CAE9FiQXF-6b4+y-BJmv7ekrCrXKYyhvZDBqVbLeXSPJa0_cToA@mail.gmail.com> <544E235C.5010908@gaast.net> <CAE9FiQVMaGs=2OMbk6M7x=EhhfaVn5xT_70Sr+rU2Z1HEfjXbw@mail.gmail.com> <544EC59D.9080303@gaast.net> <CAE9FiQXC7YfzPp43EX5r4KNPhF4jua_Jg_JLBnSTffzAmRaY=g@mail.gmail.com> <544EDD40.1040107@gaast.net> <CAE9FiQWfV+h5YGxKEg7kSdhD7_OVoEqNyZZqYr=vpDwz1Lnb_g@mail.gmail.com> <545027F9.1040703@gaast.net> <CAE9FiQXM=uAWPD04o8ic2juEaWVQ=seq=+CBjnPnFdrueY-RjQ@mail.gmail.com> <5450B55E.6010103@gaast.net> <CAE9FiQUH_Ce4ejnn_GG=QnG=R3jt7jHzYScPy-hqPzBMbFU=EQ@mail.gmail.com> <545214C5.6070004@gaast.net> <CAE9FiQVZV8xk0haCPo=nikBCNQfawPiw20kdEUGfJ_NdtSi5JQ@mail.gmai
 l.com>
In-Reply-To: <CAE9FiQVZV8xk0haCPo=nikBCNQfawPiw20kdEUGfJ_NdtSi5JQ@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

On 30-10-14 16:57, Yinghai Lu wrote:
>> Sadly, with that patch (applied against a vanilla 3.17 tree like all the> others) the second resume fails already. :-(
>
> oh, no. Really want to know which bit causes the problem.
>
Good question. And I think you will find my new finding even more 
confusing: With your two patches from this e-mail, I could 
suspend+resume 3× with no problems.. With just your two debugging 
patches applied.

Lovely heisenbug here. I'll add that for every test so far I've removed 
the kernel source tree, re-untarred it and applied the patches from your 
e-mails on that, so the tests should be consistent. As is the bug 
normally, before we started testing patches the crashes were already 
always *very* reliably happening exactly after the third resume.

Just to be sure this morning was not a fluke, I've retested your patch 
from this morning, and still a crash on the second resume.

> Please check debug patch...that will print out pci conf space before
> ...and after...
>
http://gaast.net/~wilmer/.lkml/good3.17-patched-megadebug.txt


Wilmer v/d Gaast.

-- 
+-------- .''`.     - -- ---+  +        - -- --- ---- ----- ------+
| wilmer : :'  :  gaast.net |  | OSS Programmer   www.bitlbee.org |
| lintux `. `~'  debian.org |  | Full-time geek  wilmer.gaast.net |
+--- -- -  ` ---------------+  +------ ----- ---- --- -- -        +


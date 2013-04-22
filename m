Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753555Ab3DVAuj (ORCPT <rfc822;w@1wt.eu>);
	Sun, 21 Apr 2013 20:50:39 -0400
Received: from mga14.intel.com ([143.182.124.37]:31565 "EHLO mga14.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752573Ab3DVAui convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 21 Apr 2013 20:50:38 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.87,521,1363158000"; 
   d="scan'208";a="230068532"
From: "Pan, Zhenjie" <zhenjie.pan@intel.com>
To: Don Zickus <dzickus@redhat.com>, Stephane Eranian <eranian@google.com>
CC: Peter Zijlstra <a.p.zijlstra@chello.nl>,
        "paulus@samba.org" <paulus@samba.org>,
        "mingo@redhat.com" <mingo@redhat.com>,
        "acme@ghostprotocols.net" <acme@ghostprotocols.net>,
        "akpm@linux-foundation.org" <akpm@linux-foundation.org>,
        "tglx@linutronix.de" <tglx@linutronix.de>,
        "Liu, Chuansheng" <chuansheng.liu@intel.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: RE: [PATCH v2] NMI: fix NMI period is not correct when cpu
 frequency changes issue.
Thread-Topic: [PATCH v2] NMI: fix NMI period is not correct when cpu
 frequency changes issue.
Thread-Index: Ac46b5lX48efHbUtRT2d/NJzqZ6DWQBdzKSAAAC9ZQAAA1VkgAC+rv5A
Date: Mon, 22 Apr 2013 00:50:34 +0000
Message-ID: <F98D4B5C3D86834DB612ABF854C98B7FB5FACF@SHSMSX101.ccr.corp.intel.com>
References: <F98D4B5C3D86834DB612ABF854C98B7FB5D7FE@SHSMSX101.ccr.corp.intel.com>
 <1366285369.19383.19.camel@laptop>
 <CABPqkBTpzSBEezx4ScwYYX6L8ir4GLBG9MMYJuAb6YA0QbiurQ@mail.gmail.com>
 <20130418133927.GJ79013@redhat.com>
In-Reply-To: <20130418133927.GJ79013@redhat.com>
Accept-Language: zh-CN, en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [10.239.127.40]
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> I believe it mattered to the Chrome folks. They want the watchdog to be as
> tight as possible so the user experience isn't a hang but a quick reboot
> instead.  They like setting the watchdog to something like 2 seconds.
> 
> There was a patch a few months ago that tried to hack around this issue and I
> suggested this approach as a better solution.  I forgot what the original
> problem was.  Perhaps someone can jump in and explain the problem being
> solved (other than the watchdog isn't always 10 seconds)?
> 
> Cheers,
> Don

Yes, I also think the period is important sometimes.
As I mentioned before, the case I meet is:
When the system hang with interrupt disabled, we use NMI to detect.
Then it will find hard lockup and cause a panic.
Panic is very important for debug these kind of issues.

But if cpu frequency change, the period will be 2 times, 3 times even more.(if cpu can down from 2.0GHz to 200MHz, will be 10 times, it's a very big deviation)
This make watchdog reset happen before hard lockup detect.

Thanks
Pan Zhenjie

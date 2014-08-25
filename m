Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753962AbaHYC5J (ORCPT <rfc822;w@1wt.eu>);
	Sun, 24 Aug 2014 22:57:09 -0400
Received: from mga02.intel.com ([134.134.136.20]:10300 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753826AbaHYC5H (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 24 Aug 2014 22:57:07 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.04,394,1406617200"; 
   d="scan'208";a="592719541"
Message-ID: <53FAA544.4030401@intel.com>
Date: Mon, 25 Aug 2014 10:53:56 +0800
From: Lan Tianyu <tianyu.lan@intel.com>
User-Agent: Mozilla/5.0 (X11; Linux i686 on x86_64; rv:31.0) Gecko/20100101 Thunderbird/31.0
MIME-Version: 1.0
To: Linus Torvalds <torvalds@linux-foundation.org>,
        Knut Petersen <Knut_Petersen@t-online.de>,
        "Rafael J. Wysocki" <rafael.j.wysocki@intel.com>,
        Thomas Renninger <trenn@suse.de>
CC: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: [Bug 3.14.17] inconsistent lock state
References: <53F9CC77.70009@t-online.de> <CA+55aFwZP1gyf=mvTrKjWwj6YE6=5y1+aZdmsNMHUp6d3dckXw@mail.gmail.com>
In-Reply-To: <CA+55aFwZP1gyf=mvTrKjWwj6YE6=5y1+aZdmsNMHUp6d3dckXw@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 2014年08月25日 01:50, Linus Torvalds wrote:
> Rafael? Lan Tianyu? This is not some minor locking bug. This is a
> *major* mistake unless I misread something.
> 

Hi Linus:

Sorry about this. We are resolving the issue in the other bug
report(https://lkml.org/lkml/2014/8/21/606) and I have proposed a fix
patch(http://marc.info/?l=linux-acpi&m=140869309231199&w=2).

It's my fault. ACPI button notify callback will be called in the
interrupt context when the button device is enumerated from ACPI FADT
table(So called fixed button device). The ACPI button device also can be
enumerated from ACPI namespace and its callback will be run in the
process context just like other ACPI devices' notify callbacks. These
two kind of butt devices uses the same callback. Originally, I assumed
all ACPI notify callbacks were run in the process context and didn't
check whether netlink routine can use in the interrupt context or not.
Sorry again.

>                 Linus
> 


-- 
Best regards
Tianyu Lan

Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757138Ab3BAQnM (ORCPT <rfc822;w@1wt.eu>);
	Fri, 1 Feb 2013 11:43:12 -0500
Received: from forward3.mail.yandex.net ([77.88.46.8]:45264 "EHLO
	forward3.mail.yandex.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756891Ab3BAQnJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 1 Feb 2013 11:43:09 -0500
Message-ID: <510BF096.7060705@yandex.ru>
Date: Fri, 01 Feb 2013 20:43:02 +0400
From: Mike Lykov <combr@yandex.ru>
User-Agent: Mozilla/5.0 (Windows NT 6.1; WOW64; rv:17.0) Gecko/20130107 Thunderbird/17.0.2
MIME-Version: 1.0
To: Don Zickus <dzickus@redhat.com>
CC: Andrew Morton <akpm@linux-foundation.org>, Ingo Molnar <mingo@kernel.org>,
        Thomas Gleixner <tglx@linutronix.de>, linux-kernel@vger.kernel.org,
        linux-watchdog@vger.kernel.org, kirill@shutemov.name
Subject: Re: [BUG?] false positive in soft lockup detector while unlzma initramfs
 on slow cpu
References: <5107D1D3.6040105@yandex.ru> <20130129153348.GR98867@redhat.com> <5108EA4B.7030003@yandex.ru> <20130130154033.GE98867@redhat.com> <510A539E.7020105@yandex.ru> <20130131144627.GL98867@redhat.com> <510B9C9B.6090605@yandex.ru> <20130201155908.GR98867@redhat.com>
In-Reply-To: <20130201155908.GR98867@redhat.com>
Content-Type: text/plain; charset=KOI8-R; format=flowed
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

01.02.2013 19:59, Don Zickus пишет:
 > Hmm, that seems to make sense.  I was expecting that problem to pop up on
 > my end but didn't see.  I just asusmed the boot code didn't use that
 > decompressor.

Can you accumulate all our discussion and create one right-coded, 
kernelcode-styled patch?

 > Though I am not sure why that is leading to your other PATA problems
 > below.  Did you have similar problems when you used other decompression
 > levels?

In past - no. But I not test this last  kernel variant with other level.

 > I am not sure how to explain the differences.

I think this is similar as decompress:
Kernel stop and wait next try in "default_idle()" for 20-30 sec, and in 
this moment softlockup detector panics ;)

But without patch for touch_softlockup_watchdog in 
decompress_unlzma+misc.c it works (try, fail, pause, try, fail, go on).

-- 
Mike
Sapienti sat.

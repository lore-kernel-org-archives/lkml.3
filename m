Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754804AbaJ1UfU (ORCPT <rfc822;w@1wt.eu>);
	Tue, 28 Oct 2014 16:35:20 -0400
Received: from mout.kundenserver.de ([212.227.17.10]:55420 "EHLO
	mout.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754599AbaJ1UfS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 28 Oct 2014 16:35:18 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: Thomas Gleixner <tglx@linutronix.de>
Cc: Heena Sirwani <heenasirwani@gmail.com>, linux-kernel@vger.kernel.org,
        john.stultz@linaro.org
Subject: Re: [PATCH v2] timekeeping: Added a function to return tv_sec portion of ktime_get_real_ts64()
Date: Tue, 28 Oct 2014 21:35:08 +0100
Message-ID: <1825407.TtFpTslzjC@wuerfel>
User-Agent: KMail/4.11.5 (Linux/3.16.0-10-generic; KDE/4.11.5; x86_64; ; )
In-Reply-To: <alpine.DEB.2.11.1410282123450.5308@nanos>
References: <20141027050804.GA8550@heena-HP-Compaq-8200-Elite-MT-PC> <9160485.26T1OFaUNG@wuerfel> <alpine.DEB.2.11.1410282123450.5308@nanos>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
X-Provags-ID: V02:K0:plMnAnu7P1uR3hm/WVWG5XfUtL+eXvbJJAagoYZghjS
 eIm1NyargZ1ytuA6x396tqG8MQ7MNYQNH8nQbE8kJb9nQBIAE+
 Ida5lv/WMnEYSfAefyS4xvRsmWRz/jfAMOzkoYk+/ae9aFKYx6
 /aLGB72ImuOSLZz10rvqcekL82HseTVUU52YyXlyI7ax67g5W/
 IAGRkfzm2EvqQ20HYsBJA1lOm60TUHKiqU3bV+BcSKj1n40V2N
 3tAQQebjHd9xuWLxbxVYSsHdqUUopAsx68W9H2rDQKGeDJhrZp
 UoeoeS8cFlf+1OHt1gB33KTERTNRRfUszxoVE3vdlj9pPF1GWv
 hBbYIqQC+MCcMF++LSDA=
X-UI-Out-Filterresults: notjunk:1;
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday 28 October 2014 21:31:32 Thomas Gleixner wrote:
> On Tue, 28 Oct 2014, Arnd Bergmann wrote:
> > On Tuesday 28 October 2014 18:13:09 Thomas Gleixner wrote:
> > I'd like to apply this patch to my y2038 branch and apply the
> > other patches that need it on top, unless you want to still submit
> > it for 3.18.
> 
> I think I should take these patches for 3.18. We do not create users
> yet, but it makes it easier for submaintaners to apply stuff which you
> convert. And it lets me have the whole core lot together with other
> changes in that area. I create a seperate branch which you can pull
> from.

Ok, sounds good.

> > Regarding the names, should we then have
> > 
> > time64_t ktime_get_real_seconds(void);
> > time64_t ktime_get_seconds(void);
> 
> I like that one. Moving all the time interfaces to a ktime_ prefix and
> let the default implementation as CLOCK_MONOTONIC and the others with
> the added '_real', '_boot' ... describe their CLOCK_WHATEVER property
> makes it pretty clear.

Good. So you can apply this patch as-is and Heena will get you the
other one.

Thanks!

	Arnd

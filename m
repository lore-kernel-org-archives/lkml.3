Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932382Ab3APASU (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Jan 2013 19:18:20 -0500
Received: from mout.web.de ([212.227.17.11]:58574 "EHLO mout.web.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758355Ab3APASS (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Jan 2013 19:18:18 -0500
Message-ID: <50F5F1B7.3040201@web.de>
Date: Wed, 16 Jan 2013 01:17:59 +0100
From: Soeren Moch <smoch@web.de>
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:17.0) Gecko/20130106 Thunderbird/17.0.2
MIME-Version: 1.0
To: Jason Cooper <jason@lakedaemon.net>
CC: Greg KH <gregkh@linuxfoundation.org>,
        Thomas Petazzoni <thomas.petazzoni@free-electrons.com>,
        Andrew Lunn <andrew@lunn.ch>, Arnd Bergmann <arnd@arndb.de>,
        KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
        linux-kernel@vger.kernel.org, Michal Hocko <mhocko@suse.cz>,
        linux-mm@kvack.org, Kyungmin Park <kyungmin.park@samsung.com>,
        Mel Gorman <mgorman@suse.de>,
        Andrew Morton <akpm@linux-foundation.org>,
        Marek Szyprowski <m.szyprowski@samsung.com>,
        linaro-mm-sig@lists.linaro.org, linux-arm-kernel@lists.infradead.org,
        Sebastian Hesselbarth <sebastian.hesselbarth@gmail.com>
Subject: Re: [PATCH v2] mm: dmapool: use provided gfp flags for all dma_alloc_coherent()
 calls
References: <20121119144826.f59667b2.akpm@linux-foundation.org> <1353421905-3112-1-git-send-email-m.szyprowski@samsung.com> <50F3F289.3090402@web.de> <20130115165642.GA25500@titan.lakedaemon.net> <20130115175020.GA3764@kroah.com> <20130115201617.GC25500@titan.lakedaemon.net> <20130115215602.GF25500@titan.lakedaemon.net>
In-Reply-To: <20130115215602.GF25500@titan.lakedaemon.net>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-Provags-ID: V02:K0:eCxafcB4zhTtfVr/QLqJlb0cA1mIUMKTQcS/8ykDHit
 l+uOkFyHA1atwegp3R5bmxmwYH3Uu6EMCIDGm+Q/FEjw+bfgEm
 e541M8h6RGEK6vjmSD1/xV6Iwv1u4D/9PnmGBHB/K44evzXXkS
 wFEuCLhIm3xuJ56QnFffO3O/R/04chTJT4KGa9zy3FYgd3KZrC
 VCRrVfKc/J4enqjAq2J6g==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 15.01.2013 22:56, Jason Cooper wrote:
> Soeren,
>
> On Tue, Jan 15, 2013 at 03:16:17PM -0500, Jason Cooper wrote:
>> If my understanding is correct, one of the drivers (most likely one)
>> either asks for too small of a dma buffer, or is not properly
>> deallocating blocks from the per-device pool.  Either case leads to
>> exhaustion, and falling back to the atomic pool.  Which subsequently
>> gets wiped out as well.
>
> If my hunch is right, could you please try each of the three dvb drivers
> in turn and see which one (or more than one) causes the error?
>

In fact I use only 2 types of DVB sticks: em28xx usb bridge plus drxk
demodulator, and dib0700 usb bridge plus dib7000p demod.

I would bet for em28xx causing the error, but this is not thoroughly
tested. Unfortunately testing with removed sticks is not easy, because
this is a production system and disabling some services for the long
time we need to trigger this error will certainly result in unhappy
users.

I will see what I can do here. Is there an easy way to track the buffer
usage without having to wait for complete exhaustion?

In linux-3.5.x there is no such problem. Can we use all available memory
for dma buffers here on armv5 architectures, in contrast to newer
kernels?

Regards,
Soeren


Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754464Ab3IZVm4 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Sep 2013 17:42:56 -0400
Received: from mailout32.mail01.mtsvc.net ([216.70.64.70]:59676 "EHLO
	n23.mail01.mtsvc.net" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1753875Ab3IZVmz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Sep 2013 17:42:55 -0400
Message-ID: <5244AA5C.8060100@hurleysoftware.com>
Date: Thu, 26 Sep 2013 17:42:52 -0400
From: Peter Hurley <peter@hurleysoftware.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.0
MIME-Version: 1.0
To: Andrew Morton <akpm@linux-foundation.org>
CC: Greg KH <gregkh@linuxfoundation.org>,
        Fengguang Wu <fengguang.wu@intel.com>,
        LKML <linux-kernel@vger.kernel.org>, lkp@01.org,
        Tejun Heo <tj@kernel.org>
Subject: Re: increased vmap_area_lock contentions on "n_tty: Move buffers
 into n_tty_data"
References: <20130913005133.GA32479@localhost>	<20130913010936.GA1291@localhost>	<5238767D.1080606@hurleysoftware.com>	<20130917232214.GA11390@localhost>	<5238F252.5070905@hurleysoftware.com>	<20130926003315.2e81bc84.akpm@linux-foundation.org>	<52441B23.7050704@hurleysoftware.com>	<20130926150421.GA25545@kroah.com>	<52447064.5030902@hurleysoftware.com> <20130926110551.52ad8156.akpm@linux-foundation.org>
In-Reply-To: <20130926110551.52ad8156.akpm@linux-foundation.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Authenticated-User: 990527 peter@hurleysoftware.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 09/26/2013 02:05 PM, Andrew Morton wrote:
> On Thu, 26 Sep 2013 13:35:32 -0400 Peter Hurley <peter@hurleysoftware.com> wrote:
>
>> The issue with a single large kmalloc is that it may fail where
>> 3 separate, page-or-less kmallocs would not have.
>
> Or vmalloc fails first, because of internal fragmentation of the vmap
> arena.  This problem plus vmalloc's slowness are the reasons why
> vmalloc should be avoided.

Ok, no vmalloc.

> A tremendous number of places in the kernel perform higher-order
> allocations nowadays.  The page allocator works damn hard to service
> them and I expect that switching to kmalloc here will be OK.

I've had order-4 allocation failures before on 10Gb. In fact, the
nouveau driver switched to vmalloc for that very reason (commit
d005f51eb93d71cd40ebd11dd377453fa8c8a42a, drm/nouveau: use vmalloc
for pgt allocation).

Regards,
Peter Hurley

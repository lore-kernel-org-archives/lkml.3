Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755419Ab3BEN51 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Feb 2013 08:57:27 -0500
Received: from mail-la0-f50.google.com ([209.85.215.50]:49679 "EHLO
	mail-la0-f50.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754018Ab3BEN5Y (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Feb 2013 08:57:24 -0500
MIME-Version: 1.0
In-Reply-To: <20130205133104.GC2532@8bytes.org>
References: <1359657210.6061.3.camel@lorien2>
	<20130201130035.GE25591@8bytes.org>
	<1359743519.2759.38.camel@lorien2>
	<20130205133104.GC2532@8bytes.org>
Date: Tue, 5 Feb 2013 06:57:21 -0700
Message-ID: <CAKocOOO6Z2LyLYiuQMWf4iv4PAP8h5jbNWxRcSXKgXD1es6GYg@mail.gmail.com>
Subject: Re: IO_PAGE_FAULTs on unity mapped regions during amd_iommu_init() in
 Linux 3.4
From: Shuah Khan <shuahkhan@gmail.com>
To: Joerg Roedel <joro@8bytes.org>
Cc: Shuah Khan <shuah.khan@hp.com>, LKML <linux-kernel@vger.kernel.org>,
        stable <stable@vger.kernel.org>, iommu@lists.linux-foundation.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Feb 5, 2013 at 6:31 AM, Joerg Roedel <joro@8bytes.org> wrote:
> Hi Shuah,
>
> On Fri, Feb 01, 2013 at 11:31:59AM -0700, Shuah Khan wrote:
>> Yes, 3.7 has the same window of opportunity for this race condition,
>> however I couldn't figure out why it doesn't happen on 3.7. On 3.7 the
>> window between amd_iommu_init_hardware() and amd_iommu_init_dma_ops()
>> might actually be wider than the window in 3.4.
>
> I think this is highly timing related. IOMMU initialization may have
> been moved by a few milliseconds between the kernel versions which might
> cause the warnings to appear or disappear. I don't think it has much
> value to dive deeper into the differences between the initialization
> sequences.
>
> As somethimes with such issues there is a simple and a more complex fix
> for that. I'll try to come up with a simple fix for the next merge
> window and implement the clean and more complex one for the next one.
>

Hi Joerg,

Thanks much. I will hang on to this test system for testing your fix.

-- Shuah

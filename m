Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753733AbaFHRxV (ORCPT <rfc822;w@1wt.eu>);
	Sun, 8 Jun 2014 13:53:21 -0400
Received: from terminus.zytor.com ([198.137.202.10]:55447 "EHLO mail.zytor.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753638AbaFHRxU (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 8 Jun 2014 13:53:20 -0400
Message-ID: <5394A309.7030705@zytor.com>
Date: Sun, 08 Jun 2014 10:53:13 -0700
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.5.0
MIME-Version: 1.0
To: Nikolay Amiantov <nikoamia@gmail.com>, linux-kernel@vger.kernel.org
Subject: Re: What can change in ways Linux handles memory when all memory
 >4G is disabled? (x86)
References: <CA+waHKUfu0Mxy_J9qWwayxZVDBA_RDYrpsL100Mr1sUBQRchVw@mail.gmail.com>
In-Reply-To: <CA+waHKUfu0Mxy_J9qWwayxZVDBA_RDYrpsL100Mr1sUBQRchVw@mail.gmail.com>
X-Enigmail-Version: 1.6
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 06/06/2014 05:06 PM, Nikolay Amiantov wrote:
> 
> I've played a bit with this theory in mind and found a very
> interesting thing -- when I reserve all memory upper than 4G with
> "memmap" kernel option ("memmap=99G$0x100000000"), everything works!
> Also, I've written a small utility that fills memory with zeros using
> /dev/mem and then checks it. I've checked reserved memory with it, and
> it appears that no memory in that region is corrupted at all, which is
> even more strange. I suspect that somehow when nvidia is enabled
> I/O-mapped memory regions are corrupted, and only when upper memory is
> not enabled. Also, memory map does not differ apart from missing last
> big chunk of memory with and without "memmap", and with Windows, too.
> If I enable even small chunk of "upper" memory (e.g.,
> 0x270000000-0x280000000), there are usual crashes.
> 
> Long story short: I'm interested how memory management can differ when
> this "upper" memory regions are enabled?
> 

This would point either to an iommu problem, or a problem in the driver
where addresses somehow get truncated to 32 bits.  Since this is a
graphics driver it is extremely complex, and subtle problems could be
buried somewhere inside it.  The fact that you can trigger it without a
driver would point to that kind of problem inside the firmware.

	-hpa



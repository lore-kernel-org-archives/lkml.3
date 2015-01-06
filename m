Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754175AbbAFHxm (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Jan 2015 02:53:42 -0500
Received: from mail-lb0-f181.google.com ([209.85.217.181]:62748 "EHLO
	mail-lb0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751414AbbAFHxl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Jan 2015 02:53:41 -0500
MIME-Version: 1.0
In-Reply-To: <20150106020445.GB23775@node.dhcp.inet.fi>
References: <CAM===sRw3xsabexzmecOyr=UNEkpJA059yB7TYfd-6LqBLgiGA@mail.gmail.com>
	<20150105155210.4ac86388@lxorguk.ukuu.org.uk>
	<20150106020445.GB23775@node.dhcp.inet.fi>
Date: Tue, 6 Jan 2015 09:53:40 +0200
Message-ID: <CAM===sTd4W2FLfVjqTfODqdCUiR_aKoDx0oRpjsy0JLOSfFSkA@mail.gmail.com>
Subject: Re: Old O_DIRECT story
From: Leon Pollak <leon.pollak@gmail.com>
To: "Kirill A. Shutemov" <kirill@shutemov.name>
Cc: One Thousand Gnomes <gnomes@lxorguk.ukuu.org.uk>,
        linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

IMHO(!):
1. It will be slower, as pre-fill takes its significant time.
2. DMA-Kernel competition makes this method unusable.

On 6 January 2015 at 04:04, Kirill A. Shutemov <kirill@shutemov.name> wrote:
> On Mon, Jan 05, 2015 at 03:52:10PM +0000, One Thousand Gnomes wrote:
>> > I tried in all ways to implement this with mmap(), but it does not success,
>> > because I did not find a way to mmap() file as O_WRONLY. Mapping as O_RDWR
>> > makes kernel to pre-fill mapped memory with partition data. So, kernel and
>> > DMA actually compete on the RAM area to fill it - one with garbage, one
>> > with actual data. Kernel wins.
>> >
>> > So, how to implement Linus's advice?
>>
>> Use O_DIRECT. There are lots of problems with the mmap() model, in
>> particular with how mmu table changes scale to large numbers of CPU
>> threads (ie they don't).
>
> They do. Kinda. See split page table lock.
> But, yeah, mmap() approach should not be faster anyway.
>
> --
>  Kirill A. Shutemov

Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754766AbbAFCE5 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Jan 2015 21:04:57 -0500
Received: from mta-out1.inet.fi ([62.71.2.203]:36570 "EHLO jenni2.inet.fi"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753889AbbAFCEz (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Jan 2015 21:04:55 -0500
Date: Tue, 6 Jan 2015 04:04:45 +0200
From: "Kirill A. Shutemov" <kirill@shutemov.name>
To: One Thousand Gnomes <gnomes@lxorguk.ukuu.org.uk>
Cc: Leon Pollak <leon.pollak@gmail.com>, linux-kernel@vger.kernel.org
Subject: Re: Old O_DIRECT story
Message-ID: <20150106020445.GB23775@node.dhcp.inet.fi>
References: <CAM===sRw3xsabexzmecOyr=UNEkpJA059yB7TYfd-6LqBLgiGA@mail.gmail.com>
 <20150105155210.4ac86388@lxorguk.ukuu.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20150105155210.4ac86388@lxorguk.ukuu.org.uk>
User-Agent: Mutt/1.5.23.1 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jan 05, 2015 at 03:52:10PM +0000, One Thousand Gnomes wrote:
> > I tried in all ways to implement this with mmap(), but it does not success,
> > because I did not find a way to mmap() file as O_WRONLY. Mapping as O_RDWR
> > makes kernel to pre-fill mapped memory with partition data. So, kernel and
> > DMA actually compete on the RAM area to fill it - one with garbage, one
> > with actual data. Kernel wins.
> > 
> > So, how to implement Linus's advice?
> 
> Use O_DIRECT. There are lots of problems with the mmap() model, in
> particular with how mmu table changes scale to large numbers of CPU
> threads (ie they don't).

They do. Kinda. See split page table lock.
But, yeah, mmap() approach should not be faster anyway.

-- 
 Kirill A. Shutemov

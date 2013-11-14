Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753907Ab3KNXi4 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 Nov 2013 18:38:56 -0500
Received: from c60.cesmail.net ([216.154.195.49]:29688 "EHLO c60.cesmail.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752624Ab3KNXit (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 Nov 2013 18:38:49 -0500
Date: Thu, 14 Nov 2013 18:38:42 -0500
From: Pavel Roskin <proski@gnu.org>
To: Austin S Hemmelgarn <ahferroin7@gmail.com>
Cc: Christian Ruppert <christian.ruppert@abilis.com>,
        linux-kernel@vger.kernel.org,
        Andrew Morton <akpm@linux-foundation.org>,
        "H. Peter Anvin" <hpa@zytor.com>,
        Vineet Gupta <Vineet.Gupta1@synopsys.com>,
        Noam Camus <noamc@ezchip.com>
Subject: Re: Uncompressed kernel doesn't build on x86_64
Message-ID: <20131114183842.2c4b10aa@IRBT4585>
In-Reply-To: <5284DA98.1060402@gmail.com>
References: <20131113113418.167b8ffd@IRBT4585>
	<20131114083247.GB9687@ab42.lan>
	<5284DA98.1060402@gmail.com>
X-Mailer: Claws Mail 3.8.0 (GTK+ 2.24.10; i686-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 14 Nov 2013 09:13:44 -0500
Austin S Hemmelgarn <ahferroin7@gmail.com> wrote:

> On 2013-11-14 03:32, Christian Ruppert wrote:
> > 2. A patch to enable uncompressed x86 kernels. As stated above, I
> > don't think this makes a lot of sense in itself but it might serve
> > as an example for people working on other platforms with
> > self-extracting kernels and the nozip not-decompression algorithm
> > might be useful on those platforms as well. I only had a single
> > x86-64 machine available to test this, however, so some more
> > testing might be required.
> 
> I disagree with the argument that an uncompressed x86 kernel doesn't
> make sense, If you have a very fast boot device, then it is fully
> conceivable that an uncompressed kernel could boot faster than a
> compressed one.  I have seen a very large number of systems where the
> LZO compression boots at least twice as fast as gzip or bz2 (because
> the disks are fast enough that a few megabytes of size difference
> make much less of an impact than a slow decompressor).

I concur, the uncompressed kernel certainly makes sense in some cases.

If the kernel runs in an emulator, decompression could be slow.

If the kernel runs in a virtual machine, the kernel would need to be
decompressed separately for every virtual machine.  Reading from the
disk would be done only once if several virtual machines are started in
a short period of time.

-- 
Regards,
Pavel Roskin

Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752298Ab3EYHFi (ORCPT <rfc822;w@1wt.eu>);
	Sat, 25 May 2013 03:05:38 -0400
Received: from mail-ea0-f181.google.com ([209.85.215.181]:49856 "EHLO
	mail-ea0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750954Ab3EYHFh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 25 May 2013 03:05:37 -0400
Message-ID: <51A062B5.8040601@redhat.com>
Date: Sat, 25 May 2013 09:05:25 +0200
From: Paolo Bonzini <pbonzini@redhat.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130514 Thunderbird/17.0.6
MIME-Version: 1.0
To: Christoph Hellwig <hch@infradead.org>
CC: James Bottomley <James.Bottomley@HansenPartnership.com>,
        Tejun Heo <tj@kernel.org>, Jens Axboe <axboe@kernel.dk>,
        lkml <linux-kernel@vger.kernel.org>,
        "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>
Subject: Re: PING^7 (was Re: [PATCH v2 00/14] Corrections and customization
 of the SG_IO command whitelist (CVE-2012-4542))
References: <20130522193009.GA23845@mtj.dyndns.org> <519D360D.4050309@redhat.com> <20130522221737.GA12339@mtj.dyndns.org> <519DC926.4000106@redhat.com> <20130523090222.GA26592@mtj.dyndns.org> <519DE5AD.7080303@redhat.com> <20130524014405.GB16882@mtj.dyndns.org> <519F12FF.6090809@redhat.com> <CAOS58YODjkSF=V7wADqbn_z8c6bmj=r03hWxEs5B1O+1cd0n6g@mail.gmail.com> <1369456502.5008.5.camel@dabdike> <20130525052744.GA25186@infradead.org>
In-Reply-To: <20130525052744.GA25186@infradead.org>
X-Enigmail-Version: 1.5.1
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Il 25/05/2013 07:27, Christoph Hellwig ha scritto:
> On Fri, May 24, 2013 at 09:35:02PM -0700, James Bottomley wrote:
>> I'll go along with this.  I'm also wondering what the problem would be
>> if we just allowed all commands on either CAP_SYS_RAWIO or opening the
>> device for write, so we just defer to the filesystem permissions and
>> restricted read only opens to the basic all device opcodes.
> 
> I've been out of this area for a bit, but the problem used to be that
> you could send destructive commands to a partition.  The right fix
> for that would be to not allow SG_IO on partitions at all, just
> wondering if anything would be broken by this.

Linus wanted to keep that for CAP_SYS_RAWIO.  We found two uses of SG_IO
on partitions: zfs-fuse used SYNCHRONIZE CACHE; some proprietary driver
used TEST UNIT READY.

Really, the solution is to make the bitmaps configurable in userspace.
It is no less secure than unpriv_sgio.  Then the kernel can be
configured at build-time to have either an MMC bitmap and a basic
whitelist of a dozen commands.  We can even avoid working around those
few conflicting opcodes; if you're paranoid you can just configure your
kernel right.

Paolo

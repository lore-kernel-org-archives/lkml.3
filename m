Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933783AbaKMPOk (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Nov 2014 10:14:40 -0500
Received: from mx1.redhat.com ([209.132.183.28]:51067 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933457AbaKMPOi convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Nov 2014 10:14:38 -0500
Date: Thu, 13 Nov 2014 10:14:08 -0500
From: Kyle McMartin <kmcmarti@redhat.com>
To: Catalin Marinas <catalin.marinas@arm.com>
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "pmatouse@redhat.com" <pmatouse@redhat.com>,
        Will Deacon <Will.Deacon@arm.com>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>
Subject: Re: [PATCH] arm64: __clear_user: handle exceptions on strb
Message-ID: <20141113151407.GG6869@redacted.bos.redhat.com>
References: <20141112210744.GC6869@redacted.bos.redhat.com>
 <20141113150624.GB18494@e104818-lin.cambridge.arm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8BIT
In-Reply-To: <20141113150624.GB18494@e104818-lin.cambridge.arm.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Nov 13, 2014 at 03:06:25PM +0000, Catalin Marinas wrote:
> On Wed, Nov 12, 2014 at 09:07:44PM +0000, Kyle McMartin wrote:
> > ARM64 currently doesn't fix up faults on the single-byte (strb) case of
> > __clear_user... which means that we can cause a nasty kernel panic as an
> > ordinary user with any multiple PAGE_SIZE+1 read from /dev/zero.
> > i.e.: dd if=/dev/zero of=foo ibs=1 count=1 (or ibs=65537, etc.)
> 
> Thanks for this, it's been like this for a while. Applied.
> 

Thanks Catalin, if it's not too late, I forgot to add a
Reported-by: Miloš Prchlík <mprchlik@redhat.com>
for the initial report of the panic.

regards, Kyle

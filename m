Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751562AbaLEMbc (ORCPT <rfc822;w@1wt.eu>);
	Fri, 5 Dec 2014 07:31:32 -0500
Received: from foss-mx-na.foss.arm.com ([217.140.108.86]:45231 "EHLO
	foss-mx-na.foss.arm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750823AbaLEMbb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 5 Dec 2014 07:31:31 -0500
Date: Fri, 5 Dec 2014 12:31:17 +0000
From: Catalin Marinas <catalin.marinas@arm.com>
To: Arnd Bergmann <arnd@arndb.de>
Cc: "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        Olof Johansson <olof@lixom.net>, "agraf@suse.de" <agraf@suse.de>,
        Will Deacon <Will.Deacon@arm.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] arm64: Enable CONFIG_COMPAT also for 64k page size
Message-ID: <20141205123116.GD28339@e104818-lin.cambridge.arm.com>
References: <1417707993-82290-1-git-send-email-agraf@suse.de>
 <3551792.oHatG1W6W1@wuerfel>
 <20141205110507.GB28339@e104818-lin.cambridge.arm.com>
 <2131163.V0fUaF9isN@wuerfel>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <2131163.V0fUaF9isN@wuerfel>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Dec 05, 2014 at 12:24:49PM +0000, Arnd Bergmann wrote:
> On Friday 05 December 2014 11:05:07 Catalin Marinas wrote:
> > 
> > > Should we add support for 64k-pages in the arm32 kernel as well now?
> > 
> > 32-bit LPAE doesn't support 64K pages but IIRC the classic MMU does
> > (though I have to check whether it was optional). But it's not feasible
> > to enable this in a 32-bit environment because of the memory wasted with
> > large pages (on average 32KB per mapped file, possibly even more if you
> > have lots of small files).
> 
> That sounds like a tradeoff that some users might be willing to make.
> 
> I remember that with ps3-linux, a lot of people wanted to enable 64k-pages
> because the Cell processor has such a small number of TLB entries (256 or
> 1024), but Linux only has around 200MB of memory available. I believe
> there are arm32 machines with more RAM and fewer TLBs.

I've heard that the WD MyCloud NAS (Cortex-A9 based) moved to 64K pages
and they rebuilt the filesystem (which annoyed some people that were
previously installing Debian packages directly, they now need
recompilation).

-- 
Catalin

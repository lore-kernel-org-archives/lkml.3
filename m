Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965236Ab3FTJZB (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Jun 2013 05:25:01 -0400
Received: from mailout2.w1.samsung.com ([210.118.77.12]:19975 "EHLO
	mailout2.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S965172Ab3FTJY6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Jun 2013 05:24:58 -0400
X-AuditID: cbfec7f4-b7fd76d0000035e1-3f-51c2ca675317
From: Phil Carmody <phil.carmody@partner.samsung.com>
To: "'Mark Brown'" <broonie@kernel.org>,
        "'Tomasz Figa'" <tomasz.figa@gmail.com>
Cc: linux-samsung-soc@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-kernel@vger.kernel.org, linux-spi@vger.kernel.org,
        alsa-devel@alsa-project.org, "'Kukjin Kim'" <kgene.kim@samsung.com>,
        "'Vinod Koul'" <vinod.koul@intel.com>, "'Dan Williams'" <djbw@fb.co>
References: <1371416058-22047-1-git-send-email-tomasz.figa@gmail.com>
 <20130619174047.GB1403@sirena.org.uk> <3697657.tZFV7pR81Q@flatron>
 <20130619192211.GH1403@sirena.org.uk>
In-reply-to: <20130619192211.GH1403@sirena.org.uk>
Subject: RE: [RFC PATCH 00/11] ARM: s3c64xx: Let amba-pl08x driver handle DMA
Date: Thu, 20 Jun 2013 12:24:47 +0300
Message-id: <001201ce6d98$03d9b920$0b8d2b60$%carmody@partner.samsung.com>
MIME-version: 1.0
Content-type: text/plain; charset=us-ascii
Content-transfer-encoding: 7bit
X-Mailer: Microsoft Office Outlook 12.0
Thread-index: Ac5tk07MG03t5YpDTU+0RCALKC5SZwAA3pdw
Content-language: en-gb
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFvrHLMWRmVeSWpSXmKPExsVy+t/xq7rppw4FGsz8L2dx5eIhJoupD5+w
	WUxes4fZonfBVTaLTY+vsVpc3jWHzWLG+X1MFo0fb7JbrNr1h9HiZd9+Fgcujw2fm9g8fnTd
	YPPYOesuu8fiPS+ZPDat6mTz2Lyk3qNvyypGj8+b5AI4orhsUlJzMstSi/TtErgyHq5exVjw
	haNix4+tTA2M/9i6GDk4JARMJPrvaXcxcgKZYhIX7q0HCnNxCAksZZS42jeLBcL5xyixqO8Y
	G0gVm4CpxJQV35hAmkUEfCSm9viD1DAL9DNJrH/wkx2iYROjxNeGlWANnAJGEh1ztjGC2MIC
	vhINk48zgdgsAqoSmzs6wGp4BTwl1l07zAphC0r8mHyPBcRmFtCSWL8Top5ZQF5i85q3zBBX
	q0s8+qsLEhYBGj/9aDMbRIm4xMMZvUwTGIVmIZk0C8mkWUgmzULSsoCRZRWjaGppckFxUnqu
	oV5xYm5xaV66XnJ+7iZGSJx92cG4+JjVIUYBDkYlHl7NywcDhVgTy4orcw8xSnAwK4nwps45
	FCjEm5JYWZValB9fVJqTWnyIkYmDU6qBcYXIkf2xLYtMeGWqF5xi9lvbw5v6Saqf7fT/zg0P
	hU43eLMsXRYSfNG0+a/D7dyCU8fOsqXYbnNc5CbEUMl6V30VC9POZwK3Dv+9zbhaVeTeNfVG
	4e2zvfKE37Fcz/Pxbl5fuuuET4HL4sLin2JqT1hYZYSYrq1Yu/L369ysmmtTbsYdP+d2XIml
	OCPRUIu5qDgRAP3WcKKRAgAA
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

(Apologies if this is mangled, fighting both Outlook and remote desktop :-(
)

linux-kernel-owner@vger.kernel.org wrote on Behalf Of Mark Brown
> On Wed, Jun 19, 2013 at 08:26:12PM +0200, Tomasz Figa wrote:
> > On Wednesday 19 of June 2013 18:40:47 Mark Brown wrote:
> 
> > > -		ret = pd->get_signal(plchan->cd);
> > > +		ret = (pd->get_signal)(plchan->cd);
> 
> > Hmm, that's strange. The former is a completely valid piece of
> code...
> 
> I know, hence...
> 
> > > to get it to build which makes me suspect the compiler a bit as
> well...
> 
> ...my comment about suspecting the compiler.

Can you just make that minimal change, and diff the objdump of the two .o's?
It would be worth a bug-report against the toolchain if different code was
being generated. If objdump spews huge numbers of diffs (due to one address
changing and pushing everything else out of kilter), then feel free to
forward both .o's or both objdumps to me, and I can run a script over them,
which knows to ignore unimportant address changes. 

Praying that this mail is readable to you, as it's not readable as I write
it,
Phil



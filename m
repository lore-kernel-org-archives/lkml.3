Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965292Ab3FTLPF (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Jun 2013 07:15:05 -0400
Received: from mailout4.w1.samsung.com ([210.118.77.14]:57098 "EHLO
	mailout4.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S965044Ab3FTLPC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Jun 2013 07:15:02 -0400
X-AuditID: cbfec7f5-b7f376d000001ec6-db-51c2e4342ea0
From: Phil Carmody <phil.carmody@partner.samsung.com>
To: "'Mark Brown'" <broonie@kernel.org>
Cc: "'Tomasz Figa'" <tomasz.figa@gmail.com>, linux-samsung-soc@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        linux-spi@vger.kernel.org, alsa-devel@alsa-project.org,
        "'Kukjin Kim'" <kgene.kim@samsung.com>,
        "'Vinod Koul'" <vinod.koul@intel.com>, "'Dan Williams'" <djbw@fb.co>
References: <1371416058-22047-1-git-send-email-tomasz.figa@gmail.com>
 <20130619174047.GB1403@sirena.org.uk> <3697657.tZFV7pR81Q@flatron>
 <20130619192211.GH1403@sirena.org.uk>
 <001201ce6d98$03d9b920$0b8d2b60$%carmody@partner.samsung.com>
 <20130620103532.GA27646@sirena.org.uk>
In-reply-to: <20130620103532.GA27646@sirena.org.uk>
Subject: RE: [RFC PATCH 00/11] ARM: s3c64xx: Let amba-pl08x driver handle DMA
Date: Thu, 20 Jun 2013 14:14:53 +0300
Message-id: <002501ce6da7$655924b0$300b6e10$%carmody@partner.samsung.com>
MIME-version: 1.0
Content-type: text/plain; charset=us-ascii
Content-transfer-encoding: 7bit
X-Mailer: Microsoft Office Outlook 12.0
Thread-index: Ac5toeuWVchdk1ZdQDqhffBQDe0lGgAA09rw
Content-language: en-gb
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFvrHLMWRmVeSWpSXmKPExsVy+t/xy7omTw4FGmxbIW5x5eIhJoupD5+w
	WUxes4fZonfBVTaLTY+vsVpc3jWHzWLG+X1MFo0fb7JbrNr1h9HiZd9+Fgcujw2fm9g8fnTd
	YPPYOesuu8fiPS+ZPDat6mTz2Lyk3qNvyypGj8+b5AI4orhsUlJzMstSi/TtErgy9j9dwljw
	jaNi8YIrzA2MX9m6GDk5JARMJK7uvsUCYYtJXLi3HijOxSEksJRRoqF5ATOE849RYsLOf8wg
	VWwCphJTVnxj6mLk4BARUJX4/8odpIZZYAeTxPEN+xkhGmYzSXzoOsQO0sApYCyx6NwFsBXC
	Ar4SDZOPM4HYLEDNK581gw3lFfCUONp+ngXCFpT4MfkemM0soCWxfidEPbOAvMTmNW+ZQRZL
	CKhLPPqrC3GDkcSUh+UQFeISD2f0Mk1gFJqFZNAsJINmIRk0C0nLAkaWVYyiqaXJBcVJ6blG
	esWJucWleel6yfm5mxghcfZ1B+PSY1aHGAU4GJV4eDUuHwwUYk0sK67MPcQowcGsJMKbOudQ
	oBBvSmJlVWpRfnxRaU5q8SFGJg5OqQbGBv/fabtZl7f7ry/nKvJYsvbBJMPLW0oc7n2MkjJR
	maD765hLj97P0hWG3M9zn1z+/i99ulmieCLHXfG+JvnboWmhu9SnXv51jPee1dI1z3at6tVi
	W6d6KV28O33VsU0uWr2V519mKKflbta9pMzt/PbsLhFjpQNKhZ3vv/kxq155tHSSi62AEktx
	RqKhFnNRcSIAeT2mYpECAAA=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> -----Original Message-----
> On Thu, Jun 20, 2013 at 12:24:47PM +0300, Phil Carmody wrote:
> > Can you just make that minimal change, and diff the objdump of the
> two .o's?
> > It would be worth a bug-report against the toolchain if different
> code
> > was being generated. If objdump spews huge numbers of diffs (due to
> > one address changing and pushing everything else out of kilter), then
> > feel free to forward both .o's or both objdumps to me, and I can run
> a
> > script over them, which knows to ignore unimportant address changes.
> 
> See Arnd's followup - this looks like a collision with the get_signal
> macro in signal.h.


With my language-lawyer hat on, I'd suggest ``(get_signal)'' to prevent the
macro expansion:

/tmp$ cat crap.c

#define fnlikemacro(foo) foo+

int x(int y) {
  int (fnlikemacro) = y;
  return fnlikemacro(y)(fnlikemacro);
}

/tmp$ gcc -E crap.c

int x(int y) {
  int (fnlikemacro) = y;
  return y+(fnlikemacro);
}

(and yes, that compiles.)

However, it's more tempting (i.e. sensible) to just rename the 
one with the weaker claim to the name.

Phil



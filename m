Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753308AbaHZSiG (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Aug 2014 14:38:06 -0400
Received: from mailapp01.imgtec.com ([195.59.15.196]:22225 "EHLO
	mailapp01.imgtec.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752816AbaHZSiF convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Aug 2014 14:38:05 -0400
From: Leonid Yegoshin <Leonid.Yegoshin@imgtec.com>
To: Ralf Baechle <ralf@linux-mips.org>
CC: Max Filippov <jcmvbkbc@gmail.com>,
        "linux-xtensa@linux-xtensa.org" <linux-xtensa@linux-xtensa.org>,
        Chris Zankel <chris@zankel.net>, "Marc Gauthier" <marc@cadence.com>,
        "linux-mm@kvack.org" <linux-mm@kvack.org>,
        "linux-arch@vger.kernel.org" <linux-arch@vger.kernel.org>,
        "linux-mips@linux-mips.org" <linux-mips@linux-mips.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        David Rientjes <rientjes@google.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        "Steven J. Hill" <Steven.Hill@imgtec.com>
Subject: Re: [PATCH v4 0/2] mm/highmem: make kmap cache coloring aware
Thread-Topic: [PATCH v4 0/2] mm/highmem: make kmap cache coloring aware
Thread-Index: AQHPre7N5QBJ5Fz/0EKvD+9jsRp2sZviKfYAgAEz3a8=
Date: Tue, 26 Aug 2014 18:37:52 +0000
Message-ID: <nlshxsgfkahrb2t7cl2hk6q5.1409078269675@email.android.com>
References: <1406941899-19932-1-git-send-email-jcmvbkbc@gmail.com>,<20140825171600.GH25892@linux-mips.org>
In-Reply-To: <20140825171600.GH25892@linux-mips.org>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

16KB page size solution may sometime be a solution:

1) in microcontroller environment then small pages have advantage
in small applications world.

2) some kernel drivers may not fit well a different page size, especially if HW
has an embedded memory translation: GPU, video/audio decoders,
supplement accelerators.

3) finally, somebody can increase cache size faster than page size,
this race never finishes.



Ralf Baechle <ralf@linux-mips.org> wrote:


On Sat, Aug 02, 2014 at 05:11:37AM +0400, Max Filippov wrote:

> this series adds mapping color control to the generic kmap code, allowing
> architectures with aliasing VIPT cache to use high memory. There's also
> use example of this new interface by xtensa.

I haven't actually ported this to MIPS but it certainly appears to be
the right framework to get highmem aliases handled on MIPS, too.

Though I still consider increasing PAGE_SIZE to 16k the preferable
solution because it will entirly do away with cache aliases.

Thanks,

  Ralf

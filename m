Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752419Ab3K2EZc (ORCPT <rfc822;w@1wt.eu>);
	Thu, 28 Nov 2013 23:25:32 -0500
Received: from TYO202.gate.nec.co.jp ([202.32.8.206]:52564 "EHLO
	tyo202.gate.nec.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751001Ab3K2EZ2 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 28 Nov 2013 23:25:28 -0500
From: Atsushi Kumagai <kumagai-atsushi@mxc.nes.nec.co.jp>
To: HATAYAMA Daisuke <d.hatayama@jp.fujitsu.com>
CC: "bhe@redhat.com" <bhe@redhat.com>, "tom.vaden@hp.com" <tom.vaden@hp.com>,
        "kexec@lists.infradead.org" <kexec@lists.infradead.org>,
        "ptesarik@suse.cz" <ptesarik@suse.cz>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "lisa.mitchell@hp.com" <lisa.mitchell@hp.com>,
        "vgoyal@redhat.com" <vgoyal@redhat.com>,
        "anderson@redhat.com" <anderson@redhat.com>,
        "ebiederm@xmission.com" <ebiederm@xmission.com>,
        "jingbai.ma@hp.com" <jingbai.ma@hp.com>
Subject: Re: [PATCH 0/3] makedumpfile: hugepage filtering for vmcore dump
Thread-Topic: [PATCH 0/3] makedumpfile: hugepage filtering for vmcore dump
Thread-Index: Ac7snBnC1kksR0zQtUinUJVDkNQRF///lTGA//9a6ZA=
Date: Fri, 29 Nov 2013 04:23:19 +0000
Message-ID: <0910DD04CBD6DE4193FCF86B9C00BE971C86DC@BPXM01GP.gisp.nec.co.jp>
References: <0910DD04CBD6DE4193FCF86B9C00BE971C855E@BPXM01GP.gisp.nec.co.jp>
 <5298084B.7060603@jp.fujitsu.com>
In-Reply-To: <5298084B.7060603@jp.fujitsu.com>
Accept-Language: ja-JP, en-US
Content-Language: ja-JP
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [10.21.40.240]
Content-Type: text/plain; charset="iso-2022-jp"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 2013/11/29 12:24:45, kexec <kexec-bounces@lists.infradead.org> wrote:
> (2013/11/29 12:02), Atsushi Kumagai wrote:
> > On 2013/11/28 16:50:21, kexec <kexec-bounces@lists.infradead.org> wrote:
> >>>> ping, in case you overlooked this...
> >>>
> >>> Sorry for the delayed response, I prioritize the release of v1.5.5 now.
> >>>
> >>> Thanks for your advice, check_cyclic_buffer_overrun() should be fixed
> >>> as you said. In addition, I'm considering other way to address such case,
> >>> that is to bring the number of "overflowed pages" to the next cycle and
> >>> exclude them at the top of __exclude_unnecessary_pages() like below:
> >>>
> >>>                  /*
> >>>                   * The pages which should be excluded still remain.
> >>>                   */
> >>>                  if (remainder >= 1) {
> >>>                          int i;
> >>>                          unsigned long tmp;
> >>>                          for (i = 0; i < remainder; ++i) {
> >>>                                  if (clear_bit_on_2nd_bitmap_for_kernel(pfn + i)) {
> >>>                                          pfn_user++;
> >>>                                          tmp++;
> >>>                                  }
> >>>                          }
> >>>                          pfn += tmp;
> >>>                          remainder -= tmp;
> >>>                          mem_map += (tmp - 1) * SIZE(page);
> >>>                          continue;
> >>>                  }
> >>>
> >>> If this way works well, then aligning info->buf_size_cyclic will be
> >>> unnecessary.
> >>>
> >>
> >> I selected the current implementation of changing cyclic buffer size becuase
> >> I thought it was simpler than carrying over remaining filtered pages to next cycle
> >> in that there was no need to add extra code in filtering processing.
> >>
> >> I guess the reason why you think this is better now is how to detect maximum order of
> >> huge page is hard in some way, right?
> > 
> > The maximum order will be gotten from HUGETLB_PAGE_ORDER or HPAGE_PMD_ORDER,
> > so I don't say it's hard. However, the carrying over method doesn't depend on
> > such kernel symbols, so I think it's robuster.
> > 
> 
> Then, it's better to remove check_cyclic_buffer_overrun() and rewrite part of free page
> filtering in __exclude_unnecessary_pages(). Could you do that too?

Sure, I'll modify it too.


Thanks
Atsushi Kumagai

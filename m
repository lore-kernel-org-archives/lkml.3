Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752212AbaAQOrW (ORCPT <rfc822;w@1wt.eu>);
	Fri, 17 Jan 2014 09:47:22 -0500
Received: from mga11.intel.com ([192.55.52.93]:51303 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751248AbaAQOrT (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 17 Jan 2014 09:47:19 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.95,670,1384329600"; 
   d="scan'208";a="466700021"
From: "Ren, Qiaowei" <qiaowei.ren@intel.com>
To: Borislav Petkov <bp@alien8.de>
CC: "H. Peter Anvin" <hpa@zytor.com>, Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, "x86@kernel.org" <x86@kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: RE: [PATCH 2/5] x86, mpx: hook #BR exception handler to allocate
 bound tables
Thread-Topic: [PATCH 2/5] x86, mpx: hook #BR exception handler to allocate
 bound tables
Thread-Index: AQHPDzsFvFwJDOMjVUqdOlZ/jiA8spqASnOAgAGzAYD///USAIAHFB8w
Date: Fri, 17 Jan 2014 14:47:15 +0000
Message-ID: <9E0BE1322F2F2246BD820DA9FC397ADE014E575D@SHSMSX102.ccr.corp.intel.com>
References: <1389518403-7715-1-git-send-email-qiaowei.ren@intel.com>
 <1389518403-7715-2-git-send-email-qiaowei.ren@intel.com>
 <20140112092019.GA3664@pd.tnic> <52D35ABB.8070904@intel.com>
 <20140113103808.GC5388@pd.tnic>
In-Reply-To: <20140113103808.GC5388@pd.tnic>
Accept-Language: zh-CN, en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [10.239.127.40]
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org
Content-Transfer-Encoding: 8bit
X-MIME-Autoconverted: from base64 to 8bit by mail.home.local id s0HElRw9025216

> -----Original Message-----
> From: Borislav Petkov [mailto:bp@alien8.de]
> Sent: Monday, January 13, 2014 6:38 PM
> To: Ren, Qiaowei
> Cc: H. Peter Anvin; Thomas Gleixner; Ingo Molnar; x86@kernel.org;
> linux-kernel@vger.kernel.org
> Subject: Re: [PATCH 2/5] x86, mpx: hook #BR exception handler to allocate
> bound tables
> 
> On Mon, Jan 13, 2014 at 11:17:15AM +0800, Ren Qiaowei wrote:
> > Yes, I run this with lockdep enabled.
> 
> Ok, but you still are doing memory allocation in the exception handler,
> AFAICT:
> 
> do_bounds
> |->do_mpx_bt_fault
>    |->allocate_bt
>       |->sys_mmap_pgoff
>          |->vm_mmap_pgoff
>             |->do_mmap_pgoff
>                |->mmap_region
>                   |-> kmem_cache_zalloc(vm_area_cachep, GFP_KERNEL);
> 
Sorry for my late reply.

Petkov, could you please detail the problem? Memory allocation can't be done in the eception handler? I guess it is like do_page_fault(), right?

Thanks,
Qiaowei
ÿôèº{.nÇ+‰·Ÿ®‰­†+%ŠËÿ±éİ¶¥Šwÿº{.nÇ+‰·¥Š{±şG«éÿŠ{ayºÊ‡Ú™ë,j­¢f£¢·hšïêÿ‘êçz_è®(­éšŠİ¢j"ú¶m§ÿÿ¾«şG«éÿ¢¸?™¨è­Ú&£ø§~á¶iO•æ¬z·švØ^¶m§ÿÿÃÿ¶ìÿ¢¸?–I¥

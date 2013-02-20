Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935373Ab3BTNN6 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Feb 2013 08:13:58 -0500
Received: from mail-la0-f48.google.com ([209.85.215.48]:32805 "EHLO
	mail-la0-f48.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934921Ab3BTNN4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Feb 2013 08:13:56 -0500
MIME-Version: 1.0
X-Originating-IP: [188.6.195.195]
In-Reply-To: <BEC9F67575FA1E429CA7CF5AE9BE3634403505@SHSMSX102.ccr.corp.intel.com>
References: <1360113112.17267.1.camel@fli24-HP-Compaq-8100-Elite-CMT-PC>
	<6332427.iqPUMjtDaQ@vostro.rjw.lan>
	<BEC9F67575FA1E429CA7CF5AE9BE3634400F30@SHSMSX102.ccr.corp.intel.com>
	<3321530.AgvEeduuPx@vostro.rjw.lan>
	<20130219104633.GA23279@xo-6d-61-c0.localdomain>
	<BEC9F67575FA1E429CA7CF5AE9BE3634403505@SHSMSX102.ccr.corp.intel.com>
Date: Wed, 20 Feb 2013 14:13:54 +0100
Message-ID: <CAJfpegvmrFywtwS5giuCgVc5Cr3G1+fXKTPYiCZsV5P1jinxXA@mail.gmail.com>
Subject: Re: [fuse-devel] Getting rid of freezer for suspend [was Re: [PATCH]
 fuse: make fuse daemon frozen along with kernel threads]
From: Miklos Szeredi <miklos@szeredi.hu>
To: "Li, Fei" <fei.li@intel.com>
Cc: Pavel Machek <pavel@ucw.cz>, "Rafael J. Wysocki" <rjw@sisk.pl>,
        "Brown, Len" <len.brown@intel.com>, "Wang, Biao" <biao.wang@intel.com>,
        "peterz@infradead.org" <peterz@infradead.org>,
        "linux-pm@vger.kernel.org" <linux-pm@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "fuse-devel@lists.sourceforge.net" <fuse-devel@lists.sourceforge.net>,
        "mingo@redhat.com" <mingo@redhat.com>,
        "Liu, Chuansheng" <chuansheng.liu@intel.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Feb 20, 2013 at 3:54 AM, Li, Fei <fei.li@intel.com> wrote:

>> From: Pavel Machek [mailto:pavel@ucw.cz]
>>
>> freeze_priority?
>>
>> I _hope_ we will not need more than three priorities, (user, fused, kernel), but
>> I hoped not no need more than two before, so...

>
> IMHO, we still use two priorities, with the exception that user space process such
> as fuse daemon can be configured to be frozen in kernel threads frozen phase
> instead of user space processes frozen phase.

I'm not sure that will work.  Fuse processes are in fact ordinary
userspace processes, and so should be frozen before kernel threads.

Thanks,
Miklos

Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752075Ab3LKDXi (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Dec 2013 22:23:38 -0500
Received: from mail-we0-f170.google.com ([74.125.82.170]:50168 "EHLO
	mail-we0-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751172Ab3LKDXe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Dec 2013 22:23:34 -0500
MIME-Version: 1.0
In-Reply-To: <20131211023238.GA10365@kroah.com>
References: <1386601025-422-1-git-send-email-bergwolf@gmail.com>
 <1386601025-422-7-git-send-email-bergwolf@gmail.com> <20131211023238.GA10365@kroah.com>
From: Peng Tao <bergwolf@gmail.com>
Date: Wed, 11 Dec 2013 11:23:12 +0800
Message-ID: <CA+a=Yy5dRDD3ZLf-q5y5-UGn4RkRkgZQRDsKpaOYbVMaEFXhmA@mail.gmail.com>
Subject: Re: [PATCH 06/13] staging/lustre/llite: remove ll_d_root_ops
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Lai Siyao <laisiyao@whamcloud.com>, Lai Siyao <lai.siyao@intel.com>,
        Andreas Dilger <andreas.dilger@intel.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Dec 11, 2013 at 10:32 AM, Greg Kroah-Hartman
<gregkh@linuxfoundation.org> wrote:
> On Mon, Dec 09, 2013 at 10:56:58PM +0800, Peng Tao wrote:
>> From: Lai Siyao <laisiyao@whamcloud.com>
>>
>> Mnt root dentry will never be revalidated, but its d_op->d_compare
>> will be called for its children, to simplify code, we use the same
>> ll_d_ops as normal dentries.
>> But its attribute may be invalid before access, this won't cause
>> any issue because it always exists, and the only operation depends
>> on its attribute is .permission, which has revalidated it in lustre
>> code.
>>
>> So it's okay to remove ll_d_root_ops, and remove unnecessary checks
>> in lookup/revalidate/statahead.
>
> This breaks the build.
>
> It's as if you aren't testing this.
>
err... I tested the series as a whole but it turns out this breakage
got fixed in the next patch. Looks like I should really have tested
every single patch instead.

sorry...

> I'm really tired of this, I really don't want to take any more patches
> from you for a while, as I dread them every time I see a series sent by
> you for this codebase.
>
I'll give you a break then... sorry for getting you annoyed.

Thanks,
Tao

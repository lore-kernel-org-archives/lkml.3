Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756549Ab3D1WMJ (ORCPT <rfc822;w@1wt.eu>);
	Sun, 28 Apr 2013 18:12:09 -0400
Received: from mail-wg0-f41.google.com ([74.125.82.41]:57847 "EHLO
	mail-wg0-f41.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753722Ab3D1WMH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 28 Apr 2013 18:12:07 -0400
MIME-Version: 1.0
In-Reply-To: <OFCF117D0B.61A9CA12-ON48257B4F.002F2292-48257B4F.0030E459@zte.com.cn>
References: <OFCF117D0B.61A9CA12-ON48257B4F.002F2292-48257B4F.0030E459@zte.com.cn>
Date: Mon, 29 Apr 2013 00:12:05 +0200
Message-ID: <CAFLxGvxqwpc5fbyGpy9o4qzEfn0i3eocs36TrkX9=SfZ_oT-5w@mail.gmail.com>
Subject: Re: [PATCH] UBI: fix memory leak when use fastmap
From: richard -rw- weinberger <richard.weinberger@gmail.com>
To: wang.bo116@zte.com.cn
Cc: artem.bityutskiy@linux.intel.com,
        "linux-mtd@lists.infradead.org" <linux-mtd@lists.infradead.org>,
        LKML <linux-kernel@vger.kernel.org>, liu.dong3@zte.com.cn,
        cui.yunfeng@zte.com.cn
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi!

On Tue, Apr 16, 2013 at 10:53 AM,  <wang.bo116@zte.com.cn> wrote:
> Hello,
>         Sorry, there is still something wrong with the previous patch's
> format, try to submit it again. When use ubi fastmap, there is a memory
> leak which will make destroy_ai() fail to free the slab alloced in
> scan_fast(). The following patch fix this problem by use a temporary
> "ubi_attach_info" variable in scan_fast().

Thanks a lot for your patch!

Did you test it well?
We need to make sure that it does the right thing for the following cases:
1. fastmap disabled, attaching a non-fastmap volume
1. fastmap disabled, attaching a fastmap volume
3. fastmap enabled, attaching a non-fastmap volume
4. fastmap enablled, attaching a fastmap volume

--
Thanks,
//richard

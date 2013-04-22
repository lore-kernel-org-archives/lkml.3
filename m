Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753617Ab3DVX4b (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Apr 2013 19:56:31 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:53899 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752423Ab3DVX4a (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Apr 2013 19:56:30 -0400
Date: Mon, 22 Apr 2013 16:56:29 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: kbuild test robot <fengguang.wu@intel.com>
Cc: Jingoo Han <jg1.han@samsung.com>, kbuild-all@01.org,
        linux-sparse@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [next:akpm 798/1000] drivers/rtc/rtc-ds1286.c:343:24: sparse:
 incorrect type in argument 1 (different address spaces)
Message-Id: <20130422165629.bae79e6c5251bf148a3bae73@linux-foundation.org>
In-Reply-To: <5171d93a.0NZAGYYKNj8hjsAs%fengguang.wu@intel.com>
References: <5171d93a.0NZAGYYKNj8hjsAs%fengguang.wu@intel.com>
X-Mailer: Sylpheed 3.2.0beta5 (GTK+ 2.24.10; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 20 Apr 2013 07:54:34 +0800 kbuild test robot <fengguang.wu@intel.com> wrote:

> tree:   git://git.kernel.org/pub/scm/linux/kernel/git/next/linux-next.git akpm
> head:   c9941b7ec7840ad33f5822c7f238157558d40132
> commit: d5e42b5769899607e1e4b0c9200340d24f370e8c [798/1000] rtc: rtc-ds1286: use devm_*() functions
> 
> 
> sparse warnings: (new ones prefixed by >>)
> 
> >> drivers/rtc/rtc-ds1286.c:343:24: sparse: incorrect type in argument 1 (different address spaces)
>    drivers/rtc/rtc-ds1286.c:343:24:    expected void const *ptr
>    drivers/rtc/rtc-ds1286.c:343:24:    got unsigned int [noderef] [usertype] <asn:2>*rtcregs
> >> drivers/rtc/rtc-ds1286.c:344:36: sparse: incorrect type in argument 1 (different address spaces)
>    drivers/rtc/rtc-ds1286.c:344:36:    expected void const *ptr
>    drivers/rtc/rtc-ds1286.c:344:36:    got unsigned int [noderef] [usertype] <asn:2>*rtcregs
> 
> vim +343 drivers/rtc/rtc-ds1286.c
> 
>    337			return -ENODEV;
>    338		priv = devm_kzalloc(&pdev->dev, sizeof(struct ds1286_priv), GFP_KERNEL);
>    339		if (!priv)
>    340			return -ENOMEM;
>    341	
>    342		priv->rtcregs = devm_ioremap_resource(&pdev->dev, res);
>  > 343		if (IS_ERR(priv->rtcregs))
>  > 344			return PTR_ERR(priv->rtcregs);
>    345	
>    346		spin_lock_init(&priv->lock);
>    347		platform_set_drvdata(pdev, priv);

I think doing IS_ERR() and PTR_ERR() on __iomem pointers is a natural
thing, and we should be able to do this without adding call-site
trickery to make sparse happy.

Is there some sort of annotation which we can add to the
IS_ERR()/PTR_ERR() definitions so that sparse will stop warning about
this usage?


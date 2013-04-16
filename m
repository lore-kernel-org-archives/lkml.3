Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935120Ab3DPAnF (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Apr 2013 20:43:05 -0400
Received: from mail-pa0-f46.google.com ([209.85.220.46]:45491 "EHLO
	mail-pa0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934813Ab3DPAnD convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Apr 2013 20:43:03 -0400
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8BIT
To: Sebastian Hesselbarth <sebastian.hesselbarth@gmail.com>,
        Stephen Rothwell <sfr@canb.auug.org.au>
From: Mike Turquette <mturquette@linaro.org>
In-Reply-To: <516BA63B.5090707@gmail.com>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org
References: <20130415150402.fd83866829f3108f45b7c126@canb.auug.org.au>
 <516BA63B.5090707@gmail.com>
Message-ID: <20130416004236.6507.63400@quantum>
User-Agent: alot/0.3.4
Subject: Re: linux-next: build failure after merge of the clk tree
Date: Mon, 15 Apr 2013 17:42:36 -0700
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Quoting Sebastian Hesselbarth (2013-04-15 00:03:23)
> On 04/15/2013 07:04 AM, Stephen Rothwell wrote:
> > After merging the clk tree, today's linux-next build (x86_64 allmodconfig)
> > failed like this:
> >
> > ERROR: "of_clk_add_provider" [drivers/clk/clk-si5351.ko] undefined!
> > ERROR: "of_clk_src_onecell_get" [drivers/clk/clk-si5351.ko] undefined!
> 
> Stephen,
> 
> I must have missed the both above when allowing clk-si5351 to be built
> for !OF. I sent a patch to make clk-si5351 depend on CONFIG_OF until
> we sort it out.
> 
> > ERROR: "__clk_get_flags" [drivers/clk/clk-si5351.ko] undefined!
> 
> I sent a patch to export the above function but Mike must have missed
> it. I resent it on list.
> 

Sorry about missing that export.

I've taken both of your fixes into clk-next.

Regards,
Mike

> Sebastian
> 
> > Caused by commit 9abd5f0555df ("clk: add si5351 i2c common clock
> > driver").  It probbaly need to depend on CONFIG_OF.
> >
> > I have used the clk tree from next-20130412 for today.

Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934743Ab3DOHD2 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Apr 2013 03:03:28 -0400
Received: from mail-bk0-f48.google.com ([209.85.214.48]:60670 "EHLO
	mail-bk0-f48.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932679Ab3DOHD0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Apr 2013 03:03:26 -0400
Message-ID: <516BA63B.5090707@gmail.com>
Date: Mon, 15 Apr 2013 09:03:23 +0200
From: Sebastian Hesselbarth <sebastian.hesselbarth@gmail.com>
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:10.0.12) Gecko/20130116 Icedove/10.0.12
MIME-Version: 1.0
To: Stephen Rothwell <sfr@canb.auug.org.au>
CC: Mike Turquette <mturquette@linaro.org>, linux-next@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: linux-next: build failure after merge of the clk tree
References: <20130415150402.fd83866829f3108f45b7c126@canb.auug.org.au>
In-Reply-To: <20130415150402.fd83866829f3108f45b7c126@canb.auug.org.au>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 04/15/2013 07:04 AM, Stephen Rothwell wrote:
> After merging the clk tree, today's linux-next build (x86_64 allmodconfig)
> failed like this:
>
> ERROR: "of_clk_add_provider" [drivers/clk/clk-si5351.ko] undefined!
> ERROR: "of_clk_src_onecell_get" [drivers/clk/clk-si5351.ko] undefined!

Stephen,

I must have missed the both above when allowing clk-si5351 to be built
for !OF. I sent a patch to make clk-si5351 depend on CONFIG_OF until
we sort it out.

> ERROR: "__clk_get_flags" [drivers/clk/clk-si5351.ko] undefined!

I sent a patch to export the above function but Mike must have missed
it. I resent it on list.

Sebastian

> Caused by commit 9abd5f0555df ("clk: add si5351 i2c common clock
> driver").  It probbaly need to depend on CONFIG_OF.
>
> I have used the clk tree from next-20130412 for today.


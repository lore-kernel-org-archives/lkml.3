Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754054AbaCJT4B (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Mar 2014 15:56:01 -0400
Received: from shards.monkeyblade.net ([149.20.54.216]:46773 "EHLO
	shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752838AbaCJTz7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Mar 2014 15:55:59 -0400
Date: Mon, 10 Mar 2014 15:55:57 -0400 (EDT)
Message-Id: <20140310.155557.1576514754598895473.davem@davemloft.net>
To: kys@microsoft.com
Cc: netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        devel@linuxdriverproject.org, olaf@aepfle.de, apw@canonical.com,
        jasowang@redhat.com
Subject: Re: [PATCH V3 0/6] Drivers: net: hyperv: Enable various offloads 
From: David Miller <davem@davemloft.net>
In-Reply-To: <1394335362-11126-1-git-send-email-kys@microsoft.com>
References: <1394335362-11126-1-git-send-email-kys@microsoft.com>
X-Mailer: Mew version 6.5 on Emacs 24.1 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.7 (shards.monkeyblade.net [149.20.54.216]); Mon, 10 Mar 2014 12:55:59 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: "K. Y. Srinivasan" <kys@microsoft.com>
Date: Sat,  8 Mar 2014 19:22:42 -0800

> This patch set enables both checksum as well as segmentation offload.
> As part of this effort I have enabled scatter gather I/O a well.
> 
> In version 2 of these patches, I addressed comments from David Miller and
> Dan Carpenter.
> 
> In this version I have addressed the latest comments from David Miller.

Series applied, thanks.

I still think that fill_pg_buf() could be improved.

For example, it returns '1' if len is passed in as zero.  Maybe that can't
happen, but if it does the page buffer array will be corrupted and the
driver will process garbage.

It seems so much more straightforward to me if you simply incremented
'j' in the loop when an array entry is actually filled in.  Then just
return 'j'.

	int j;
 ...
		pb[j].pfn = page_to_pfn(page);
		pb[j].offset = offset;
		pb[j].len = bytes;
		j++;
 ...
	return j;


Then 'j' is unambiguously the number of pb array entries which were
filled in, no matter what.

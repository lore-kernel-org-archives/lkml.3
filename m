Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751698AbaBSGi0 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Feb 2014 01:38:26 -0500
Received: from relay.parallels.com ([195.214.232.42]:48749 "EHLO
	relay.parallels.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750931AbaBSGiZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Feb 2014 01:38:25 -0500
Message-ID: <5304515A.8070809@parallels.com>
Date: Wed, 19 Feb 2014 10:38:18 +0400
From: Vladimir Davydov <vdavydov@parallels.com>
MIME-Version: 1.0
To: <Valdis.Kletnieks@vt.edu>
CC: LKML <linux-kernel@vger.kernel.org>, Jan Kara <jack@suse.cz>,
        Wu Fengguang <fengguang.wu@intel.com>,
        Andrew Morton <akpm@linux-foundation.org>
Subject: Re: Unkillable R-state process stuck in sendfile
References: <530205D9.1010908@parallels.com> <59184.1392750827@turing-police.cc.vt.edu>
In-Reply-To: <59184.1392750827@turing-police.cc.vt.edu>
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.30.16.96]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 02/18/2014 11:13 PM, Valdis.Kletnieks@vt.edu wrote:
> On Mon, 17 Feb 2014 16:51:37 +0400, Vladimir Davydov said:
>
>>         out_fd = eventfd(0, 0);
>>         if (out_fd < 0)
>>                 err(1, "eventfd");
>>         ret = sendfile64(out_fd, in_fd, NULL, SIZE);
>> I'm not sure if this is actually bad and should be fixed, but perhaps
>> it's worth making do_generic_file_read() check for fatal signals pending
>> and break the read loop if so?
> Why do we even allow an eventfd to be fed to sendfile64 at all? What
> does that even *mean*?

I guess it's meaningless, so another fix (if this should be fixed at
all) would be disabling splice to eventfd. However, I cannot be
100%-sure nobody splices data to eventfd...

Thanks.

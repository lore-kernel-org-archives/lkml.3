Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S966023Ab3GSFsX (ORCPT <rfc822;w@1wt.eu>);
	Fri, 19 Jul 2013 01:48:23 -0400
Received: from mail7.hitachi.co.jp ([133.145.228.42]:53475 "EHLO
	mail7.hitachi.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S965543Ab3GSFsU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 19 Jul 2013 01:48:20 -0400
X-AuditID: 85900ec0-d4ccab900000151e-25-51e8d32248cb
Message-ID: <51E8D310.2050207@hitachi.com>
Date: Fri, 19 Jul 2013 14:48:00 +0900
From: Yoshihiro YUNOMAE <yoshihiro.yunomae.ez@hitachi.com>
User-Agent: Mozilla/5.0 (Windows NT 5.2; rv:13.0) Gecko/20120604 Thunderbird/13.0
MIME-Version: 1.0
To: Amit Shah <amit.shah@redhat.com>
Cc: linux-kernel@vger.kernel.org,
        Hidehiro Kawai <hidehiro.kawai.ez@hitachi.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>,
        Arnd Bergmann <arnd@arndb.de>, yrl.pp-manager.tt@hitachi.com
Subject: Re: Re: [PATCH 0/2] [BUGFIX] virtio/console: Fix two bugs of splice_write
References: <20130718231927.3664.50418.stgit@yunodevel> <20130719052345.GD3087@amit-x200.redhat.com>
In-Reply-To: <20130719052345.GD3087@amit-x200.redhat.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-Brightmail-Tracker: AAAAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


(2013/07/19 14:23), Amit Shah wrote:
> On (Fri) 19 Jul 2013 [08:19:27], Yoshihiro YUNOMAE wrote:
>> Hi,
>>
>> This patch set fixes two bugs of splice_write in the virtio-console driver.
>>
>> [BUG1] Although pipe->nrbufs is empty, the driver tries to do splice_write.
>>         => This induces oops in sg_init_table().
>>
>> [BUG2] No lock for competition of splice_write.
>>         => This induces oops in splice_from_pipe_feed() by bug of any user
>>            application.
>
> Spotted a bug in the 2nd patch.  Do you want to also CC these to stable@?

Sure! I'll CC stable@ and virtualization@lists.linux-foundation.org.
Thanks!

Yoshihiro YUNOMAE

-- 
Yoshihiro YUNOMAE
Software Platform Research Dept. Linux Technology Center
Hitachi, Ltd., Yokohama Research Laboratory
E-mail: yoshihiro.yunomae.ez@hitachi.com



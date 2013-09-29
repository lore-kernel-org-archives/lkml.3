Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753491Ab3I2Gwp (ORCPT <rfc822;w@1wt.eu>);
	Sun, 29 Sep 2013 02:52:45 -0400
Received: from userp1040.oracle.com ([156.151.31.81]:32592 "EHLO
	userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751311Ab3I2Gwn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 29 Sep 2013 02:52:43 -0400
Message-ID: <5247CECC.9050003@oracle.com>
Date: Sun, 29 Sep 2013 14:55:08 +0800
From: vaughan <vaughan.cao@oracle.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130805 Thunderbird/17.0.8
MIME-Version: 1.0
To: Jeff Moyer <jmoyer@redhat.com>
CC: axboe@kernel.dk, linux-kernel@vger.kernel.org, alexey.kodanev@oracle.com
Subject: Re: [PATCH v2] block: register_blkdev doesn't check name against
 NULL
References: <1378809614-17490-1-git-send-email-vaughan.cao@oracle.com> <1378866250-22679-1-git-send-email-vaughan.cao@oracle.com> <x49mwn3y4bo.fsf@segfault.boston.devel.redhat.com>
In-Reply-To: <x49mwn3y4bo.fsf@segfault.boston.devel.redhat.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Source-IP: acsinet22.oracle.com [141.146.126.238]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 09/23/2013 10:56 PM, Jeff Moyer wrote:
> Vaughan Cao <vaughan.cao@oracle.com> writes:
>
>> register_blkdev(0, NULL) can result kernel Oops by copying from NULL
>> in strlcpy(). Fix it by checking NULL pointer at the beginning and
>> WARN when encountered in unregister_blkdev.
> Uhh, so yeah, this is an exported function, so I could see maybe wanting
> to do the argument checking.  But honestly, if your driver can't even
> get this right, is there any hope of it actually working?
>
> This seems like a pointless patch to me, but ultimately it's up to Jens.
>
> Cheers,
> Jeff
>
> p.s. the kerneldoc tells you what to put there:
>  * @name: the name of the new block device as a zero terminated string
Thanks for your comment, Jeff. I have the same feeling as you, however,
shouldn't kernel do its best to provide the maximum stable working ability?
And it's test case 7 of block driver in ltp project -
http://sourceforge.net/p/ltp/git/ci/master/tree/testcases/kernel/device-drivers/block/kernel_space/test_block.c.
It seems their attitude is we should check this.

Vaughan

Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754567Ab3GVBFh (ORCPT <rfc822;w@1wt.eu>);
	Sun, 21 Jul 2013 21:05:37 -0400
Received: from mail4.hitachi.co.jp ([133.145.228.5]:33147 "EHLO
	mail4.hitachi.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754010Ab3GVBFf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 21 Jul 2013 21:05:35 -0400
X-AuditID: 85900ec0-d4ccab900000151e-14-51ec855be7a8
Message-ID: <51EC8556.9040101@hitachi.com>
Date: Mon, 22 Jul 2013 10:05:26 +0900
From: Yoshihiro YUNOMAE <yoshihiro.yunomae.ez@hitachi.com>
User-Agent: Mozilla/5.0 (Windows NT 5.2; rv:13.0) Gecko/20120604 Thunderbird/13.0
MIME-Version: 1.0
To: Amit Shah <amit.shah@redhat.com>
Cc: linux-kernel@vger.kernel.org, Arnd Bergmann <arnd@arndb.de>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, virtualization@lists.linux-foundation.org,
        Hidehiro Kawai <hidehiro.kawai.ez@hitachi.com>,
        yrl.pp-manager.tt@hitachi.com,
        Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>
Subject: Re: Re: [PATCH V2 0/2] [BUGFIX] virtio/console: Fix two bugs of
 splice_write
References: <20130719091951.9698.95194.stgit@yunodevel> <20130719100543.GM3087@amit-x200.redhat.com>
In-Reply-To: <20130719100543.GM3087@amit-x200.redhat.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-Brightmail-Tracker: AAAAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Amit,

Sorry for the late reply.

(2013/07/19 19:05), Amit Shah wrote:
> On (Fri) 19 Jul 2013 [18:19:51], Yoshihiro YUNOMAE wrote:
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
>>
>> These reports are written in each patch.
>>
>> Changes in V2:
>> - Fix a locking problem for error
>>
>> Thanks!
>
> Reviewed-by: Amit Shah <amit.shah@redhat.com>

Thank you for reviewing this patch set.

> For the patches to be picked up in the stable trees, you need to
> include CC: <stable@vger.kernel.org> in the sign-off area of the
> patches, just cc'ing in the patch posting doesn't help.  See
> Documentation/stable_kernel_rules.txt.
>
> Can you submit a v3 with that change, and also add my reviewed-by
> line?

Sure. I'll add stable@ line, your reviewed-by line, and Masami's
reviewed-by line in sign-off area for each patch.

Thanks,
Yoshihiro YUNOMAE

-- 
Yoshihiro YUNOMAE
Software Platform Research Dept. Linux Technology Center
Hitachi, Ltd., Yokohama Research Laboratory
E-mail: yoshihiro.yunomae.ez@hitachi.com



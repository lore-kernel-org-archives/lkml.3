Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S966007Ab3GSFrR (ORCPT <rfc822;w@1wt.eu>);
	Fri, 19 Jul 2013 01:47:17 -0400
Received: from mail7.hitachi.co.jp ([133.145.228.42]:53257 "EHLO
	mail7.hitachi.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S965594Ab3GSFrE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 19 Jul 2013 01:47:04 -0400
X-AuditID: 85900ec0-d24c6b900000151e-20-51e8d2d50e5d
Message-ID: <51E8D2C3.80600@hitachi.com>
Date: Fri, 19 Jul 2013 14:46:43 +0900
From: Yoshihiro YUNOMAE <yoshihiro.yunomae.ez@hitachi.com>
User-Agent: Mozilla/5.0 (Windows NT 5.2; rv:13.0) Gecko/20120604 Thunderbird/13.0
MIME-Version: 1.0
To: Amit Shah <amit.shah@redhat.com>
Cc: linux-kernel@vger.kernel.org,
        Hidehiro Kawai <hidehiro.kawai.ez@hitachi.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>,
        Arnd Bergmann <arnd@arndb.de>, yrl.pp-manager.tt@hitachi.com
Subject: Re: Re: [PATCH 2/2] [BUGFIX] virtio/console: Add pipe_lock/unlock
 for splice_write
References: <20130718231927.3664.50418.stgit@yunodevel> <20130718231932.3664.25089.stgit@yunodevel> <20130719052312.GC3087@amit-x200.redhat.com>
In-Reply-To: <20130719052312.GC3087@amit-x200.redhat.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Brightmail-Tracker: AAAAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Amit,

(2013/07/19 14:23), Amit Shah wrote:
> On (Fri) 19 Jul 2013 [08:19:32], Yoshihiro YUNOMAE wrote:
>> Add pipe_lock/unlock for splice_write to avoid oops by following competition:
>
>> diff --git a/drivers/char/virtio_console.c b/drivers/char/virtio_console.c
>> index 8722656..4a28e4c 100644
>> --- a/drivers/char/virtio_console.c
>> +++ b/drivers/char/virtio_console.c
>> @@ -936,6 +936,7 @@ static ssize_t port_fops_splice_write(struct pipe_inode_info *pipe,
>>   	 * pipe->nrbufs == 0 means there are no data to transfer,
>>   	 * so this returns just 0 for no data.
>>   	 */
>> +	pipe_lock(pipe);
>>   	if (!pipe->nrbufs)
>>   		return 0;
>>
>> @@ -953,6 +954,7 @@ static ssize_t port_fops_splice_write(struct pipe_inode_info *pipe,
>>   	sgl.sg = buf->sg;
>>   	sg_init_table(sgl.sg, sgl.size);
>>   	ret = __splice_from_pipe(pipe, &sd, pipe_to_sg);
>> +	pipe_unlock(pipe);
>>   	if (likely(ret > 0))
>>   		ret = __send_to_port(port, buf->sg, sgl.n, sgl.len, buf, true);
>>
>>
>
> You're not unlocking in all the error return cases.

Oh, sorry.
I'll resend a revised patch soon.
Thanks!

Yoshihiro YUNOMAE

-- 
###2013.03.18より変更###
-------------------------------------------------
湯前　慶大（YUNOMAE Yoshihiro）
（株）日立製作所　横浜研究所
ソフトウェアプラットフォーム研究部 PP3u & LTC
e-mail: yoshihiro.yunomae.ez@hitachi.com
内線PHS: 874-2583
外線PHS: 050-3135-2583
-------------------------------------------------
Yoshihiro YUNOMAE
Software Platform Research Dept. Linux Technology Center
Hitachi, Ltd., Yokohama Research Laboratory
E-mail: yoshihiro.yunomae.ez@hitachi.com



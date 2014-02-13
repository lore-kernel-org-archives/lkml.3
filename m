Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753623AbaBMJ4r (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Feb 2014 04:56:47 -0500
Received: from cn.fujitsu.com ([222.73.24.84]:43656 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1752290AbaBMJ4o (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Feb 2014 04:56:44 -0500
X-IronPort-AV: E=Sophos;i="4.95,837,1384272000"; 
   d="scan'208";a="9520625"
Message-ID: <52FC94D0.2050705@cn.fujitsu.com>
Date: Thu, 13 Feb 2014 17:48:00 +0800
From: Gu Zheng <guz.fnst@cn.fujitsu.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:7.0.1) Gecko/20110930 Thunderbird/7.0.1
MIME-Version: 1.0
To: Andrey Tsyvarev <tsyvarev@ispras.ru>
CC: jaegeuk.kim@samsung.com, linux-kernel <linux-kernel@vger.kernel.org>,
        linux-f2fs-devel@lists.sourceforge.net
Subject: Re: [f2fs-dev] f2fs: f2fs unmount hangs if f2fs_init_acl() fails
 during mkdir syscall
References: <52F320FC.50803@ispras.ru> <1391666564.25542.78.camel@kjgkr> <52F37D67.208@ispras.ru> <1391734185.25542.80.camel@kjgkr> <1391749933.25542.83.camel@kjgkr> <52F9DF85.7040402@ispras.ru> <52FC832F.6000103@cn.fujitsu.com> <52FC9315.2090707@ispras.ru>
In-Reply-To: <52FC9315.2090707@ispras.ru>
X-MIMETrack: Itemize by SMTP Server on mailserver/fnst(Release 8.5.3|September 15, 2011) at
 2014/02/13 17:54:17,
	Serialize by Router on mailserver/fnst(Release 8.5.3|September 15, 2011) at
 2014/02/13 17:54:21,
	Serialize complete at 2014/02/13 17:54:21
Content-Transfer-Encoding: 7bit
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,
On 02/13/2014 05:40 PM, Andrey Tsyvarev wrote:

> Hi,
> 
>> BTW, have you tested the case that added remove_dirty_dir_inode() into the fail path
>> of init_inode_metadata?
>> diff --git a/fs/f2fs/dir.c b/fs/f2fs/dir.c
>> index e095a4f..d5a2c9e 100644
>> --- a/fs/f2fs/dir.c
>> +++ b/fs/f2fs/dir.c
>> @@ -375,6 +375,7 @@ put_error:
>>          /* once the failed inode becomes a bad inode, i_mode is S_IFREG */
>>          truncate_inode_pages(&inode->i_data, 0);
>>          truncate_blocks(inode, 0);
>> +       remove_dirty_dir_inode(inode);
>>   error:
>>          remove_inode_page(inode);
>>          return ERR_PTR(err);
> Yes, i have tested that case. Fail in init_inode_metadata has been processed correctly. Thanks.

If no other regressions, maybe you can send out the fix patch about this issue.:)

Thanks,
Gu

> 



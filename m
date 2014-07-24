Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758748AbaGXGAF (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Jul 2014 02:00:05 -0400
Received: from mailhub.sw.ru ([195.214.232.25]:16449 "EHLO relay.sw.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750904AbaGXGAD (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Jul 2014 02:00:03 -0400
Message-ID: <53D0A0CC.9070506@parallels.com>
Date: Thu, 24 Jul 2014 09:59:40 +0400
From: Vasily Averin <vvs@parallels.com>
Organization: Parallels
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130329 Thunderbird/17.0.5
MIME-Version: 1.0
CC: Alexander Viro <viro@zeniv.linux.org.uk>, linux-fsdevel@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        Richard Weinberger <richard.weinberger@gmail.com>
Subject: Re: [PATCH  v4] fs: umount on symlink leaks mnt count
References: <CAFLxGvxf_bsLNKRtt05zgkdHy+7ALWMz29QUG=f9UwTcqXetfg@mail.gmail.com>  <cover.1405859651.git.vvs@openvz.org> <53CCCF9F.6090301@parallels.com> <1406095603.2509.11.camel@perseus.fritz.box>
In-Reply-To: <1406095603.2509.11.camel@perseus.fritz.box>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
To: unlisted-recipients:; (no To-header on input)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

CVE-2014-5045 was assigned for this issue

On 07/23/2014 10:06 AM, Ian Kent wrote:
> On Mon, 2014-07-21 at 12:30 +0400, Vasily Averin wrote:
>> Currently umount on symlink blocks following umount:
>>
>> /vz is separate mount
>>
>> # ls /vz/ -al | grep test
>> drwxr-xr-x.  2 root root       4096 Jul 19 01:14 testdir
>> lrwxrwxrwx.  1 root root         11 Jul 19 01:16 testlink -> /vz/testdir
>> # umount -l /vz/testlink
>> umount: /vz/testlink: not mounted (expected)
>>
>> # lsof /vz
>> # umount /vz
>> umount: /vz: device is busy. (unexpected)
>>
>> In this case mountpoint_last() gets an extra refcount on path->mnt
>>
>> Signed-off-by: Vasily Averin <vvs@openvz.org>
> 
> Acked-by: Ian Kent <raven@themaw.net>


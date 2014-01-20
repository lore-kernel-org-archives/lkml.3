Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753261AbaATLdu (ORCPT <rfc822;w@1wt.eu>);
	Mon, 20 Jan 2014 06:33:50 -0500
Received: from relay.parallels.com ([195.214.232.42]:41081 "EHLO
	relay.parallels.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751905AbaATLdp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 20 Jan 2014 06:33:45 -0500
Message-ID: <52DD0991.2000905@parallels.com>
Date: Mon, 20 Jan 2014 15:33:37 +0400
From: Maxim Patlasov <mpatlasov@parallels.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.1.0
MIME-Version: 1.0
To: Miklos Szeredi <miklos@szeredi.hu>
CC: <dev@parallels.com>, <xemul@parallels.com>,
        <fuse-devel@lists.sourceforge.net>, <bfoster@redhat.com>,
        <linux-kernel@vger.kernel.org>, <jbottomley@parallels.com>,
        <linux-fsdevel@vger.kernel.org>, <akpm@linux-foundation.org>,
        <fengguang.wu@intel.com>, <devel@openvz.org>
Subject: Re: [PATCH 05/11] fuse: Trust kernel i_mtime only -v2
References: <20131010130718.10089.6736.stgit@dhcp-10-30-17-2.sw.ru> <20131010131051.10089.62357.stgit@dhcp-10-30-17-2.sw.ru> <20131112165251.GA10813@tucsk.piliscsaba.szeredi.hu> <52BC4E35.8040503@parallels.com> <20140106162242.GE16230@tucsk.piliscsaba.szeredi.hu>
In-Reply-To: <20140106162242.GE16230@tucsk.piliscsaba.szeredi.hu>
Content-Type: text/plain; charset="ISO-8859-1"; format=flowed
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.30.28.216]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 01/06/2014 08:22 PM, Miklos Szeredi wrote:
> On Thu, Dec 26, 2013 at 07:41:41PM +0400, Maxim Patlasov wrote:
>>>> +
>>>> +	if (!err)
>>>> +		clear_bit(FUSE_I_MTIME_DIRTY, &fi->state);
>>> Doing the test and the clear separately opens a huge race window when i_mtime
>>> modifications are bound to get lost.
>> No. Because the whole operation is protected by i_mutex (see
>> fuse_fsync_common()).
> fuse_release_common() doesn't have i_mutex.  It's probably safe to acquire it,
> but is that really needed?

No, that's not needed, I think. Because by the time of calling 
fuse_release(), file->f_count is already zero and no userspace activity 
is possible on the file.

Are you OK about -v3 version of the patch (sent 12/26/2013)?

Thanks,
Maxim

>
> Thanks,
> Miklos
>


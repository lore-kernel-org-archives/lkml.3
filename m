Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756009AbaHYP1f (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 Aug 2014 11:27:35 -0400
Received: from relay.parallels.com ([195.214.232.42]:48995 "EHLO
	relay.parallels.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755942AbaHYP1d (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 Aug 2014 11:27:33 -0400
Message-ID: <53FB55E3.1050806@parallels.com>
Date: Mon, 25 Aug 2014 19:27:31 +0400
From: Maxim Patlasov <mpatlasov@parallels.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.6.0
MIME-Version: 1.0
To: Miklos Szeredi <miklos@szeredi.hu>
CC: fuse-devel <fuse-devel@lists.sourceforge.net>,
        Anand Avati <avati@gluster.org>,
        Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 4/6] fuse: enable close_wait synchronous release
References: <20140821160304.11005.15166.stgit@localhost.localdomain>	<20140821160855.11005.86653.stgit@localhost.localdomain> <CAJfpegteyt_+g59skASpubFBSgs-c8XoOG-3Y+coKyr1nvyKfw@mail.gmail.com>
In-Reply-To: <CAJfpegteyt_+g59skASpubFBSgs-c8XoOG-3Y+coKyr1nvyKfw@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.30.22.200]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 08/22/2014 06:04 PM, Miklos Szeredi wrote:
> On Thu, Aug 21, 2014 at 6:09 PM, Maxim Patlasov <MPatlasov@parallels.com> wrote:
>> The patch enables the feature by passing 'true' to fuse_file_put in
>> fuse_release_common.
>>
>> Previously, this was safe only in special cases when we sure that
>> multi-threaded userspace won't deadlock if we'll synchronously send
>> FUSE_RELEASE in the context of read-ahead or write-back callback. Now, it's
>> always safe because callbacks don't send requests to userspace anymore.
> But we do want to make this privileged, as there are unlikely but
> possible DoS scenarios with a sync release.

The latest patch of the set implements DISABLE_SYNC_RELEASE mount 
option. We can instrument fusermount to use the option by default for 
unprivileged mounts (allowing system administrator to configure it like 
"user_allow_other"). Do you have a better way to implement DoS 
protection in mind?

Thanks,
Maxim

Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753680Ab3BRPP4 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Feb 2013 10:15:56 -0500
Received: from mail-oa0-f43.google.com ([209.85.219.43]:56522 "EHLO
	mail-oa0-f43.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752984Ab3BRPPz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Feb 2013 10:15:55 -0500
MIME-Version: 1.0
In-Reply-To: <878v6lzmzk.fsf@devron.myhome.or.jp>
References: <1350138661-2454-1-git-send-email-linkinjeon@gmail.com>
	<1360810114.1727.306.camel@jesse>
	<CAKYAXd9qmDYivsJduT3bFD2vPOc0DQ0f8RQTxQ7MXXTCQMMQQA@mail.gmail.com>
	<1360825669.1727.337.camel@jesse>
	<CAKYAXd9tVzvP_Oa+BoUwKbpaMoVZKZgesDgrLirqoyk6AHrJ2A@mail.gmail.com>
	<1360900178.1727.393.camel@jesse>
	<87fw0t26qu.fsf@devron.myhome.or.jp>
	<CAKYAXd-DSo1R7zgu81vc9ckke+5doeEd2QPwqHt54OF-VZo34Q@mail.gmail.com>
	<878v6lzmzk.fsf@devron.myhome.or.jp>
Date: Tue, 19 Feb 2013 00:15:54 +0900
Message-ID: <CAKYAXd94jVs4SMdVUEsnsYjApru=+8cWFmXO3L_NAvwM1ge6cw@mail.gmail.com>
Subject: Re: Read support for fat_fallocate()? (was [v2] fat: editions to
 support fat_fallocate())
From: Namjae Jeon <linkinjeon@gmail.com>
To: OGAWA Hirofumi <hirofumi@mail.parknet.co.jp>
Cc: Andrew Bartlett <abartlet@samba.org>, linux-kernel@vger.kernel.org,
        Ravishankar N <cyberax82@gmail.com>,
        Amit Sahrawat <amit.sahrawat83@gmail.com>,
        Nam-Jae Jeon <namjae.jeon@samsung.com>,
        Ravishankar N <ravi.n1@samsung.com>,
        Amit Sahrawat <a.sahrawat@samsung.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2013/2/18 OGAWA Hirofumi <hirofumi@mail.parknet.co.jp>:
> Namjae Jeon <linkinjeon@gmail.com> writes:
>
>>> Hm. My concerns are compatibility and reliability. Although We can
>>> change on-disk format if need, but I don't think it can be compatible
>>> and reliable. If so, who wants to use it? I feel there is no reason to
>>> use FAT if there is no compatible.
>>>
>>> Well, anyway, possible solution would be, we can pre-allocate physical
>>> blocks via fallocate(2) or something, but discard pre-allocated blocks
>>> at ->release() (or before unmount at least). This way would have
>>> compatibility (no on-disk change over unmount) and possible breakage
>>> would be same with normal extend write patterns on kernel crash
>>> (i.e. Windows or fsck will truncate after i_size).
>> Hi OGAWA.
>> We don't need to consider device unplugging case ?
>> If yes, I can rework fat fallocate patch as your suggestion.
>
> In my suggestion, I think, kernel crash or something like unplugging
> cases handles has no change from current way.
>
> Any pre-allocated blocks are truncated by fsck as inconsistency state,
> like crash before updating i_size for normal extend write.  I.e. across
> unmount, nobody care whether pre-allocated or not. IOW, if there is
> inconsistent between i_size and cluster chain (includes via
> fallocate(2)) across unmount, it should be handled as broken state.
>
> In short, the lifetime of pre-allocated blocks are from fallocate(2) to
> ->release() only.
Okay, I will post updated fat fallocate patch after looking into more.
Thanks.
>
> Thanks.
> --
> OGAWA Hirofumi <hirofumi@mail.parknet.co.jp>

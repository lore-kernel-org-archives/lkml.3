Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752611Ab3GAGTf (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Jul 2013 02:19:35 -0400
Received: from mail.parknet.co.jp ([210.171.160.6]:49246 "EHLO
	mail.parknet.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752446Ab3GAGTe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Jul 2013 02:19:34 -0400
From: OGAWA Hirofumi <hirofumi@mail.parknet.co.jp>
To: bintian.wang@linaro.org
Cc: linux-kernel@vger.kernel.org, Mike Lockwood <lockwood@android.com>,
        dmitry pervushin <dpervushin@gmail.com>,
        Colin Cross <ccross@android.com>,
        Android Kernel Team <kernel-team@android.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        John Stultz <john.stultz@linaro.org>
Subject: Re: [PATCH RFC] Add FAT_IOCTL_GET_VOLUME_ID
References: <1372646398-4204-1-git-send-email-bintian.wang@linaro.org>
	<87wqpakdvd.fsf@devron.myhome.or.jp>
Date: Mon, 01 Jul 2013 15:19:31 +0900
In-Reply-To: <87wqpakdvd.fsf@devron.myhome.or.jp> (OGAWA Hirofumi's message of
	"Mon, 01 Jul 2013 15:12:22 +0900")
Message-ID: <87sizykdjg.fsf@devron.myhome.or.jp>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/24.3.50 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

OGAWA Hirofumi <hirofumi@mail.parknet.co.jp> writes:

>> +	case FAT_IOCTL_GET_VOLUME_ID:
>> +		id = fat_ioctl_volume_id(inode);
>> +		return copy_to_user((unsigned int *)arg, &id, sizeof(id));
>
>> +	case FAT_IOCTL_GET_VOLUME_ID:
>> +		id = fat_ioctl_volume_id(inode);
>> +		return copy_to_user((unsigned int *)arg, &id, sizeof(id));
>
> This pattern seems to from put_user().
>
> Unnecessary cast of 1st arg. And copy_to_user() returns remaining bytes
> when fail (not error code).

Ah, actually, this needs cast, but it is to annotate for sparse. Well,
is there any reason to restrict this only on the directory?

For now, fat_generic_ioctl() looks easier way to do this.
(fat_generic_ioctl() should work for the both of compat code and dir/file)

Thanks.
-- 
OGAWA Hirofumi <hirofumi@mail.parknet.co.jp>

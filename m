Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752742Ab3LQDQH (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Dec 2013 22:16:07 -0500
Received: from m59-178.qiye.163.com ([123.58.178.59]:52560 "EHLO
	m59-178.qiye.163.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752026Ab3LQDQF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Dec 2013 22:16:05 -0500
Message-ID: <52AFC020.10403@ubuntukylin.com>
Date: Tue, 17 Dec 2013 11:08:16 +0800
From: Li Wang <liwang@ubuntukylin.com>
User-Agent: Mozilla/5.0 (Windows NT 6.1; rv:24.0) Gecko/20100101 Thunderbird/24.1.1
MIME-Version: 1.0
To: Cong Wang <xiyou.wangcong@gmail.com>
CC: Alexander Viro <viro@zeniv.linux.org.uk>, Sage Weil <sage@inktank.com>,
        linux-fsdevel@vger.kernel.org, linux-mm@kvack.org,
        LKML <linux-kernel@vger.kernel.org>,
        Yunchuan Wen <yunchuanwen@ubuntukylin.com>
Subject: Re: [PATCH 0/5] VFS: Directory level cache cleaning
References: <cover.1387205337.git.liwang@ubuntukylin.com> <CAM_iQpUSX1yX9SMvUnbwZ7UkaBMUheOEiZNaSb4m8gWBQzzGDQ@mail.gmail.com>
In-Reply-To: <CAM_iQpUSX1yX9SMvUnbwZ7UkaBMUheOEiZNaSb4m8gWBQzzGDQ@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-HM-Spam-Status: e1koWUFPN1dZCBgUCR5ZQUlIVUNLQkJCQk9NTkJPSUhDSFdZCQ4XHghZQV
	koKz0kKDQ9Lz06MjckMjUkMz46Pz4pQUtVS0A2IyQiPigkMjUkMz46Pz4pQUtVS0ArLykkNTQkMj
	UkMz46Pz4pQUlVS0A4NC41LykiJDg1QUtVS0ApPjwyNDUkOigyOkFLVUtAKyk0LTI1OD4kMy41Oj
	VBS1VLQD8iNTo2MjgkMiskNTQkMjUkMz46Pz4pQUtVS0ApPjo3JDIrJDI1JCk5NyQyNSQzPjo*Pi
	lBSklVS0A2LjcvMiQpOCsvJD8yPT0#KT41LyQyNSQzPjo*PilBSVVLQDIrJC80PzoiJDg1LyRLJE
	pLS0FLVUtAMiskTiQ2MjUuLz4kODUvJEskSktBS1VLQDIrJEokNjI1Li8#JDg1LyRLJEpLQUtVS0
	AyKyRKJDM0LikkODUvJEskSktLQUtVS0AyKyRISyQ2MjUuLz4kODUvJEskTktBS1VLQDU0LyQ9Oj
	Y0LigkPzQ2OjI1JCgrPSQ9OjI3QUpLVUtAPTUkNjoiJE9KQiQzNzEkSiRLQ0tIS09BS1VISEA9Ky
	QpPiQ9LCQzNzEkS0NLSEtNQVZMVU5AKC45JD5BSlVOTkA9NSQoLjkkPjUsNCk*KCQzNzEkSktLSU
	tKQUtVSUNAPTUkOTIvTCQzNzEkS0xKSUtJQUhVSk5ZBg++
X-HM-Sender-Digest: e1kSHx4VD1lBWUc6MQg6Cjo4LDo4EDorKjhIOj4qOkMwCjFVSlVKSENM
	SU9CTEtLTUJNVTMWGhIXVRcSDBoVHDsOGQ4VDw4QAhcSFVUYFBZFWVdZDB4ZWUEdGhcIHldZCAFZ
	QUlOQ0s3V1kSC1lBWU1KVUpDTFVOT1VCWQY+
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

As far as we know, fadvise(DONTNEED) does not support metadata
cache cleaning. We think that is desirable under massive small files
situations. Another thing is that do people accept the behavior
of feeding a directory fd to fadvise will recusively clean all
page caches of files inside that directory?

On 2013/12/17 1:45, Cong Wang wrote:
> On Mon, Dec 16, 2013 at 7:00 AM, Li Wang <liwang@ubuntukylin.com> wrote:
>> This patch extend the 'drop_caches' interface to
>> support directory level cache cleaning and has a complete
>> backward compatibility. '{1,2,3}' keeps the same semantics
>> as before. Besides, "{1,2,3}:DIRECTORY_PATH_NAME" is allowed
>> to recursively clean the caches under DIRECTORY_PATH_NAME.
>> For example, 'echo 1:/home/foo/jpg > /proc/sys/vm/drop_caches'
>> will clean the page caches of the files inside 'home/foo/jpg'.
>>
>
> This interface is ugly...
>
> And we already have a file-level drop cache, that is,
> fadvise(DONTNEED). Can you extend it if it can't
> handle a directory fd?
>

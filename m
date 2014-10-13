Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754501AbaJMU0W (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Oct 2014 16:26:22 -0400
Received: from mail-wi0-f181.google.com ([209.85.212.181]:55993 "EHLO
	mail-wi0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751860AbaJMU0U (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 Oct 2014 16:26:20 -0400
From: Dmitry Monakhov <dmonakhov@openvz.org>
To: Jens Axboe <axboe@fb.com>, linux-kernel@vger.kernel.org
Cc: keith.busch@intel.com
Subject: Re: [PATCH] block: update locking context for blk_free_devt
In-Reply-To: <543C33B1.2010700@fb.com>
References: <1413225357-18981-1-git-send-email-dmonakhov@openvz.org> <543C33B1.2010700@fb.com>
User-Agent: Notmuch/0.18.1 (http://notmuchmail.org) Emacs/24.3.1 (x86_64-redhat-linux-gnu)
Date: Tue, 14 Oct 2014 00:26:10 +0400
Message-ID: <8738arra1p.fsf@openvz.org>
MIME-Version: 1.0
Content-Type: multipart/signed; boundary="=-=-=";
	micalg=pgp-sha1; protocol="application/pgp-signature"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--=-=-=
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

Jens Axboe <axboe@fb.com> writes:

> On 2014-10-13 12:35, Dmitry Monakhov wrote:
>> After 2da78092 this function will not longer sleepy
>>
>> Signed-off-by: Dmitry Monakhov <dmonakhov@openvz.org>
>> ---
>>   block/genhd.c |    4 +---
>>   1 files changed, 1 insertions(+), 3 deletions(-)
>>
>> diff --git a/block/genhd.c b/block/genhd.c
>> index 09da5e4..ae9aaa5 100644
>> --- a/block/genhd.c
>> +++ b/block/genhd.c
>> @@ -441,12 +441,10 @@ int blk_alloc_devt(struct hd_struct *part, dev_t *=
devt)
>>    * Free @devt which was allocated using blk_alloc_devt().
>>    *
>>    * CONTEXT:
>> - * Might sleep.
>> + * Don't care.
>>    */
>>   void blk_free_devt(dev_t devt)
>>   {
>> -	might_sleep();
>> -
>>   	if (devt =3D=3D MKDEV(0, 0))
>>   		return;
>
> What's this against? The might_sleep() was killed about a month ago by=20
> commit 46f341ffcfb5. The comment wasn't updated though, it should be.
Against 764f612c6c3c23  linux-block/for-next.
I've found this during development other blockdev related feature.
can you please point what is your development branch.
>
> --=20
> Jens Axboe

--=-=-=
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1

iQIcBAEBAgAGBQJUPDViAAoJEFzOBSYIXfveoQkP/RXFQuoCDjsXcFOsantTslbl
8U33wO6KvruBmFdEkTBlgbBbD1ios6Z5NO5kGM7dgeAHDWB5+55P41AdWZZEtI2w
VKOt4JbO9ETVhdyOGGIu4kHGq4OaWppIl3QIAyKoNPtWY98f9Rd02Kie6iL7aVKJ
RgCD3swq7pKl7ty+rzoFC0/YNiDObctVTDFTNNBf5DSBU2vrqPYcMeDtITULGBHs
cM7SrcutkGD6UrPvgGiis1d7zo5bHz5bjld7Yz9iTE653wusbprjbiMxs/37OdqW
185I9FzZfcHTfARV/ZxOuWlC544G+OpqtiiQMHrZdgaghIjAgUOa7bExobDtW3x/
N87+Q9oKYpkF03F2ZznUGsGxx8lR8zoZAJPb6KdwkXqwAL/LCoe6li/si6/6hfvy
tUumCZGjEMGscSPRguUSNtrtCXAONqoph8l8XIybs9THNRIJXh51glwF01ZPZeS2
Kqlp3HcPtoggZGCVBiyS/QffHEC9FQCy0VkK6Y5DGvAcwYIoauPn7h6cFl6SFKf9
TR5GmCSh5C1xg2dqTHDlb3io/6hrs12BrxOhFOZsWXcASUGp+kipvSaiSxhVE2Oe
lzwagUF0EwJ7NCpkmrSjd6jSQyRKP4BqAMtyCwccYZDYej+1pys4ptKRR8Y+wDwV
sZ9MRAWWkB1OXT5tpsmC
=VByx
-----END PGP SIGNATURE-----
--=-=-=--

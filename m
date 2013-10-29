Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753204Ab3J2U76 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Oct 2013 16:59:58 -0400
Received: from mail-ie0-f178.google.com ([209.85.223.178]:54910 "EHLO
	mail-ie0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752862Ab3J2U74 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Oct 2013 16:59:56 -0400
MIME-Version: 1.0
In-Reply-To: <CAGG-pUTqVk5JkhWDU6-EicWzQT-rhiXBuXRm6uPmVSVifQ_FzQ@mail.gmail.com>
References: <1381184340-11190-1-git-send-email-geyslan@gmail.com>
	<1381185204.2081.221.camel@joe-AO722>
	<CAGG-pURYyCV4waC8Z+5qAd1mAB2ZHhEkRaGspFuyEDrvj_dTdQ@mail.gmail.com>
	<1381191145.2081.230.camel@joe-AO722>
	<CAGG-pUQJCGcY=hAobBodH-dTLLohUpe6KJbuMvwWkhdt3RSk+A@mail.gmail.com>
	<CAFkjPTmFOkw5n964zGuiON1oLSy1CsPQQ8TrGNho6L-+M5Z7SA@mail.gmail.com>
	<CAGG-pUTHAnPOiX0n6FjbkhtFeiOY-704_rEvrhkzo4uv1rQ=hA@mail.gmail.com>
	<CAGG-pUTfWiVznsKkQH0bBiHgbi+waHNw0zmoTMVk4pVJGPUN_A@mail.gmail.com>
	<CAGG-pUQyB_4ivOvJWvq_5p-o-5vOC6srNVRk0GAvqqG-PVGMrQ@mail.gmail.com>
	<CAFkjPTm_JhrWVzk0njqaUwpn5RxqYgRWYV2ZvPyrYoFKZHkgog@mail.gmail.com>
	<CAGG-pURzs512=6zu2_vBz5vtJu3Dm8hsdV=qZuUa5GJng6Eceg@mail.gmail.com>
	<CAGG-pUTqVk5JkhWDU6-EicWzQT-rhiXBuXRm6uPmVSVifQ_FzQ@mail.gmail.com>
Date: Tue, 29 Oct 2013 18:59:55 -0200
Message-ID: <CAGG-pUTQgToxUcQkPkE6T9LA2jWvx5DcPq=E_H0XhLJRsPckYQ@mail.gmail.com>
Subject: Re: [PATCH] 9p: unsigned/signed wrap in p9/unix modes.
From: =?ISO-8859-1?Q?Geyslan_Greg=F3rio_Bem?= <geyslan@gmail.com>
To: Eric Van Hensbergen <ericvh@gmail.com>
Cc: Joe Perches <joe@perches.com>, Ron Minnich <rminnich@sandia.gov>,
        Latchesar Ionkov <lucho@ionkov.net>,
        V9FS Developers <v9fs-developer@lists.sourceforge.net>,
        linux-kernel <linux-kernel@vger.kernel.org>,
        kernel-br <kernel-br@googlegroups.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2013/10/28 Geyslan Gregório Bem <geyslan@gmail.com>:
> 2013/10/28 Geyslan Gregório Bem <geyslan@gmail.com>
>>
>> 2013/10/27 Eric Van Hensbergen <ericvh@gmail.com>
>>>
>>> Looks like the right approach.  The one other optional thing I mentioned was support for passing NULL for rdev and not trying to parse the device info when rdev == NULL.  Its a very slight optimization in the grand scheme of things, but would seem to be cleaner for the folks calling the function who don't touch rdev after the fact...
>>>
>>>      -eric
>>>
>> Great. Let me do the changes this afternoon.
>>
>>
> Hi Eric and all.
>
> You requested to avoid the parsing of device when rdev is NULL, all
> right? But I'm afraid that that manner the res (return value) can be
> returned wrong when the bit mode is a device. Well, I did some
> changes. In this new approach, when rdev is NULL, the function only
> doesn't make the device, but returns the res (umode_t) nicely.
>
> Tell me if this approach is correct. Do I have to modify something else?
>
> --
> Regards,
>
> Geyslan G. Bem
> hackingbits.com

Eric, I sent the new patch:
[PATCH] 9p: code refactor in vfs_inode.c

-- 
Regards,

Geyslan G. Bem
hackingbits.com

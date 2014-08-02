Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751041AbaHBXNs (ORCPT <rfc822;w@1wt.eu>);
	Sat, 2 Aug 2014 19:13:48 -0400
Received: from mail-oi0-f44.google.com ([209.85.218.44]:53003 "EHLO
	mail-oi0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750780AbaHBXNq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 2 Aug 2014 19:13:46 -0400
MIME-Version: 1.0
In-Reply-To: <1407000807.1835.14.camel@joe-AO725>
References: <1406413711-7798-1-git-send-email-rickard_strandqvist@spectrumdigital.se>
 <CADT32eLts-tdQdHo+W3Zc1wQ6Qz8aS3TmHsm8OxmiF2fmhOW5g@mail.gmail.com> <1407000807.1835.14.camel@joe-AO725>
From: Rickard Strandqvist <rickard_strandqvist@spectrumdigital.se>
Date: Sun, 3 Aug 2014 01:13:25 +0200
Message-ID: <CAFo99gZrTd5+Z_XK+CmhF8ROPZSLGZvwzuwQSwFz5_kGHTAn8w@mail.gmail.com>
Subject: Re: [PATCH] fs: cifs: cifsencrypt.c: Cleaning up missing
 null-terminate in conjunction with strncpy
To: Joe Perches <joe@perches.com>
Cc: Shirish Pargaonkar <shirishpargaonkar@gmail.com>,
        Steve French <sfrench@samba.org>,
        linux-cifs <linux-cifs@vger.kernel.org>,
        samba-technical <samba-technical@lists.samba.org>,
        LKML <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2014-08-02 19:33 GMT+02:00 Joe Perches <joe@perches.com>:
> On Sat, 2014-08-02 at 11:55 -0500, Shirish Pargaonkar wrote:
>> Acked-by: Shirish Pargaonkar <spargaonkar@suse.com>
> []
>> > diff --git a/fs/cifs/cifsencrypt.c b/fs/cifs/cifsencrypt.c
> []
>> > @@ -307,7 +307,7 @@ int calc_lanman_hash(const char *password, const char *cryptkey, bool encrypt,
>> >
>> >         memset(password_with_pad, 0, CIFS_ENCPWD_SIZE);
>> >         if (password)
>> > -               strncpy(password_with_pad, password, CIFS_ENCPWD_SIZE);
>> > +               strncpy(password_with_pad, password, CIFS_ENCPWD_SIZE - 1);
>
>
> Is this always correct?


Hi

Because password_with_pad gets set to all zeros above, the character,
I do not guarantee a copy terminating null.
Unless it is so that you do not want any terminating null.


Kind regards
Rickard Strandqvist

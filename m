Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751724AbaESUuE (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 May 2014 16:50:04 -0400
Received: from mail-vc0-f176.google.com ([209.85.220.176]:37487 "EHLO
	mail-vc0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750754AbaESUuC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 May 2014 16:50:02 -0400
MIME-Version: 1.0
In-Reply-To: <20140519091650.GS15585@mwanda>
References: <1400385604-21086-1-git-send-email-matlackdavid@gmail.com>
 <1400385604-21086-2-git-send-email-matlackdavid@gmail.com> <20140519091650.GS15585@mwanda>
From: David Matlack <matlackdavid@gmail.com>
Date: Mon, 19 May 2014 13:49:41 -0700
Message-ID: <CANoiuGLzE=xbNjsFEsm9RAJrtEcGkd0rTy9t8ODzYEsGMUmNUQ@mail.gmail.com>
Subject: Re: [PATCH 1/2] staging: slicoss: rewrite eeprom checksum code
To: Dan Carpenter <dan.carpenter@oracle.com>
Cc: gregkh@linuxfoundation.org, devel@driverdev.osuosl.org,
        charrer@alacritech.com, linux-kernel@vger.kernel.org,
        Lior Dotan <liodot@gmail.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, May 19, 2014 at 2:16 AM, Dan Carpenter <dan.carpenter@oracle.com> wrote:
> This patch is great, thanks, don't resend.  But I wish the subject said
> "fix" instead of "rewrite".  I was expecting it to just be a cleanup.
>
> It helps a lot if `git log --oneline` says which patches should be
> backported.
>
> regards,
> dan carpenter
>

Thanks for the review Dan. I know you said not resend but I'd like to clean up
the patch a bit if you don't mind:

* Add a comment making it clear this is RFC 1071

* Remove the byte swapping code. Specifically,

+       if ((unsigned long) eeprom & 1) {
+               leading_byte = bp;
+               bp++;
        }

and

+       if (leading_byte) {
+               checksum = __reduce(checksum);
+               checksum <<= 8;
+
+               final_word = *leading_byte;
+               if (trailing_byte)
+                       final_word |= *trailing_byte << 8;
+       }

  After reading the RFC [1], I don't think the it's correct in either
  implementation (the bytes in the final result are in the wrong order). And
  since this function is only used to checksum the eeprom, and not checksum a
  fragment of a IP packet, it's not needed. So we can just remove it.

* s/rewrite/fix/ in the subject

[1] http://tools.ietf.org/html/rfc1071 (see Section 2.(A) and 2.(B))

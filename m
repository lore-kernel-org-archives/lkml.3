Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753384AbaDDWEU (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 Apr 2014 18:04:20 -0400
Received: from mail-ve0-f177.google.com ([209.85.128.177]:40605 "EHLO
	mail-ve0-f177.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752849AbaDDWER (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 Apr 2014 18:04:17 -0400
MIME-Version: 1.0
In-Reply-To: <20140403131143.69f324c7@samsung.com>
References: <20140403131143.69f324c7@samsung.com>
Date: Fri, 4 Apr 2014 15:04:16 -0700
X-Google-Sender-Auth: 8vp0M2c9_giXTFOImMu7v4ENIf0
Message-ID: <CA+55aFz8+kgRAm9Oozkcaa+diL_6OEP=M4wr7j5z-HTOg-2O=g@mail.gmail.com>
Subject: Re: [GIT PULL for v3.15-rc1] media updates
From: Linus Torvalds <torvalds@linux-foundation.org>
To: Mauro Carvalho Chehab <m.chehab@samsung.com>,
        Hans Verkuil <hans.verkuil@cisco.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,
        Linux Media Mailing List <linux-media@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Apr 3, 2014 at 9:11 AM, Mauro Carvalho Chehab
<m.chehab@samsung.com> wrote:
>
> Please pull from:
>   git://git.kernel.org/pub/scm/linux/kernel/git/mchehab/linux-media v4l_for_linus

Oh, just noticed that this seems to be the cause of a new annoying warning:

   usr/include/linux/v4l2-common.h:72: found __[us]{8,16,32,64} type
without #include <linux/types.h>

which seems to have come in through commits 777f4f85b75f1 and 254a47770163f.

I think the proper fix is to just add that

  #include <linux/types.h>

to include/uapi/linux/v4l2-common.h. Assuming that really is supposed
to be a user-visible API at all?

              Linus

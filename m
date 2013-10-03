Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754150Ab3JCNNU (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Oct 2013 09:13:20 -0400
Received: from services.gouders.net ([141.101.32.176]:51653 "EHLO
	services.gouders.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752347Ab3JCNNS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Oct 2013 09:13:18 -0400
From: Dirk Gouders <dirk@gouders.net>
To: Martin Walch <walch.martin@web.de>
Cc: "Yann E. MORIN" <yann.morin.1998@free.fr>, linux-kbuild@vger.kernel.org,
        Michal Marek <mmarek@suse.cz>, Jiri Kosina <trivial@kernel.org>,
        Arve =?utf-8?B?SGrDuG5uZXbDpWc=?= <arve@android.com>,
        Benjamin Poirier <bpoirier@suse.de>, Wang YanQing <udknight@gmail.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Jean Delvare <jdelvare@suse.de>, Kees Cook <keescook@chromium.org>,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 4/4] kconfig: remove unused definition from scanner
In-Reply-To: <1491733.iNaKkFyqph@tacticalops> (Martin Walch's message of "Thu,
	03 Oct 2013 02:30:21 +0200")
References: <6249343.9Mjtul3lu5@tacticalops> <ghk3hwjhqk.fsf@lena.gouders.net>
	<201310020857.54800.yann.morin.1998@free.fr>
	<1491733.iNaKkFyqph@tacticalops>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/23.4 (gnu/linux)
Date: Thu, 03 Oct 2013 15:13:09 +0200
Message-ID: <ghsiwia462.fsf@lena.gouders.net>
MIME-Version: 1.0
Content-Type: multipart/mixed; boundary="=-=-="
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--=-=-=

Martin Walch <walch.martin@web.de> writes:

> On Wednesday 02 October 2013 08:57:54 Yann E. MORIN wrote:
>> On Wednesday 02 October 2013 08:42:59 Dirk Gouders wrote:
>> > I think you should also regenerate the scanner and add
>> > the new zconf.lex.c_shipped to this patch.
>> 
>> I think sending the re-generated parser as a separate patch helps
>> in reviewing. Ie. I'd prefer a fifth patch.
>> 
>> BTW, regenerating the parser can be done with:
>>     make REGENERATE_PARSERS=1 config
>
> Actually, I regenerated the scanner. However, the results did not change
> after applying the patch, because the definition that the patch removes
> (ws) is not used anywhere. It is only a cleanup.

Sorry, my review was too superficial.
I did downgrade my flex to see if your changes affect the scanner,
but I did not test it without your patch and also did not have a look in
what the changes are.

The changes I noticed here are probably related to the flex package I
use (on a Gentoo system) -- they even occur without your patch.  I'll
attach what I noticed in case someone is interested.

Dirk


--=-=-=
Content-Disposition: inline; filename=zconf.lex.c_shipped.patch
Content-Description: zconf.lex.c_shipped.patch

diff --git a/scripts/kconfig/zconf.lex.c_shipped b/scripts/kconfig/zconf.lex.c_shipped
index a0521aa..3eb4c0b 100644
--- a/scripts/kconfig/zconf.lex.c_shipped
+++ b/scripts/kconfig/zconf.lex.c_shipped
@@ -920,7 +920,7 @@ static int input (void );
 /* This used to be an fputs(), but since the string might contain NUL's,
  * we now use fwrite().
  */
-#define ECHO do { if (fwrite( zconftext, zconfleng, 1, zconfout )) {} } while (0)
+#define ECHO fwrite( zconftext, zconfleng, 1, zconfout )
 #endif
 
 /* Gets input and stuffs it into "buf".  number of characters read, or YY_NULL,

--=-=-=--

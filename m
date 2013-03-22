Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932928Ab3CVNvs (ORCPT <rfc822;w@1wt.eu>);
	Fri, 22 Mar 2013 09:51:48 -0400
Received: from mail3-relais-sop.national.inria.fr ([192.134.164.104]:56055
	"EHLO mail3-relais-sop.national.inria.fr" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751724Ab3CVNvq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 22 Mar 2013 09:51:46 -0400
X-Greylist: delayed 597 seconds by postgrey-1.27 at vger.kernel.org; Fri, 22 Mar 2013 09:51:46 EDT
X-IronPort-AV: E=Sophos;i="4.84,891,1355094000"; 
   d="scan'208";a="7475638"
Date: Fri, 22 Mar 2013 14:41:47 +0100
From: Samuel Thibault <samuel.thibault@ens-lyon.org>
To: Karel Zak <kzak@redhat.com>
Cc: linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org,
        util-linux@vger.kernel.org
Subject: Re: [ANNOUNCE] util-linux v2.23-rc1
Message-ID: <20130322134147.GA6125@type.bordeaux.inria.fr>
Mail-Followup-To: Samuel Thibault <samuel.thibault@ens-lyon.org>,
	Karel Zak <kzak@redhat.com>, linux-kernel@vger.kernel.org,
	linux-fsdevel@vger.kernel.org, util-linux@vger.kernel.org
References: <20130322125621.GA6278@x2.net.home>
MIME-Version: 1.0
Content-Type: multipart/mixed; boundary="ibTvN161/egqYuK8"
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20130322125621.GA6278@x2.net.home>
User-Agent: Mutt/1.5.21+34 (58baf7c9f32f) (2010-12-30)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--ibTvN161/egqYuK8
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit

Hello,

Karel Zak, le Fri 22 Mar 2013 13:56:21 +0100, a écrit :
> The util-linux release v2.23-rc1 is available at
>  
>    ftp://ftp.kernel.org/pub/linux/utils/util-linux/v2.23
>     
> Feedback and bug reports, as always, are welcomed.

Here is a couple of obvious fixes for non-linux systems.

Samuel

--ibTvN161/egqYuK8
Content-Type: text/plain; charset=us-ascii
Content-Disposition: attachment; filename=patch

diff --git a/login-utils/sulogin.c b/login-utils/sulogin.c
index db5f41e..621df1e 100644
--- a/login-utils/sulogin.c
+++ b/login-utils/sulogin.c
@@ -118,7 +118,9 @@ static void tcinit(struct console *con)
 		cfsetispeed(tio, ispeed);
 		cfsetospeed(tio, ospeed);
 
+#ifdef HAVE_STRUCT_TERMIOS_C_LINE
 		tio->c_line         = 0;
+#endif
 		tio->c_cc[VTIME]    = 0;
 		tio->c_cc[VMIN]     = 1;
 
@@ -198,7 +200,7 @@ static void tcfinal(struct console *con)
 	tio->c_cc[VEOF]     = CEOF;
 #ifdef VSWTC
 	tio->c_cc[VSWTC]    = _POSIX_VDISABLE;
-#else
+#elif defined(VSWTCH)
 	tio->c_cc[VSWTCH]   = _POSIX_VDISABLE;
 #endif
 	tio->c_cc[VSTART]   = CSTART;

--ibTvN161/egqYuK8--

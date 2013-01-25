Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754681Ab3AYXpb (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 Jan 2013 18:45:31 -0500
Received: from moutng.kundenserver.de ([212.227.126.187]:54213 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753547Ab3AYXp3 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 Jan 2013 18:45:29 -0500
From: Arnd Bergmann <arnd@arndb.de>
To: "Myklebust, Trond" <Trond.Myklebust@netapp.com>
Subject: Re: [PATCH 15/19] sunrpc: don't warn for unused variable 'buf'
Date: Fri, 25 Jan 2013 23:45:25 +0000
User-Agent: KMail/1.12.2 (Linux/3.8.0-1-generic; KDE/4.3.2; x86_64; ; )
Cc: "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "J. Bruce Fields" <bfields@redhat.com>,
        "linux-nfs@vger.kernel.org" <linux-nfs@vger.kernel.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>
References: <1359123276-15833-1-git-send-email-arnd@arndb.de> <1359153858-31992-16-git-send-email-arnd@arndb.de> <4FA345DA4F4AE44899BD2B03EEEC2FA91833C205@sacexcmbx05-prd.hq.netapp.com>
In-Reply-To: <4FA345DA4F4AE44899BD2B03EEEC2FA91833C205@sacexcmbx05-prd.hq.netapp.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="windows-1252"
Content-Transfer-Encoding: 8BIT
Message-Id: <201301252345.25829.arnd@arndb.de>
X-Provags-ID: V02:K0:nqv/CtIiVRxf8lDLWSJ9myN6YI9+jISjZSMt+/qPHrj
 Jk3LAvgEteNqg0hgm7iwz3W9gsm87SWqigVGK6jlXYomfbEPdZ
 3nzJIYuJVWwfMYTinfDD+SxKV8EYB2N6LRRozw71qnAo56eR4A
 EpZ0FrCnz59TTU8XnPHdDn7qAY0u0UAu0tb959/07Ubc9u1ItC
 uiidM879CMF+rHeKRcYKXGvk8DMHt4xcLtUk40dEfjV+INoOaH
 7L9gbgX5Zee8IOZjzapviE/c70j3U0PtQ04RNy2DW/1daoRKBx
 iAf7VDEJjAZQM2XPHPsy9W2wXYOUiI+ktjX2zHTNT7wKclc/+9
 LiJJpz661HFaI526Zc2k=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Friday 25 January 2013, Myklebust, Trond wrote:
> > -----Original Message-----
> > From: Arnd Bergmann [mailto:arnd@arndb.de]
> > Marking it as __maybe_unused avoids a harmless gcc warning.
> 
> Alternatively, just declare it using the RPC_IFDEBUG() macro.

Right, makes sense: that's more consistent with other functions
doing the same thing. Thanks for taking a look.

	Arnd

8<----

>From 3b2baeac061bd60dbf14bb61bcc03cbd64c85ac4 Mon Sep 17 00:00:00 2001
From: Arnd Bergmann <arnd@arndb.de>
Date: Mon, 26 Nov 2012 22:46:26 +0000
Subject: [PATCH] sunrpc: don't warn for unused variable 'buf'

When RPC_DEBUG is unset, the dprintk() macro does nothing,
causing the 'buf' variable in svc_printk to become unused.
Enclosing it in RPC_IFDEBUG avoids a harmless gcc warning.

Without this patch, building at91_dt_defconfig results in:

net/sunrpc/svc.c: In function 'svc_printk':
net/sunrpc/svc.c:1051:7: warning: unused variable 'buf' [-Wunused-variable]

Signed-off-by: Arnd Bergmann <arnd@arndb.de>
Cc: "J. Bruce Fields" <bfields@redhat.com>
Cc: Trond Myklebust <Trond.Myklebust@netapp.com>
Cc: linux-nfs@vger.kernel.org
Cc: netdev@vger.kernel.org

diff --git a/net/sunrpc/svc.c b/net/sunrpc/svc.c
index dbf12ac..9485e66 100644
--- a/net/sunrpc/svc.c
+++ b/net/sunrpc/svc.c
@@ -1047,7 +1047,7 @@ void svc_printk(struct svc_rqst *rqstp, const char *fmt, ...)
 {
 	struct va_format vaf;
 	va_list args;
-	char 	buf[RPC_MAX_ADDRBUFLEN];
+	RPC_IFDEBUG(char buf[RPC_MAX_ADDRBUFLEN]);
 
 	va_start(args, fmt);
 



Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753029AbbAJXyu (ORCPT <rfc822;w@1wt.eu>);
	Sat, 10 Jan 2015 18:54:50 -0500
Received: from plane.gmane.org ([80.91.229.3]:52013 "EHLO plane.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752782AbbAJXyt (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 10 Jan 2015 18:54:49 -0500
X-Injected-Via-Gmane: http://gmane.org/
Mail-Followup-To: linux-kernel@vger.kernel.org
To: linux-kernel@vger.kernel.org
From: rh_ <richard_hubbe11@lavabit.com>
Subject: Re: man-pages-3.77 is released
Date: Sat, 10 Jan 2015 15:52:24 -0800
Organization: L2N
Message-ID: <20150110155224.08c9a2c9@127>
References: <54B150D4.6060405@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Complaints-To: usenet@ger.gmane.org
X-Gmane-NNTP-Posting-Host: ip68-6-109-86.sb.sd.cox.net
User-Agent: dsodnetnin
X-Gmane-NNTP-Posting-Host: EZnn0.37p
Original-Received: from slem by 1.1 with local
X-No-Archive: yes
Archive: no
X-Archive: encrypt
X-Operating-System: Barebones_6.1
X-Gmane-NNTP-Posting-Host: 192.168.1.1
X-NNTP-Posting-Host: 192.168.1.1
Mail-Copies-To: never
X-Archive: expiry=79
X-Mailer: EZnn0.37u
X-Newsreader: EZnn0.37u
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 10 Jan 2015 17:18:28 +0100
"Michael Kerrisk (man-pages)" <mtk.manpages@gmail.com> wrote:

-snip 8< snip-

I did:

git clone git://git.kernel.org/pub/scm/docs/man-pages/man-pages.git
cd man-pages
make install prefix=/ssd42/man

The man pages do install but I get one error:

mktemp: cannot create temp file /tmp/manpages-checksXXXX: Invalid argument
for i in man?; do \
	install -d -m 755 /ssd42/man-pages/share/man/"$i" || exit $?; \
	install -m 644 "$i"/* /ssd42/man-pages/share/man/"$i" || exit $?; \
done; \


--- Makefile	2015-01-10 15:48:44.000000000 -0800
+++ Makefile.new	2015-01-10 15:48:35.000000000 -0800
@@ -57,7 +57,7 @@ install:
 
 # Check if groff reports warnings (may be words of sentances not displayed)
 # from http://lintian.debian.org/tags/manpage-has-errors-from-man.html 
-GROFF_LOG := $(shell mktemp /tmp/manpages-checksXXXX)
+GROFF_LOG := $(shell mktemp /tmp/manpages-checks.XXXXXX)
 check-groff-warnings:
 	for i in man?/*.[1-9]; \
 	do \




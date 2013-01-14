Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757318Ab3ANRqO (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Jan 2013 12:46:14 -0500
Received: from lihas.de ([87.106.212.181]:56532 "EHLO mx.lihas.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756495Ab3ANRqN (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Jan 2013 12:46:13 -0500
X-Greylist: delayed 566 seconds by postgrey-1.27 at vger.kernel.org; Mon, 14 Jan 2013 12:46:12 EST
Date: Mon, 14 Jan 2013 18:36:31 +0100
From: Christian Recktenwald <cre@lihas.de>
To: linux-kernel@vger.kernel.org
Subject: linux-firmware/Makefile - rm: cannot remove
 `/lib/firmware/{WHENCE,LICENSE.*,LICENCE.*}': No such file or directory
Message-ID: <20130114173631.GA16331@curtis.s.lihas.de>
Reply-To: Christian Recktenwald <cre@lihas.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
Organization: Adrian Reyer LinuxHaus Stuttgart
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Checked out commit 65a5163b8bb77bd7759efa3ca780867fcaed89b0

Makefile looks like:

  ...
  install:
		  mkdir -p $(DESTDIR)$(FIRMWAREDIR)
		  cp -r * $(DESTDIR)$(FIRMWAREDIR)
		  rm -f $(DESTDIR)/usbdux/*dux $(DESTDIR)/*/*.asm
		  rm $(DESTDIR)$(FIRMWAREDIR)/{WHENCE,LICENSE.*,LICENCE.*}

last one breaks. AFAIK {WHENCE,LICENSE.*,LICENCE.*} would 
be a bash-ism. 

Replacing by:
		rm $(DESTDIR)$(FIRMWAREDIR)/WHENCE 
		rm $(DESTDIR)$(FIRMWAREDIR)/LICENCE.*
		rm $(DESTDIR)$(FIRMWAREDIR)/LICENSE.*
or
	    /bin/bash -c "rm -f $(DESTDIR)$(FIRMWAREDIR)/{WHENCE,LICENSE.*,LICENCE.*}"
helps.

make: GNU Make 3.81

-- 
LiHAS - Adrian Reyer - Hessenwiesenstraße 10 - D-70565 Stuttgart
Fon: +49 (7 11) 78 28 50 90 - Fax:  +49 (7 11) 78 28 50 91
Mail: cre@lihas.de - Web: http://lihas.de
Linux, Netzwerke, Consulting & Support - USt-ID: DE 227 816 626 Stuttgart

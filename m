Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753943Ab3IFPNR (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Sep 2013 11:13:17 -0400
Received: from mail-ob0-f170.google.com ([209.85.214.170]:45605 "EHLO
	mail-ob0-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752490Ab3IFPNQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Sep 2013 11:13:16 -0400
Message-ID: <5229F10A.7000503@lwfinger.net>
Date: Fri, 06 Sep 2013 10:13:14 -0500
From: Larry Finger <Larry.Finger@lwfinger.net>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130801 Thunderbird/17.0.8
MIME-Version: 1.0
To: Geert Uytterhoeven <geert@linux-m68k.org>
CC: LKML <linux-kernel@vger.kernel.org>,
        linux-wireless <linux-wireless@vger.kernel.org>
Subject: Build warnings in b43 and b43legacy
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Geert,

In http://lkml.indiana.edu/hypermail/linux/kernel/1309.0/00918.html and earlier 
postings of the build regressions in 3.11-rcX, I notice the following entries:

+ /scratch/kisskb/src/drivers/net/wireless/b43/b43.h: warning: 'packed' 
attribute ignored for field of type 'union <anonymous>' [-Wattributes]: => 641:2
+ /scratch/kisskb/src/drivers/net/wireless/b43/xmit.h: warning: 'packed' 
attribute ignored for field of type 'struct <anonymous>' [-Wattributes]: => 
64:3, 88:3, 290:3, 283:3, 77:3
+ /scratch/kisskb/src/drivers/net/wireless/b43legacy/b43legacy.h: warning: 
'packed' attribute ignored for field of type 'union <anonymous>' [-Wattributes]: 
=> 381:2

 From the indicated source lines, and some research on the topic of packed 
attributes of anonymous entities, I think I know what it would take to fix 
these; however, I am reluctant to touch this code. Firstly, my compiler does not 
show the warning, and secondly, blindly reworking those critical structures 
could cause severe regressions.

What compiler version and options does it take to get these warnings to appear?

Thanks,

Larry

Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753543Ab3FEJBN (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Jun 2013 05:01:13 -0400
Received: from faui40.informatik.uni-erlangen.de ([131.188.34.40]:33568 "EHLO
	faui40.informatik.uni-erlangen.de" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753450Ab3FEJBI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Jun 2013 05:01:08 -0400
From: Johannes Schilling <of82ecuq@cip.cs.fau.de>
To: linux-kernel@vger.kernel.org
Cc: linux-kernel@i4.cs.fau.de, Al Cho <acho@novell.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Amarjargal Gundjalam <amarjargal16@gmail.com>,
        Kurt Kanzenbach <shifty91@gmail.com>, devel@driverdev.osuosl.org,
        Johannes Schilling <of82ecuq@cip.cs.fau.de>,
        Laura Lawniczak <laura.lawniczak@googlemail.com>
Subject: [PATCH 0/6] keucr: checkpatch fixes
Date: Wed,  5 Jun 2013 10:50:00 +0200
Message-Id: <1370422206-14961-1-git-send-email-of82ecuq@cip.cs.fau.de>
X-Mailer: git-send-email 1.7.10.4
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


hi,

we started cleaning up a bit in drivers/staging/keucr, resolved a lot of
checkpatch warnings and errors.


[PATCH 1/6] keucr: remove some unneccesary typedefs

in ../init.c the two unused typedefed structures ADDRESS_T and SSFDCTYPE_T are
removed, in other files typedefs are removed and replaced with actual
structures and pointers.


[PATCH 2/6] keucr: fix some camelCase warnings

still a lot of camelCase to go, but this is a start. checkpatch.pl is mostly
satisfied with the progress.


[PATCH 3/6] migrate printk to dev_dbg/info/warn/err

printk()-calls without facility levels replaced with dev_{dbg,info,warn,err}
accordingly.


[PATCH 4/6] keucr: make error messages less aggressive

in .../keucr/smilsub.c a lot of error messages ended with "!!\n", we changed
that to a less shouting version. also, no punctuation in error messages is
probably a good thing.


[PATCH 5/6] keucr: various alignment- and whitespace-problems

line-lengths, whitespace around operators and placement of braces now as
demanded by checkpatch


[PATCH 6/6] keucr: use more specific max_t(int, ..

one more change, didn't fit in any of the other categories: change max(a, b)
to max_t(int, a, b) in .../keucr/transport.c, as suggested by checkpatch



all in all we're on a good way to get clean here, by far the biggest part that
is left is "externs should be avoided in .c files", those will need some more
careful work.


regards,
   laura lawniczak, johannes schilling



total diffstat:

Johannes Schilling (6):
  keucr: remove some unneccesary typedefs
  keucr: fix some camelCase warnings
  keucr: migrate printk to dev_dbg/info/warn/err
  keucr: make error messages less aggressive
  keucr: fix some alignment- and whitespace-problems
  keucr: use more specific max_t(int, ..

 drivers/staging/keucr/init.c      |   72 +++++++++++-----------
 drivers/staging/keucr/init.h      |    8 +--
 drivers/staging/keucr/scsiglue.c  |    7 ++-
 drivers/staging/keucr/smil.h      |   16 -----
 drivers/staging/keucr/smilmain.c  |  122 ++++++++++++++++++-------------------
 drivers/staging/keucr/smilsub.c   |   14 ++---
 drivers/staging/keucr/smscsi.c    |    6 +-
 drivers/staging/keucr/transport.c |    4 +-
 drivers/staging/keucr/usb.c       |    8 +--
 drivers/staging/keucr/usb.h       |   30 ++++-----
 10 files changed, 132 insertions(+), 155 deletions(-)


Signed-off-by: Laura Lawniczak <laura.lawniczak@googlemail.com>
Signed-off-by: Johannes Schilling <of82ecuq@cip.cs.fau.de> 

-- 
1.7.10.4


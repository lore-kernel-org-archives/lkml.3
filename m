Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755353Ab3JMT3M (ORCPT <rfc822;w@1wt.eu>);
	Sun, 13 Oct 2013 15:29:12 -0400
Received: from mail.tpi.com ([74.45.170.26]:39007 "EHLO mail.tpi.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755099Ab3JMT3L (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 13 Oct 2013 15:29:11 -0400
From: Tim Gardner <tim.gardner@canonical.com>
To: linux-cifs@vger.kernel.org, samba-technical@lists.samba.org,
        linux-kernel@vger.kernel.org
Cc: Tim Gardner <tim.gardner@canonical.com>, Steve French <sfrench@samba.org>
Subject: [PATCH 3.12-rc4] cifs: ntstatus_to_dos_map[] is not terminated
Date: Sun, 13 Oct 2013 13:29:03 -0600
Message-Id: <1381692543-41226-1-git-send-email-tim.gardner@canonical.com>
X-Mailer: git-send-email 1.7.9.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Functions that walk the ntstatus_to_dos_map[] array could
run off the end. For example, ntstatus_to_dos() loops
while ntstatus_to_dos_map[].ntstatus is not 0. Granted,
this is mostly theoretical, but could be used as a DOS attack
if the error code in the SMB header is bogus.

Cc: Steve French <sfrench@samba.org>
Signed-off-by: Tim Gardner <tim.gardner@canonical.com>
---
 fs/cifs/netmisc.c |    4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/fs/cifs/netmisc.c b/fs/cifs/netmisc.c
index af847e1..651a527 100644
--- a/fs/cifs/netmisc.c
+++ b/fs/cifs/netmisc.c
@@ -780,7 +780,9 @@ static const struct {
 	ERRDOS, ERRnoaccess, 0xc0000290}, {
 	ERRDOS, ERRbadfunc, 0xc000029c}, {
 	ERRDOS, ERRsymlink, NT_STATUS_STOPPED_ON_SYMLINK}, {
-	ERRDOS, ERRinvlevel, 0x007c0001}, };
+	ERRDOS, ERRinvlevel, 0x007c0001}, {
+	0, 0, 0 }
+};
 
 /*****************************************************************************
  Print an error message from the status code
-- 
1.7.9.5


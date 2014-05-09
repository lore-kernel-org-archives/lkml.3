Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757391AbaEITVh (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 May 2014 15:21:37 -0400
Received: from relay4-d.mail.gandi.net ([217.70.183.196]:41119 "EHLO
	relay4-d.mail.gandi.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757088AbaEITVf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 May 2014 15:21:35 -0400
X-Originating-IP: 173.246.103.110
Date: Fri, 9 May 2014 12:21:27 -0700
From: Josh Triplett <josh@joshtriplett.org>
To: mtk.manpages@gmail.com, linux-man@vger.kernel.org
Cc: Arnd Bergmann <arnd@arndb.de>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        akpm@linux-foundation.org, linux-kernel@vger.kernel.org,
        linux-api@vger.kernel.org
Subject: [PATCH] mem.4, ioports.4: Document /dev/ioports
Message-ID: <20140509192126.GA13050@jtriplet-mobl1>
References: <20140509191914.GA7286@jtriplet-mobl1>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140509191914.GA7286@jtriplet-mobl1>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

/dev/ioports works like /dev/port, but supports 16-bit and 32-bit ports.

Signed-off-by: Josh Triplett <josh@joshtriplett.org>
---

Wasn't sure whether I should update the "Modified" notice at the top;
ideally such things should go away in favor of git.

 man4/ioports.4 |  1 +
 man4/mem.4     | 21 +++++++++++++++++++--
 2 files changed, 20 insertions(+), 2 deletions(-)
 create mode 100644 man4/ioports.4

diff --git a/man4/ioports.4 b/man4/ioports.4
new file mode 100644
index 0000000..d4c1762
--- /dev/null
+++ b/man4/ioports.4
@@ -0,0 +1 @@
+.so man4/mem.4
diff --git a/man4/mem.4 b/man4/mem.4
index 74b7b89..adfd810 100644
--- a/man4/mem.4
+++ b/man4/mem.4
@@ -25,7 +25,7 @@
 .\" Modified Sat Jul 24 16:59:10 1993 by Rik Faith (faith@cs.unc.edu)
 .TH MEM 4 1992-11-21 "Linux" "Linux Programmer's Manual"
 .SH NAME
-mem, kmem, port \- system memory, kernel memory and system ports
+mem, kmem, port, ioports \- system memory, kernel memory and system ports
 .SH DESCRIPTION
 .B mem
 is a character device file
@@ -66,7 +66,8 @@ chown root:kmem /dev/kmem
 .B port
 is similar to
 .BR mem ,
-but the I/O ports are accessed.
+but the I/O ports are accessed.  Multi-byte reads or writes to port will
+operate on successive byte-sized ports.
 .LP
 It is typically created by:
 .RS
@@ -75,12 +76,28 @@ mknod \-m 660 /dev/port c 1 4
 .br
 chown root:mem /dev/port
 .RE
+.LP
+.B ioports
+is similar to
+.BR port ,
+but supports reads and writes of 16-bit or 32-bit ports.  Reads or writes to
+ioport with sizes other than 1, 2, or 4 will return EINVAL.
+.LP
+It is typically created by:
+.RS
+.sp
+mknod \-m 660 /dev/ioports c 1 12
+.br
+chown root:mem /dev/ioports
+.RE
 .SH FILES
 .I /dev/mem
 .br
 .I /dev/kmem
 .br
 .I /dev/port
+.br
+.I /dev/ioports
 .SH SEE ALSO
 .BR chown (1),
 .BR mknod (1),
-- 
2.0.0.rc2


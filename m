Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758128Ab3CFNkc (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Mar 2013 08:40:32 -0500
Received: from mailout01.c08.mtsvc.net ([205.186.168.189]:50357 "EHLO
	mailout01.c08.mtsvc.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756024Ab3CFNi5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Mar 2013 08:38:57 -0500
From: Peter Hurley <peter@hurleysoftware.com>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: Jiri Slaby <jslaby@suse.cz>, linux-serial@vger.kernel.org,
        linux-kernel@vger.kernel.org, Peter Hurley <peter@hurleysoftware.com>
Subject: [PATCH 3/7] tty: Fix checkpatch errors in tty_ldisc.h
Date: Wed,  6 Mar 2013 08:38:21 -0500
Message-Id: <1362577105-19757-4-git-send-email-peter@hurleysoftware.com>
X-Mailer: git-send-email 1.8.1.2
In-Reply-To: <1362577105-19757-1-git-send-email-peter@hurleysoftware.com>
References: <1362577105-19757-1-git-send-email-peter@hurleysoftware.com>
X-Authenticated-User: 125194 peter@hurleysoftware.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Signed-off-by: Peter Hurley <peter@hurleysoftware.com>
---
 include/linux/tty_ldisc.h | 132 +++++++++++++++++++++++-----------------------
 1 file changed, 66 insertions(+), 66 deletions(-)

diff --git a/include/linux/tty_ldisc.h b/include/linux/tty_ldisc.h
index a8c58c2..1ef449e 100644
--- a/include/linux/tty_ldisc.h
+++ b/include/linux/tty_ldisc.h
@@ -9,89 +9,89 @@
  *
  * int	(*open)(struct tty_struct *);
  *
- * 	This function is called when the line discipline is associated
- * 	with the tty.  The line discipline can use this as an
- * 	opportunity to initialize any state needed by the ldisc routines.
- * 
+ *	This function is called when the line discipline is associated
+ *	with the tty.  The line discipline can use this as an
+ *	opportunity to initialize any state needed by the ldisc routines.
+ *
  * void	(*close)(struct tty_struct *);
  *
  *	This function is called when the line discipline is being
- * 	shutdown, either because the tty is being closed or because
- * 	the tty is being changed to use a new line discipline
- * 
+ *	shutdown, either because the tty is being closed or because
+ *	the tty is being changed to use a new line discipline
+ *
  * void	(*flush_buffer)(struct tty_struct *tty);
  *
- * 	This function instructs the line discipline to clear its
- * 	buffers of any input characters it may have queued to be
- * 	delivered to the user mode process.
- * 
+ *	This function instructs the line discipline to clear its
+ *	buffers of any input characters it may have queued to be
+ *	delivered to the user mode process.
+ *
  * ssize_t (*chars_in_buffer)(struct tty_struct *tty);
  *
- * 	This function returns the number of input characters the line
+ *	This function returns the number of input characters the line
  *	discipline may have queued up to be delivered to the user mode
  *	process.
- * 
+ *
  * ssize_t (*read)(struct tty_struct * tty, struct file * file,
  *		   unsigned char * buf, size_t nr);
  *
- * 	This function is called when the user requests to read from
- * 	the tty.  The line discipline will return whatever characters
- * 	it has buffered up for the user.  If this function is not
- * 	defined, the user will receive an EIO error.
- * 
+ *	This function is called when the user requests to read from
+ *	the tty.  The line discipline will return whatever characters
+ *	it has buffered up for the user.  If this function is not
+ *	defined, the user will receive an EIO error.
+ *
  * ssize_t (*write)(struct tty_struct * tty, struct file * file,
- * 		    const unsigned char * buf, size_t nr);
- *
- * 	This function is called when the user requests to write to the
- * 	tty.  The line discipline will deliver the characters to the
- * 	low-level tty device for transmission, optionally performing
- * 	some processing on the characters first.  If this function is
- * 	not defined, the user will receive an EIO error.
- * 
+ *		    const unsigned char * buf, size_t nr);
+ *
+ *	This function is called when the user requests to write to the
+ *	tty.  The line discipline will deliver the characters to the
+ *	low-level tty device for transmission, optionally performing
+ *	some processing on the characters first.  If this function is
+ *	not defined, the user will receive an EIO error.
+ *
  * int	(*ioctl)(struct tty_struct * tty, struct file * file,
- * 		 unsigned int cmd, unsigned long arg);
+ *		 unsigned int cmd, unsigned long arg);
  *
  *	This function is called when the user requests an ioctl which
- * 	is not handled by the tty layer or the low-level tty driver.
- * 	It is intended for ioctls which affect line discpline
- * 	operation.  Note that the search order for ioctls is (1) tty
- * 	layer, (2) tty low-level driver, (3) line discpline.  So a
- * 	low-level driver can "grab" an ioctl request before the line
- * 	discpline has a chance to see it.
- * 
+ *	is not handled by the tty layer or the low-level tty driver.
+ *	It is intended for ioctls which affect line discpline
+ *	operation.  Note that the search order for ioctls is (1) tty
+ *	layer, (2) tty low-level driver, (3) line discpline.  So a
+ *	low-level driver can "grab" an ioctl request before the line
+ *	discpline has a chance to see it.
+ *
  * long	(*compat_ioctl)(struct tty_struct * tty, struct file * file,
- * 		        unsigned int cmd, unsigned long arg);
+ *		        unsigned int cmd, unsigned long arg);
  *
- *      Process ioctl calls from 32-bit process on 64-bit system
+ *	Process ioctl calls from 32-bit process on 64-bit system
  *
  * void	(*set_termios)(struct tty_struct *tty, struct ktermios * old);
  *
- * 	This function notifies the line discpline that a change has
- * 	been made to the termios structure.
- * 
+ *	This function notifies the line discpline that a change has
+ *	been made to the termios structure.
+ *
  * int	(*poll)(struct tty_struct * tty, struct file * file,
- * 		  poll_table *wait);
+ *		  poll_table *wait);
  *
- * 	This function is called when a user attempts to select/poll on a
- * 	tty device.  It is solely the responsibility of the line
- * 	discipline to handle poll requests.
+ *	This function is called when a user attempts to select/poll on a
+ *	tty device.  It is solely the responsibility of the line
+ *	discipline to handle poll requests.
  *
  * void	(*receive_buf)(struct tty_struct *, const unsigned char *cp,
- * 		       char *fp, int count);
- *
- * 	This function is called by the low-level tty driver to send
- * 	characters received by the hardware to the line discpline for
- * 	processing.  <cp> is a pointer to the buffer of input
- * 	character received by the device.  <fp> is a pointer to a
- * 	pointer of flag bytes which indicate whether a character was
- * 	received with a parity error, etc.
- * 
+ *		       char *fp, int count);
+ *
+ *	This function is called by the low-level tty driver to send
+ *	characters received by the hardware to the line discpline for
+ *	processing.  <cp> is a pointer to the buffer of input
+ *	character received by the device.  <fp> is a pointer to a
+ *	pointer of flag bytes which indicate whether a character was
+ *	received with a parity error, etc.
+ *
  * void	(*write_wakeup)(struct tty_struct *);
  *
- * 	This function is called by the low-level tty driver to signal
- * 	that line discpline should try to send more characters to the
- * 	low-level driver for transmission.  If the line discpline does
- * 	not have any more data to send, it can just return.
+ *	This function is called by the low-level tty driver to signal
+ *	that line discpline should try to send more characters to the
+ *	low-level driver for transmission.  If the line discpline does
+ *	not have any more data to send, it can just return.
  *
  * int (*hangup)(struct tty_struct *)
  *
@@ -162,7 +162,7 @@ struct tty_ldisc_ops {
 	char	*name;
 	int	num;
 	int	flags;
-	
+
 	/*
 	 * The following routines are called from above.
 	 */
@@ -170,19 +170,19 @@ struct tty_ldisc_ops {
 	void	(*close)(struct tty_struct *);
 	void	(*flush_buffer)(struct tty_struct *tty);
 	ssize_t	(*chars_in_buffer)(struct tty_struct *tty);
-	ssize_t	(*read)(struct tty_struct * tty, struct file * file,
-			unsigned char __user * buf, size_t nr);
-	ssize_t	(*write)(struct tty_struct * tty, struct file * file,
-			 const unsigned char * buf, size_t nr);	
-	int	(*ioctl)(struct tty_struct * tty, struct file * file,
+	ssize_t	(*read)(struct tty_struct *tty, struct file *file,
+			unsigned char __user *buf, size_t nr);
+	ssize_t	(*write)(struct tty_struct *tty, struct file *file,
+			 const unsigned char *buf, size_t nr);
+	int	(*ioctl)(struct tty_struct *tty, struct file *file,
 			 unsigned int cmd, unsigned long arg);
-	long	(*compat_ioctl)(struct tty_struct * tty, struct file * file,
+	long	(*compat_ioctl)(struct tty_struct *tty, struct file *file,
 				unsigned int cmd, unsigned long arg);
-	void	(*set_termios)(struct tty_struct *tty, struct ktermios * old);
+	void	(*set_termios)(struct tty_struct *tty, struct ktermios *old);
 	unsigned int (*poll)(struct tty_struct *, struct file *,
 			     struct poll_table_struct *);
 	int	(*hangup)(struct tty_struct *tty);
-	
+
 	/*
 	 * The following routines are called from below.
 	 */
@@ -192,7 +192,7 @@ struct tty_ldisc_ops {
 	void	(*dcd_change)(struct tty_struct *, unsigned int);
 
 	struct  module *owner;
-	
+
 	int refcount;
 };
 
-- 
1.8.1.2


Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932956Ab3CRV7F (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Mar 2013 17:59:05 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:45564 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755437Ab3CRVGr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Mar 2013 17:06:47 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        David Miller <davem@davemloft.net>, Jiri Slaby <jslaby@suse.cz>
Subject: [ 25/75] TTY: disable debugging warning
Date: Mon, 18 Mar 2013 14:06:48 -0700
Message-Id: <20130318210512.065708253@linuxfoundation.org>
X-Mailer: git-send-email 1.8.1.2.434.g9a6c84e.dirty
In-Reply-To: <20130318210510.203500214@linuxfoundation.org>
References: <20130318210510.203500214@linuxfoundation.org>
User-Agent: quilt/0.60-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.8-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Jiri Slaby <jslaby@suse.cz>

commit 34dcfb8479ab3c3669561eb9279284cb0eda2572 upstream.

We added a warning to flush_to_ldisc to report cases when it is called
with a NULL tty. It was for debugging purposes and it lead to a
patchset from Peter Hurley. The patchset however did not make it to
3.9, so disable the warning now to not disturb people.

We can re-add it when the series is in and we are hunting for another
bugs.

Reported-by: David Miller <davem@davemloft.net>
Signed-off-by: Jiri Slaby <jslaby@suse.cz>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/tty/tty_buffer.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/tty/tty_buffer.c
+++ b/drivers/tty/tty_buffer.c
@@ -473,7 +473,7 @@ static void flush_to_ldisc(struct work_s
 	struct tty_ldisc *disc;
 
 	tty = port->itty;
-	if (WARN_RATELIMIT(tty == NULL, "tty is NULL\n"))
+	if (tty == NULL)
 		return;
 
 	disc = tty_ldisc_ref(tty);



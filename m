Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752036Ab3ISAnF (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Sep 2013 20:43:05 -0400
Received: from mailout01.c08.mtsvc.net ([205.186.168.189]:34085 "EHLO
	mailout01.c08.mtsvc.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751737Ab3ISAnD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Sep 2013 20:43:03 -0400
From: Peter Hurley <peter@hurleysoftware.com>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: Jiri Slaby <jslaby@suse.cz>, linux-kernel@vger.kernel.org,
        linux-serial@vger.kernel.org, Peter Hurley <peter@hurleysoftware.com>
Subject: [PATCH tty-next 0/1] premature tty_port destruction diagnostic
Date: Wed, 18 Sep 2013 20:42:38 -0400
Message-Id: <1379551359-15000-1-git-send-email-peter@hurleysoftware.com>
X-Mailer: git-send-email 1.8.1.2
X-Authenticated-User: 125194 peter@hurleysoftware.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Greg,

Now that the bluetooth rfcomm tty refcounting is fixed in linux-next,
I'd like to add this patch which aborts tty_port destruction if the
tty has not yet been released. At least this problem won't show up
as some random memory corruption (as was happening with rfcomm).

Even though this only WARNs, the machine is likely to crash anyway
because the port indexes will not be in sync; the tty layer will
assume the port has been destructed while the tty_port obviously
has not.

Regards,

Peter Hurley (1):
  tty: Prevent tty_port destruction if tty not released

 drivers/tty/tty_port.c | 4 ++++
 1 file changed, 4 insertions(+)

-- 
1.8.1.2


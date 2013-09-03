Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761288Ab3ICVNh (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Sep 2013 17:13:37 -0400
Received: from mx1.redhat.com ([209.132.183.28]:4895 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1760952Ab3ICVNf (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Sep 2013 17:13:35 -0400
Date: Tue, 3 Sep 2013 17:13:23 -0400
From: Dave Jones <davej@redhat.com>
To: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Cc: Srinivas Kandagatla <srinivas.kandagatla@st.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Subject: Restrict ST ASC driver to only build on !ARM when COMPILE_TEST is
 set.
Message-ID: <20130903211323.GA2247@redhat.com>
Mail-Followup-To: Dave Jones <davej@redhat.com>,
	Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
	Srinivas Kandagatla <srinivas.kandagatla@st.com>,
	Greg Kroah-Hartman <gregkh@linuxfoundation.org>
References: <20130903185959.E387A661287@gitolite.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20130903185959.E387A661287@gitolite.kernel.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The Kconfig for this option suggests it's only relevant on STi SoCs,
so add depends to have it not show up on archs that won't ever run it.
 
Signed-off-by: Dave Jones <davej@fedoraproject.org>

diff --git a/drivers/tty/serial/Kconfig b/drivers/tty/serial/Kconfig
index cc4c868..304a637 100644
--- a/drivers/tty/serial/Kconfig
+++ b/drivers/tty/serial/Kconfig
@@ -1503,6 +1503,7 @@ config SERIAL_FSL_LPUART_CONSOLE
 config SERIAL_ST_ASC
 	tristate "ST ASC serial port support"
 	select SERIAL_CORE
+	depends on ARM || COMPILE_TEST
 	help
 	  This driver is for the on-chip Asychronous Serial Controller on
 	  STMicroelectronics STi SoCs.

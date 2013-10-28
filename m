Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757513Ab3J1TzU (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Oct 2013 15:55:20 -0400
Received: from zimbra3.corp.accelance.fr ([213.162.49.233]:57265 "EHLO
	zimbra3.corp.accelance.fr" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756096Ab3J1TzT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Oct 2013 15:55:19 -0400
X-Greylist: delayed 401 seconds by postgrey-1.27 at vger.kernel.org; Mon, 28 Oct 2013 15:55:19 EDT
Message-ID: <526EBECB.1010805@openwide.fr>
Date: Mon, 28 Oct 2013 20:45:15 +0100
From: Romain Naour <romain.naour@openwide.fr>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130805 Thunderbird/17.0.8
MIME-Version: 1.0
To: linux-kernel@vger.kernel.org
Subject: trace-cmd: use pkg-config instead of python-config
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


trace-cmd use python-config to find out which headers
and libraries should be used to link against the Python libraries.
By default, python-config returns paths that are inappropriate for
cross-compilation.

Add PYTHON_VERS to build trace-cmd with python2 or python3

Signed-off-by: Romain Naour <romain.naour@openwide.fr>
---
  Makefile | 8 +++++---
  1 file changed, 5 insertions(+), 3 deletions(-)

diff --git a/Makefile b/Makefile
index 83329ca..23b70d8 100644
--- a/Makefile
+++ b/Makefile
@@ -80,8 +80,10 @@ ifndef NO_PYTHON
  PYTHON        := ctracecmd.so
  PYTHON_GUI    := ctracecmd.so ctracecmdgui.so

+PYTHON_VERS ?= python
+
  # Can build python?
-ifeq ($(shell sh -c "python-config --includes > /dev/null 2>&1 && echo 
y"), y)
+ifeq ($(shell sh -c "pkg-config --cflags $(PYTHON_VERS) > /dev/null 
2>&1 && echo y"), y)
      PYTHON_PLUGINS := plugin_python.so
      BUILD_PYTHON := $(PYTHON) $(PYTHON_PLUGINS)
      PYTHON_SO_INSTALL := ctracecmd.install
@@ -546,8 +548,8 @@ clean:

  ##### PYTHON STUFF #####

-PYTHON_INCLUDES = `python-config --includes`
-PYTHON_LDFLAGS = `python-config --ldflags` \
+PYTHON_INCLUDES = `pkg-config --cflags $(PYTHON_VERS)`
+PYTHON_LDFLAGS = `pkg-config --libs $(PYTHON_VERS)` \
          $(shell python -c "import distutils.sysconfig; print 
distutils.sysconfig.get_config_var('LINKFORSHARED')")
  PYGTK_CFLAGS = `pkg-config --cflags pygtk-2.0`

--
1.8.4



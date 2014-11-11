Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752161AbaKKCMH (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Nov 2014 21:12:07 -0500
Received: from mga01.intel.com ([192.55.52.88]:24860 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751877AbaKKCK4 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Nov 2014 21:10:56 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.97,862,1389772800"; 
   d="scan'208";a="414590936"
From: Stephanie Wallick <stephanie.s.wallick@intel.com>
To: linux-kernel@vger.kernel.org
Cc: gregkh@linuxfoundation.org, linux-usb@vger.kernel.org,
        devel@driverdev.osuosl.org, "Sean O. Stalley" <sean.stalley@intel.com>
Subject: [V2 PATCH 09/10] added tools for building/loading media agnostic (MA) USB drivers
Date: Mon, 10 Nov 2014 18:09:40 -0800
Message-Id: <1415671781-11351-9-git-send-email-stephanie.s.wallick@intel.com>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1415671781-11351-1-git-send-email-stephanie.s.wallick@intel.com>
References: <MA USB drivers>
 <1415671781-11351-1-git-send-email-stephanie.s.wallick@intel.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Adds various scripts for building, loading and unloading the MA USB
drivers and a utility that can be used for connecting and disconnecting
the host and device drivers.

Signed-off-by: Sean O. Stalley <sean.stalley@intel.com>
Signed-off-by: Stephanie Wallick <stephanie.s.wallick@intel.com>
---
 drivers/staging/mausb/mausb-util/AUTHORS           |   2 +
 drivers/staging/mausb/mausb-util/Android.mk        |   3 +
 drivers/staging/mausb/mausb-util/ChangeLog         |   0
 drivers/staging/mausb/mausb-util/INSTALL           |   0
 drivers/staging/mausb/mausb-util/LICENCE           |   0
 drivers/staging/mausb/mausb-util/Makefile          |  14 ++
 drivers/staging/mausb/mausb-util/README            |  68 +++++++
 drivers/staging/mausb/mausb-util/config.mk         |  17 ++
 drivers/staging/mausb/mausb-util/src/Android.mk    |  13 ++
 drivers/staging/mausb/mausb-util/src/Makefile      |  18 ++
 drivers/staging/mausb/mausb-util/src/connect.c     |  69 +++++++
 drivers/staging/mausb/mausb-util/src/connect.h     |  22 +++
 drivers/staging/mausb/mausb-util/src/mausb.c       | 201 +++++++++++++++++++++
 drivers/staging/mausb/mausb-util/src/mausb.h       |  64 +++++++
 drivers/staging/mausb/mausb-util/src/mausb_ioctl.h |  24 +++
 drivers/staging/mausb/mausb-util/src/utils.c       |  94 ++++++++++
 drivers/staging/mausb/scripts/Android.mk           |  38 ++++
 .../staging/mausb/scripts/build_load_connect.sh    |  69 +++++++
 drivers/staging/mausb/scripts/load_gzero.sh        |   5 +
 .../mausb/scripts/load_mausb_android-dev.sh        |  31 ++++
 .../mausb/scripts/load_mausb_android-host.sh       |  31 ++++
 .../staging/mausb/scripts/load_mausb_android.sh    |  33 ++++
 drivers/staging/mausb/scripts/load_script.sh       | 125 +++++++++++++
 drivers/staging/mausb/scripts/modprobify.sh        |  10 +
 drivers/staging/mausb/scripts/unload_gzero.sh      |   5 +
 25 files changed, 956 insertions(+)
 create mode 100644 drivers/staging/mausb/mausb-util/AUTHORS
 create mode 100644 drivers/staging/mausb/mausb-util/Android.mk
 create mode 100644 drivers/staging/mausb/mausb-util/ChangeLog
 create mode 100644 drivers/staging/mausb/mausb-util/INSTALL
 create mode 100644 drivers/staging/mausb/mausb-util/LICENCE
 create mode 100644 drivers/staging/mausb/mausb-util/Makefile
 create mode 100644 drivers/staging/mausb/mausb-util/README
 create mode 100644 drivers/staging/mausb/mausb-util/config.mk
 create mode 100644 drivers/staging/mausb/mausb-util/src/Android.mk
 create mode 100644 drivers/staging/mausb/mausb-util/src/Makefile
 create mode 100644 drivers/staging/mausb/mausb-util/src/connect.c
 create mode 100644 drivers/staging/mausb/mausb-util/src/connect.h
 create mode 100644 drivers/staging/mausb/mausb-util/src/mausb.c
 create mode 100644 drivers/staging/mausb/mausb-util/src/mausb.h
 create mode 100644 drivers/staging/mausb/mausb-util/src/mausb_ioctl.h
 create mode 100644 drivers/staging/mausb/mausb-util/src/utils.c
 create mode 100644 drivers/staging/mausb/scripts/Android.mk
 create mode 100755 drivers/staging/mausb/scripts/build_load_connect.sh
 create mode 100755 drivers/staging/mausb/scripts/load_gzero.sh
 create mode 100755 drivers/staging/mausb/scripts/load_mausb_android-dev.sh
 create mode 100755 drivers/staging/mausb/scripts/load_mausb_android-host.sh
 create mode 100755 drivers/staging/mausb/scripts/load_mausb_android.sh
 create mode 100755 drivers/staging/mausb/scripts/load_script.sh
 create mode 100755 drivers/staging/mausb/scripts/modprobify.sh
 create mode 100755 drivers/staging/mausb/scripts/unload_gzero.sh

diff --git a/drivers/staging/mausb/mausb-util/AUTHORS b/drivers/staging/mausb/mausb-util/AUTHORS
new file mode 100644
index 0000000..6312e6a
--- /dev/null
+++ b/drivers/staging/mausb/mausb-util/AUTHORS
@@ -0,0 +1,2 @@
+Sean O. Stalley <sean.stalley@intel.com>
+Aymen Zayet <aymen.zayet@intel.com>
diff --git a/drivers/staging/mausb/mausb-util/Android.mk b/drivers/staging/mausb/mausb-util/Android.mk
new file mode 100644
index 0000000..c455f97
--- /dev/null
+++ b/drivers/staging/mausb/mausb-util/Android.mk
@@ -0,0 +1,3 @@
+LOCAL_PATH := $(call my-dir)
+
+include $(call all-subdir-makefiles)
diff --git a/drivers/staging/mausb/mausb-util/ChangeLog b/drivers/staging/mausb/mausb-util/ChangeLog
new file mode 100644
index 0000000..e69de29
diff --git a/drivers/staging/mausb/mausb-util/INSTALL b/drivers/staging/mausb/mausb-util/INSTALL
new file mode 100644
index 0000000..e69de29
diff --git a/drivers/staging/mausb/mausb-util/LICENCE b/drivers/staging/mausb/mausb-util/LICENCE
new file mode 100644
index 0000000..e69de29
diff --git a/drivers/staging/mausb/mausb-util/Makefile b/drivers/staging/mausb/mausb-util/Makefile
new file mode 100644
index 0000000..abd5fe0
--- /dev/null
+++ b/drivers/staging/mausb/mausb-util/Makefile
@@ -0,0 +1,14 @@
+include config.mk
+
+.PHONY: $(BINARY_NAME) all clean
+
+all: $(BINARY_NAME)
+
+$(BINARY_NAME):
+	$(MAKE) -C src/
+	cp -rf src/$(BINARY_NAME) .
+
+
+clean:
+	$(MAKE) -C src/ clean
+	rm -rf $(BINARY_NAME) *~
diff --git a/drivers/staging/mausb/mausb-util/README b/drivers/staging/mausb/mausb-util/README
new file mode 100644
index 0000000..c921355
--- /dev/null
+++ b/drivers/staging/mausb/mausb-util/README
@@ -0,0 +1,68 @@
+#    #   ##   #    #  ####  #####     #    # ##### # #      # ##### #   #
+##  ##  #  #  #    # #      #    #    #    #   #   # #      #   #    # #
+# ## # #    # #    #  ####  #####     #    #   #   # #      #   #     #
+#    # ###### #    #      # #    #    #    #   #   # #      #   #     #
+#    # #    # #    # #    # #    #    #    #   #   # #      #   #     #
+#    # #    #  ####   ####  #####      ####    #   # ###### #   #     #
+
+
+Author: Aymen Zayet
+License: GPL2
+Version: 0.1
+
+1. Description
+--------------
+This tool includes many commands that help to test / debug the MAUSB devices.
+mausb bin provides to the host a way to connect and disconnect from the MAUSB device
+by selecting the mode (ip or llc).
+
+2. Usage
+--------
+(*) The following steps can be used to test the connection between two Moorefield based devices :
+
+>> adb devices
+List of devices attached
+INV140200379	device
+INV140200169	device
+
+for device INV140200379:
+>>adb -s INV140200379 shell busybox ifconfig wlan0
+wlan0     Link encap:Ethernet  HWaddr 78:FF:57:00:6D:7A
+          inet addr:192.168.2.100  Bcast:192.168.2.255  Mask:255.255.255.0
+          inet6 addr: fe80::7aff:57ff:fe00:6d7a/64 Scope:Link
+          UP BROADCAST RUNNING MULTICAST  MTU:1500  Metric:1
+          RX packets:264 errors:0 dropped:0 overruns:0 frame:0
+          TX packets:287 errors:0 dropped:0 overruns:0 carrier:0
+          collisions:0 txqueuelen:1000
+          RX bytes:29906 (29.2 KiB)  TX bytes:29267 (28.5 KiB)
+
+for device INV140200169:
+>> adb -s INV140200169 shell busybox ifconfig wlan0
+wlan0     Link encap:Ethernet  HWaddr 78:FF:57:00:6C:A8
+          inet addr:192.168.2.113  Bcast:192.168.2.255  Mask:255.255.255.0
+          inet6 addr: fe80::7aff:57ff:fe00:6ca8/64 Scope:Link
+          UP BROADCAST RUNNING MULTICAST  MTU:1500  Metric:1
+          RX packets:268 errors:0 dropped:0 overruns:0 frame:0
+          TX packets:290 errors:0 dropped:0 overruns:0 carrier:0
+          collisions:0 txqueuelen:1000
+          RX bytes:31168 (30.4 KiB)  TX bytes:30413 (29.7 KiB)
+
+run INV140200379 as a MAUSB host:
+>> adb -s INV140200379 shell load_mausb_android-host.sh
+mausb load process complete
+
+then run INV140200169 as MAUSB device:
+>>adb -s INV140200169 shell load_mausb_android-dev.sh
+mausb load process complete
+
+now on the device side , run :
+>> mausb --mode llc --connect --addr 78:FF:57:00:6D:7A
+
+then from the host side, run :
+>> mausb --mode llc --connect --addr 78:FF:57:00:6C:A8 
+
+3. Documentation
+----------------
+
+4. Miscellaneous
+----------------
diff --git a/drivers/staging/mausb/mausb-util/config.mk b/drivers/staging/mausb/mausb-util/config.mk
new file mode 100644
index 0000000..d272823
--- /dev/null
+++ b/drivers/staging/mausb/mausb-util/config.mk
@@ -0,0 +1,17 @@
+SRCDIR          = $(shell pwd)
+DESTDIR         = /usr/local/bin
+
+CC              = gcc
+CFLAGS          = -g -ggdb -D __DEBUG
+LDFLAGS         =
+SHELL           = /bin/sh
+#CFLAGS         = -O2 -fomit-frame-pointer                                                 
+
+PROJECT_NAME    = mausb
+PROJECT_VERSION = 0.1
+
+BINARY_NAME     = $(PROJECT_NAME)
+
+SOURCE_FILES    = utils.c connect.c mausb.c
+
+OBJECT_FILES    = $(SOURCE_FILES:.c=.o)
diff --git a/drivers/staging/mausb/mausb-util/src/Android.mk b/drivers/staging/mausb/mausb-util/src/Android.mk
new file mode 100644
index 0000000..881c5fc
--- /dev/null
+++ b/drivers/staging/mausb/mausb-util/src/Android.mk
@@ -0,0 +1,13 @@
+LOCAL_PATH := $(call my-dir)
+include $(CLEAR_VARS)
+LOCAL_CFLAGS += -Wall -g
+LOCAL_LDFLAGS +=
+LOCAL_LDLIBS += -lpthread -lm -ldl
+LOCAL_SRC_FILES:= \
+	mausb.c \
+	utils.c \
+	connect.c
+LOCAL_C_INCLUDES += linux/modules/ma-usb/drivers
+LOCAL_MODULE := mausb
+LOCAL_MODULE_TAGS := optional
+include $(BUILD_EXECUTABLE)
diff --git a/drivers/staging/mausb/mausb-util/src/Makefile b/drivers/staging/mausb/mausb-util/src/Makefile
new file mode 100644
index 0000000..deb98a6
--- /dev/null
+++ b/drivers/staging/mausb/mausb-util/src/Makefile
@@ -0,0 +1,18 @@
+include ../config.mk
+
+all: $(BINARY_NAME)
+
+$(BINARY_NAME): $(OBJECT_FILES)
+	@echo -n "(LD)" $@ " "
+	@$(CC) $(LDFLAGS) $(CFLAGS) $^ -o $@
+	@echo OK
+
+%.o: %.c
+	@echo -n "(CC)" $@ " "
+	@$(CC) $(CFLAGS) -c $< -o $@
+	@echo OK
+
+clean:
+	rm -rf *.[oas] .*.flags *.ko .*.cmd .*.d .*.tmp *.mod.c .tmp_versions Module*.symv\
+ers
+	rm -f $(BINARY_NAME) *~
\ No newline at end of file
diff --git a/drivers/staging/mausb/mausb-util/src/connect.c b/drivers/staging/mausb/mausb-util/src/connect.c
new file mode 100644
index 0000000..6d6936b
--- /dev/null
+++ b/drivers/staging/mausb/mausb-util/src/connect.c
@@ -0,0 +1,69 @@
+/*
+  (c) Aymen Zayet (aymen.zayet@intel.com)
+
+  This file is part of mausb utility.
+
+  mausb is free software: you can redistribute it and/or modify
+  it under the terms of the GNU General Public License as published by
+  the Free Software Foundation, either version 2 of the License, or
+  (at your option) any later version.
+
+  mausb is distributed in the hope that it will be useful,
+  but WITHOUT ANY WARRANTY; without even the implied warranty of
+  MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.	See the
+  GNU General Public License for more details.
+
+  You should have received a copy of the GNU General Public License
+  along with mausb. If not, see <http://www.gnu.org/licenses/>.
+*/
+#include "mausb.h"
+
+int set_ipv4_addr(mausb_t *config)
+{
+	char buf[128] = {0};
+	printf("%s: setting ip address\n", __func__);
+	sprintf(buf, "%u", config->ip);
+	if (0 <= ioctl(config->device, IOCTL_SET_IP, buf))
+		return 0;
+	return errno;
+}
+
+int set_mac_addr(mausb_t *config)
+{
+	char buf[128] = {0};
+	printf("%s: setting mac address\n", __func__);
+	memcpy(buf, config->mac, 6);
+	if (0 <= ioctl(config->device, IOCTL_SET_MAC, buf)) {
+		printf("Msg from kernel space : mac %s set successfully\n",
+		       (char *)buf);
+		return 0;
+	}
+	return errno;
+}
+int set_port(mausb_t *config)
+{
+	char buf[128] = {0};
+	printf("%s: setting port\n", __func__);
+	sprintf(buf, "%u", config->port);
+	if (0 <= ioctl(config->device, IOCTL_SET_PORT, buf))
+		return 0;
+	return errno;
+}
+
+int connect_device(mausb_t *config)
+{
+	char buf[128] = {0};
+	printf("%s: connecting device\n", __func__);
+	if (0 <= ioctl(config->device, IOCTL_GADGET_C, buf))
+		return 0;
+	return errno;
+}
+
+int disconnect_device(mausb_t *config)
+{
+	char buf[128] = {0};
+	printf("%s: disconnecting device\n", __func__);
+	if (0 <= ioctl(config->device, IOCTL_GADGET_D, buf))
+		return 0;
+	return errno;
+}
diff --git a/drivers/staging/mausb/mausb-util/src/connect.h b/drivers/staging/mausb/mausb-util/src/connect.h
new file mode 100644
index 0000000..30bd1c5
--- /dev/null
+++ b/drivers/staging/mausb/mausb-util/src/connect.h
@@ -0,0 +1,22 @@
+/*
+  (c) Aymen Zayet (aymen.zayet@intel.com)
+
+  This file is part of mausb utility.
+
+  mausb is free software: you can redistribute it and/or modify
+  it under the terms of the GNU General Public License as published by
+  the Free Software Foundation, either version 2 of the License, or
+  (at your option) any later version.
+
+  mausb is distributed in the hope that it will be useful,
+  but WITHOUT ANY WARRANTY; without even the implied warranty of
+  MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.	See the
+  GNU General Public License for more details.
+
+  You should have received a copy of the GNU General Public License
+  along with mausb. If not, see <http://www.gnu.org/licenses/>.
+*/
+#ifndef CONNECT_H_
+#define CONNECT_H_
+
+#endif /* CONNECT_H_ */
diff --git a/drivers/staging/mausb/mausb-util/src/mausb.c b/drivers/staging/mausb/mausb-util/src/mausb.c
new file mode 100644
index 0000000..67903a6
--- /dev/null
+++ b/drivers/staging/mausb/mausb-util/src/mausb.c
@@ -0,0 +1,201 @@
+/*
+  (c) Aymen Zayet (aymen.zayet@intel.com)
+
+  This file is part of mausb utility.
+
+  mausb is free software: you can redistribute it and/or modify
+  it under the terms of the GNU General Public License as published by
+  the Free Software Foundation, either version 2 of the License, or
+  (at your option) any later version.
+
+  mausb is distributed in the hope that it will be useful,
+  but WITHOUT ANY WARRANTY; without even the implied warranty of
+  MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.	See the
+  GNU General Public License for more details.
+
+  You should have received a copy of the GNU General Public License
+  along with mausb. If not, see <http://www.gnu.org/licenses/>.
+*/
+
+#include "mausb.h"
+
+
+
+static struct option l_opts[] = {
+	/* no_argument options */
+	{"help", no_argument, 0, 'h'},
+	{"verbose", no_argument, 0, 'v'},
+	{"connect", no_argument, 0, 'c'},
+	{"disconnect", no_argument, 0, 'd'},
+
+	/* required_argument options */
+	{"addr", required_argument, 0, 'a'},
+	{"port", required_argument, 0, 'p'},
+	{"mode", required_argument, 0, 'm'},
+
+	/* end */
+	{0, 0, 0, 0},
+};
+
+static void usage(const char *this)
+{
+	fprintf(stderr,
+		"Usage: "
+		"\t%s [[options]] command"
+		"\n\t\t [--help/-h] show this help"
+		"\n\t\t [--verbose/-h] Add more trace about what's going on"
+		"\n\t\t [--mode/-m] mausb mode to be used : ip (default) or llc"
+		"\n\t\t [--connect/-c] connect to mausb device"
+		"\n\t\t [--disconnect/-d] disconnect from mausb device"
+		"\n\t\t [--port/-p] set the port number in case of tcp connection"
+		"\n\t\t [--addr/-a] ip or mac address depending on the given mode"
+		"\n", this);
+	return ;
+}
+
+static int check_config(void)
+{
+	int ret;
+
+	if (config.cmd == disconnect)
+		return 0;
+
+	switch (config.mode) {
+	case ip:
+		ret = !config.port;
+		break;
+	case llc:
+		ret = !config.mac;
+		break;
+	default:
+		ret = !! config.mode;
+	}
+
+	return ((config.cmd > max_command) ||
+		(config.mode > supported_mode) ||
+		ret);
+}
+
+static void print_config(void)
+{
+	return ;
+}
+
+static int process_options(int argc, char **argv)
+{
+	int option;
+
+	memset(&config, 0, sizeof(mausb_t));
+        config.mode = ip;
+	while ((option = getopt_long(argc, argv, "hfp:a:cdvm:", l_opts, NULL)) != EOF) {
+		switch(option) {
+		case 'h': // help
+			usage(argv[0]);
+			exit(0);
+			break;
+
+		case 'v': // verbose
+			config.verbose = 1;
+			break;
+ 
+		case 'c': // connect
+			config.cmd = connect;
+			break;
+
+		case 'd': // disconnect
+			config.cmd = disconnect;
+			break;
+
+		case 'm': // mode
+			if (strlen(optarg) == 3 && !strncmp(optarg, "llc", 3))
+				config.mode = llc;
+			else if (strlen(optarg) == 2 && !strncmp(optarg, "ip", 2))
+				config.mode = ip;
+			else {
+				fprintf(stderr, "could not determine mode\n");
+				goto err_options;
+			}
+			break;
+
+		case 'a': // addr
+			if (config.mode == llc) {
+				if (MACADDR_STR_SIZE != strlen(optarg))
+					goto err_options;
+				if (get_mac_address(optarg, config.mac))
+					goto err_options;
+			} else {
+				if (strlen(optarg) >= IPADDR_MAX)
+					goto err_options;
+				if (convert_ipv4_to_uint32(optarg, &config.ip))
+					goto err_options;
+				strcpy(config.ip_addr, optarg);
+			}
+			break;
+
+		case 'p': // port
+			config.port = atoi(optarg);
+			break;
+
+		default:
+			fprintf(stderr, "invalid option %c\n", option);
+			goto err_options;
+			break;
+		}
+	}
+
+	if (check_config()) {
+		fprintf(stderr, "check_config() failed\n");
+		goto err_options;
+	}
+
+	if (config.verbose)
+		print_config();
+
+	return 0;
+
+err_options:
+	usage(argv[0]);
+	return -1;
+}
+
+int main(int argc, char **argv)
+{
+	int ret;
+
+	if (ret = process_options(argc, argv))
+		goto error;
+
+	printf("progran terminated successfully ip %x %s %d\n", config.ip,
+	       config.ip_addr, config.port);
+
+	ret = config.device = open(MAUSB_DEVICE, 0);
+	if (ret < 0) {
+		fprintf(stderr, "cannot open device %d\n", ret);
+		goto error;
+	}
+
+	switch(config.cmd) {
+	case connect:
+		if (config.verbose)
+			printf("connecting to %s port %u\n", config.ip_addr, config.port);
+		if (config.mode == llc) {
+			if (ret = set_mac_addr(&config))
+				goto close_device;
+		} else {
+			if (ret = set_ipv4_addr(&config))
+				goto close_device;
+			if (ret = set_port(&config))
+				goto close_device;
+		}
+		if  (ret = connect_device(&config))
+			goto close_device;
+		break;
+	case disconnect:
+		disconnect_device(&config);
+		break;
+	}
+close_device:
+	close(config.device);
+error:
+	return ret;
+}
diff --git a/drivers/staging/mausb/mausb-util/src/mausb.h b/drivers/staging/mausb/mausb-util/src/mausb.h
new file mode 100644
index 0000000..547bc92a
--- /dev/null
+++ b/drivers/staging/mausb/mausb-util/src/mausb.h
@@ -0,0 +1,64 @@
+/*
+  (c) Aymen Zayet (aymen.zayet@intel.com)
+
+  This file is part of mausb utility.
+
+  mausb is free software: you can redistribute it and/or modify
+  it under the terms of the GNU General Public License as published by
+  the Free Software Foundation, either version 2 of the License, or
+  (at your option) any later version.
+
+  mausb is distributed in the hope that it will be useful,
+  but WITHOUT ANY WARRANTY; without even the implied warranty of
+  MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.	See the
+  GNU General Public License for more details.
+
+  You should have received a copy of the GNU General Public License
+  along with mausb. If not, see <http://www.gnu.org/licenses/>.
+*/
+#ifndef MAUSB_H_
+#define MAUSB_H_
+
+#include <unistd.h>
+#include <stdlib.h>
+#include <string.h>
+#include <errno.h>
+#include <stdint.h>
+#include <stdio.h>
+#include <getopt.h>
+#include <sys/ioctl.h>
+#include "connect.h"
+#include "mausb_ioctl.h"
+
+#define MAUSB_DEVICE "/dev/mausb"
+#define IPADDR_MAX 16
+#define MACADDR_STR_SIZE 17 /* excluding null termination char */
+
+typedef enum {
+	connect,
+	disconnect,
+	max_command,
+} mausb_cmd;
+
+typedef enum {
+	ip,
+	llc,
+	supported_mode,
+} mausb_mode;
+
+typedef struct {
+	int device;		       // file descriptor of the mausb device
+	char verbose;		       // is verbose mode enabled
+	mausb_cmd cmd;		       // keep the requested command to execute
+	uint32_t ip;		       // ip address of the device in case of ip mode
+	char ip_addr[IPADDR_MAX];      // ip address given in cmdline (x.x.x.x)
+	uint8_t mac[6];		       // mac address (aa:bb:cc:dd:ee:ff)
+	uint32_t port;		       // ip port number in case of ip mode
+	mausb_mode mode;	       // default is ip
+} mausb_t;
+
+mausb_t config;
+int convert_ipv4_to_uint32(char *, uint32_t *);
+
+int get_mac_address(char *, uint8_t *);
+#endif /* MAUSB_H_ */
diff --git a/drivers/staging/mausb/mausb-util/src/mausb_ioctl.h b/drivers/staging/mausb/mausb-util/src/mausb_ioctl.h
new file mode 100644
index 0000000..e6953d3
--- /dev/null
+++ b/drivers/staging/mausb/mausb-util/src/mausb_ioctl.h
@@ -0,0 +1,24 @@
+#ifndef MAUSB_IOCTL_H
+#define MAUSB_IOCTL_H
+
+#define BUFFER 80
+#define DRIVER_VERSION "Alpha 0.0.25"
+#define MAJOR_NUM 100
+
+/* These define the ioctl functions that can be used */
+#define IOCTL_GET_VRSN _IOR(MAJOR_NUM, 0, char *)
+#define IOCTL_GET_NAME _IOR(MAJOR_NUM, 1, char *)
+#define IOCTL_GADGET_C _IOR(MAJOR_NUM, 2, char *)
+#define IOCTL_GADGET_D _IOR(MAJOR_NUM, 3, char *)
+#define IOCTL_SET_IP   _IOR(MAJOR_NUM, 4, char *)
+#define IOCTL_SET_PORT _IOR(MAJOR_NUM, 5, char *)
+#define IOCTL_SET_MAC  _IOR(MAJOR_NUM, 6, char *)
+
+
+/* This is the location where the device file will be created. It is used to
+ * read/write to in order to communicate to and from the device */
+#define DEVICE_FILE_NAME "/dev/mausb"
+
+#define ETH_ALEN 6
+
+#endif
diff --git a/drivers/staging/mausb/mausb-util/src/utils.c b/drivers/staging/mausb/mausb-util/src/utils.c
new file mode 100644
index 0000000..f06e2ce
--- /dev/null
+++ b/drivers/staging/mausb/mausb-util/src/utils.c
@@ -0,0 +1,94 @@
+/*
+  (c) Aymen Zayet (aymen.zayet@intel.com)
+
+  This file is part of mausb utility.
+
+  mausb is free software: you can redistribute it and/or modify
+  it under the terms of the GNU General Public License as published by
+  the Free Software Foundation, either version 2 of the License, or
+  (at your option) any later version.
+
+  mausb is distributed in the hope that it will be useful,
+  but WITHOUT ANY WARRANTY; without even the implied warranty of
+  MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.	See the
+  GNU General Public License for more details.
+
+  You should have received a copy of the GNU General Public License
+  along with mausb. If not, see <http://www.gnu.org/licenses/>.
+*/
+#include "mausb.h"
+
+int convert_ipv4_to_uint32(char *addr, uint32_t *ipnum)
+{
+	uint8_t digits[4];
+	int i, j = 0;
+        char ip[64];
+
+	if (addr == NULL)
+		goto input_err;
+
+	strncpy(ip, addr, strlen(addr)+1);
+	i = strlen(ip);
+	memset(digits, 0, 4);
+
+	if (IPADDR_MAX < strlen(ip))
+		goto input_err;
+
+again:
+	while (i-1 && ip[--i - 1] != '.');
+        if (i-1) {
+                ip[i-1] = '\0';
+                digits[j++] = atoi(ip+i);
+		goto again;
+        } else
+                digits[j++] = atoi(ip);
+
+	*ipnum = digits[3] << 24 |
+		digits[2] << 16 |
+		digits[1] << 8 |
+		digits[0] << 0;
+
+        return 0;
+
+input_err:
+	return -1;
+}
+
+
+int get_mac_address(char *addr, uint8_t *out)
+{
+
+	uint8_t digits[6];
+	int i, j = 0;
+	char mac[64];
+
+	if (addr == NULL)
+		goto input_err;
+
+	strncpy(mac, addr, strlen(addr)+1);
+	i = strlen(mac);
+	memset(digits, 0, 6);
+
+	if (MACADDR_STR_SIZE != strlen(mac))
+		goto input_err;
+
+again:
+	while (i-1 && mac[--i - 1] != ':');
+	if (i-1) {
+		mac[i-1] = '\0';
+		digits[j++] = strtol(mac+i, NULL, 16);
+		goto again;
+	} else
+		digits[j++] = strtol(mac, NULL, 16);
+
+	for (i = 0; i < 6; i++) {
+                printf("[%d]=0x%x ", i, digits[i]);
+		out[5-i] = digits[i];
+        }
+
+        printf("\n");
+	return 0;
+
+input_err:
+	return -1;
+}
diff --git a/drivers/staging/mausb/scripts/Android.mk b/drivers/staging/mausb/scripts/Android.mk
new file mode 100644
index 0000000..ddba51a
--- /dev/null
+++ b/drivers/staging/mausb/scripts/Android.mk
@@ -0,0 +1,38 @@
+LOCAL_PATH := $(call my-dir)
+
+include $(CLEAR_VARS)
+LOCAL_MODULE := load_mausb_android.sh
+LOCAL_MODULE_TAGS := optional
+LOCAL_SRC_FILES := $(LOCAL_MODULE)
+LOCAL_MODULE_CLASS := EXECUTABLE
+
+ifeq ($(TARGET_OUT_EXECUTABLE),)
+TARGET_OUT_EXECUTABLE := $(TARGET_OUT)/bin
+endif
+
+include $(BUILD_PREBUILT)
+
+include $(CLEAR_VARS)
+
+LOCAL_MODULE := load_mausb_android-host.sh
+LOCAL_MODULE_TAGS := optional
+LOCAL_SRC_FILES := $(LOCAL_MODULE)
+LOCAL_MODULE_CLASS := EXECUTABLE
+
+ifeq ($(TARGET_OUT_EXECUTABLE),)
+TARGET_OUT_EXECUTABLE := $(TARGET_OUT)/bin
+endif
+
+include $(BUILD_PREBUILT)
+
+include $(CLEAR_VARS)
+LOCAL_MODULE := load_mausb_android-dev.sh
+LOCAL_MODULE_TAGS := optional
+LOCAL_SRC_FILES := $(LOCAL_MODULE)
+LOCAL_MODULE_CLASS := EXECUTABLE
+
+ifeq ($(TARGET_OUT_EXECUTABLE),)
+TARGET_OUT_EXECUTABLE := $(TARGET_OUT)/bin
+endif
+
+include $(BUILD_PREBUILT)
\ No newline at end of file
diff --git a/drivers/staging/mausb/scripts/build_load_connect.sh b/drivers/staging/mausb/scripts/build_load_connect.sh
new file mode 100755
index 0000000..f40cdd7
--- /dev/null
+++ b/drivers/staging/mausb/scripts/build_load_connect.sh
@@ -0,0 +1,69 @@
+#!/bin/bash
+
+side="invalid"
+mode="invalid"
+addr="invalid"
+
+while getopts "hdbtsa:" opt; do
+	case "$opt" in
+	h) side="-h"
+	   ;;
+	d) side="-d"
+	   ;;
+	b) side="-b"
+	   ;;
+	t) mode="-t"
+	   ;;
+	s) mode="-s"
+	   ;;
+	a) addr=$OPTARG
+	   ;;
+	esac
+done
+
+
+if [ "$side" == "invalid" ]
+then
+	echo $side
+	echo "please choose host (-h) or device (-d)"
+	exit
+fi
+
+if [ "$mode" == "invalid" ]
+then
+	echo $mode
+	echo "please choose tcp (-t) or snap (-s)"
+	exit
+fi
+
+if [ "$addr" == "invalid" ]
+then
+	echo $addr
+	echo "please enter a valid address (-a 1.2.3.4, -a 01:23:45:67:89:0a)"
+	exit
+fi
+
+
+cd ../
+# make clean && make
+make -j8
+cd drivers/
+
+wireshark -k -i eth0 &
+
+sudo ../scripts/load_script.sh $side $mode
+
+sudo cat /proc/modules | grep ma
+
+if [ "$mode" == "-s" ]
+then
+	echo "connecting mausb"
+	../tools/mausb-util/mausb -c -m llc -a $addr
+fi
+
+if [ "$mode" == "-t" ]
+then
+	echo "connecting mausb"
+	../tools/mausb-util/mausb -c -m ip -p 9001 -a $addr
+fi
+
diff --git a/drivers/staging/mausb/scripts/load_gzero.sh b/drivers/staging/mausb/scripts/load_gzero.sh
new file mode 100755
index 0000000..9266199
--- /dev/null
+++ b/drivers/staging/mausb/scripts/load_gzero.sh
@@ -0,0 +1,5 @@
+#!/bin/bash
+
+modprobe g_zero
+
+echo g_zero load process complete
\ No newline at end of file
diff --git a/drivers/staging/mausb/scripts/load_mausb_android-dev.sh b/drivers/staging/mausb/scripts/load_mausb_android-dev.sh
new file mode 100755
index 0000000..c23cdef
--- /dev/null
+++ b/drivers/staging/mausb/scripts/load_mausb_android-dev.sh
@@ -0,0 +1,31 @@
+#!/system/xbin/ash
+
+# For Android targets, insmod shall be used since
+# the ueventd take care of the dependencies.
+
+GREEN="\\033[1;32m"
+NORMAL="\\033[0;39m"
+RED="\\033[1;31m"
+
+load_module()
+{
+    insmod $1
+    if [ $? -ne 0 ]; then
+	echo -e $RED
+	echo "unable to insmod $1 (err : $?)"
+	echo -e $NORMAL
+	exit $?
+    fi
+}
+
+
+load_module /lib/modules/matcp_core.ko
+load_module /lib/modules/maudc.ko
+#load_module /lib/modules/mamed.ko
+load_module /lib/modules/matcp_dev.ko
+
+mknod /dev/mausb c 100 0
+
+echo -e $GREEN
+echo "mausb load process complete"
+echo -e $NORMAL
diff --git a/drivers/staging/mausb/scripts/load_mausb_android-host.sh b/drivers/staging/mausb/scripts/load_mausb_android-host.sh
new file mode 100755
index 0000000..85f0a20
--- /dev/null
+++ b/drivers/staging/mausb/scripts/load_mausb_android-host.sh
@@ -0,0 +1,31 @@
+#!/system/xbin/ash
+
+# For Android targets, insmod shall be used since
+# the ueventd take care of the dependencies.
+
+GREEN="\\033[1;32m"
+NORMAL="\\033[0;39m"
+RED="\\033[1;31m"
+
+load_module()
+{
+    insmod $1
+    if [ $? -ne 0 ]; then
+	echo -e $RED
+	echo "unable to insmod $1 (err : $?)"
+	echo -e $NORMAL
+	exit $?
+    fi
+}
+
+
+load_module /lib/modules/matcp_core.ko
+load_module /lib/modules/mausb.ko
+#load_module /lib/modules/mamed.ko
+load_module /lib/modules/matcp_host.ko
+
+mknod /dev/mausb c 100 0
+
+echo -e $GREEN
+echo "mausb load process complete"
+echo -e $NORMAL
diff --git a/drivers/staging/mausb/scripts/load_mausb_android.sh b/drivers/staging/mausb/scripts/load_mausb_android.sh
new file mode 100755
index 0000000..57f119e
--- /dev/null
+++ b/drivers/staging/mausb/scripts/load_mausb_android.sh
@@ -0,0 +1,33 @@
+#!/system/xbin/ash
+
+# For Android targets, insmod shall be used since
+# the ueventd take care of the dependencies.
+
+GREEN="\\033[1;32m"
+NORMAL="\\033[0;39m"
+RED="\\033[1;31m"
+
+load_module()
+{
+    insmod $1
+    if [ $? -ne 0 ]; then
+	echo -e $RED
+	echo "unable to insmod $1 (err : $?)"
+	echo -e $NORMAL
+	exit $?
+    fi
+}
+
+
+load_module /lib/modules/matcp_core.ko
+load_module /lib/modules/mausb.ko
+load_module /lib/modules/maudc.ko
+#load_module /lib/modules/mamed.ko
+load_module /lib/modules/matcp_host.ko
+load_module /lib/modules/matcp_dev.ko
+
+mknod /dev/mausb c 100 0
+
+echo -e $GREEN
+echo "mausb load process complete"
+echo -e $NORMAL
\ No newline at end of file
diff --git a/drivers/staging/mausb/scripts/load_script.sh b/drivers/staging/mausb/scripts/load_script.sh
new file mode 100755
index 0000000..7c92afa
--- /dev/null
+++ b/drivers/staging/mausb/scripts/load_script.sh
@@ -0,0 +1,125 @@
+#!/bin/bash
+# This script is used for loading & unloading the mausb_driver
+
+# note: this script must be run with root priviledge (for the modprobes)
+
+side="invalid"
+mode="invalid"
+load="load"
+
+# Determine weather to load a host or device in TCP mode or snap mode
+while getopts "hdbtslu" opt; do
+	case "$opt" in
+	h) side="host"
+	   ;;
+	d) side="device"
+	   ;;
+	b) side="both"
+	   ;;
+	t) mode="tcp"
+	   ;;
+	s) mode="snap"
+	   ;;
+	l) load="load"
+	   ;;
+	u) load="unload"
+	   ;;
+	esac
+done
+
+if [ "$side" == "invalid" ]
+then
+	echo $side
+	echo "please choose host (-h) or device (-d)"
+	exit
+fi
+
+if [ "$mode" == "invalid" ]
+then
+	echo $mode
+	echo "please choose a tcp (-t) or snap (-s)"
+	exit
+fi
+
+
+
+if [ "$load" == "load" ]
+then
+	# copy the LKM into the module library
+	pushd $(dirname $0)
+	cp ../drivers/*.ko /lib/modules/$(uname -r)/kernel/drivers/usb/
+	popd
+
+	# depmod so the kernel can figure out its dependacies
+	depmod -A
+
+	# open the file for ioctl calls
+	mknod /dev/mausb c 100 0
+
+	modprobe_flags=""
+
+elif [ "$load" == "unload" ]
+then
+	# unload the drivers instead of loading them
+	modprobe_flags="-r"
+
+fi
+
+
+
+# load the drivers
+
+if [ "$mode" == "tcp" ] && [ "$load" == "load" ]
+then
+	modprobe $modprobe_flags matcp_core
+
+elif [ "$mode" == "snap" ]
+then
+	modprobe $modprobe_flags masnap_core
+fi
+
+
+if [ "$side" == "device" ] || [ "$side" == "both" ]
+then
+	if [ "$load" == "load" ]
+	then
+		modprobe $modprobe_flags maudc
+	fi
+
+	modprobe $modprobe_flags g_zero
+
+	if [ "$mode" == "tcp" ]
+	then
+		modprobe $modprobe_flags matcp_dev
+
+	elif [ "$mode" == "snap" ]
+	then
+		modprobe $modprobe_flags masnap_dev
+	fi
+fi
+
+if [ "$side" == "host" ] || [ "$side" == "both" ]
+then
+	if [ "$load" == "load" ]
+	then
+		modprobe $modprobe_flags mausb
+	fi
+
+	if [ "$mode" == "tcp" ]
+	then
+		modprobe $modprobe_flags matcp_host
+
+	elif [ "$mode" == "snap" ]
+	then
+		modprobe $modprobe_flags masnap_host
+	fi
+
+fi
+
+if [ "$load" == "unload" ]
+then
+	modprobe $modprobe_flags maudc
+	modprobe $modprobe_flags mausb
+fi
+
+echo "$load mausb $side $mode driver complete"
diff --git a/drivers/staging/mausb/scripts/modprobify.sh b/drivers/staging/mausb/scripts/modprobify.sh
new file mode 100755
index 0000000..b5f16ab
--- /dev/null
+++ b/drivers/staging/mausb/scripts/modprobify.sh
@@ -0,0 +1,10 @@
+#!/bin/bash
+
+
+# note: this scripted needs to be run as a superuser to work
+
+# copy the LKM into the module library
+cp ./*.ko /lib/modules/$(uname -r)/kernel/drivers/usb/
+
+# depmod so the kernel can figure out its dependacies
+depmod -A
diff --git a/drivers/staging/mausb/scripts/unload_gzero.sh b/drivers/staging/mausb/scripts/unload_gzero.sh
new file mode 100755
index 0000000..e506b2d
--- /dev/null
+++ b/drivers/staging/mausb/scripts/unload_gzero.sh
@@ -0,0 +1,5 @@
+#!/bin/bash
+
+modprobe -r g_zero
+
+echo g_zero unload process complete
\ No newline at end of file
-- 
1.9.1


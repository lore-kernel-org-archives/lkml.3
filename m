Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757288AbaEIXnZ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 May 2014 19:43:25 -0400
Received: from smtprelay0129.hostedemail.com ([216.40.44.129]:55497 "EHLO
	smtprelay.hostedemail.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1755200AbaEIXnU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 May 2014 19:43:20 -0400
X-Session-Marker: 6A6F6540706572636865732E636F6D
X-Spam-Summary: 2,0,0,,d41d8cd98f00b204,joe@perches.com,:::::::,RULES_HIT:69:355:379:541:960:966:968:973:981:982:988:989:1260:1345:1359:1437:1605:1730:1747:1777:1792:1801:2196:2198:2199:2200:2393:2538:2559:2562:2693:2731:2898:2901:3138:3139:3140:3141:3142:3865:3866:3867:3868:3870:3871:3872:3874:4250:4321:4385:4605:5007:6248:6261:7875:7903:7904:8603:10004:10026:10226:10848:11026:11638:11657:11914:12043:12257:12294:12296:12438:12517:12519:12555:12679:12683:13161:13229:13972:21063,0,RBL:none,CacheIP:none,Bayesian:0.5,0.5,0.5,Netcheck:none,DomainCache:0,MSF:not bulk,SPF:fn,MSBL:0,DNSBL:none,Custom_rules:0:0:0
X-HE-Tag: stamp74_910a87eabb332
X-Filterd-Recvd-Size: 77050
From: Joe Perches <joe@perches.com>
To: linux-kernel@vger.kernel.org
Cc: Jeff Dike <jdike@addtoit.com>, Richard Weinberger <richard@nod.at>,
        user-mode-linux-devel@lists.sourceforge.net
Subject: [PATCH 1/4] UserModeLinux: Convert UM_KERN_<LEVEL> to KERN_<LEVEL>
Date: Fri,  9 May 2014 16:43:10 -0700
Message-Id: <e519609e20be6c6be87bbf0e2dd716abdfaa698e.1399678795.git.joe@perches.com>
X-Mailer: git-send-email 1.8.1.2.459.gbcd45b4.dirty
In-Reply-To: <cover.1399678795.git.joe@perches.com>
References: <cover.1399678795.git.joe@perches.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The defines are the same since commit 9429ec96c2718
("um: Preinclude include/linux/kern_levels.h")
so just convert them to the normal KERN_<LEVEL> uses.

Signed-off-by: Joe Perches <joe@perches.com>
---
 arch/um/drivers/chan_user.c              | 28 ++++++-------
 arch/um/drivers/daemon_user.c            | 16 ++++----
 arch/um/drivers/fd.c                     |  6 +--
 arch/um/drivers/mconsole_user.c          |  4 +-
 arch/um/drivers/net_user.c               | 12 +++---
 arch/um/drivers/pcap_user.c              | 12 +++---
 arch/um/drivers/port_user.c              |  4 +-
 arch/um/drivers/pty.c                    |  4 +-
 arch/um/drivers/slip_user.c              | 20 ++++-----
 arch/um/drivers/slirp_user.c             |  6 +--
 arch/um/drivers/tty.c                    |  2 +-
 arch/um/drivers/umcast_user.c            | 20 ++++-----
 arch/um/drivers/vde_user.c               | 12 +++---
 arch/um/drivers/xterm.c                  | 16 ++++----
 arch/um/os-Linux/aio.c                   | 26 ++++++------
 arch/um/os-Linux/drivers/ethertap_user.c | 20 ++++-----
 arch/um/os-Linux/drivers/tuntap_user.c   | 14 +++----
 arch/um/os-Linux/file.c                  | 22 +++++-----
 arch/um/os-Linux/helper.c                | 18 ++++----
 arch/um/os-Linux/irq.c                   |  4 +-
 arch/um/os-Linux/process.c               | 22 +++++-----
 arch/um/os-Linux/sigio.c                 | 52 ++++++++++++------------
 arch/um/os-Linux/skas/mem.c              | 14 +++----
 arch/um/os-Linux/skas/process.c          | 70 ++++++++++++++++----------------
 arch/um/os-Linux/time.c                  |  2 +-
 arch/um/os-Linux/tty.c                   |  6 +--
 arch/um/os-Linux/umid.c                  | 28 ++++++-------
 arch/x86/um/bugs_32.c                    | 14 +++----
 arch/x86/um/os-Linux/registers.c         |  2 +-
 29 files changed, 238 insertions(+), 238 deletions(-)

diff --git a/arch/um/drivers/chan_user.c b/arch/um/drivers/chan_user.c
index 3fd7c3e..c0d47cf 100644
--- a/arch/um/drivers/chan_user.c
+++ b/arch/um/drivers/chan_user.c
@@ -153,7 +153,7 @@ static int winch_thread(void *arg)
 	pipe_fd = data->pipe_fd;
 	count = write(pipe_fd, &c, sizeof(c));
 	if (count != sizeof(c))
-		printk(UM_KERN_ERR "winch_thread : failed to write "
+		printk(KERN_ERR "winch_thread : failed to write "
 		       "synchronization byte, err = %d\n", -count);
 
 	/*
@@ -166,7 +166,7 @@ static int winch_thread(void *arg)
 	sigfillset(&sigs);
 	/* Block all signals possible. */
 	if (sigprocmask(SIG_SETMASK, &sigs, NULL) < 0) {
-		printk(UM_KERN_ERR "winch_thread : sigprocmask failed, "
+		printk(KERN_ERR "winch_thread : sigprocmask failed, "
 		       "errno = %d\n", errno);
 		exit(1);
 	}
@@ -174,19 +174,19 @@ static int winch_thread(void *arg)
 	sigdelset(&sigs, SIGWINCH);
 
 	if (setsid() < 0) {
-		printk(UM_KERN_ERR "winch_thread : setsid failed, errno = %d\n",
+		printk(KERN_ERR "winch_thread : setsid failed, errno = %d\n",
 		       errno);
 		exit(1);
 	}
 
 	if (ioctl(pty_fd, TIOCSCTTY, 0) < 0) {
-		printk(UM_KERN_ERR "winch_thread : TIOCSCTTY failed on "
+		printk(KERN_ERR "winch_thread : TIOCSCTTY failed on "
 		       "fd %d err = %d\n", pty_fd, errno);
 		exit(1);
 	}
 
 	if (tcsetpgrp(pty_fd, os_getpid()) < 0) {
-		printk(UM_KERN_ERR "winch_thread : tcsetpgrp failed on "
+		printk(KERN_ERR "winch_thread : tcsetpgrp failed on "
 		       "fd %d err = %d\n", pty_fd, errno);
 		exit(1);
 	}
@@ -199,7 +199,7 @@ static int winch_thread(void *arg)
 	 */
 	count = read(pipe_fd, &c, sizeof(c));
 	if (count != sizeof(c))
-		printk(UM_KERN_ERR "winch_thread : failed to read "
+		printk(KERN_ERR "winch_thread : failed to read "
 		       "synchronization byte, err = %d\n", errno);
 
 	while(1) {
@@ -211,7 +211,7 @@ static int winch_thread(void *arg)
 
 		count = write(pipe_fd, &c, sizeof(c));
 		if (count != sizeof(c))
-			printk(UM_KERN_ERR "winch_thread : write failed, "
+			printk(KERN_ERR "winch_thread : write failed, "
 			       "err = %d\n", errno);
 	}
 }
@@ -225,7 +225,7 @@ static int winch_tramp(int fd, struct tty_port *port, int *fd_out,
 
 	err = os_pipe(fds, 1, 1);
 	if (err < 0) {
-		printk(UM_KERN_ERR "winch_tramp : os_pipe failed, err = %d\n",
+		printk(KERN_ERR "winch_tramp : os_pipe failed, err = %d\n",
 		       -err);
 		goto out;
 	}
@@ -240,7 +240,7 @@ static int winch_tramp(int fd, struct tty_port *port, int *fd_out,
 	 */
 	err = run_helper_thread(winch_thread, &data, CLONE_FILES, stack_out);
 	if (err < 0) {
-		printk(UM_KERN_ERR "fork of winch_thread failed - errno = %d\n",
+		printk(KERN_ERR "fork of winch_thread failed - errno = %d\n",
 		       -err);
 		goto out_close;
 	}
@@ -248,16 +248,16 @@ static int winch_tramp(int fd, struct tty_port *port, int *fd_out,
 	*fd_out = fds[0];
 	n = read(fds[0], &c, sizeof(c));
 	if (n != sizeof(c)) {
-		printk(UM_KERN_ERR "winch_tramp : failed to read "
+		printk(KERN_ERR "winch_tramp : failed to read "
 		       "synchronization byte\n");
-		printk(UM_KERN_ERR "read failed, err = %d\n", errno);
-		printk(UM_KERN_ERR "fd %d will not support SIGWINCH\n", fd);
+		printk(KERN_ERR "read failed, err = %d\n", errno);
+		printk(KERN_ERR "fd %d will not support SIGWINCH\n", fd);
 		err = -EINVAL;
 		goto out_close;
 	}
 
 	if (os_set_fd_block(*fd_out, 0)) {
-		printk(UM_KERN_ERR "winch_tramp: failed to set thread_fd "
+		printk(KERN_ERR "winch_tramp: failed to set thread_fd "
 		       "non-blocking.\n");
 		goto out_close;
 	}
@@ -295,7 +295,7 @@ void register_winch(int fd, struct tty_port *port)
 
 		count = write(thread_fd, &c, sizeof(c));
 		if (count != sizeof(c))
-			printk(UM_KERN_ERR "register_winch : failed to write "
+			printk(KERN_ERR "register_winch : failed to write "
 			       "synchronization byte, err = %d\n", errno);
 	}
 }
diff --git a/arch/um/drivers/daemon_user.c b/arch/um/drivers/daemon_user.c
index 8813c10..f3933c7 100644
--- a/arch/um/drivers/daemon_user.c
+++ b/arch/um/drivers/daemon_user.c
@@ -35,7 +35,7 @@ static struct sockaddr_un *new_addr(void *name, int len)
 
 	sun = uml_kmalloc(sizeof(struct sockaddr_un), UM_GFP_KERNEL);
 	if (sun == NULL) {
-		printk(UM_KERN_ERR "new_addr: allocation of sockaddr_un "
+		printk(KERN_ERR "new_addr: allocation of sockaddr_un "
 		       "failed\n");
 		return NULL;
 	}
@@ -55,7 +55,7 @@ static int connect_to_switch(struct daemon_data *pri)
 	pri->control = socket(AF_UNIX, SOCK_STREAM, 0);
 	if (pri->control < 0) {
 		err = -errno;
-		printk(UM_KERN_ERR "daemon_open : control socket failed, "
+		printk(KERN_ERR "daemon_open : control socket failed, "
 		       "errno = %d\n", -err);
 		return err;
 	}
@@ -63,7 +63,7 @@ static int connect_to_switch(struct daemon_data *pri)
 	if (connect(pri->control, (struct sockaddr *) ctl_addr,
 		   sizeof(*ctl_addr)) < 0) {
 		err = -errno;
-		printk(UM_KERN_ERR "daemon_open : control connect failed, "
+		printk(KERN_ERR "daemon_open : control connect failed, "
 		       "errno = %d\n", -err);
 		goto out;
 	}
@@ -71,20 +71,20 @@ static int connect_to_switch(struct daemon_data *pri)
 	fd = socket(AF_UNIX, SOCK_DGRAM, 0);
 	if (fd < 0) {
 		err = -errno;
-		printk(UM_KERN_ERR "daemon_open : data socket failed, "
+		printk(KERN_ERR "daemon_open : data socket failed, "
 		       "errno = %d\n", -err);
 		goto out;
 	}
 	if (bind(fd, (struct sockaddr *) local_addr, sizeof(*local_addr)) < 0) {
 		err = -errno;
-		printk(UM_KERN_ERR "daemon_open : data bind failed, "
+		printk(KERN_ERR "daemon_open : data bind failed, "
 		       "errno = %d\n", -err);
 		goto out_close;
 	}
 
 	sun = uml_kmalloc(sizeof(struct sockaddr_un), UM_GFP_KERNEL);
 	if (sun == NULL) {
-		printk(UM_KERN_ERR "new_addr: allocation of sockaddr_un "
+		printk(KERN_ERR "new_addr: allocation of sockaddr_un "
 		       "failed\n");
 		err = -ENOMEM;
 		goto out_close;
@@ -96,7 +96,7 @@ static int connect_to_switch(struct daemon_data *pri)
 	req.sock = *local_addr;
 	n = write(pri->control, &req, sizeof(req));
 	if (n != sizeof(req)) {
-		printk(UM_KERN_ERR "daemon_open : control setup request "
+		printk(KERN_ERR "daemon_open : control setup request "
 		       "failed, err = %d\n", -errno);
 		err = -ENOTCONN;
 		goto out_free;
@@ -104,7 +104,7 @@ static int connect_to_switch(struct daemon_data *pri)
 
 	n = read(pri->control, sun, sizeof(*sun));
 	if (n != sizeof(*sun)) {
-		printk(UM_KERN_ERR "daemon_open : read of data socket failed, "
+		printk(KERN_ERR "daemon_open : read of data socket failed, "
 		       "err = %d\n", -errno);
 		err = -ENOTCONN;
 		goto out_free;
diff --git a/arch/um/drivers/fd.c b/arch/um/drivers/fd.c
index a13a427..bc9310c 100644
--- a/arch/um/drivers/fd.c
+++ b/arch/um/drivers/fd.c
@@ -26,14 +26,14 @@ static void *fd_init(char *str, int device, const struct chan_opts *opts)
 	int n;
 
 	if (*str != ':') {
-		printk(UM_KERN_ERR "fd_init : channel type 'fd' must specify a "
+		printk(KERN_ERR "fd_init : channel type 'fd' must specify a "
 		       "file descriptor\n");
 		return NULL;
 	}
 	str++;
 	n = strtoul(str, &end, 0);
 	if ((*end != '\0') || (end == str)) {
-		printk(UM_KERN_ERR "fd_init : couldn't parse file descriptor "
+		printk(KERN_ERR "fd_init : couldn't parse file descriptor "
 		       "'%s'\n", str);
 		return NULL;
 	}
@@ -76,7 +76,7 @@ static void fd_close(int fd, void *d)
 
 	CATCH_EINTR(err = tcsetattr(fd, TCSAFLUSH, &data->tt));
 	if (err)
-		printk(UM_KERN_ERR "Failed to restore terminal state - "
+		printk(KERN_ERR "Failed to restore terminal state - "
 		       "errno = %d\n", -err);
 	data->raw = 0;
 }
diff --git a/arch/um/drivers/mconsole_user.c b/arch/um/drivers/mconsole_user.c
index 9920982..f77908f 100644
--- a/arch/um/drivers/mconsole_user.c
+++ b/arch/um/drivers/mconsole_user.c
@@ -187,7 +187,7 @@ int mconsole_notify(char *sock_name, int type, const void *data, int len)
 		notify_sock = socket(PF_UNIX, SOCK_DGRAM, 0);
 		if (notify_sock < 0) {
 			err = -errno;
-			printk(UM_KERN_ERR "mconsole_notify - socket failed, "
+			printk(KERN_ERR "mconsole_notify - socket failed, "
 			       "errno = %d\n", errno);
 		}
 	}
@@ -212,7 +212,7 @@ int mconsole_notify(char *sock_name, int type, const void *data, int len)
 		   sizeof(target));
 	if (n < 0) {
 		err = -errno;
-		printk(UM_KERN_ERR "mconsole_notify - sendto failed, "
+		printk(KERN_ERR "mconsole_notify - sendto failed, "
 		       "errno = %d\n", errno);
 	}
 	return err;
diff --git a/arch/um/drivers/net_user.c b/arch/um/drivers/net_user.c
index cd14157..2c1bc11 100644
--- a/arch/um/drivers/net_user.c
+++ b/arch/um/drivers/net_user.c
@@ -23,7 +23,7 @@ int tap_open_common(void *dev, char *gate_addr)
 		return 0;
 	if (sscanf(gate_addr, "%d.%d.%d.%d", &tap_addr[0],
 		  &tap_addr[1], &tap_addr[2], &tap_addr[3]) != 4) {
-		printk(UM_KERN_ERR "Invalid tap IP address - '%s'\n",
+		printk(KERN_ERR "Invalid tap IP address - '%s'\n",
 		       gate_addr);
 		return -EINVAL;
 	}
@@ -41,7 +41,7 @@ void tap_check_ips(char *gate_addr, unsigned char *eth_addr)
 	    (eth_addr[1] == tap_addr[1]) &&
 	    (eth_addr[2] == tap_addr[2]) &&
 	    (eth_addr[3] == tap_addr[3])) {
-		printk(UM_KERN_ERR "The tap IP address and the UML eth IP "
+		printk(KERN_ERR "The tap IP address and the UML eth IP "
 		       "address must be different\n");
 	}
 }
@@ -85,10 +85,10 @@ void read_output(int fd, char *output, int len)
 
 err:
 	if (ret < 0)
-		printk(UM_KERN_ERR "read_output - read of %s failed, "
+		printk(KERN_ERR "read_output - read of %s failed, "
 		       "errno = %d\n", str, -ret);
 	else
-		printk(UM_KERN_ERR "read_output - read of %s failed, read only "
+		printk(KERN_ERR "read_output - read of %s failed, read only "
 		       "%d of %d bytes\n", str, ret, expected);
 }
 
@@ -184,7 +184,7 @@ static int change_tramp(char **argv, char *output, int output_len)
 
 	err = os_pipe(fds, 1, 0);
 	if (err < 0) {
-		printk(UM_KERN_ERR "change_tramp - pipe failed, err = %d\n",
+		printk(KERN_ERR "change_tramp - pipe failed, err = %d\n",
 		       -err);
 		return err;
 	}
@@ -222,7 +222,7 @@ static void change(char *dev, char *what, unsigned char *addr,
 	output_len = UM_KERN_PAGE_SIZE;
 	output = uml_kmalloc(output_len, UM_GFP_KERNEL);
 	if (output == NULL)
-		printk(UM_KERN_ERR "change : failed to allocate output "
+		printk(KERN_ERR "change : failed to allocate output "
 		       "buffer\n");
 
 	pid = change_tramp(argv, output, output_len);
diff --git a/arch/um/drivers/pcap_user.c b/arch/um/drivers/pcap_user.c
index c07b9c7..c3431a4 100644
--- a/arch/um/drivers/pcap_user.c
+++ b/arch/um/drivers/pcap_user.c
@@ -22,7 +22,7 @@ static int pcap_user_init(void *data, void *dev)
 	p = pcap_open_live(pri->host_if, ETH_MAX_PACKET + ETH_HEADER_OTHER,
 			   pri->promisc, 0, errors);
 	if (p == NULL) {
-		printk(UM_KERN_ERR "pcap_user_init : pcap_open_live failed - "
+		printk(KERN_ERR "pcap_user_init : pcap_open_live failed - "
 		       "'%s'\n", errors);
 		return -EINVAL;
 	}
@@ -44,14 +44,14 @@ static int pcap_open(void *data)
 	if (pri->filter != NULL) {
 		err = dev_netmask(pri->dev, &netmask);
 		if (err < 0) {
-			printk(UM_KERN_ERR "pcap_open : dev_netmask failed\n");
+			printk(KERN_ERR "pcap_open : dev_netmask failed\n");
 			return -EIO;
 		}
 
 		pri->compiled = uml_kmalloc(sizeof(struct bpf_program),
 					UM_GFP_KERNEL);
 		if (pri->compiled == NULL) {
-			printk(UM_KERN_ERR "pcap_open : kmalloc failed\n");
+			printk(KERN_ERR "pcap_open : kmalloc failed\n");
 			return -ENOMEM;
 		}
 
@@ -59,14 +59,14 @@ static int pcap_open(void *data)
 				   (struct bpf_program *) pri->compiled,
 				   pri->filter, pri->optimize, netmask);
 		if (err < 0) {
-			printk(UM_KERN_ERR "pcap_open : pcap_compile failed - "
+			printk(KERN_ERR "pcap_open : pcap_compile failed - "
 			       "'%s'\n", pcap_geterr(pri->pcap));
 			goto out;
 		}
 
 		err = pcap_setfilter(pri->pcap, pri->compiled);
 		if (err < 0) {
-			printk(UM_KERN_ERR "pcap_open : pcap_setfilter "
+			printk(KERN_ERR "pcap_open : pcap_setfilter "
 			       "failed - '%s'\n", pcap_geterr(pri->pcap));
 			goto out;
 		}
@@ -116,7 +116,7 @@ int pcap_user_read(int fd, void *buffer, int len, struct pcap_data *pri)
 
 	n = pcap_dispatch(pri->pcap, 1, handler, (u_char *) &hdata);
 	if (n < 0) {
-		printk(UM_KERN_ERR "pcap_dispatch failed - %s\n",
+		printk(KERN_ERR "pcap_dispatch failed - %s\n",
 		       pcap_geterr(pri->pcap));
 		return -EIO;
 	}
diff --git a/arch/um/drivers/port_user.c b/arch/um/drivers/port_user.c
index 9a8e1b6..a8dfe5c 100644
--- a/arch/um/drivers/port_user.c
+++ b/arch/um/drivers/port_user.c
@@ -29,14 +29,14 @@ static void *port_init(char *str, int device, const struct chan_opts *opts)
 	int port;
 
 	if (*str != ':') {
-		printk(UM_KERN_ERR "port_init : channel type 'port' must "
+		printk(KERN_ERR "port_init : channel type 'port' must "
 		       "specify a port number\n");
 		return NULL;
 	}
 	str++;
 	port = strtoul(str, &end, 0);
 	if ((*end != '\0') || (end == str)) {
-		printk(UM_KERN_ERR "port_init : couldn't parse port '%s'\n",
+		printk(KERN_ERR "port_init : couldn't parse port '%s'\n",
 		       str);
 		return NULL;
 	}
diff --git a/arch/um/drivers/pty.c b/arch/um/drivers/pty.c
index f1fcc2c..f43ba32 100644
--- a/arch/um/drivers/pty.c
+++ b/arch/um/drivers/pty.c
@@ -47,7 +47,7 @@ static int pts_open(int input, int output, int primary, void *d,
 	fd = get_pty();
 	if (fd < 0) {
 		err = -errno;
-		printk(UM_KERN_ERR "open_pts : Failed to open pts\n");
+		printk(KERN_ERR "open_pts : Failed to open pts\n");
 		return err;
 	}
 
@@ -106,7 +106,7 @@ static int getmaster(char *line)
 		}
 	}
 
-	printk(UM_KERN_ERR "getmaster - no usable host pty devices\n");
+	printk(KERN_ERR "getmaster - no usable host pty devices\n");
 	return -ENOENT;
 }
 
diff --git a/arch/um/drivers/slip_user.c b/arch/um/drivers/slip_user.c
index 55c290d..ffced38 100644
--- a/arch/um/drivers/slip_user.c
+++ b/arch/um/drivers/slip_user.c
@@ -30,7 +30,7 @@ static int set_up_tty(int fd)
 	struct termios tios;
 
 	if (tcgetattr(fd, &tios) < 0) {
-		printk(UM_KERN_ERR "could not get initial terminal "
+		printk(KERN_ERR "could not get initial terminal "
 		       "attributes\n");
 		return -1;
 	}
@@ -48,7 +48,7 @@ static int set_up_tty(int fd)
 	cfsetispeed(&tios, B38400);
 
 	if (tcsetattr(fd, TCSAFLUSH, &tios) < 0) {
-		printk(UM_KERN_ERR "failed to set terminal attributes\n");
+		printk(KERN_ERR "failed to set terminal attributes\n");
 		return -1;
 	}
 	return 0;
@@ -79,7 +79,7 @@ static int slip_tramp(char **argv, int fd)
 
 	err = os_pipe(fds, 1, 0);
 	if (err < 0) {
-		printk(UM_KERN_ERR "slip_tramp : pipe failed, err = %d\n",
+		printk(KERN_ERR "slip_tramp : pipe failed, err = %d\n",
 		       -err);
 		goto out;
 	}
@@ -96,7 +96,7 @@ static int slip_tramp(char **argv, int fd)
 	output_len = UM_KERN_PAGE_SIZE;
 	output = uml_kmalloc(output_len, UM_GFP_KERNEL);
 	if (output == NULL) {
-		printk(UM_KERN_ERR "slip_tramp : failed to allocate output "
+		printk(KERN_ERR "slip_tramp : failed to allocate output "
 		       "buffer\n");
 		os_kill_process(pid, 1);
 		err = -ENOMEM;
@@ -131,7 +131,7 @@ static int slip_open(void *data)
 
 	err = get_pty();
 	if (err < 0) {
-		printk(UM_KERN_ERR "slip-open : Failed to open pty, err = %d\n",
+		printk(KERN_ERR "slip-open : Failed to open pty, err = %d\n",
 		       -err);
 		goto out;
 	}
@@ -139,7 +139,7 @@ static int slip_open(void *data)
 
 	err = open(ptsname(mfd), O_RDWR, 0);
 	if (err < 0) {
-		printk(UM_KERN_ERR "Couldn't open tty for slip line, "
+		printk(KERN_ERR "Couldn't open tty for slip line, "
 		       "err = %d\n", -err);
 		goto out_close;
 	}
@@ -158,13 +158,13 @@ static int slip_open(void *data)
 		err = slip_tramp(argv, sfd);
 
 		if (err < 0) {
-			printk(UM_KERN_ERR "slip_tramp failed - err = %d\n",
+			printk(KERN_ERR "slip_tramp failed - err = %d\n",
 			       -err);
 			goto out_close2;
 		}
 		err = os_get_ifname(pri->slave, pri->name);
 		if (err < 0) {
-			printk(UM_KERN_ERR "get_ifname failed, err = %d\n",
+			printk(KERN_ERR "get_ifname failed, err = %d\n",
 			       -err);
 			goto out_close2;
 		}
@@ -173,7 +173,7 @@ static int slip_open(void *data)
 	else {
 		err = os_set_slip(sfd);
 		if (err < 0) {
-			printk(UM_KERN_ERR "Failed to set slip discipline "
+			printk(KERN_ERR "Failed to set slip discipline "
 			       "encapsulation - err = %d\n", -err);
 			goto out_close2;
 		}
@@ -203,7 +203,7 @@ static void slip_close(int fd, void *data)
 	err = slip_tramp(argv, pri->slave);
 
 	if (err != 0)
-		printk(UM_KERN_ERR "slip_tramp failed - errno = %d\n", -err);
+		printk(KERN_ERR "slip_tramp failed - errno = %d\n", -err);
 	close(fd);
 	close(pri->slave);
 	pri->slave = -1;
diff --git a/arch/um/drivers/slirp_user.c b/arch/um/drivers/slirp_user.c
index c999d18..4a049c3 100644
--- a/arch/um/drivers/slirp_user.c
+++ b/arch/um/drivers/slirp_user.c
@@ -57,7 +57,7 @@ static int slirp_open(void *data)
 
 	err = slirp_tramp(pri->argw.argv, fds[1]);
 	if (err < 0) {
-		printk(UM_KERN_ERR "slirp_tramp failed - errno = %d\n", -err);
+		printk(KERN_ERR "slirp_tramp failed - errno = %d\n", -err);
 		goto out;
 	}
 	pid = err;
@@ -85,14 +85,14 @@ static void slirp_close(int fd, void *data)
 	pri->slave = -1;
 
 	if (pri->pid<1) {
-		printk(UM_KERN_ERR "slirp_close: no child process to shut "
+		printk(KERN_ERR "slirp_close: no child process to shut "
 		       "down\n");
 		return;
 	}
 
 #if 0
 	if (kill(pri->pid, SIGHUP)<0) {
-		printk(UM_KERN_ERR "slirp_close: sending hangup to %d failed "
+		printk(KERN_ERR "slirp_close: sending hangup to %d failed "
 		       "(%d)\n", pri->pid, errno);
 	}
 #endif
diff --git a/arch/um/drivers/tty.c b/arch/um/drivers/tty.c
index eaa201b..ef1f138 100644
--- a/arch/um/drivers/tty.c
+++ b/arch/um/drivers/tty.c
@@ -21,7 +21,7 @@ static void *tty_chan_init(char *str, int device, const struct chan_opts *opts)
 	struct tty_chan *data;
 
 	if (*str != ':') {
-		printk(UM_KERN_ERR "tty_init : channel type 'tty' must specify "
+		printk(KERN_ERR "tty_init : channel type 'tty' must specify "
 		       "a device\n");
 		return NULL;
 	}
diff --git a/arch/um/drivers/umcast_user.c b/arch/um/drivers/umcast_user.c
index 6074184..95abd89 100644
--- a/arch/um/drivers/umcast_user.c
+++ b/arch/um/drivers/umcast_user.c
@@ -25,7 +25,7 @@ static struct sockaddr_in *new_addr(char *addr, unsigned short port)
 
 	sin = uml_kmalloc(sizeof(struct sockaddr_in), UM_GFP_KERNEL);
 	if (sin == NULL) {
-		printk(UM_KERN_ERR "new_addr: allocation of sockaddr_in "
+		printk(KERN_ERR "new_addr: allocation of sockaddr_in "
 		       "failed\n");
 		return NULL;
 	}
@@ -79,14 +79,14 @@ static int umcast_open(void *data)
 
 	if (fd < 0) {
 		err = -errno;
-		printk(UM_KERN_ERR "umcast_open : data socket failed, "
+		printk(KERN_ERR "umcast_open : data socket failed, "
 		       "errno = %d\n", errno);
 		goto out;
 	}
 
 	if (setsockopt(fd, SOL_SOCKET, SO_REUSEADDR, &yes, sizeof(yes)) < 0) {
 		err = -errno;
-		printk(UM_KERN_ERR "umcast_open: SO_REUSEADDR failed, "
+		printk(KERN_ERR "umcast_open: SO_REUSEADDR failed, "
 		       "errno = %d\n", errno);
 		goto out_close;
 	}
@@ -96,7 +96,7 @@ static int umcast_open(void *data)
 		if (setsockopt(fd, SOL_IP, IP_MULTICAST_TTL, &pri->ttl,
 			       sizeof(pri->ttl)) < 0) {
 			err = -errno;
-			printk(UM_KERN_ERR "umcast_open: IP_MULTICAST_TTL "
+			printk(KERN_ERR "umcast_open: IP_MULTICAST_TTL "
 			       "failed, error = %d\n", errno);
 			goto out_close;
 		}
@@ -105,7 +105,7 @@ static int umcast_open(void *data)
 		if (setsockopt(fd, SOL_IP, IP_MULTICAST_LOOP,
 			       &yes, sizeof(yes)) < 0) {
 			err = -errno;
-			printk(UM_KERN_ERR "umcast_open: IP_MULTICAST_LOOP "
+			printk(KERN_ERR "umcast_open: IP_MULTICAST_LOOP "
 			       "failed, error = %d\n", errno);
 			goto out_close;
 		}
@@ -114,7 +114,7 @@ static int umcast_open(void *data)
 	/* bind socket to the address */
 	if (bind(fd, (struct sockaddr *) lsin, sizeof(*lsin)) < 0) {
 		err = -errno;
-		printk(UM_KERN_ERR "umcast_open : data bind failed, "
+		printk(KERN_ERR "umcast_open : data bind failed, "
 		       "errno = %d\n", errno);
 		goto out_close;
 	}
@@ -126,12 +126,12 @@ static int umcast_open(void *data)
 		if (setsockopt(fd, SOL_IP, IP_ADD_MEMBERSHIP,
 			       &mreq, sizeof(mreq)) < 0) {
 			err = -errno;
-			printk(UM_KERN_ERR "umcast_open: IP_ADD_MEMBERSHIP "
+			printk(KERN_ERR "umcast_open: IP_ADD_MEMBERSHIP "
 			       "failed, error = %d\n", errno);
-			printk(UM_KERN_ERR "There appears not to be a "
+			printk(KERN_ERR "There appears not to be a "
 			       "multicast-capable network interface on the "
 			       "host.\n");
-			printk(UM_KERN_ERR "eth0 should be configured in order "
+			printk(KERN_ERR "eth0 should be configured in order "
 			       "to use the multicast transport.\n");
 			goto out_close;
 		}
@@ -157,7 +157,7 @@ static void umcast_close(int fd, void *data)
 		mreq.imr_interface.s_addr = 0;
 		if (setsockopt(fd, SOL_IP, IP_DROP_MEMBERSHIP,
 			       &mreq, sizeof(mreq)) < 0) {
-			printk(UM_KERN_ERR "umcast_close: IP_DROP_MEMBERSHIP "
+			printk(KERN_ERR "umcast_close: IP_DROP_MEMBERSHIP "
 			       "failed, error = %d\n", errno);
 		}
 	}
diff --git a/arch/um/drivers/vde_user.c b/arch/um/drivers/vde_user.c
index 64cb630..893573b 100644
--- a/arch/um/drivers/vde_user.c
+++ b/arch/um/drivers/vde_user.c
@@ -22,12 +22,12 @@ static int vde_user_init(void *data, void *dev)
 
 	if (conn == NULL) {
 		err = -errno;
-		printk(UM_KERN_ERR "vde_user_init: vde_open failed, "
+		printk(KERN_ERR "vde_user_init: vde_open failed, "
 		       "errno = %d\n", errno);
 		return err;
 	}
 
-	printk(UM_KERN_INFO "vde backend - connection opened\n");
+	printk(KERN_INFO "vde backend - connection opened\n");
 
 	pri->conn = conn;
 
@@ -41,7 +41,7 @@ static int vde_user_open(void *data)
 	if (pri->conn != NULL)
 		return vde_datafd(pri->conn);
 
-	printk(UM_KERN_WARNING "vde_open - we have no VDECONN to open");
+	printk(KERN_WARNING "vde_open - we have no VDECONN to open");
 	return -EINVAL;
 }
 
@@ -50,7 +50,7 @@ static void vde_remove(void *data)
 	struct vde_data *pri = data;
 
 	if (pri->conn != NULL) {
-		printk(UM_KERN_INFO "vde backend - closing connection\n");
+		printk(KERN_INFO "vde backend - closing connection\n");
 		vde_close(pri->conn);
 		pri->conn = NULL;
 		kfree(pri->args);
@@ -58,7 +58,7 @@ static void vde_remove(void *data)
 		return;
 	}
 
-	printk(UM_KERN_WARNING "vde_remove - we have no VDECONN to remove");
+	printk(KERN_WARNING "vde_remove - we have no VDECONN to remove");
 }
 
 const struct net_user_info vde_user_info = {
@@ -78,7 +78,7 @@ void vde_init_libstuff(struct vde_data *vpri, struct vde_init *init)
 
 	vpri->args = uml_kmalloc(sizeof(struct vde_open_args), UM_GFP_KERNEL);
 	if (vpri->args == NULL) {
-		printk(UM_KERN_ERR "vde_init_libstuff - vde_open_args "
+		printk(KERN_ERR "vde_init_libstuff - vde_open_args "
 		       "allocation failed");
 		return;
 	}
diff --git a/arch/um/drivers/xterm.c b/arch/um/drivers/xterm.c
index 20e30be..939ca36 100644
--- a/arch/um/drivers/xterm.c
+++ b/arch/um/drivers/xterm.c
@@ -99,7 +99,7 @@ static int xterm_open(int input, int output, int primary, void *d,
 	 * will work but w/o it we can be pretty sure it won't.
 	 */
 	if (getenv("DISPLAY") == NULL) {
-		printk(UM_KERN_ERR "xterm_open: $DISPLAY not set.\n");
+		printk(KERN_ERR "xterm_open: $DISPLAY not set.\n");
 		return -ENODEV;
 	}
 
@@ -112,14 +112,14 @@ static int xterm_open(int input, int output, int primary, void *d,
 	fd = mkstemp(file);
 	if (fd < 0) {
 		err = -errno;
-		printk(UM_KERN_ERR "xterm_open : mkstemp failed, errno = %d\n",
+		printk(KERN_ERR "xterm_open : mkstemp failed, errno = %d\n",
 		       errno);
 		return err;
 	}
 
 	if (unlink(file)) {
 		err = -errno;
-		printk(UM_KERN_ERR "xterm_open : unlink failed, errno = %d\n",
+		printk(KERN_ERR "xterm_open : unlink failed, errno = %d\n",
 		       errno);
 		close(fd);
 		return err;
@@ -128,7 +128,7 @@ static int xterm_open(int input, int output, int primary, void *d,
 
 	fd = os_create_unix_socket(file, sizeof(file), 1);
 	if (fd < 0) {
-		printk(UM_KERN_ERR "xterm_open : create_unix_socket failed, "
+		printk(KERN_ERR "xterm_open : create_unix_socket failed, "
 		       "errno = %d\n", -fd);
 		return fd;
 	}
@@ -137,14 +137,14 @@ static int xterm_open(int input, int output, int primary, void *d,
 	pid = run_helper(NULL, NULL, argv);
 	if (pid < 0) {
 		err = pid;
-		printk(UM_KERN_ERR "xterm_open : run_helper failed, "
+		printk(KERN_ERR "xterm_open : run_helper failed, "
 		       "errno = %d\n", -err);
 		goto out_close1;
 	}
 
 	err = os_set_fd_block(fd, 0);
 	if (err < 0) {
-		printk(UM_KERN_ERR "xterm_open : failed to set descriptor "
+		printk(KERN_ERR "xterm_open : failed to set descriptor "
 		       "non-blocking, err = %d\n", -err);
 		goto out_kill;
 	}
@@ -152,14 +152,14 @@ static int xterm_open(int input, int output, int primary, void *d,
 	new = xterm_fd(fd, &data->helper_pid);
 	if (new < 0) {
 		err = new;
-		printk(UM_KERN_ERR "xterm_open : os_rcv_fd failed, err = %d\n",
+		printk(KERN_ERR "xterm_open : os_rcv_fd failed, err = %d\n",
 		       -err);
 		goto out_kill;
 	}
 
 	err = os_set_fd_block(new, 0);
 	if (err) {
-		printk(UM_KERN_ERR "xterm_open : failed to set xterm "
+		printk(KERN_ERR "xterm_open : failed to set xterm "
 		       "descriptor non-blocking, err = %d\n", -err);
 		goto out_close2;
 	}
diff --git a/arch/um/os-Linux/aio.c b/arch/um/os-Linux/aio.c
index 014eb35..19a5315 100644
--- a/arch/um/os-Linux/aio.c
+++ b/arch/um/os-Linux/aio.c
@@ -88,7 +88,7 @@ static int do_aio(aio_context_t ctx, enum aio_type type, int fd, char *buf,
 		iocbp->aio_nbytes = sizeof(c);
 		break;
 	default:
-		printk(UM_KERN_ERR "Bogus op in do_aio - %d\n", type);
+		printk(KERN_ERR "Bogus op in do_aio - %d\n", type);
 		return -EINVAL;
 	}
 
@@ -110,7 +110,7 @@ static int aio_thread(void *arg)
 		if (n < 0) {
 			if (errno == EINTR)
 				continue;
-			printk(UM_KERN_ERR "aio_thread - io_getevents failed, "
+			printk(KERN_ERR "aio_thread - io_getevents failed, "
 			       "errno = %d\n", errno);
 		}
 		else {
@@ -120,7 +120,7 @@ static int aio_thread(void *arg)
 			reply_fd = ((struct aio_context *) reply.data)->reply_fd;
 			err = write(reply_fd, &reply, sizeof(reply));
 			if (err != sizeof(reply))
-				printk(UM_KERN_ERR "aio_thread - write failed, "
+				printk(KERN_ERR "aio_thread - write failed, "
 				       "fd = %d, err = %d\n", reply_fd, errno);
 		}
 	}
@@ -150,7 +150,7 @@ static int do_not_aio(struct aio_thread_req *req)
 		n = read(req->io_fd, &c, sizeof(c));
 		break;
 	default:
-		printk(UM_KERN_ERR "do_not_aio - bad request type : %d\n",
+		printk(KERN_ERR "do_not_aio - bad request type : %d\n",
 		       req->type);
 		return -EINVAL;
 	}
@@ -177,12 +177,12 @@ static int not_aio_thread(void *arg)
 		err = read(aio_req_fd_r, &req, sizeof(req));
 		if (err != sizeof(req)) {
 			if (err < 0)
-				printk(UM_KERN_ERR "not_aio_thread - "
+				printk(KERN_ERR "not_aio_thread - "
 				       "read failed, fd = %d, err = %d\n",
 				       aio_req_fd_r,
 				       errno);
 			else {
-				printk(UM_KERN_ERR "not_aio_thread - short "
+				printk(KERN_ERR "not_aio_thread - short "
 				       "read, fd = %d, length = %d\n",
 				       aio_req_fd_r, err);
 			}
@@ -193,7 +193,7 @@ static int not_aio_thread(void *arg)
 						     .err	= err });
 		err = write(req.aio->reply_fd, &reply, sizeof(reply));
 		if (err != sizeof(reply))
-			printk(UM_KERN_ERR "not_aio_thread - write failed, "
+			printk(KERN_ERR "not_aio_thread - write failed, "
 			       "fd = %d, err = %d\n", req.aio->reply_fd, errno);
 	}
 
@@ -230,10 +230,10 @@ out_close_pipe:
 	aio_req_fd_r = -1;
 out:
 #ifndef HAVE_AIO_ABI
-	printk(UM_KERN_INFO "/usr/include/linux/aio_abi.h not present during "
+	printk(KERN_INFO "/usr/include/linux/aio_abi.h not present during "
 	       "build\n");
 #endif
-	printk(UM_KERN_INFO "2.6 host AIO support not used - falling back to "
+	printk(KERN_INFO "2.6 host AIO support not used - falling back to "
 	       "I/O thread\n");
 	return 0;
 }
@@ -246,7 +246,7 @@ static int init_aio_26(void)
 
 	if (io_setup(256, &ctx)) {
 		err = -errno;
-		printk(UM_KERN_ERR "aio_thread failed to initialize context, "
+		printk(KERN_ERR "aio_thread failed to initialize context, "
 		       "err = %d\n", errno);
 		return err;
 	}
@@ -258,7 +258,7 @@ static int init_aio_26(void)
 
 	aio_pid = err;
 
-	printk(UM_KERN_INFO "Using 2.6 host AIO\n");
+	printk(KERN_INFO "Using 2.6 host AIO\n");
 	return 0;
 }
 
@@ -275,7 +275,7 @@ static int submit_aio_26(enum aio_type type, int io_fd, char *buf, int len,
 		err = write(aio->reply_fd, &reply, sizeof(reply));
 		if (err != sizeof(reply)) {
 			err = -errno;
-			printk(UM_KERN_ERR "submit_aio_26 - write failed, "
+			printk(KERN_ERR "submit_aio_26 - write failed, "
 			       "fd = %d, err = %d\n", aio->reply_fd, -err);
 		}
 		else err = 0;
@@ -326,7 +326,7 @@ static int init_aio(void)
 	if (!aio_24) {
 		err = init_aio_26();
 		if (err && (errno == ENOSYS)) {
-			printk(UM_KERN_INFO "2.6 AIO not supported on the "
+			printk(KERN_INFO "2.6 AIO not supported on the "
 			       "host - reverting to 2.4 AIO\n");
 			aio_24 = 1;
 		}
diff --git a/arch/um/os-Linux/drivers/ethertap_user.c b/arch/um/os-Linux/drivers/ethertap_user.c
index b39b669..2e097cd 100644
--- a/arch/um/os-Linux/drivers/ethertap_user.c
+++ b/arch/um/os-Linux/drivers/ethertap_user.c
@@ -45,14 +45,14 @@ static void etap_change(int op, unsigned char *addr, unsigned char *netmask,
 	memcpy(change.netmask, netmask, sizeof(change.netmask));
 	CATCH_EINTR(n = write(fd, &change, sizeof(change)));
 	if (n != sizeof(change)) {
-		printk(UM_KERN_ERR "etap_change - request failed, err = %d\n",
+		printk(KERN_ERR "etap_change - request failed, err = %d\n",
 		       errno);
 		return;
 	}
 
 	output = uml_kmalloc(UM_KERN_PAGE_SIZE, UM_GFP_KERNEL);
 	if (output == NULL)
-		printk(UM_KERN_ERR "etap_change : Failed to allocate output "
+		printk(KERN_ERR "etap_change : Failed to allocate output "
 		       "buffer\n");
 	read_output(fd, output, UM_KERN_PAGE_SIZE);
 	if (output != NULL) {
@@ -123,12 +123,12 @@ static int etap_tramp(char *dev, char *gate, int control_me,
 	CATCH_EINTR(n = read(control_me, &c, sizeof(c)));
 	if (n != sizeof(c)) {
 		err = -errno;
-		printk(UM_KERN_ERR "etap_tramp : read of status failed, "
+		printk(KERN_ERR "etap_tramp : read of status failed, "
 		       "err = %d\n", -err);
 		return err;
 	}
 	if (c != 1) {
-		printk(UM_KERN_ERR "etap_tramp : uml_net failed\n");
+		printk(KERN_ERR "etap_tramp : uml_net failed\n");
 		err = helper_wait(pid);
 	}
 	return err;
@@ -147,7 +147,7 @@ static int etap_open(void *data)
 	err = socketpair(AF_UNIX, SOCK_DGRAM, 0, data_fds);
 	if (err) {
 		err = -errno;
-		printk(UM_KERN_ERR "etap_open - data socketpair failed - "
+		printk(KERN_ERR "etap_open - data socketpair failed - "
 		       "err = %d\n", errno);
 		return err;
 	}
@@ -155,7 +155,7 @@ static int etap_open(void *data)
 	err = socketpair(AF_UNIX, SOCK_STREAM, 0, control_fds);
 	if (err) {
 		err = -errno;
-		printk(UM_KERN_ERR "etap_open - control socketpair failed - "
+		printk(KERN_ERR "etap_open - control socketpair failed - "
 		       "err = %d\n", errno);
 		goto out_close_data;
 	}
@@ -167,7 +167,7 @@ static int etap_open(void *data)
 	read_output(control_fds[0], output, output_len);
 
 	if (output == NULL)
-		printk(UM_KERN_ERR "etap_open : failed to allocate output "
+		printk(KERN_ERR "etap_open : failed to allocate output "
 		       "buffer\n");
 	else {
 		printk("%s", output);
@@ -175,7 +175,7 @@ static int etap_open(void *data)
 	}
 
 	if (err < 0) {
-		printk(UM_KERN_ERR "etap_tramp failed - err = %d\n", -err);
+		printk(KERN_ERR "etap_tramp failed - err = %d\n", -err);
 		goto out_close_control;
 	}
 
@@ -201,11 +201,11 @@ static void etap_close(int fd, void *data)
 	close(fd);
 
 	if (shutdown(pri->data_fd, SHUT_RDWR) < 0)
-		printk(UM_KERN_ERR "etap_close - shutdown data socket failed, "
+		printk(KERN_ERR "etap_close - shutdown data socket failed, "
 		       "errno = %d\n", errno);
 
 	if (shutdown(pri->control_fd, SHUT_RDWR) < 0)
-		printk(UM_KERN_ERR "etap_close - shutdown control socket "
+		printk(KERN_ERR "etap_close - shutdown control socket "
 		       "failed, errno = %d\n", errno);
 
 	close(pri->data_fd);
diff --git a/arch/um/os-Linux/drivers/tuntap_user.c b/arch/um/os-Linux/drivers/tuntap_user.c
index 14126d9..1c5edf8 100644
--- a/arch/um/os-Linux/drivers/tuntap_user.c
+++ b/arch/um/os-Linux/drivers/tuntap_user.c
@@ -102,7 +102,7 @@ static int tuntap_open_tramp(char *gate, int *fd_out, int me, int remote,
 	*used_out = n;
 	if (n < 0) {
 		err = -errno;
-		printk(UM_KERN_ERR "tuntap_open_tramp : recvmsg failed - "
+		printk(KERN_ERR "tuntap_open_tramp : recvmsg failed - "
 		       "errno = %d\n", errno);
 		return err;
 	}
@@ -110,13 +110,13 @@ static int tuntap_open_tramp(char *gate, int *fd_out, int me, int remote,
 
 	cmsg = CMSG_FIRSTHDR(&msg);
 	if (cmsg == NULL) {
-		printk(UM_KERN_ERR "tuntap_open_tramp : didn't receive a "
+		printk(KERN_ERR "tuntap_open_tramp : didn't receive a "
 		       "message\n");
 		return -EINVAL;
 	}
 	if ((cmsg->cmsg_level != SOL_SOCKET) ||
 	   (cmsg->cmsg_type != SCM_RIGHTS)) {
-		printk(UM_KERN_ERR "tuntap_open_tramp : didn't receive a "
+		printk(KERN_ERR "tuntap_open_tramp : didn't receive a "
 		       "descriptor\n");
 		return -EINVAL;
 	}
@@ -140,7 +140,7 @@ static int tuntap_open(void *data)
 		pri->fd = os_open_file("/dev/net/tun",
 				       of_cloexec(of_rdwr(OPENFLAGS())), 0);
 		if (pri->fd < 0) {
-			printk(UM_KERN_ERR "Failed to open /dev/net/tun, "
+			printk(KERN_ERR "Failed to open /dev/net/tun, "
 			       "err = %d\n", -pri->fd);
 			return pri->fd;
 		}
@@ -149,7 +149,7 @@ static int tuntap_open(void *data)
 		strlcpy(ifr.ifr_name, pri->dev_name, sizeof(ifr.ifr_name));
 		if (ioctl(pri->fd, TUNSETIFF, &ifr) < 0) {
 			err = -errno;
-			printk(UM_KERN_ERR "TUNSETIFF failed, errno = %d\n",
+			printk(KERN_ERR "TUNSETIFF failed, errno = %d\n",
 			       errno);
 			close(pri->fd);
 			return err;
@@ -159,7 +159,7 @@ static int tuntap_open(void *data)
 		err = socketpair(AF_UNIX, SOCK_DGRAM, 0, fds);
 		if (err) {
 			err = -errno;
-			printk(UM_KERN_ERR "tuntap_open : socketpair failed - "
+			printk(KERN_ERR "tuntap_open : socketpair failed - "
 			       "errno = %d\n", errno);
 			return err;
 		}
@@ -176,7 +176,7 @@ static int tuntap_open(void *data)
 		if (err < 0) {
 			printk("%s", output);
 			free_output_buffer(buffer);
-			printk(UM_KERN_ERR "tuntap_open_tramp failed - "
+			printk(KERN_ERR "tuntap_open_tramp failed - "
 			       "err = %d\n", -err);
 			return err;
 		}
diff --git a/arch/um/os-Linux/file.c b/arch/um/os-Linux/file.c
index 08d90fb..8bf76d4 100644
--- a/arch/um/os-Linux/file.c
+++ b/arch/um/os-Linux/file.c
@@ -288,7 +288,7 @@ int os_file_size(const char *file, unsigned long long *size_out)
 
 	err = os_stat_file(file, &buf);
 	if (err < 0) {
-		printk(UM_KERN_ERR "Couldn't stat \"%s\" : err = %d\n", file,
+		printk(KERN_ERR "Couldn't stat \"%s\" : err = %d\n", file,
 		       -err);
 		return err;
 	}
@@ -300,13 +300,13 @@ int os_file_size(const char *file, unsigned long long *size_out)
 		fd = open(file, O_RDONLY, 0);
 		if (fd < 0) {
 			err = -errno;
-			printk(UM_KERN_ERR "Couldn't open \"%s\", "
+			printk(KERN_ERR "Couldn't open \"%s\", "
 			       "errno = %d\n", file, errno);
 			return err;
 		}
 		if (ioctl(fd, BLKGETSIZE, &blocks) < 0) {
 			err = -errno;
-			printk(UM_KERN_ERR "Couldn't get the block size of "
+			printk(KERN_ERR "Couldn't get the block size of "
 			       "\"%s\", errno = %d\n", file, errno);
 			close(fd);
 			return err;
@@ -326,7 +326,7 @@ int os_file_modtime(const char *file, unsigned long *modtime)
 
 	err = os_stat_file(file, &buf);
 	if (err < 0) {
-		printk(UM_KERN_ERR "Couldn't stat \"%s\" : err = %d\n", file,
+		printk(KERN_ERR "Couldn't stat \"%s\" : err = %d\n", file,
 		       -err);
 		return err;
 	}
@@ -368,7 +368,7 @@ int os_pipe(int *fds, int stream, int close_on_exec)
 	return 0;
 
  error:
-	printk(UM_KERN_ERR "os_pipe : Setting FD_CLOEXEC failed, err = %d\n",
+	printk(KERN_ERR "os_pipe : Setting FD_CLOEXEC failed, err = %d\n",
 	       -err);
 	close(fds[1]);
 	close(fds[0]);
@@ -386,7 +386,7 @@ int os_set_fd_async(int fd)
 	flags |= O_ASYNC | O_NONBLOCK;
 	if (fcntl(fd, F_SETFL, flags) < 0) {
 		err = -errno;
-		printk(UM_KERN_ERR "os_set_fd_async : failed to set O_ASYNC "
+		printk(KERN_ERR "os_set_fd_async : failed to set O_ASYNC "
 		       "and O_NONBLOCK on fd # %d, errno = %d\n", fd, errno);
 		return err;
 	}
@@ -394,7 +394,7 @@ int os_set_fd_async(int fd)
 	if ((fcntl(fd, F_SETSIG, SIGIO) < 0) ||
 	    (fcntl(fd, F_SETOWN, os_getpid()) < 0)) {
 		err = -errno;
-		printk(UM_KERN_ERR "os_set_fd_async : Failed to fcntl F_SETOWN "
+		printk(KERN_ERR "os_set_fd_async : Failed to fcntl F_SETOWN "
 		       "(or F_SETSIG) fd %d, errno = %d\n", fd, errno);
 		return err;
 	}
@@ -502,13 +502,13 @@ int os_rcv_fd(int fd, int *helper_pid_out)
 
 	cmsg = CMSG_FIRSTHDR(&msg);
 	if (cmsg == NULL) {
-		printk(UM_KERN_ERR "rcv_fd didn't receive anything, "
+		printk(KERN_ERR "rcv_fd didn't receive anything, "
 		       "error = %d\n", errno);
 		return -1;
 	}
 	if ((cmsg->cmsg_level != SOL_SOCKET) ||
 	    (cmsg->cmsg_type != SCM_RIGHTS)) {
-		printk(UM_KERN_ERR "rcv_fd didn't receive a descriptor\n");
+		printk(KERN_ERR "rcv_fd didn't receive a descriptor\n");
 		return -1;
 	}
 
@@ -528,7 +528,7 @@ int os_create_unix_socket(const char *file, int len, int close_on_exec)
 	if (close_on_exec) {
 		err = os_set_exec_close(sock);
 		if (err < 0)
-			printk(UM_KERN_ERR "create_unix_socket : "
+			printk(KERN_ERR "create_unix_socket : "
 			       "close_on_exec failed, err = %d", -err);
 	}
 
@@ -568,7 +568,7 @@ int os_lock_file(int fd, int excl)
 		goto out;
 	}
 
-	printk(UM_KERN_ERR "F_SETLK failed, file already locked by pid %d\n",
+	printk(KERN_ERR "F_SETLK failed, file already locked by pid %d\n",
 	       lock.l_pid);
 	err = save;
  out:
diff --git a/arch/um/os-Linux/helper.c b/arch/um/os-Linux/helper.c
index e3ee4a5..0f6af24 100644
--- a/arch/um/os-Linux/helper.c
+++ b/arch/um/os-Linux/helper.c
@@ -52,14 +52,14 @@ int run_helper(void (*pre_exec)(void *), void *pre_data, char **argv)
 	ret = socketpair(AF_UNIX, SOCK_STREAM, 0, fds);
 	if (ret < 0) {
 		ret = -errno;
-		printk(UM_KERN_ERR "run_helper : pipe failed, errno = %d\n",
+		printk(KERN_ERR "run_helper : pipe failed, errno = %d\n",
 		       errno);
 		goto out_free;
 	}
 
 	ret = os_set_exec_close(fds[1]);
 	if (ret < 0) {
-		printk(UM_KERN_ERR "run_helper : setting FD_CLOEXEC failed, "
+		printk(KERN_ERR "run_helper : setting FD_CLOEXEC failed, "
 		       "ret = %d\n", -ret);
 		goto out_close;
 	}
@@ -74,7 +74,7 @@ int run_helper(void (*pre_exec)(void *), void *pre_data, char **argv)
 	pid = clone(helper_child, (void *) sp, CLONE_VM, &data);
 	if (pid < 0) {
 		ret = -errno;
-		printk(UM_KERN_ERR "run_helper : clone failed, errno = %d\n",
+		printk(KERN_ERR "run_helper : clone failed, errno = %d\n",
 		       errno);
 		goto out_free2;
 	}
@@ -92,7 +92,7 @@ int run_helper(void (*pre_exec)(void *), void *pre_data, char **argv)
 	} else {
 		if (n < 0) {
 			n = -errno;
-			printk(UM_KERN_ERR "run_helper : read on pipe failed, "
+			printk(KERN_ERR "run_helper : read on pipe failed, "
 			       "ret = %d\n", -n);
 			ret = n;
 		}
@@ -124,7 +124,7 @@ int run_helper_thread(int (*proc)(void *), void *arg, unsigned int flags,
 	pid = clone(proc, (void *) sp, flags, arg);
 	if (pid < 0) {
 		err = -errno;
-		printk(UM_KERN_ERR "run_helper_thread : clone failed, "
+		printk(KERN_ERR "run_helper_thread : clone failed, "
 		       "errno = %d\n", errno);
 		return err;
 	}
@@ -132,12 +132,12 @@ int run_helper_thread(int (*proc)(void *), void *arg, unsigned int flags,
 		CATCH_EINTR(pid = waitpid(pid, &status, __WCLONE));
 		if (pid < 0) {
 			err = -errno;
-			printk(UM_KERN_ERR "run_helper_thread - wait failed, "
+			printk(KERN_ERR "run_helper_thread - wait failed, "
 			       "errno = %d\n", errno);
 			pid = err;
 		}
 		if (!WIFEXITED(status) || (WEXITSTATUS(status) != 0))
-			printk(UM_KERN_ERR "run_helper_thread - thread "
+			printk(KERN_ERR "run_helper_thread - thread "
 			       "returned status 0x%x\n", status);
 		free_stack(stack, 0);
 	} else
@@ -152,11 +152,11 @@ int helper_wait(int pid)
 
 	CATCH_EINTR(ret = waitpid(pid, &status, wflags));
 	if (ret < 0) {
-		printk(UM_KERN_ERR "helper_wait : waitpid process %d failed, "
+		printk(KERN_ERR "helper_wait : waitpid process %d failed, "
 		       "errno = %d\n", pid, errno);
 		return -errno;
 	} else if (!WIFEXITED(status) || WEXITSTATUS(status) != 0) {
-		printk(UM_KERN_ERR "helper_wait : process %d exited with "
+		printk(KERN_ERR "helper_wait : process %d exited with "
 		       "status 0x%x\n", pid, status);
 		return -ECHILD;
 	} else
diff --git a/arch/um/os-Linux/irq.c b/arch/um/os-Linux/irq.c
index b9afb74..487a55e 100644
--- a/arch/um/os-Linux/irq.c
+++ b/arch/um/os-Linux/irq.c
@@ -29,7 +29,7 @@ int os_waiting_for_events(struct irq_fd *active_fds)
 	if (n < 0) {
 		err = -errno;
 		if (errno != EINTR)
-			printk(UM_KERN_ERR "os_waiting_for_events:"
+			printk(KERN_ERR "os_waiting_for_events:"
 			       " poll returned %d, errno = %d\n", n, errno);
 		return err;
 	}
@@ -88,7 +88,7 @@ void os_free_irq_by_cb(int (*test)(struct irq_fd *, void *), void *arg,
 			struct irq_fd *old_fd = *prev;
 			if ((pollfds[i].fd != -1) &&
 			    (pollfds[i].fd != (*prev)->fd)) {
-				printk(UM_KERN_ERR "os_free_irq_by_cb - "
+				printk(KERN_ERR "os_free_irq_by_cb - "
 				       "mismatch between active_fds and "
 				       "pollfds, fd %d vs %d\n",
 				       (*prev)->fd, pollfds[i].fd);
diff --git a/arch/um/os-Linux/process.c b/arch/um/os-Linux/process.c
index 8408aba..3a46345 100644
--- a/arch/um/os-Linux/process.c
+++ b/arch/um/os-Linux/process.c
@@ -32,13 +32,13 @@ unsigned long os_process_pc(int pid)
 	sprintf(proc_stat, "/proc/%d/stat", pid);
 	fd = open(proc_stat, O_RDONLY, 0);
 	if (fd < 0) {
-		printk(UM_KERN_ERR "os_process_pc - couldn't open '%s', "
+		printk(KERN_ERR "os_process_pc - couldn't open '%s', "
 		       "errno = %d\n", proc_stat, errno);
 		goto out;
 	}
 	CATCH_EINTR(err = read(fd, buf, sizeof(buf)));
 	if (err < 0) {
-		printk(UM_KERN_ERR "os_process_pc - couldn't read '%s', "
+		printk(KERN_ERR "os_process_pc - couldn't read '%s', "
 		       "err = %d\n", proc_stat, errno);
 		goto out_close;
 	}
@@ -47,7 +47,7 @@ unsigned long os_process_pc(int pid)
 	if (sscanf(buf, "%*d " COMM_SCANF " %*c %*d %*d %*d %*d %*d %*d %*d "
 		   "%*d %*d %*d %*d %*d %*d %*d %*d %*d %*d %*d %*d %*d %*d "
 		   "%*d %*d %*d %*d %*d %lu", &pc) != 1)
-		printk(UM_KERN_ERR "os_process_pc - couldn't find pc in '%s'\n",
+		printk(KERN_ERR "os_process_pc - couldn't find pc in '%s'\n",
 		       buf);
  out_close:
 	close(fd);
@@ -67,7 +67,7 @@ int os_process_parent(int pid)
 	snprintf(stat, sizeof(stat), "/proc/%d/stat", pid);
 	fd = open(stat, O_RDONLY, 0);
 	if (fd < 0) {
-		printk(UM_KERN_ERR "Couldn't open '%s', errno = %d\n", stat,
+		printk(KERN_ERR "Couldn't open '%s', errno = %d\n", stat,
 		       errno);
 		return parent;
 	}
@@ -76,7 +76,7 @@ int os_process_parent(int pid)
 	close(fd);
 
 	if (n < 0) {
-		printk(UM_KERN_ERR "Couldn't read '%s', errno = %d\n", stat,
+		printk(KERN_ERR "Couldn't read '%s', errno = %d\n", stat,
 		       errno);
 		return parent;
 	}
@@ -84,7 +84,7 @@ int os_process_parent(int pid)
 	parent = FAILURE_PID;
 	n = sscanf(data, "%*d " COMM_SCANF " %*c %d", &parent);
 	if (n != 1)
-		printk(UM_KERN_ERR "Failed to scan '%s'\n", data);
+		printk(KERN_ERR "Failed to scan '%s'\n", data);
 
 	return parent;
 }
@@ -185,10 +185,10 @@ int __init can_drop_memory(void)
 	void *addr;
 	int fd, ok = 0;
 
-	printk(UM_KERN_INFO "Checking host MADV_REMOVE support...");
+	printk(KERN_INFO "Checking host MADV_REMOVE support...");
 	fd = create_mem_file(UM_KERN_PAGE_SIZE);
 	if (fd < 0) {
-		printk(UM_KERN_ERR "Creating test memory file failed, "
+		printk(KERN_ERR "Creating test memory file failed, "
 		       "err = %d\n", -fd);
 		goto out;
 	}
@@ -196,17 +196,17 @@ int __init can_drop_memory(void)
 	addr = mmap64(NULL, UM_KERN_PAGE_SIZE, PROT_READ | PROT_WRITE,
 		      MAP_SHARED, fd, 0);
 	if (addr == MAP_FAILED) {
-		printk(UM_KERN_ERR "Mapping test memory file failed, "
+		printk(KERN_ERR "Mapping test memory file failed, "
 		       "err = %d\n", -errno);
 		goto out_close;
 	}
 
 	if (madvise(addr, UM_KERN_PAGE_SIZE, MADV_REMOVE) != 0) {
-		printk(UM_KERN_ERR "MADV_REMOVE failed, err = %d\n", -errno);
+		printk(KERN_ERR "MADV_REMOVE failed, err = %d\n", -errno);
 		goto out_unmap;
 	}
 
-	printk(UM_KERN_CONT "OK\n");
+	printk(KERN_CONT "OK\n");
 	ok = 1;
 
 out_unmap:
diff --git a/arch/um/os-Linux/sigio.c b/arch/um/os-Linux/sigio.c
index 46e762f..14633a5 100644
--- a/arch/um/os-Linux/sigio.c
+++ b/arch/um/os-Linux/sigio.c
@@ -62,7 +62,7 @@ static int write_sigio_thread(void *unused)
 		if (n < 0) {
 			if (errno == EINTR)
 				continue;
-			printk(UM_KERN_ERR "write_sigio_thread : poll returned "
+			printk(KERN_ERR "write_sigio_thread : poll returned "
 			       "%d, errno = %d\n", n, errno);
 		}
 		for (i = 0; i < fds->used; i++) {
@@ -73,7 +73,7 @@ static int write_sigio_thread(void *unused)
 				CATCH_EINTR(n = read(sigio_private[1], &c,
 						     sizeof(c)));
 				if (n != sizeof(c))
-					printk(UM_KERN_ERR
+					printk(KERN_ERR
 					       "write_sigio_thread : "
 					       "read on socket failed, "
 					       "err = %d\n", errno);
@@ -91,7 +91,7 @@ static int write_sigio_thread(void *unused)
 
 			CATCH_EINTR(n = write(respond_fd, &c, sizeof(c)));
 			if (n != sizeof(c))
-				printk(UM_KERN_ERR "write_sigio_thread : "
+				printk(KERN_ERR "write_sigio_thread : "
 				       "write on socket failed, err = %d\n",
 				       errno);
 		}
@@ -109,7 +109,7 @@ static int need_poll(struct pollfds *polls, int n)
 
 	new = uml_kmalloc(n * sizeof(struct pollfd), UM_GFP_ATOMIC);
 	if (new == NULL) {
-		printk(UM_KERN_ERR "need_poll : failed to allocate new "
+		printk(KERN_ERR "need_poll : failed to allocate new "
 		       "pollfds\n");
 		return -ENOMEM;
 	}
@@ -135,14 +135,14 @@ static void update_thread(void)
 	flags = set_signals(0);
 	CATCH_EINTR(n = write(sigio_private[0], &c, sizeof(c)));
 	if (n != sizeof(c)) {
-		printk(UM_KERN_ERR "update_thread : write failed, err = %d\n",
+		printk(KERN_ERR "update_thread : write failed, err = %d\n",
 		       errno);
 		goto fail;
 	}
 
 	CATCH_EINTR(n = read(sigio_private[0], &c, sizeof(c)));
 	if (n != sizeof(c)) {
-		printk(UM_KERN_ERR "update_thread : read failed, err = %d\n",
+		printk(KERN_ERR "update_thread : read failed, err = %d\n",
 		       errno);
 		goto fail;
 	}
@@ -243,7 +243,7 @@ static struct pollfd *setup_initial_poll(int fd)
 
 	p = uml_kmalloc(sizeof(struct pollfd), UM_GFP_KERNEL);
 	if (p == NULL) {
-		printk(UM_KERN_ERR "setup_initial_poll : failed to allocate "
+		printk(KERN_ERR "setup_initial_poll : failed to allocate "
 		       "poll\n");
 		return NULL;
 	}
@@ -271,13 +271,13 @@ static void write_sigio_workaround(void)
 
 	err = os_pipe(l_write_sigio_fds, 1, 1);
 	if (err < 0) {
-		printk(UM_KERN_ERR "write_sigio_workaround - os_pipe 1 failed, "
+		printk(KERN_ERR "write_sigio_workaround - os_pipe 1 failed, "
 		       "err = %d\n", -err);
 		return;
 	}
 	err = os_pipe(l_sigio_private, 1, 1);
 	if (err < 0) {
-		printk(UM_KERN_ERR "write_sigio_workaround - os_pipe 2 failed, "
+		printk(KERN_ERR "write_sigio_workaround - os_pipe 2 failed, "
 		       "err = %d\n", -err);
 		goto out_close1;
 	}
@@ -345,7 +345,7 @@ void sigio_broken(int fd, int read)
 	sigio_lock();
 	err = need_poll(&all_sigio_fds, all_sigio_fds.used + 1);
 	if (err) {
-		printk(UM_KERN_ERR "maybe_sigio_broken - failed to add pollfd "
+		printk(KERN_ERR "maybe_sigio_broken - failed to add pollfd "
 		       "for descriptor %d\n", fd);
 		goto out;
 	}
@@ -434,7 +434,7 @@ static void __init check_one_sigio(void (*proc)(int, int))
 
 	initial_thread_cb(openpty_cb, &pty);
 	if (pty.err) {
-		printk(UM_KERN_ERR "check_one_sigio failed, errno = %d\n",
+		printk(KERN_ERR "check_one_sigio failed, errno = %d\n",
 		       -pty.err);
 		return;
 	}
@@ -443,7 +443,7 @@ static void __init check_one_sigio(void (*proc)(int, int))
 	slave = pty.slave;
 
 	if ((master == -1) || (slave == -1)) {
-		printk(UM_KERN_ERR "check_one_sigio failed to allocate a "
+		printk(KERN_ERR "check_one_sigio failed to allocate a "
 		       "pty\n");
 		return;
 	}
@@ -451,20 +451,20 @@ static void __init check_one_sigio(void (*proc)(int, int))
 	/* Not now, but complain so we now where we failed. */
 	err = raw(master);
 	if (err < 0) {
-		printk(UM_KERN_ERR "check_one_sigio : raw failed, errno = %d\n",
+		printk(KERN_ERR "check_one_sigio : raw failed, errno = %d\n",
 		      -err);
 		return;
 	}
 
 	err = async_pty(master, slave);
 	if (err < 0) {
-		printk(UM_KERN_ERR "check_one_sigio : sigio_async failed, "
+		printk(KERN_ERR "check_one_sigio : sigio_async failed, "
 		       "err = %d\n", -err);
 		return;
 	}
 
 	if (sigaction(SIGIO, NULL, &old) < 0) {
-		printk(UM_KERN_ERR "check_one_sigio : sigaction 1 failed, "
+		printk(KERN_ERR "check_one_sigio : sigaction 1 failed, "
 		       "errno = %d\n", errno);
 		return;
 	}
@@ -472,7 +472,7 @@ static void __init check_one_sigio(void (*proc)(int, int))
 	new = old;
 	new.sa_handler = handler;
 	if (sigaction(SIGIO, &new, NULL) < 0) {
-		printk(UM_KERN_ERR "check_one_sigio : sigaction 2 failed, "
+		printk(KERN_ERR "check_one_sigio : sigaction 2 failed, "
 		       "errno = %d\n", errno);
 		return;
 	}
@@ -484,7 +484,7 @@ static void __init check_one_sigio(void (*proc)(int, int))
 	close(slave);
 
 	if (sigaction(SIGIO, &old, NULL) < 0)
-		printk(UM_KERN_ERR "check_one_sigio : sigaction 3 failed, "
+		printk(KERN_ERR "check_one_sigio : sigaction 3 failed, "
 		       "errno = %d\n", errno);
 }
 
@@ -493,45 +493,45 @@ static void tty_output(int master, int slave)
 	int n;
 	char buf[512];
 
-	printk(UM_KERN_INFO "Checking that host ptys support output SIGIO...");
+	printk(KERN_INFO "Checking that host ptys support output SIGIO...");
 
 	memset(buf, 0, sizeof(buf));
 
 	while (write(master, buf, sizeof(buf)) > 0) ;
 	if (errno != EAGAIN)
-		printk(UM_KERN_ERR "tty_output : write failed, errno = %d\n",
+		printk(KERN_ERR "tty_output : write failed, errno = %d\n",
 		       errno);
 	while (((n = read(slave, buf, sizeof(buf))) > 0) &&
 	       !({ barrier(); got_sigio; }))
 		;
 
 	if (got_sigio) {
-		printk(UM_KERN_CONT "Yes\n");
+		printk(KERN_CONT "Yes\n");
 		pty_output_sigio = 1;
 	} else if (n == -EAGAIN)
-		printk(UM_KERN_CONT "No, enabling workaround\n");
+		printk(KERN_CONT "No, enabling workaround\n");
 	else
-		printk(UM_KERN_CONT "tty_output : read failed, err = %d\n", n);
+		printk(KERN_CONT "tty_output : read failed, err = %d\n", n);
 }
 
 static void tty_close(int master, int slave)
 {
-	printk(UM_KERN_INFO "Checking that host ptys support SIGIO on "
+	printk(KERN_INFO "Checking that host ptys support SIGIO on "
 	       "close...");
 
 	close(slave);
 	if (got_sigio) {
-		printk(UM_KERN_CONT "Yes\n");
+		printk(KERN_CONT "Yes\n");
 		pty_close_sigio = 1;
 	} else
-		printk(UM_KERN_CONT "No, enabling workaround\n");
+		printk(KERN_CONT "No, enabling workaround\n");
 }
 
 static void __init check_sigio(void)
 {
 	if ((access("/dev/ptmx", R_OK) < 0) &&
 	    (access("/dev/ptyp0", R_OK) < 0)) {
-		printk(UM_KERN_WARNING "No pseudo-terminals available - "
+		printk(KERN_WARNING "No pseudo-terminals available - "
 		       "skipping pty SIGIO check\n");
 		return;
 	}
diff --git a/arch/um/os-Linux/skas/mem.c b/arch/um/os-Linux/skas/mem.c
index e7f8c94..4f0da16 100644
--- a/arch/um/os-Linux/skas/mem.c
+++ b/arch/um/os-Linux/skas/mem.c
@@ -55,9 +55,9 @@ static inline long do_syscall_stub(struct mm_id * mm_idp, void **addr)
 
 	n = ptrace_setregs(pid, syscall_regs);
 	if (n < 0) {
-		printk(UM_KERN_ERR "Registers - \n");
+		printk(KERN_ERR "Registers - \n");
 		for (i = 0; i < MAX_REG_NR; i++)
-			printk(UM_KERN_ERR "\t%d\t0x%lx\n", i, syscall_regs[i]);
+			printk(KERN_ERR "\t%d\t0x%lx\n", i, syscall_regs[i]);
 		panic("do_syscall_stub : PTRACE_SETREGS failed, errno = %d\n",
 		      -n);
 	}
@@ -79,22 +79,22 @@ static inline long do_syscall_stub(struct mm_id * mm_idp, void **addr)
 	offset = *((unsigned long *) mm_idp->stack + 1);
 	if (offset) {
 		data = (unsigned long *)(mm_idp->stack + offset - STUB_DATA);
-		printk(UM_KERN_ERR "do_syscall_stub : ret = %ld, offset = %ld, "
+		printk(KERN_ERR "do_syscall_stub : ret = %ld, offset = %ld, "
 		       "data = %p\n", ret, offset, data);
 		syscall = (unsigned long *)((unsigned long)data + data[0]);
-		printk(UM_KERN_ERR "do_syscall_stub: syscall %ld failed, "
+		printk(KERN_ERR "do_syscall_stub: syscall %ld failed, "
 		       "return value = 0x%lx, expected return value = 0x%lx\n",
 		       syscall[0], ret, syscall[7]);
-		printk(UM_KERN_ERR "    syscall parameters: "
+		printk(KERN_ERR "    syscall parameters: "
 		       "0x%lx 0x%lx 0x%lx 0x%lx 0x%lx 0x%lx\n",
 		       syscall[1], syscall[2], syscall[3],
 		       syscall[4], syscall[5], syscall[6]);
 		for (n = 1; n < data[0]/sizeof(long); n++) {
 			if (n == 1)
-				printk(UM_KERN_ERR "    additional syscall "
+				printk(KERN_ERR "    additional syscall "
 				       "data:");
 			if (n % 4 == 1)
-				printk("\n" UM_KERN_ERR "      ");
+				printk("\n" KERN_ERR "      ");
 			printk("  0x%lx", data[n]);
 		}
 		if (n > 1)
diff --git a/arch/um/os-Linux/skas/process.c b/arch/um/os-Linux/skas/process.c
index 452c214..7f8b3de 100644
--- a/arch/um/os-Linux/skas/process.c
+++ b/arch/um/os-Linux/skas/process.c
@@ -34,9 +34,9 @@ static int ptrace_dump_regs(int pid)
 	if (ptrace(PTRACE_GETREGS, pid, 0, regs) < 0)
 		return -errno;
 
-	printk(UM_KERN_ERR "Stub registers -\n");
+	printk(KERN_ERR "Stub registers -\n");
 	for (i = 0; i < ARRAY_SIZE(regs); i++)
-		printk(UM_KERN_ERR "\t%d - %lx\n", i, regs[i]);
+		printk(KERN_ERR "\t%d - %lx\n", i, regs[i]);
 
 	return 0;
 }
@@ -64,7 +64,7 @@ void wait_stub_done(int pid)
 
 		err = ptrace(PTRACE_CONT, pid, 0, 0);
 		if (err) {
-			printk(UM_KERN_ERR "wait_stub_done : continue failed, "
+			printk(KERN_ERR "wait_stub_done : continue failed, "
 			       "errno = %d\n", errno);
 			fatal_sigsegv();
 		}
@@ -78,9 +78,9 @@ void wait_stub_done(int pid)
 bad_wait:
 	err = ptrace_dump_regs(pid);
 	if (err)
-		printk(UM_KERN_ERR "Failed to get registers from stub, "
+		printk(KERN_ERR "Failed to get registers from stub, "
 		       "errno = %d\n", -err);
-	printk(UM_KERN_ERR "wait_stub_done : failed to wait for SIGTRAP, "
+	printk(KERN_ERR "wait_stub_done : failed to wait for SIGTRAP, "
 	       "pid = %d, n = %d, errno = %d, status = 0x%x\n", pid, n, errno,
 	       status);
 	if (bad_stop)
@@ -98,13 +98,13 @@ static void get_skas_faultinfo(int pid, struct faultinfo *fi)
 
 	err = get_fp_registers(pid, fpregs);
 	if (err < 0) {
-		printk(UM_KERN_ERR "save_fp_registers returned %d\n",
+		printk(KERN_ERR "save_fp_registers returned %d\n",
 		       err);
 		fatal_sigsegv();
 	}
 	err = ptrace(PTRACE_CONT, pid, 0, SIGSEGV);
 	if (err) {
-		printk(UM_KERN_ERR "Failed to continue stub, pid = %d, "
+		printk(KERN_ERR "Failed to continue stub, pid = %d, "
 		       "errno = %d\n", pid, errno);
 		fatal_sigsegv();
 	}
@@ -118,7 +118,7 @@ static void get_skas_faultinfo(int pid, struct faultinfo *fi)
 
 	err = put_fp_registers(pid, fpregs);
 	if (err < 0) {
-		printk(UM_KERN_ERR "put_fp_registers returned %d\n",
+		printk(KERN_ERR "put_fp_registers returned %d\n",
 		       err);
 		fatal_sigsegv();
 	}
@@ -150,14 +150,14 @@ static void handle_trap(int pid, struct uml_pt_regs *regs,
 		err = ptrace(PTRACE_POKEUSER, pid, PT_SYSCALL_NR_OFFSET,
 			     __NR_getpid);
 		if (err < 0) {
-			printk(UM_KERN_ERR "handle_trap - nullifying syscall "
+			printk(KERN_ERR "handle_trap - nullifying syscall "
 			       "failed, errno = %d\n", errno);
 			fatal_sigsegv();
 		}
 
 		err = ptrace(PTRACE_SYSCALL, pid, 0, 0);
 		if (err < 0) {
-			printk(UM_KERN_ERR "handle_trap - continuing to end of "
+			printk(KERN_ERR "handle_trap - continuing to end of "
 			       "syscall failed, errno = %d\n", errno);
 			fatal_sigsegv();
 		}
@@ -167,9 +167,9 @@ static void handle_trap(int pid, struct uml_pt_regs *regs,
 		    (WSTOPSIG(status) != SIGTRAP + 0x80)) {
 			err = ptrace_dump_regs(pid);
 			if (err)
-				printk(UM_KERN_ERR "Failed to get registers "
+				printk(KERN_ERR "Failed to get registers "
 				       "from process, errno = %d\n", -err);
-			printk(UM_KERN_ERR "handle_trap - failed to wait at "
+			printk(KERN_ERR "handle_trap - failed to wait at "
 			       "end of syscall, errno = %d, status = %d\n",
 			       errno, status);
 			fatal_sigsegv();
@@ -193,7 +193,7 @@ static int userspace_tramp(void *stack)
 	signal(SIGWINCH, SIG_IGN);
 	err = set_interval();
 	if (err) {
-		printk(UM_KERN_ERR "userspace_tramp - setting timer failed, "
+		printk(KERN_ERR "userspace_tramp - setting timer failed, "
 		       "errno = %d\n", err);
 		exit(1);
 	}
@@ -206,7 +206,7 @@ static int userspace_tramp(void *stack)
 	addr = mmap64((void *) STUB_CODE, UM_KERN_PAGE_SIZE,
 		      PROT_EXEC, MAP_FIXED | MAP_PRIVATE, fd, offset);
 	if (addr == MAP_FAILED) {
-		printk(UM_KERN_ERR "mapping mmap stub at 0x%lx failed, "
+		printk(KERN_ERR "mapping mmap stub at 0x%lx failed, "
 		       "errno = %d\n", STUB_CODE, errno);
 		exit(1);
 	}
@@ -217,7 +217,7 @@ static int userspace_tramp(void *stack)
 			    UM_KERN_PAGE_SIZE, PROT_READ | PROT_WRITE,
 			    MAP_FIXED | MAP_SHARED, fd, offset);
 		if (addr == MAP_FAILED) {
-			printk(UM_KERN_ERR "mapping segfault stack "
+			printk(KERN_ERR "mapping segfault stack "
 			       "at 0x%lx failed, errno = %d\n",
 			       STUB_DATA, errno);
 			exit(1);
@@ -236,7 +236,7 @@ static int userspace_tramp(void *stack)
 		sa.sa_sigaction = (void *) v;
 		sa.sa_restorer = NULL;
 		if (sigaction(SIGSEGV, &sa, NULL) < 0) {
-			printk(UM_KERN_ERR "userspace_tramp - setting SIGSEGV "
+			printk(KERN_ERR "userspace_tramp - setting SIGSEGV "
 			       "handler failed - errno = %d\n", errno);
 			exit(1);
 		}
@@ -262,7 +262,7 @@ int start_userspace(unsigned long stub_stack)
 		     MAP_PRIVATE | MAP_ANONYMOUS, -1, 0);
 	if (stack == MAP_FAILED) {
 		err = -errno;
-		printk(UM_KERN_ERR "start_userspace : mmap failed, "
+		printk(KERN_ERR "start_userspace : mmap failed, "
 		       "errno = %d\n", errno);
 		return err;
 	}
@@ -274,7 +274,7 @@ int start_userspace(unsigned long stub_stack)
 	pid = clone(userspace_tramp, (void *) sp, flags, (void *) stub_stack);
 	if (pid < 0) {
 		err = -errno;
-		printk(UM_KERN_ERR "start_userspace : clone failed, "
+		printk(KERN_ERR "start_userspace : clone failed, "
 		       "errno = %d\n", errno);
 		return err;
 	}
@@ -283,7 +283,7 @@ int start_userspace(unsigned long stub_stack)
 		CATCH_EINTR(n = waitpid(pid, &status, WUNTRACED | __WALL));
 		if (n < 0) {
 			err = -errno;
-			printk(UM_KERN_ERR "start_userspace : wait failed, "
+			printk(KERN_ERR "start_userspace : wait failed, "
 			       "errno = %d\n", errno);
 			goto out_kill;
 		}
@@ -291,7 +291,7 @@ int start_userspace(unsigned long stub_stack)
 
 	if (!WIFSTOPPED(status) || (WSTOPSIG(status) != SIGSTOP)) {
 		err = -EINVAL;
-		printk(UM_KERN_ERR "start_userspace : expected SIGSTOP, got "
+		printk(KERN_ERR "start_userspace : expected SIGSTOP, got "
 		       "status = %d\n", status);
 		goto out_kill;
 	}
@@ -299,14 +299,14 @@ int start_userspace(unsigned long stub_stack)
 	if (ptrace(PTRACE_OLDSETOPTIONS, pid, NULL,
 		   (void *) PTRACE_O_TRACESYSGOOD) < 0) {
 		err = -errno;
-		printk(UM_KERN_ERR "start_userspace : PTRACE_OLDSETOPTIONS "
+		printk(KERN_ERR "start_userspace : PTRACE_OLDSETOPTIONS "
 		       "failed, errno = %d\n", errno);
 		goto out_kill;
 	}
 
 	if (munmap(stack, UM_KERN_PAGE_SIZE) < 0) {
 		err = -errno;
-		printk(UM_KERN_ERR "start_userspace : munmap failed, "
+		printk(KERN_ERR "start_userspace : munmap failed, "
 		       "errno = %d\n", errno);
 		goto out_kill;
 	}
@@ -331,7 +331,7 @@ void userspace(struct uml_pt_regs *regs)
 	interrupt_end();
 
 	if (getitimer(ITIMER_VIRTUAL, &timer))
-		printk(UM_KERN_ERR "Failed to get itimer, errno = %d\n", errno);
+		printk(KERN_ERR "Failed to get itimer, errno = %d\n", errno);
 	nsecs = timer.it_value.tv_sec * UM_NSEC_PER_SEC +
 		timer.it_value.tv_usec * UM_NSEC_PER_USEC;
 	nsecs += os_nsecs();
@@ -358,27 +358,27 @@ void userspace(struct uml_pt_regs *regs)
 					     singlestepping(NULL));
 
 		if (ptrace(op, pid, 0, 0)) {
-			printk(UM_KERN_ERR "userspace - ptrace continue "
+			printk(KERN_ERR "userspace - ptrace continue "
 			       "failed, op = %d, errno = %d\n", op, errno);
 			fatal_sigsegv();
 		}
 
 		CATCH_EINTR(err = waitpid(pid, &status, WUNTRACED | __WALL));
 		if (err < 0) {
-			printk(UM_KERN_ERR "userspace - wait failed, "
+			printk(KERN_ERR "userspace - wait failed, "
 			       "errno = %d\n", errno);
 			fatal_sigsegv();
 		}
 
 		regs->is_user = 1;
 		if (ptrace(PTRACE_GETREGS, pid, 0, regs->gp)) {
-			printk(UM_KERN_ERR "userspace - PTRACE_GETREGS failed, "
+			printk(KERN_ERR "userspace - PTRACE_GETREGS failed, "
 			       "errno = %d\n", errno);
 			fatal_sigsegv();
 		}
 
 		if (get_fp_registers(pid, regs->fp)) {
-			printk(UM_KERN_ERR "userspace -  get_fp_registers failed, "
+			printk(KERN_ERR "userspace -  get_fp_registers failed, "
 			       "errno = %d\n", errno);
 			fatal_sigsegv();
 		}
@@ -429,7 +429,7 @@ void userspace(struct uml_pt_regs *regs)
 				unblock_signals();
 				break;
 			default:
-				printk(UM_KERN_ERR "userspace - child stopped "
+				printk(KERN_ERR "userspace - child stopped "
 				       "with signal %d\n", sig);
 				fatal_sigsegv();
 			}
@@ -486,14 +486,14 @@ int copy_context_skas0(unsigned long new_stack, int pid)
 	err = ptrace_setregs(pid, thread_regs);
 	if (err < 0) {
 		err = -errno;
-		printk(UM_KERN_ERR "copy_context_skas0 : PTRACE_SETREGS "
+		printk(KERN_ERR "copy_context_skas0 : PTRACE_SETREGS "
 		       "failed, pid = %d, errno = %d\n", pid, -err);
 		return err;
 	}
 
 	err = put_fp_registers(pid, thread_fp_regs);
 	if (err < 0) {
-		printk(UM_KERN_ERR "copy_context_skas0 : put_fp_registers "
+		printk(KERN_ERR "copy_context_skas0 : put_fp_registers "
 		       "failed, pid = %d, err = %d\n", pid, err);
 		return err;
 	}
@@ -508,7 +508,7 @@ int copy_context_skas0(unsigned long new_stack, int pid)
 	err = ptrace(PTRACE_CONT, pid, 0, 0);
 	if (err) {
 		err = -errno;
-		printk(UM_KERN_ERR "Failed to continue new process, pid = %d, "
+		printk(KERN_ERR "Failed to continue new process, pid = %d, "
 		       "errno = %d\n", pid, errno);
 		return err;
 	}
@@ -517,7 +517,7 @@ int copy_context_skas0(unsigned long new_stack, int pid)
 
 	pid = data->err;
 	if (pid < 0) {
-		printk(UM_KERN_ERR "copy_context_skas0 - stub-parent reports "
+		printk(KERN_ERR "copy_context_skas0 - stub-parent reports "
 		       "error %d\n", -pid);
 		return pid;
 	}
@@ -528,7 +528,7 @@ int copy_context_skas0(unsigned long new_stack, int pid)
 	 */
 	wait_stub_done(pid);
 	if (child_data->err != STUB_DATA) {
-		printk(UM_KERN_ERR "copy_context_skas0 - stub-child reports "
+		printk(KERN_ERR "copy_context_skas0 - stub-child reports "
 		       "error %ld\n", child_data->err);
 		err = child_data->err;
 		goto out_kill;
@@ -537,7 +537,7 @@ int copy_context_skas0(unsigned long new_stack, int pid)
 	if (ptrace(PTRACE_OLDSETOPTIONS, pid, NULL,
 		   (void *)PTRACE_O_TRACESYSGOOD) < 0) {
 		err = -errno;
-		printk(UM_KERN_ERR "copy_context_skas0 : PTRACE_OLDSETOPTIONS "
+		printk(KERN_ERR "copy_context_skas0 : PTRACE_OLDSETOPTIONS "
 		       "failed, errno = %d\n", errno);
 		goto out_kill;
 	}
@@ -606,7 +606,7 @@ int start_idle_thread(void *stack, jmp_buf *switch_buf)
 		kmalloc_ok = 0;
 		return 1;
 	default:
-		printk(UM_KERN_ERR "Bad sigsetjmp return in "
+		printk(KERN_ERR "Bad sigsetjmp return in "
 		       "start_idle_thread - %d\n", n);
 		fatal_sigsegv();
 	}
diff --git a/arch/um/os-Linux/time.c b/arch/um/os-Linux/time.c
index e9824d5..d6037c1 100644
--- a/arch/um/os-Linux/time.c
+++ b/arch/um/os-Linux/time.c
@@ -61,7 +61,7 @@ long long disable_timer(void)
 	long long remain, max = UM_NSEC_PER_SEC / UM_HZ;
 
 	if (setitimer(ITIMER_VIRTUAL, &time, &time) < 0)
-		printk(UM_KERN_ERR "disable_timer - setitimer failed, "
+		printk(KERN_ERR "disable_timer - setitimer failed, "
 		       "errno = %d\n", errno);
 
 	remain = timeval_to_ns(&time.it_value);
diff --git a/arch/um/os-Linux/tty.c b/arch/um/os-Linux/tty.c
index 721d8af..aca9032 100644
--- a/arch/um/os-Linux/tty.c
+++ b/arch/um/os-Linux/tty.c
@@ -32,7 +32,7 @@ int get_pty(void)
 	fd = open("/dev/ptmx", O_RDWR);
 	if (fd < 0) {
 		err = -errno;
-		printk(UM_KERN_ERR "get_pty : Couldn't open /dev/ptmx - "
+		printk(KERN_ERR "get_pty : Couldn't open /dev/ptmx - "
 		       "err = %d\n", errno);
 		return err;
 	}
@@ -42,14 +42,14 @@ int get_pty(void)
 
 	if (info.res < 0) {
 		err = -info.err;
-		printk(UM_KERN_ERR "get_pty : Couldn't grant pty - "
+		printk(KERN_ERR "get_pty : Couldn't grant pty - "
 		       "errno = %d\n", -info.err);
 		goto out;
 	}
 
 	if (unlockpt(fd) < 0) {
 		err = -errno;
-		printk(UM_KERN_ERR "get_pty : Couldn't unlock pty - "
+		printk(KERN_ERR "get_pty : Couldn't unlock pty - "
 		       "errno = %d\n", errno);
 		goto out;
 	}
diff --git a/arch/um/os-Linux/umid.c b/arch/um/os-Linux/umid.c
index c1dc892..e53dd97 100644
--- a/arch/um/os-Linux/umid.c
+++ b/arch/um/os-Linux/umid.c
@@ -35,7 +35,7 @@ static int __init make_uml_dir(void)
 
 		err = -ENOENT;
 		if (home == NULL) {
-			printk(UM_KERN_ERR "make_uml_dir : no value in "
+			printk(KERN_ERR "make_uml_dir : no value in "
 			       "environment for $HOME\n");
 			goto err;
 		}
@@ -138,7 +138,7 @@ static inline int is_umdir_used(char *dir)
 
 	n = snprintf(file, sizeof(file), "%s/pid", dir);
 	if (n >= sizeof(file)) {
-		printk(UM_KERN_ERR "is_umdir_used - pid filename too long\n");
+		printk(KERN_ERR "is_umdir_used - pid filename too long\n");
 		err = -E2BIG;
 		goto out;
 	}
@@ -148,7 +148,7 @@ static inline int is_umdir_used(char *dir)
 	if (fd < 0) {
 		fd = -errno;
 		if (fd != -ENOENT) {
-			printk(UM_KERN_ERR "is_umdir_used : couldn't open pid "
+			printk(KERN_ERR "is_umdir_used : couldn't open pid "
 			       "file '%s', err = %d\n", file, -fd);
 		}
 		goto out;
@@ -157,24 +157,24 @@ static inline int is_umdir_used(char *dir)
 	err = 0;
 	n = read(fd, pid, sizeof(pid));
 	if (n < 0) {
-		printk(UM_KERN_ERR "is_umdir_used : couldn't read pid file "
+		printk(KERN_ERR "is_umdir_used : couldn't read pid file "
 		       "'%s', err = %d\n", file, errno);
 		goto out_close;
 	} else if (n == 0) {
-		printk(UM_KERN_ERR "is_umdir_used : couldn't read pid file "
+		printk(KERN_ERR "is_umdir_used : couldn't read pid file "
 		       "'%s', 0-byte read\n", file);
 		goto out_close;
 	}
 
 	p = strtoul(pid, &end, 0);
 	if (end == pid) {
-		printk(UM_KERN_ERR "is_umdir_used : couldn't parse pid file "
+		printk(KERN_ERR "is_umdir_used : couldn't parse pid file "
 		       "'%s', errno = %d\n", file, errno);
 		goto out_close;
 	}
 
 	if ((kill(p, 0) == 0) || (errno != ESRCH)) {
-		printk(UM_KERN_ERR "umid \"%s\" is already in use by pid %d\n",
+		printk(KERN_ERR "umid \"%s\" is already in use by pid %d\n",
 		       umid, p);
 		return 1;
 	}
@@ -199,7 +199,7 @@ static int umdir_take_if_dead(char *dir)
 
 	ret = remove_files_and_dir(dir);
 	if (ret) {
-		printk(UM_KERN_ERR "is_umdir_used - remove_files_and_dir "
+		printk(KERN_ERR "is_umdir_used - remove_files_and_dir "
 		       "failed with err = %d\n", ret);
 	}
 	return ret;
@@ -216,7 +216,7 @@ static void __init create_pid_file(void)
 
 	fd = open(file, O_RDWR | O_CREAT | O_EXCL, 0644);
 	if (fd < 0) {
-		printk(UM_KERN_ERR "Open of machine pid file \"%s\" failed: "
+		printk(KERN_ERR "Open of machine pid file \"%s\" failed: "
 		       "%s\n", file, strerror(errno));
 		return;
 	}
@@ -224,7 +224,7 @@ static void __init create_pid_file(void)
 	snprintf(pid, sizeof(pid), "%d\n", getpid());
 	n = write(fd, pid, strlen(pid));
 	if (n != strlen(pid))
-		printk(UM_KERN_ERR "Write of pid file failed - err = %d\n",
+		printk(KERN_ERR "Write of pid file failed - err = %d\n",
 		       errno);
 
 	close(fd);
@@ -258,7 +258,7 @@ static int __init make_umid(void)
 		strlcat(tmp, "XXXXXX", sizeof(tmp));
 		fd = mkstemp(tmp);
 		if (fd < 0) {
-			printk(UM_KERN_ERR "make_umid - mkstemp(%s) failed: "
+			printk(KERN_ERR "make_umid - mkstemp(%s) failed: "
 			       "%s\n", tmp, strerror(errno));
 			err = -errno;
 			goto err;
@@ -293,7 +293,7 @@ static int __init make_umid(void)
 	}
 	if (err) {
 		err = -errno;
-		printk(UM_KERN_ERR "Failed to create '%s' - err = %d\n", umid,
+		printk(KERN_ERR "Failed to create '%s' - err = %d\n", umid,
 		       errno);
 		goto err;
 	}
@@ -316,7 +316,7 @@ static int __init make_umid_init(void)
 	 * If initializing with the given umid failed, then try again with
 	 * a random one.
 	 */
-	printk(UM_KERN_ERR "Failed to initialize umid \"%s\", trying with a "
+	printk(KERN_ERR "Failed to initialize umid \"%s\", trying with a "
 	       "random umid\n", umid);
 	*umid = '\0';
 	make_umid();
@@ -336,7 +336,7 @@ int __init umid_file_name(char *name, char *buf, int len)
 
 	n = snprintf(buf, len, "%s%s/%s", uml_dir, umid, name);
 	if (n >= len) {
-		printk(UM_KERN_ERR "umid_file_name : buffer too short\n");
+		printk(KERN_ERR "umid_file_name : buffer too short\n");
 		return -E2BIG;
 	}
 
diff --git a/arch/x86/um/bugs_32.c b/arch/x86/um/bugs_32.c
index 33daff4..b2b990a 100644
--- a/arch/x86/um/bugs_32.c
+++ b/arch/x86/um/bugs_32.c
@@ -23,7 +23,7 @@ void arch_check_bugs(void)
 {
 	struct sigaction old, new;
 
-	printk(UM_KERN_INFO "Checking for host processor cmov support...");
+	printk(KERN_INFO "Checking for host processor cmov support...");
 	new.sa_handler = cmov_sigill_test_handler;
 
 	/* Make sure that SIGILL is enabled after the handler longjmps back */
@@ -34,9 +34,9 @@ void arch_check_bugs(void)
 	if (setjmp(cmov_test_return) == 0) {
 		unsigned long foo = 0;
 		__asm__ __volatile__("cmovz %0, %1" : "=r" (foo) : "0" (foo));
-		printk(UM_KERN_CONT "Yes\n");
+		printk(KERN_CONT "Yes\n");
 	} else
-		printk(UM_KERN_CONT "No\n");
+		printk(KERN_CONT "No\n");
 
 	sigaction(SIGILL, &old, &new);
 }
@@ -53,7 +53,7 @@ void arch_examine_signal(int sig, struct uml_pt_regs *regs)
 		return;
 
 	if (copy_from_user_proc(tmp, (void *) UPT_IP(regs), 2)) {
-		printk(UM_KERN_ERR "SIGILL in init, could not read "
+		printk(KERN_ERR "SIGILL in init, could not read "
 		       "instructions!\n");
 		return;
 	}
@@ -62,13 +62,13 @@ void arch_examine_signal(int sig, struct uml_pt_regs *regs)
 		return;
 
 	if (host_has_cmov == 0)
-		printk(UM_KERN_ERR "SIGILL caused by cmov, which this "
+		printk(KERN_ERR "SIGILL caused by cmov, which this "
 		       "processor doesn't implement.  Boot a filesystem "
 		       "compiled for older processors");
 	else if (host_has_cmov == 1)
-		printk(UM_KERN_ERR "SIGILL caused by cmov, which this "
+		printk(KERN_ERR "SIGILL caused by cmov, which this "
 		       "processor claims to implement");
 	else
-		printk(UM_KERN_ERR "Bad value for host_has_cmov (%d)",
+		printk(KERN_ERR "Bad value for host_has_cmov (%d)",
 			host_has_cmov);
 }
diff --git a/arch/x86/um/os-Linux/registers.c b/arch/x86/um/os-Linux/registers.c
index 41bfe84..8ebceb8 100644
--- a/arch/x86/um/os-Linux/registers.c
+++ b/arch/x86/um/os-Linux/registers.c
@@ -106,7 +106,7 @@ unsigned long get_thread_reg(int reg, jmp_buf *buf)
 		return buf[0]->__rbp;
 #endif
 	default:
-		printk(UM_KERN_ERR "get_thread_regs - unknown register %d\n",
+		printk(KERN_ERR "get_thread_regs - unknown register %d\n",
 		       reg);
 		return 0;
 	}
-- 
1.8.1.2.459.gbcd45b4.dirty


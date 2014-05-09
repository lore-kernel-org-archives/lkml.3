Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932275AbaEIXne (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 May 2014 19:43:34 -0400
Received: from smtprelay0158.hostedemail.com ([216.40.44.158]:34624 "EHLO
	smtprelay.hostedemail.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1757381AbaEIXn0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 May 2014 19:43:26 -0400
X-Session-Marker: 6A6F6540706572636865732E636F6D
X-Spam-Summary: 2,0,0,,d41d8cd98f00b204,joe@perches.com,:::::::,RULES_HIT:69:355:379:541:960:966:968:973:981:982:988:989:1042:1260:1345:1359:1437:1605:1730:1747:1777:1792:1801:2194:2196:2198:2199:2200:2201:2393:2538:2559:2562:2693:2731:2898:2901:2904:3138:3139:3140:3141:3142:3165:3503:3504:3505:3865:3866:3867:3868:3870:3871:3872:3873:3874:4250:4321:4385:4605:5007:6248:6261:7875:7903:7904:8603:8660:9010:9165:10004:10026:10226:10848:11026:11233:11638:11657:11914:12043:12257:12294:12296:12438:12517:12519:12555:12679:12683:13148:13230:13868:13972:21063,0,RBL:none,CacheIP:none,Bayesian:0.5,0.5,0.5,Netcheck:none,DomainCache:0,MSF:not bulk,SPF:fn,MSBL:0,DNSBL:none,Custom_rules:0:0:0
X-HE-Tag: dogs46_31c5600203d
X-Filterd-Recvd-Size: 135507
From: Joe Perches <joe@perches.com>
To: linux-kernel@vger.kernel.org
Cc: Jeff Dike <jdike@addtoit.com>, Richard Weinberger <richard@nod.at>,
        user-mode-linux-devel@lists.sourceforge.net
Subject: [PATCH 3/4] UserModeLinux: Use a more current logging style
Date: Fri,  9 May 2014 16:43:12 -0700
Message-Id: <21a7f17762c0e757adaf6b9ccb4297ffb865cbfd.1399678795.git.joe@perches.com>
X-Mailer: git-send-email 1.8.1.2.459.gbcd45b4.dirty
In-Reply-To: <cover.1399678795.git.joe@perches.com>
References: <cover.1399678795.git.joe@perches.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Convert printks to pr_<level>
Coalesce formats
Realign arguments

Signed-off-by: Joe Perches <joe@perches.com>
---
 arch/um/drivers/chan_kern.c              |  27 +++----
 arch/um/drivers/chan_user.c              |  47 ++++++------
 arch/um/drivers/daemon_kern.c            |   3 +-
 arch/um/drivers/daemon_user.c            |  28 +++----
 arch/um/drivers/fd.c                     |   9 +--
 arch/um/drivers/hostaudio_kern.c         |  13 ++--
 arch/um/drivers/line.c                   |  24 +++---
 arch/um/drivers/mconsole_kern.c          |  29 +++----
 arch/um/drivers/mconsole_user.c          |   7 +-
 arch/um/drivers/mmapper_kern.c           |   7 +-
 arch/um/drivers/net_kern.c               |  53 +++++--------
 arch/um/drivers/net_user.c               |  20 ++---
 arch/um/drivers/pcap_kern.c              |   7 +-
 arch/um/drivers/pcap_user.c              |  19 +++--
 arch/um/drivers/port_kern.c              |  23 +++---
 arch/um/drivers/port_user.c              |   6 +-
 arch/um/drivers/pty.c                    |   4 +-
 arch/um/drivers/slip_user.c              |  29 +++----
 arch/um/drivers/slirp_kern.c             |   3 +-
 arch/um/drivers/slirp_user.c             |   9 +--
 arch/um/drivers/ssl.c                    |  10 +--
 arch/um/drivers/stdio_console.c          |   9 +--
 arch/um/drivers/tty.c                    |   3 +-
 arch/um/drivers/ubd_kern.c               | 100 ++++++++++++-------------
 arch/um/drivers/umcast_kern.c            |  38 +++++-----
 arch/um/drivers/umcast_user.c            |  35 ++++-----
 arch/um/drivers/vde_kern.c               |  17 ++---
 arch/um/drivers/vde_user.c               |  14 ++--
 arch/um/drivers/xterm.c                  |  26 +++----
 arch/um/drivers/xterm_kern.c             |   6 +-
 arch/um/kernel/exec.c                    |   4 +-
 arch/um/kernel/exitcode.c                |   3 +-
 arch/um/kernel/initrd.c                  |  10 +--
 arch/um/kernel/irq.c                     |  14 ++--
 arch/um/kernel/physmem.c                 |  16 ++--
 arch/um/kernel/process.c                 |   2 +-
 arch/um/kernel/sigio.c                   |   4 +-
 arch/um/kernel/skas/mmu.c                |   9 +--
 arch/um/kernel/smp.c                     |  18 ++---
 arch/um/kernel/sysrq.c                   |  21 +++---
 arch/um/kernel/time.c                    |   6 +-
 arch/um/kernel/tlb.c                     |   8 +-
 arch/um/kernel/trap.c                    |   9 +--
 arch/um/os-Linux/aio.c                   |  45 +++++------
 arch/um/os-Linux/drivers/ethertap_kern.c |   8 +-
 arch/um/os-Linux/drivers/ethertap_user.c |  32 ++++----
 arch/um/os-Linux/drivers/tuntap_kern.c   |   6 +-
 arch/um/os-Linux/drivers/tuntap_user.c   |  24 +++---
 arch/um/os-Linux/file.c                  |  37 ++++-----
 arch/um/os-Linux/helper.c                |  33 ++++----
 arch/um/os-Linux/irq.c                   |   8 +-
 arch/um/os-Linux/process.c               |  31 ++++----
 arch/um/os-Linux/sigio.c                 |  83 +++++++++-----------
 arch/um/os-Linux/skas/mem.c              |  23 +++---
 arch/um/os-Linux/skas/process.c          | 125 ++++++++++++++-----------------
 arch/um/os-Linux/time.c                  |   3 +-
 arch/um/os-Linux/tty.c                   |  10 +--
 arch/um/os-Linux/umid.c                  |  48 ++++++------
 58 files changed, 550 insertions(+), 715 deletions(-)

diff --git a/arch/um/drivers/chan_kern.c b/arch/um/drivers/chan_kern.c
index acbe6c6..59ade91 100644
--- a/arch/um/drivers/chan_kern.c
+++ b/arch/um/drivers/chan_kern.c
@@ -14,58 +14,50 @@
 static void *not_configged_init(char *str, int device,
 				const struct chan_opts *opts)
 {
-	printk(KERN_ERR "Using a channel type which is configured out of "
-	       "UML\n");
+	pr_err("Using a channel type which is configured out of UML\n");
 	return NULL;
 }
 
 static int not_configged_open(int input, int output, int primary, void *data,
 			      char **dev_out)
 {
-	printk(KERN_ERR "Using a channel type which is configured out of "
-	       "UML\n");
+	pr_err("Using a channel type which is configured out of UML\n");
 	return -ENODEV;
 }
 
 static void not_configged_close(int fd, void *data)
 {
-	printk(KERN_ERR "Using a channel type which is configured out of "
-	       "UML\n");
+	pr_err("Using a channel type which is configured out of UML\n");
 }
 
 static int not_configged_read(int fd, char *c_out, void *data)
 {
-	printk(KERN_ERR "Using a channel type which is configured out of "
-	       "UML\n");
+	pr_err("Using a channel type which is configured out of UML\n");
 	return -EIO;
 }
 
 static int not_configged_write(int fd, const char *buf, int len, void *data)
 {
-	printk(KERN_ERR "Using a channel type which is configured out of "
-	       "UML\n");
+	pr_err("Using a channel type which is configured out of UML\n");
 	return -EIO;
 }
 
 static int not_configged_console_write(int fd, const char *buf, int len)
 {
-	printk(KERN_ERR "Using a channel type which is configured out of "
-	       "UML\n");
+	pr_err("Using a channel type which is configured out of UML\n");
 	return -EIO;
 }
 
 static int not_configged_window_size(int fd, void *data, unsigned short *rows,
 				     unsigned short *cols)
 {
-	printk(KERN_ERR "Using a channel type which is configured out of "
-	       "UML\n");
+	pr_err("Using a channel type which is configured out of UML\n");
 	return -ENODEV;
 }
 
 static void not_configged_free(void *data)
 {
-	printk(KERN_ERR "Using a channel type which is configured out of "
-	       "UML\n");
+	pr_err("Using a channel type which is configured out of UML\n");
 }
 
 static const struct chan_ops not_configged_ops = {
@@ -292,8 +284,7 @@ int console_open_chan(struct line *line, struct console *co)
 	if (err)
 		return err;
 
-	printk(KERN_INFO "Console initialized on /dev/%s%d\n", co->name,
-	       co->index);
+	pr_info("Console initialized on /dev/%s%d\n", co->name, co->index);
 	return 0;
 }
 
diff --git a/arch/um/drivers/chan_user.c b/arch/um/drivers/chan_user.c
index c0d47cf..c010396 100644
--- a/arch/um/drivers/chan_user.c
+++ b/arch/um/drivers/chan_user.c
@@ -153,8 +153,8 @@ static int winch_thread(void *arg)
 	pipe_fd = data->pipe_fd;
 	count = write(pipe_fd, &c, sizeof(c));
 	if (count != sizeof(c))
-		printk(KERN_ERR "winch_thread : failed to write "
-		       "synchronization byte, err = %d\n", -count);
+		pr_err("winch_thread : failed to write synchronization byte, err = %d\n",
+		       -count);
 
 	/*
 	 * We are not using SIG_IGN on purpose, so don't fix it as I thought to
@@ -166,28 +166,27 @@ static int winch_thread(void *arg)
 	sigfillset(&sigs);
 	/* Block all signals possible. */
 	if (sigprocmask(SIG_SETMASK, &sigs, NULL) < 0) {
-		printk(KERN_ERR "winch_thread : sigprocmask failed, "
-		       "errno = %d\n", errno);
+		pr_err("winch_thread : sigprocmask failed, errno = %d\n",
+		       errno);
 		exit(1);
 	}
 	/* In sigsuspend(), block anything else than SIGWINCH. */
 	sigdelset(&sigs, SIGWINCH);
 
 	if (setsid() < 0) {
-		printk(KERN_ERR "winch_thread : setsid failed, errno = %d\n",
-		       errno);
+		pr_err("winch_thread : setsid failed, errno = %d\n", errno);
 		exit(1);
 	}
 
 	if (ioctl(pty_fd, TIOCSCTTY, 0) < 0) {
-		printk(KERN_ERR "winch_thread : TIOCSCTTY failed on "
-		       "fd %d err = %d\n", pty_fd, errno);
+		pr_err("winch_thread : TIOCSCTTY failed on fd %d err = %d\n",
+		       pty_fd, errno);
 		exit(1);
 	}
 
 	if (tcsetpgrp(pty_fd, os_getpid()) < 0) {
-		printk(KERN_ERR "winch_thread : tcsetpgrp failed on "
-		       "fd %d err = %d\n", pty_fd, errno);
+		pr_err("winch_thread : tcsetpgrp failed on fd %d err = %d\n",
+		       pty_fd, errno);
 		exit(1);
 	}
 
@@ -199,8 +198,8 @@ static int winch_thread(void *arg)
 	 */
 	count = read(pipe_fd, &c, sizeof(c));
 	if (count != sizeof(c))
-		printk(KERN_ERR "winch_thread : failed to read "
-		       "synchronization byte, err = %d\n", errno);
+		pr_err("winch_thread : failed to read synchronization byte, err = %d\n",
+		       errno);
 
 	while(1) {
 		/*
@@ -211,8 +210,8 @@ static int winch_thread(void *arg)
 
 		count = write(pipe_fd, &c, sizeof(c));
 		if (count != sizeof(c))
-			printk(KERN_ERR "winch_thread : write failed, "
-			       "err = %d\n", errno);
+			pr_err("winch_thread : write failed, err = %d\n",
+			       errno);
 	}
 }
 
@@ -225,8 +224,7 @@ static int winch_tramp(int fd, struct tty_port *port, int *fd_out,
 
 	err = os_pipe(fds, 1, 1);
 	if (err < 0) {
-		printk(KERN_ERR "winch_tramp : os_pipe failed, err = %d\n",
-		       -err);
+		pr_err("winch_tramp : os_pipe failed, err = %d\n", -err);
 		goto out;
 	}
 
@@ -240,25 +238,22 @@ static int winch_tramp(int fd, struct tty_port *port, int *fd_out,
 	 */
 	err = run_helper_thread(winch_thread, &data, CLONE_FILES, stack_out);
 	if (err < 0) {
-		printk(KERN_ERR "fork of winch_thread failed - errno = %d\n",
-		       -err);
+		pr_err("fork of winch_thread failed - errno = %d\n", -err);
 		goto out_close;
 	}
 
 	*fd_out = fds[0];
 	n = read(fds[0], &c, sizeof(c));
 	if (n != sizeof(c)) {
-		printk(KERN_ERR "winch_tramp : failed to read "
-		       "synchronization byte\n");
-		printk(KERN_ERR "read failed, err = %d\n", errno);
-		printk(KERN_ERR "fd %d will not support SIGWINCH\n", fd);
+		pr_err("winch_tramp : failed to read synchronization byte\n");
+		pr_err("read failed, err = %d\n", errno);
+		pr_err("fd %d will not support SIGWINCH\n", fd);
 		err = -EINVAL;
 		goto out_close;
 	}
 
 	if (os_set_fd_block(*fd_out, 0)) {
-		printk(KERN_ERR "winch_tramp: failed to set thread_fd "
-		       "non-blocking.\n");
+		pr_err("winch_tramp: failed to set thread_fd non-blocking\n");
 		goto out_close;
 	}
 
@@ -295,7 +290,7 @@ void register_winch(int fd, struct tty_port *port)
 
 		count = write(thread_fd, &c, sizeof(c));
 		if (count != sizeof(c))
-			printk(KERN_ERR "register_winch : failed to write "
-			       "synchronization byte, err = %d\n", errno);
+			pr_err("register_winch : failed to write synchronization byte, err = %d\n",
+			       errno);
 	}
 }
diff --git a/arch/um/drivers/daemon_kern.c b/arch/um/drivers/daemon_kern.c
index 7568cc2..197b670 100644
--- a/arch/um/drivers/daemon_kern.c
+++ b/arch/um/drivers/daemon_kern.c
@@ -70,8 +70,7 @@ static int daemon_setup(char *str, char **mac_out, void *data)
 	remain = split_if_spec(str, mac_out, &init->sock_type, &init->ctl_sock,
 			       NULL);
 	if (remain != NULL)
-		printk(KERN_WARNING "daemon_setup : Ignoring data socket "
-		       "specification\n");
+		pr_warn("daemon_setup : Ignoring data socket specification\n");
 
 	return 1;
 }
diff --git a/arch/um/drivers/daemon_user.c b/arch/um/drivers/daemon_user.c
index f3933c7..c355f99 100644
--- a/arch/um/drivers/daemon_user.c
+++ b/arch/um/drivers/daemon_user.c
@@ -35,8 +35,7 @@ static struct sockaddr_un *new_addr(void *name, int len)
 
 	sun = uml_kmalloc(sizeof(struct sockaddr_un), UM_GFP_KERNEL);
 	if (sun == NULL) {
-		printk(KERN_ERR "new_addr: allocation of sockaddr_un "
-		       "failed\n");
+		pr_err("new_addr: allocation of sockaddr_un failed\n");
 		return NULL;
 	}
 	sun->sun_family = AF_UNIX;
@@ -55,37 +54,34 @@ static int connect_to_switch(struct daemon_data *pri)
 	pri->control = socket(AF_UNIX, SOCK_STREAM, 0);
 	if (pri->control < 0) {
 		err = -errno;
-		printk(KERN_ERR "daemon_open : control socket failed, "
-		       "errno = %d\n", -err);
+		pr_err("daemon_open : control socket failed, errno = %d\n",
+		       -err);
 		return err;
 	}
 
 	if (connect(pri->control, (struct sockaddr *) ctl_addr,
 		   sizeof(*ctl_addr)) < 0) {
 		err = -errno;
-		printk(KERN_ERR "daemon_open : control connect failed, "
-		       "errno = %d\n", -err);
+		pr_err("daemon_open : control connect failed, errno = %d\n",
+		       -err);
 		goto out;
 	}
 
 	fd = socket(AF_UNIX, SOCK_DGRAM, 0);
 	if (fd < 0) {
 		err = -errno;
-		printk(KERN_ERR "daemon_open : data socket failed, "
-		       "errno = %d\n", -err);
+		pr_err("daemon_open : data socket failed, errno = %d\n", -err);
 		goto out;
 	}
 	if (bind(fd, (struct sockaddr *) local_addr, sizeof(*local_addr)) < 0) {
 		err = -errno;
-		printk(KERN_ERR "daemon_open : data bind failed, "
-		       "errno = %d\n", -err);
+		pr_err("daemon_open : data bind failed, errno = %d\n", -err);
 		goto out_close;
 	}
 
 	sun = uml_kmalloc(sizeof(struct sockaddr_un), UM_GFP_KERNEL);
 	if (sun == NULL) {
-		printk(KERN_ERR "new_addr: allocation of sockaddr_un "
-		       "failed\n");
+		pr_err("new_addr: allocation of sockaddr_un failed\n");
 		err = -ENOMEM;
 		goto out_close;
 	}
@@ -96,16 +92,16 @@ static int connect_to_switch(struct daemon_data *pri)
 	req.sock = *local_addr;
 	n = write(pri->control, &req, sizeof(req));
 	if (n != sizeof(req)) {
-		printk(KERN_ERR "daemon_open : control setup request "
-		       "failed, err = %d\n", -errno);
+		pr_err("daemon_open : control setup request failed, err = %d\n",
+		       -errno);
 		err = -ENOTCONN;
 		goto out_free;
 	}
 
 	n = read(pri->control, sun, sizeof(*sun));
 	if (n != sizeof(*sun)) {
-		printk(KERN_ERR "daemon_open : read of data socket failed, "
-		       "err = %d\n", -errno);
+		pr_err("daemon_open : read of data socket failed, err = %d\n",
+		       -errno);
 		err = -ENOTCONN;
 		goto out_free;
 	}
diff --git a/arch/um/drivers/fd.c b/arch/um/drivers/fd.c
index bc9310c..17b7262 100644
--- a/arch/um/drivers/fd.c
+++ b/arch/um/drivers/fd.c
@@ -26,15 +26,13 @@ static void *fd_init(char *str, int device, const struct chan_opts *opts)
 	int n;
 
 	if (*str != ':') {
-		printk(KERN_ERR "fd_init : channel type 'fd' must specify a "
-		       "file descriptor\n");
+		pr_err("fd_init : channel type 'fd' must specify a file descriptor\n");
 		return NULL;
 	}
 	str++;
 	n = strtoul(str, &end, 0);
 	if ((*end != '\0') || (end == str)) {
-		printk(KERN_ERR "fd_init : couldn't parse file descriptor "
-		       "'%s'\n", str);
+		pr_err("fd_init : couldn't parse file descriptor '%s'\n", str);
 		return NULL;
 	}
 
@@ -76,8 +74,7 @@ static void fd_close(int fd, void *d)
 
 	CATCH_EINTR(err = tcsetattr(fd, TCSAFLUSH, &data->tt));
 	if (err)
-		printk(KERN_ERR "Failed to restore terminal state - "
-		       "errno = %d\n", -err);
+		pr_err("Failed to restore terminal state - errno = %d\n", -err);
 	data->raw = 0;
 }
 
diff --git a/arch/um/drivers/hostaudio_kern.c b/arch/um/drivers/hostaudio_kern.c
index 9b90fdc..9bcb16f 100644
--- a/arch/um/drivers/hostaudio_kern.c
+++ b/arch/um/drivers/hostaudio_kern.c
@@ -268,8 +268,8 @@ static int hostmixer_open_mixdev(struct inode *inode, struct file *file)
 
 	if (ret < 0) {
 		kparam_block_sysfs_write(dsp);
-		printk(KERN_ERR "hostaudio_open_mixdev failed to open '%s', "
-		       "err = %d\n", dsp, -ret);
+		pr_err("hostaudio_open_mixdev failed to open '%s', err = %d\n",
+		       dsp, -ret);
 		kparam_unblock_sysfs_write(dsp);
 		kfree(state);
 		return ret;
@@ -327,20 +327,19 @@ MODULE_LICENSE("GPL");
 static int __init hostaudio_init_module(void)
 {
 	__kernel_param_lock();
-	printk(KERN_INFO "UML Audio Relay (host dsp = %s, host mixer = %s)\n",
-	       dsp, mixer);
+	pr_info("UML Audio Relay (host dsp = %s, host mixer = %s)\n",
+		dsp, mixer);
 	__kernel_param_unlock();
 
 	module_data.dev_audio = register_sound_dsp(&hostaudio_fops, -1);
 	if (module_data.dev_audio < 0) {
-		printk(KERN_ERR "hostaudio: couldn't register DSP device!\n");
+		pr_err("hostaudio: couldn't register DSP device!\n");
 		return -ENODEV;
 	}
 
 	module_data.dev_mixer = register_sound_mixer(&hostmixer_fops, -1);
 	if (module_data.dev_mixer < 0) {
-		printk(KERN_ERR "hostmixer: couldn't register mixer "
-		       "device!\n");
+		pr_err("hostmixer: couldn't register mixer device!\n");
 		unregister_sound_dsp(module_data.dev_audio);
 		return -ENODEV;
 	}
diff --git a/arch/um/drivers/line.c b/arch/um/drivers/line.c
index 8035145..7af1893 100644
--- a/arch/um/drivers/line.c
+++ b/arch/um/drivers/line.c
@@ -89,8 +89,7 @@ static int buffer_data(struct line *line, const char *buf, int len)
 	if (line->buffer == NULL) {
 		line->buffer = kmalloc(LINE_BUFSIZE, GFP_ATOMIC);
 		if (line->buffer == NULL) {
-			printk(KERN_ERR "buffer_data - atomic allocation "
-			       "failed\n");
+			pr_err("buffer_data - atomic allocation failed\n");
 			return 0;
 		}
 		line->head = line->buffer;
@@ -457,8 +456,8 @@ int line_setup(char **conf, unsigned int num, char **def,
 	return 0;
 
 out:
-	printk(KERN_ERR "Failed to set up %s with "
-	       "configuration string \"%s\" : %s\n", name, init, error);
+	pr_err("Failed to set up %s with configuration string \"%s\" : %s\n",
+	       name, init, error);
 	return -EINVAL;
 }
 
@@ -576,7 +575,7 @@ int register_lines(struct line_driver *line_driver,
 
 	err = tty_register_driver(driver);
 	if (err) {
-		printk(KERN_ERR "register_lines : can't register %s driver\n",
+		pr_err("register_lines : can't register %s driver\n",
 		       line_driver->name);
 		put_tty_driver(driver);
 		for (i = 0; i < nlines; i++)
@@ -640,10 +639,10 @@ static irqreturn_t winch_interrupt(int irq, void *data)
 				winch->fd = -1;
 				list_del(&winch->list);
 				os_close_file(fd);
-				printk(KERN_ERR "winch_interrupt : "
-				       "read failed, errno = %d\n", -err);
-				printk(KERN_ERR "fd %d is losing SIGWINCH "
-				       "support\n", winch->tty_fd);
+				pr_err("winch_interrupt : read failed, errno = %d\n",
+				       -err);
+				pr_err("fd %d is losing SIGWINCH support\n",
+				       winch->tty_fd);
 				INIT_WORK(&winch->work, __free_winch);
 				schedule_work(&winch->work);
 				return IRQ_HANDLED;
@@ -674,7 +673,7 @@ void register_winch_irq(int fd, int tty_fd, int pid, struct tty_port *port,
 
 	winch = kmalloc(sizeof(*winch), GFP_KERNEL);
 	if (winch == NULL) {
-		printk(KERN_ERR "register_winch_irq - kmalloc failed\n");
+		pr_err("register_winch_irq - kmalloc failed\n");
 		goto cleanup;
 	}
 
@@ -687,8 +686,7 @@ void register_winch_irq(int fd, int tty_fd, int pid, struct tty_port *port,
 
 	if (um_request_irq(WINCH_IRQ, fd, IRQ_READ, winch_interrupt,
 			   IRQF_SHARED, "winch", winch) < 0) {
-		printk(KERN_ERR "register_winch_irq - failed to register "
-		       "IRQ\n");
+		pr_err("register_winch_irq - failed to register IRQ\n");
 		goto out_free;
 	}
 
@@ -755,7 +753,7 @@ char *add_xterm_umid(char *base)
 	len = strlen(base) + strlen(" ()") + strlen(umid) + 1;
 	title = kmalloc(len, GFP_KERNEL);
 	if (title == NULL) {
-		printk(KERN_ERR "Failed to allocate buffer for xterm title\n");
+		pr_err("Failed to allocate buffer for xterm title\n");
 		return base;
 	}
 
diff --git a/arch/um/drivers/mconsole_kern.c b/arch/um/drivers/mconsole_kern.c
index 29880c9..e232f74 100644
--- a/arch/um/drivers/mconsole_kern.c
+++ b/arch/um/drivers/mconsole_kern.c
@@ -117,7 +117,7 @@ void mconsole_log(struct mc_request *req)
 	ptr += strlen("log ");
 
 	len = req->len - (ptr - req->request.data);
-	printk(KERN_WARNING "%.*s", len, ptr);
+	pr_warn("%.*s", len, ptr);
 	mconsole_reply(req, "", 0, 0);
 }
 
@@ -136,7 +136,7 @@ void mconsole_proc(struct mc_request *req)
 	file = file_open_root(mnt->mnt_root, mnt, ptr, O_RDONLY);
 	if (IS_ERR(file)) {
 		mconsole_reply(req, "Failed to open file", 1, 0);
-		printk(KERN_ERR "open /proc/%s: %ld\n", ptr, PTR_ERR(file));
+		pr_err("open /proc/%s: %ld\n", ptr, PTR_ERR(file));
 		goto out;
 	}
 
@@ -358,8 +358,8 @@ static int mem_config(char *str, char **error_out)
 						       list);
 				err = os_drop_memory(addr, PAGE_SIZE);
 				if (err) {
-					printk(KERN_ERR "Failed to release "
-					       "memory - errno = %d\n", err);
+					pr_err("Failed to release memory - errno = %d\n",
+					       err);
 					*error_out = "Failed to release memory";
 					goto out_unlock;
 				}
@@ -415,8 +415,8 @@ static int __init mem_mc_init(void)
 {
 	if (can_drop_memory())
 		mconsole_register_dev(&mem_mc);
-	else printk(KERN_ERR "Can't release memory to the host - memory "
-		    "hotplug won't be supported\n");
+	else
+		pr_err("Can't release memory to the host - memory hotplug won't be supported\n");
 	return 0;
 }
 
@@ -707,7 +707,7 @@ static int __init mconsole_init(void)
 
 	sock = os_create_unix_socket(file, sizeof(file), 1);
 	if (sock < 0) {
-		printk(KERN_ERR "Failed to initialize management console\n");
+		pr_err("Failed to initialize management console\n");
 		return 1;
 	}
 	if (os_set_fd_block(sock, 0))
@@ -718,7 +718,7 @@ static int __init mconsole_init(void)
 	err = um_request_irq(MCONSOLE_IRQ, sock, IRQ_READ, mconsole_interrupt,
 			     IRQF_SHARED, "mconsole", (void *)sock);
 	if (err) {
-		printk(KERN_ERR "Failed to get IRQ for management console\n");
+		pr_err("Failed to get IRQ for management console\n");
 		goto out;
 	}
 
@@ -728,12 +728,12 @@ static int __init mconsole_init(void)
 			mconsole_notify(notify_socket, MCONSOLE_SOCKET,
 					mconsole_socket_name,
 					strlen(mconsole_socket_name) + 1);
-		else printk(KERN_ERR "mconsole_setup failed to strdup "
-			    "string\n");
+		else
+			pr_err("mconsole_setup failed to strdup string\n");
 	}
 
-	printk(KERN_INFO "mconsole (version %d) initialized on %s\n",
-	       MCONSOLE_VERSION, mconsole_socket_name);
+	pr_info("mconsole (version %d) initialized on %s\n",
+		MCONSOLE_VERSION, mconsole_socket_name);
 	return 0;
 
  out:
@@ -780,7 +780,7 @@ static int create_proc_mconsole(void)
 
 	ent = proc_create("mconsole", 0200, NULL, &mconsole_proc_fops);
 	if (ent == NULL) {
-		printk(KERN_INFO "create_proc_mconsole : proc_create failed\n");
+		pr_info("create_proc_mconsole : proc_create failed\n");
 		return 0;
 	}
 	return 0;
@@ -807,8 +807,9 @@ static int mconsole_setup(char *str)
 	if (!strncmp(str, NOTIFY, strlen(NOTIFY))) {
 		str += strlen(NOTIFY);
 		notify_socket = str;
+	} else {
+		pr_err("mconsole_setup : Unknown option - '%s'\n", str);
 	}
-	else printk(KERN_ERR "mconsole_setup : Unknown option - '%s'\n", str);
 	return 1;
 }
 
diff --git a/arch/um/drivers/mconsole_user.c b/arch/um/drivers/mconsole_user.c
index f77908f..c6adc1e 100644
--- a/arch/um/drivers/mconsole_user.c
+++ b/arch/um/drivers/mconsole_user.c
@@ -187,8 +187,8 @@ int mconsole_notify(char *sock_name, int type, const void *data, int len)
 		notify_sock = socket(PF_UNIX, SOCK_DGRAM, 0);
 		if (notify_sock < 0) {
 			err = -errno;
-			printk(KERN_ERR "mconsole_notify - socket failed, "
-			       "errno = %d\n", errno);
+			pr_err("mconsole_notify - socket failed, errno = %d\n",
+			       errno);
 		}
 	}
 	unlock_notify();
@@ -212,8 +212,7 @@ int mconsole_notify(char *sock_name, int type, const void *data, int len)
 		   sizeof(target));
 	if (n < 0) {
 		err = -errno;
-		printk(KERN_ERR "mconsole_notify - sendto failed, "
-		       "errno = %d\n", errno);
+		pr_err("mconsole_notify - sendto failed, errno = %d\n", errno);
 	}
 	return err;
 }
diff --git a/arch/um/drivers/mmapper_kern.c b/arch/um/drivers/mmapper_kern.c
index 62145c2..4094609 100644
--- a/arch/um/drivers/mmapper_kern.c
+++ b/arch/um/drivers/mmapper_kern.c
@@ -103,19 +103,18 @@ static int __init mmapper_init(void)
 {
 	int err;
 
-	printk(KERN_INFO "Mapper v0.1\n");
+	pr_info("Mapper v0.1\n");
 
 	v_buf = (char *) find_iomem("mmapper", &mmapper_size);
 	if (mmapper_size == 0) {
-		printk(KERN_ERR "mmapper_init - find_iomem failed\n");
+		pr_err("mmapper_init - find_iomem failed\n");
 		return -ENODEV;
 	}
 	p_buf = __pa(v_buf);
 
 	err = misc_register(&mmapper_dev);
 	if (err) {
-		printk(KERN_ERR "mmapper - misc_register failed, err = %d\n",
-		       err);
+		pr_err("mmapper - misc_register failed, err = %d\n", err);
 		return err;
 	}
 	return 0;
diff --git a/arch/um/drivers/net_kern.c b/arch/um/drivers/net_kern.c
index 7d26d9c..025899c 100644
--- a/arch/um/drivers/net_kern.c
+++ b/arch/um/drivers/net_kern.c
@@ -124,8 +124,7 @@ static irqreturn_t uml_net_interrupt(int irq, void *dev_id)
 	spin_lock(&lp->lock);
 	while ((err = uml_net_rx(dev)) > 0) ;
 	if (err < 0) {
-		printk(KERN_ERR
-		       "Device '%s' read returned %d, shutting it down\n",
+		pr_err("Device '%s' read returned %d, shutting it down\n",
 		       dev->name, err);
 		/* dev_close can't be called in interrupt context, and takes
 		 * again lp->lock.
@@ -163,7 +162,7 @@ static int uml_net_open(struct net_device *dev)
 	err = um_request_irq(dev->irq, lp->fd, IRQ_READ, uml_net_interrupt,
 			     IRQF_SHARED, dev->name, dev);
 	if (err != 0) {
-		printk(KERN_ERR "uml_net_open: failed to get irq(%d)\n", err);
+		pr_err("uml_net_open: failed to get irq(%d)\n", err);
 		err = -ENETUNREACH;
 		goto out_close;
 	}
@@ -235,7 +234,7 @@ static int uml_net_start_xmit(struct sk_buff *skb, struct net_device *dev)
 	}
 	else {
 		netif_start_queue(dev);
-		printk(KERN_ERR "uml_net_start_xmit: failed(%d)\n", len);
+		pr_err("uml_net_start_xmit: failed(%d)\n", len);
 	}
 
 	spin_unlock_irqrestore(&lp->lock, flags);
@@ -308,40 +307,30 @@ static void setup_etheraddr(struct net_device *dev, char *str)
 		addr[i] = simple_strtoul(str, &end, 16);
 		if ((end == str) ||
 		   ((*end != ':') && (*end != ',') && (*end != '\0'))) {
-			printk(KERN_ERR
-			       "setup_etheraddr: failed to parse '%s' "
-			       "as an ethernet address\n", str);
+			pr_err("setup_etheraddr: failed to parse '%s' as an ethernet address\n",
+			       str);
 			goto random;
 		}
 		str = end + 1;
 	}
 	if (is_multicast_ether_addr(addr)) {
-		printk(KERN_ERR
-		       "Attempt to assign a multicast ethernet address to a "
-		       "device disallowed\n");
+		pr_err("Attempt to assign a multicast ethernet address to a device disallowed\n");
 		goto random;
 	}
 	if (!is_valid_ether_addr(addr)) {
-		printk(KERN_ERR
-		       "Attempt to assign an invalid ethernet address to a "
-		       "device disallowed\n");
+		pr_err("Attempt to assign an invalid ethernet address to a device disallowed\n");
 		goto random;
 	}
 	if (!is_local_ether_addr(addr)) {
-		printk(KERN_WARNING
-		       "Warning: Assigning a globally valid ethernet "
-		       "address to a device\n");
-		printk(KERN_WARNING "You should set the 2nd rightmost bit in "
-		       "the first byte of the MAC,\n");
-		printk(KERN_WARNING "i.e. %02x:%02x:%02x:%02x:%02x:%02x\n",
-		       addr[0] | 0x02, addr[1], addr[2], addr[3], addr[4],
-		       addr[5]);
+		pr_warn("Warning: Assigning a globally valid ethernet address to a device\n");
+		pr_warn("You should set the 2nd rightmost bit in the first byte of the MAC ie: %pM\n",
+			addr);
 	}
 	return;
 
 random:
-	printk(KERN_INFO
-	       "Choosing a random ethernet address for device %s\n", dev->name);
+	pr_info("Choosing a random ethernet address for device %s\n",
+		dev->name);
 	eth_hw_addr_random(dev);
 }
 
@@ -399,15 +388,14 @@ static void eth_configure(int n, void *init, char *mac,
 
 	device = kzalloc(sizeof(*device), GFP_KERNEL);
 	if (device == NULL) {
-		printk(KERN_ERR "eth_configure failed to allocate struct "
-		       "uml_net\n");
+		pr_err("eth_configure failed to allocate struct uml_net\n");
 		return;
 	}
 
 	dev = alloc_etherdev(size);
 	if (dev == NULL) {
-		printk(KERN_ERR "eth_configure: failed to allocate struct "
-		       "net_device for eth%d\n", n);
+		pr_err("eth_configure: failed to allocate struct net_device for eth%d\n",
+		       n);
 		goto out_free_device;
 	}
 
@@ -422,7 +410,7 @@ static void eth_configure(int n, void *init, char *mac,
 
 	setup_etheraddr(dev, mac);
 
-	printk(KERN_INFO "Netdevice %d (%pM) : ", n, dev->dev_addr);
+	pr_info("Netdevice %d (%pM) : ", n, dev->dev_addr);
 
 	lp = netdev_priv(dev);
 	/* This points to the transport private data. It's still clear, but we
@@ -653,14 +641,13 @@ static int __init eth_setup(char *str)
 
 	err = eth_parse(str, &n, &str, &error);
 	if (err) {
-		printk(KERN_ERR "eth_setup - Couldn't parse '%s' : %s\n",
-		       str, error);
+		pr_err("eth_setup - Couldn't parse '%s' : %s\n", str, error);
 		return 1;
 	}
 
 	new = alloc_bootmem(sizeof(*new));
 	if (new == NULL) {
-		printk(KERN_ERR "eth_init : alloc_bootmem failed\n");
+		pr_err("eth_init : alloc_bootmem failed\n");
 		return 1;
 	}
 
@@ -901,8 +888,8 @@ int tap_setup_common(char *str, char *type, char **dev_name, char **mac_out,
 
 	remain = split_if_spec(str, dev_name, mac_out, gate_addr, NULL);
 	if (remain != NULL) {
-		printk(KERN_ERR "tap_setup_common - Extra garbage on "
-		       "specification : '%s'\n", remain);
+		pr_err("tap_setup_common - Extra garbage on specification : '%s'\n",
+		       remain);
 		return 1;
 	}
 
diff --git a/arch/um/drivers/net_user.c b/arch/um/drivers/net_user.c
index 2c1bc11..71b6484 100644
--- a/arch/um/drivers/net_user.c
+++ b/arch/um/drivers/net_user.c
@@ -23,8 +23,7 @@ int tap_open_common(void *dev, char *gate_addr)
 		return 0;
 	if (sscanf(gate_addr, "%d.%d.%d.%d", &tap_addr[0],
 		  &tap_addr[1], &tap_addr[2], &tap_addr[3]) != 4) {
-		printk(KERN_ERR "Invalid tap IP address - '%s'\n",
-		       gate_addr);
+		pr_err("Invalid tap IP address - '%s'\n", gate_addr);
 		return -EINVAL;
 	}
 	return 0;
@@ -41,8 +40,7 @@ void tap_check_ips(char *gate_addr, unsigned char *eth_addr)
 	    (eth_addr[1] == tap_addr[1]) &&
 	    (eth_addr[2] == tap_addr[2]) &&
 	    (eth_addr[3] == tap_addr[3])) {
-		printk(KERN_ERR "The tap IP address and the UML eth IP "
-		       "address must be different\n");
+		pr_err("The tap IP address and the UML eth IP address must be different\n");
 	}
 }
 
@@ -85,11 +83,11 @@ void read_output(int fd, char *output, int len)
 
 err:
 	if (ret < 0)
-		printk(KERN_ERR "read_output - read of %s failed, "
-		       "errno = %d\n", str, -ret);
+		pr_err("read_output - read of %s failed, errno = %d\n",
+		       str, -ret);
 	else
-		printk(KERN_ERR "read_output - read of %s failed, read only "
-		       "%d of %d bytes\n", str, ret, expected);
+		pr_err("read_output - read of %s failed, read only %d of %d bytes\n",
+		       str, ret, expected);
 }
 
 int net_read(int fd, void *buf, int len)
@@ -184,8 +182,7 @@ static int change_tramp(char **argv, char *output, int output_len)
 
 	err = os_pipe(fds, 1, 0);
 	if (err < 0) {
-		printk(KERN_ERR "change_tramp - pipe failed, err = %d\n",
-		       -err);
+		pr_err("change_tramp - pipe failed, err = %d\n", -err);
 		return err;
 	}
 	pe_data.close_me = fds[0];
@@ -222,8 +219,7 @@ static void change(char *dev, char *what, unsigned char *addr,
 	output_len = UM_KERN_PAGE_SIZE;
 	output = uml_kmalloc(output_len, UM_GFP_KERNEL);
 	if (output == NULL)
-		printk(KERN_ERR "change : failed to allocate output "
-		       "buffer\n");
+		pr_err("change : failed to allocate output buffer\n");
 
 	pid = change_tramp(argv, output, output_len);
 	if (pid < 0) {
diff --git a/arch/um/drivers/pcap_kern.c b/arch/um/drivers/pcap_kern.c
index be0fb57..ccab947 100644
--- a/arch/um/drivers/pcap_kern.c
+++ b/arch/um/drivers/pcap_kern.c
@@ -65,8 +65,8 @@ int pcap_setup(char *str, char **mac_out, void *data)
 	remain = split_if_spec(str, &host_if, &init->filter,
 			       &options[0], &options[1], mac_out, NULL);
 	if (remain != NULL) {
-		printk(KERN_ERR "pcap_setup - Extra garbage on "
-		       "specification : '%s'\n", remain);
+		pr_err("pcap_setup - Extra garbage on specification : '%s'\n",
+		       remain);
 		return 0;
 	}
 
@@ -85,8 +85,7 @@ int pcap_setup(char *str, char **mac_out, void *data)
 		else if (!strcmp(options[i], "nooptimize"))
 			init->optimize = 0;
 		else {
-			printk(KERN_ERR "pcap_setup : bad option - '%s'\n",
-			       options[i]);
+			pr_err("pcap_setup : bad option - '%s'\n", options[i]);
 			return 0;
 		}
 	}
diff --git a/arch/um/drivers/pcap_user.c b/arch/um/drivers/pcap_user.c
index c3431a4..64987c5 100644
--- a/arch/um/drivers/pcap_user.c
+++ b/arch/um/drivers/pcap_user.c
@@ -22,8 +22,8 @@ static int pcap_user_init(void *data, void *dev)
 	p = pcap_open_live(pri->host_if, ETH_MAX_PACKET + ETH_HEADER_OTHER,
 			   pri->promisc, 0, errors);
 	if (p == NULL) {
-		printk(KERN_ERR "pcap_user_init : pcap_open_live failed - "
-		       "'%s'\n", errors);
+		pr_err("pcap_user_init : pcap_open_live failed - '%s'\n",
+		       errors);
 		return -EINVAL;
 	}
 
@@ -44,14 +44,14 @@ static int pcap_open(void *data)
 	if (pri->filter != NULL) {
 		err = dev_netmask(pri->dev, &netmask);
 		if (err < 0) {
-			printk(KERN_ERR "pcap_open : dev_netmask failed\n");
+			pr_err("pcap_open : dev_netmask failed\n");
 			return -EIO;
 		}
 
 		pri->compiled = uml_kmalloc(sizeof(struct bpf_program),
 					UM_GFP_KERNEL);
 		if (pri->compiled == NULL) {
-			printk(KERN_ERR "pcap_open : kmalloc failed\n");
+			pr_err("pcap_open : kmalloc failed\n");
 			return -ENOMEM;
 		}
 
@@ -59,15 +59,15 @@ static int pcap_open(void *data)
 				   (struct bpf_program *) pri->compiled,
 				   pri->filter, pri->optimize, netmask);
 		if (err < 0) {
-			printk(KERN_ERR "pcap_open : pcap_compile failed - "
-			       "'%s'\n", pcap_geterr(pri->pcap));
+			pr_err("pcap_open : pcap_compile failed - '%s'\n",
+			       pcap_geterr(pri->pcap));
 			goto out;
 		}
 
 		err = pcap_setfilter(pri->pcap, pri->compiled);
 		if (err < 0) {
-			printk(KERN_ERR "pcap_open : pcap_setfilter "
-			       "failed - '%s'\n", pcap_geterr(pri->pcap));
+			pr_err("pcap_open : pcap_setfilter failed - '%s'\n",
+			       pcap_geterr(pri->pcap));
 			goto out;
 		}
 	}
@@ -116,8 +116,7 @@ int pcap_user_read(int fd, void *buffer, int len, struct pcap_data *pri)
 
 	n = pcap_dispatch(pri->pcap, 1, handler, (u_char *) &hdata);
 	if (n < 0) {
-		printk(KERN_ERR "pcap_dispatch failed - %s\n",
-		       pcap_geterr(pri->pcap));
+		pr_err("pcap_dispatch failed - %s\n", pcap_geterr(pri->pcap));
 		return -EIO;
 	}
 	else if (n == 0)
diff --git a/arch/um/drivers/port_kern.c b/arch/um/drivers/port_kern.c
index 40ca5cc..27942cd 100644
--- a/arch/um/drivers/port_kern.c
+++ b/arch/um/drivers/port_kern.c
@@ -52,8 +52,7 @@ static irqreturn_t pipe_interrupt(int irq, void *data)
 		if (fd == -EAGAIN)
 			return IRQ_NONE;
 
-		printk(KERN_ERR "pipe_interrupt : os_rcv_fd returned %d\n",
-		       -fd);
+		pr_err("pipe_interrupt : os_rcv_fd returned %d\n", -fd);
 		os_close_file(conn->fd);
 	}
 
@@ -81,15 +80,14 @@ static int port_accept(struct port_list *port)
 	fd = port_connection(port->fd, socket, &pid);
 	if (fd < 0) {
 		if (fd != -EAGAIN)
-			printk(KERN_ERR "port_accept : port_connection "
-			       "returned %d\n", -fd);
+			pr_err("port_accept : port_connection returned %d\n",
+			       -fd);
 		goto out;
 	}
 
 	conn = kmalloc(sizeof(*conn), GFP_ATOMIC);
 	if (conn == NULL) {
-		printk(KERN_ERR "port_accept : failed to allocate "
-		       "connection\n");
+		pr_err("port_accept : failed to allocate connection\n");
 		goto out_close;
 	}
 	*conn = ((struct connection)
@@ -101,14 +99,13 @@ static int port_accept(struct port_list *port)
 
 	if (um_request_irq(TELNETD_IRQ, socket[0], IRQ_READ, pipe_interrupt,
 			  IRQF_SHARED, "telnetd", conn)) {
-		printk(KERN_ERR "port_accept : failed to get IRQ for "
-		       "telnetd\n");
+		pr_err("port_accept : failed to get IRQ for telnetd\n");
 		goto out_free;
 	}
 
 	if (atomic_read(&port->wait_count) == 0) {
 		os_write_file(fd, NO_WAITER_MSG, sizeof(NO_WAITER_MSG));
-		printk(KERN_ERR "No one waiting for port\n");
+		pr_err("No one waiting for port\n");
 	}
 	list_add(&conn->list, &port->pending);
 	return 1;
@@ -171,20 +168,20 @@ void *port_data(int port_num)
 	}
 	port = kmalloc(sizeof(struct port_list), GFP_KERNEL);
 	if (port == NULL) {
-		printk(KERN_ERR "Allocation of port list failed\n");
+		pr_err("Allocation of port list failed\n");
 		goto out;
 	}
 
 	fd = port_listen_fd(port_num);
 	if (fd < 0) {
-		printk(KERN_ERR "binding to port %d failed, errno = %d\n",
+		pr_err("binding to port %d failed, errno = %d\n",
 		       port_num, -fd);
 		goto out_free;
 	}
 
 	if (um_request_irq(ACCEPT_IRQ, fd, IRQ_READ, port_interrupt,
 			  IRQF_SHARED, "port", port)) {
-		printk(KERN_ERR "Failed to get IRQ for port %d\n", port_num);
+		pr_err("Failed to get IRQ for port %d\n", port_num);
 		goto out_close;
 	}
 
@@ -203,7 +200,7 @@ void *port_data(int port_num)
  found:
 	dev = kmalloc(sizeof(struct port_dev), GFP_KERNEL);
 	if (dev == NULL) {
-		printk(KERN_ERR "Allocation of port device entry failed\n");
+		pr_err("Allocation of port device entry failed\n");
 		goto out;
 	}
 
diff --git a/arch/um/drivers/port_user.c b/arch/um/drivers/port_user.c
index a8dfe5c..7bf06d3 100644
--- a/arch/um/drivers/port_user.c
+++ b/arch/um/drivers/port_user.c
@@ -29,15 +29,13 @@ static void *port_init(char *str, int device, const struct chan_opts *opts)
 	int port;
 
 	if (*str != ':') {
-		printk(KERN_ERR "port_init : channel type 'port' must "
-		       "specify a port number\n");
+		pr_err("port_init : channel type 'port' must specify a port number\n");
 		return NULL;
 	}
 	str++;
 	port = strtoul(str, &end, 0);
 	if ((*end != '\0') || (end == str)) {
-		printk(KERN_ERR "port_init : couldn't parse port '%s'\n",
-		       str);
+		pr_err("port_init : couldn't parse port '%s'\n", str);
 		return NULL;
 	}
 
diff --git a/arch/um/drivers/pty.c b/arch/um/drivers/pty.c
index f43ba32..e8dfba4 100644
--- a/arch/um/drivers/pty.c
+++ b/arch/um/drivers/pty.c
@@ -47,7 +47,7 @@ static int pts_open(int input, int output, int primary, void *d,
 	fd = get_pty();
 	if (fd < 0) {
 		err = -errno;
-		printk(KERN_ERR "open_pts : Failed to open pts\n");
+		pr_err("open_pts : Failed to open pts\n");
 		return err;
 	}
 
@@ -106,7 +106,7 @@ static int getmaster(char *line)
 		}
 	}
 
-	printk(KERN_ERR "getmaster - no usable host pty devices\n");
+	pr_err("getmaster - no usable host pty devices\n");
 	return -ENOENT;
 }
 
diff --git a/arch/um/drivers/slip_user.c b/arch/um/drivers/slip_user.c
index ffced38..0dddf2b 100644
--- a/arch/um/drivers/slip_user.c
+++ b/arch/um/drivers/slip_user.c
@@ -30,8 +30,7 @@ static int set_up_tty(int fd)
 	struct termios tios;
 
 	if (tcgetattr(fd, &tios) < 0) {
-		printk(KERN_ERR "could not get initial terminal "
-		       "attributes\n");
+		pr_err("could not get initial terminal attributes\n");
 		return -1;
 	}
 
@@ -48,7 +47,7 @@ static int set_up_tty(int fd)
 	cfsetispeed(&tios, B38400);
 
 	if (tcsetattr(fd, TCSAFLUSH, &tios) < 0) {
-		printk(KERN_ERR "failed to set terminal attributes\n");
+		pr_err("failed to set terminal attributes\n");
 		return -1;
 	}
 	return 0;
@@ -79,8 +78,7 @@ static int slip_tramp(char **argv, int fd)
 
 	err = os_pipe(fds, 1, 0);
 	if (err < 0) {
-		printk(KERN_ERR "slip_tramp : pipe failed, err = %d\n",
-		       -err);
+		pr_err("slip_tramp : pipe failed, err = %d\n", -err);
 		goto out;
 	}
 
@@ -96,8 +94,7 @@ static int slip_tramp(char **argv, int fd)
 	output_len = UM_KERN_PAGE_SIZE;
 	output = uml_kmalloc(output_len, UM_GFP_KERNEL);
 	if (output == NULL) {
-		printk(KERN_ERR "slip_tramp : failed to allocate output "
-		       "buffer\n");
+		pr_err("slip_tramp : failed to allocate output buffer\n");
 		os_kill_process(pid, 1);
 		err = -ENOMEM;
 		goto out_close;
@@ -131,16 +128,14 @@ static int slip_open(void *data)
 
 	err = get_pty();
 	if (err < 0) {
-		printk(KERN_ERR "slip-open : Failed to open pty, err = %d\n",
-		       -err);
+		pr_err("slip-open : Failed to open pty, err = %d\n", -err);
 		goto out;
 	}
 	mfd = err;
 
 	err = open(ptsname(mfd), O_RDWR, 0);
 	if (err < 0) {
-		printk(KERN_ERR "Couldn't open tty for slip line, "
-		       "err = %d\n", -err);
+		pr_err("Couldn't open tty for slip line, err = %d\n", -err);
 		goto out_close;
 	}
 	sfd = err;
@@ -158,14 +153,12 @@ static int slip_open(void *data)
 		err = slip_tramp(argv, sfd);
 
 		if (err < 0) {
-			printk(KERN_ERR "slip_tramp failed - err = %d\n",
-			       -err);
+			pr_err("slip_tramp failed - err = %d\n", -err);
 			goto out_close2;
 		}
 		err = os_get_ifname(pri->slave, pri->name);
 		if (err < 0) {
-			printk(KERN_ERR "get_ifname failed, err = %d\n",
-			       -err);
+			pr_err("get_ifname failed, err = %d\n", -err);
 			goto out_close2;
 		}
 		iter_addresses(pri->dev, open_addr, pri->name);
@@ -173,8 +166,8 @@ static int slip_open(void *data)
 	else {
 		err = os_set_slip(sfd);
 		if (err < 0) {
-			printk(KERN_ERR "Failed to set slip discipline "
-			       "encapsulation - err = %d\n", -err);
+			pr_err("Failed to set slip discipline encapsulation - err = %d\n",
+			       -err);
 			goto out_close2;
 		}
 	}
@@ -203,7 +196,7 @@ static void slip_close(int fd, void *data)
 	err = slip_tramp(argv, pri->slave);
 
 	if (err != 0)
-		printk(KERN_ERR "slip_tramp failed - errno = %d\n", -err);
+		pr_err("slip_tramp failed - errno = %d\n", -err);
 	close(fd);
 	close(pri->slave);
 	pri->slave = -1;
diff --git a/arch/um/drivers/slirp_kern.c b/arch/um/drivers/slirp_kern.c
index 4ef11ca..858caa7 100644
--- a/arch/um/drivers/slirp_kern.c
+++ b/arch/um/drivers/slirp_kern.c
@@ -82,8 +82,7 @@ static int slirp_setup(char *str, char **mac_out, void *data)
 
 	do {
 		if (i >= SLIRP_MAX_ARGS - 1) {
-			printk(KERN_WARNING "slirp_setup: truncating slirp "
-			       "arguments\n");
+			pr_warn("slirp_setup: truncating slirp arguments\n");
 			break;
 		}
 		init->argw.argv[i++] = str;
diff --git a/arch/um/drivers/slirp_user.c b/arch/um/drivers/slirp_user.c
index 4a049c3..2eacfdd 100644
--- a/arch/um/drivers/slirp_user.c
+++ b/arch/um/drivers/slirp_user.c
@@ -57,7 +57,7 @@ static int slirp_open(void *data)
 
 	err = slirp_tramp(pri->argw.argv, fds[1]);
 	if (err < 0) {
-		printk(KERN_ERR "slirp_tramp failed - errno = %d\n", -err);
+		pr_err("slirp_tramp failed - errno = %d\n", -err);
 		goto out;
 	}
 	pid = err;
@@ -85,15 +85,14 @@ static void slirp_close(int fd, void *data)
 	pri->slave = -1;
 
 	if (pri->pid<1) {
-		printk(KERN_ERR "slirp_close: no child process to shut "
-		       "down\n");
+		pr_err("slirp_close: no child process to shut down\n");
 		return;
 	}
 
 #if 0
 	if (kill(pri->pid, SIGHUP)<0) {
-		printk(KERN_ERR "slirp_close: sending hangup to %d failed "
-		       "(%d)\n", pri->pid, errno);
+		pr_err("slirp_close: sending hangup to %d failed (%d)\n",
+		       pri->pid, errno);
 	}
 #endif
 	err = helper_wait(pri->pid);
diff --git a/arch/um/drivers/ssl.c b/arch/um/drivers/ssl.c
index b8d14fa..e19eb09 100644
--- a/arch/um/drivers/ssl.c
+++ b/arch/um/drivers/ssl.c
@@ -24,8 +24,7 @@ static const int ssl_version = 1;
 
 static void ssl_announce(char *dev_name, int dev)
 {
-	printk(KERN_INFO "Serial line %d assigned device '%s'\n", dev,
-	       dev_name);
+	pr_info("Serial line %d assigned device '%s'\n", dev, dev_name);
 }
 
 /* Almost const, except that xterm_title may be changed in an initcall */
@@ -153,8 +152,7 @@ static int ssl_init(void)
 	int err;
 	int i;
 
-	printk(KERN_INFO "Initializing software serial port version %d\n",
-	       ssl_version);
+	pr_info("Initializing software serial port version %d\n", ssl_version);
 
 	err = register_lines(&driver, &ssl_ops, serial_lines,
 				    ARRAY_SIZE(serial_lines));
@@ -171,8 +169,8 @@ static int ssl_init(void)
 		if (!s)
 			s = def_conf;
 		if (setup_one_line(serial_lines, i, s, &opts, &error))
-			printk(KERN_ERR "setup_one_line failed for "
-			       "device %d : %s\n", i, error);
+			pr_err("setup_one_line failed for device %d : %s\n",
+			       i, error);
 	}
 
 	ssl_init_done = 1;
diff --git a/arch/um/drivers/stdio_console.c b/arch/um/drivers/stdio_console.c
index 7b361f3..777f8dc 100644
--- a/arch/um/drivers/stdio_console.c
+++ b/arch/um/drivers/stdio_console.c
@@ -29,8 +29,7 @@
 
 static void stdio_announce(char *dev_name, int dev)
 {
-	printk(KERN_INFO "Virtual console %d assigned device '%s'\n", dev,
-	       dev_name);
+	pr_info("Virtual console %d assigned device '%s'\n", dev, dev_name);
 }
 
 /* Almost const, except that xterm_title may be changed in an initcall */
@@ -158,7 +157,7 @@ static int stdio_init(void)
 	if (err)
 		return err;
 
-	printk(KERN_INFO "Initialized stdio console driver\n");
+	pr_info("Initialized stdio console driver\n");
 
 	new_title = add_xterm_umid(opts.xterm_title);
 	if(new_title != NULL)
@@ -172,8 +171,8 @@ static int stdio_init(void)
 		if (!s)
 			s = i ? CONFIG_CON_CHAN : CONFIG_CON_ZERO_CHAN;
 		if (setup_one_line(vts, i, s, &opts, &error))
-			printk(KERN_ERR "setup_one_line failed for "
-			       "device %d : %s\n", i, error);
+			pr_err("setup_one_line failed for device %d : %s\n",
+			       i, error);
 	}
 
 	con_init_done = 1;
diff --git a/arch/um/drivers/tty.c b/arch/um/drivers/tty.c
index ef1f138..7088ba6 100644
--- a/arch/um/drivers/tty.c
+++ b/arch/um/drivers/tty.c
@@ -21,8 +21,7 @@ static void *tty_chan_init(char *str, int device, const struct chan_opts *opts)
 	struct tty_chan *data;
 
 	if (*str != ':') {
-		printk(KERN_ERR "tty_init : channel type 'tty' must specify "
-		       "a device\n");
+		pr_err("tty_init : channel type 'tty' must specify a device\n");
 		return NULL;
 	}
 	str++;
diff --git a/arch/um/drivers/ubd_kern.c b/arch/um/drivers/ubd_kern.c
index 3716e69..265cad0 100644
--- a/arch/um/drivers/ubd_kern.c
+++ b/arch/um/drivers/ubd_kern.c
@@ -295,8 +295,7 @@ static int ubd_setup_common(char *str, int *index_out, char **error_out)
 
 		fake_major = major;
 
-		printk(KERN_INFO "Setting extra ubd major number to %d\n",
-		       major);
+		pr_info("Setting extra ubd major number to %d\n", major);
 		err = 0;
 	out1:
 		mutex_unlock(&ubd_lock);
@@ -389,8 +388,8 @@ static int ubd_setup(char *str)
 
 	err = ubd_setup_common(str, NULL, &error);
 	if(err)
-		printk(KERN_ERR "Failed to initialize device with \"%s\" : "
-		       "%s\n", str, error);
+		pr_err("Failed to initialize device with \"%s\" : %s\n",
+		       str, error);
 	return 1;
 }
 
@@ -422,8 +421,8 @@ __uml_help(ubd_setup,
 
 static int udb_setup(char *str)
 {
-	printk("udb%s specified on command line is almost certainly a ubd -> "
-	       "udb TYPO\n", str);
+	printk("udb%s specified on command line is almost certainly a ubd -> udb TYPO\n",
+	       str);
 	return 1;
 }
 
@@ -458,8 +457,8 @@ static void ubd_handler(void)
 		if(n != sizeof(req)){
 			if(n == -EAGAIN)
 				break;
-			printk(KERN_ERR "spurious interrupt in ubd_handler, "
-			       "err = %d\n", -n);
+			pr_err("spurious interrupt in ubd_handler, err = %d\n",
+			       -n);
 			return;
 		}
 
@@ -554,28 +553,28 @@ static int backing_file_mismatch(char *file, __u64 size, time_t mtime)
 
 	err = os_file_modtime(file, &modtime);
 	if (err < 0) {
-		printk(KERN_ERR "Failed to get modification time of backing "
-		       "file \"%s\", err = %d\n", file, -err);
+		pr_err("Failed to get modification time of backing file \"%s\", err = %d\n",
+		       file, -err);
 		return err;
 	}
 
 	err = os_file_size(file, &actual);
 	if (err < 0) {
-		printk(KERN_ERR "Failed to get size of backing file \"%s\", "
-		       "err = %d\n", file, -err);
+		pr_err("Failed to get size of backing file \"%s\", err = %d\n",
+		       file, -err);
 		return err;
 	}
 
 	if (actual != size) {
 		/*__u64 can be a long on AMD64 and with %lu GCC complains; so
 		 * the typecast.*/
-		printk(KERN_ERR "Size mismatch (%llu vs %llu) of COW header "
-		       "vs backing file\n", (unsigned long long) size, actual);
+		pr_err("Size mismatch (%llu vs %llu) of COW header vs backing file\n",
+		       (unsigned long long) size, actual);
 		return -EINVAL;
 	}
 	if (modtime != mtime) {
-		printk(KERN_ERR "mtime mismatch (%ld vs %ld) of COW header vs "
-		       "backing file\n", mtime, modtime);
+		pr_err("mtime mismatch (%ld vs %ld) of COW header vs backing file\n",
+		       mtime, modtime);
 		return -EINVAL;
 	}
 	return 0;
@@ -593,21 +592,18 @@ static int path_requires_switch(char *from_cmdline, char *from_cow, char *cow)
 
 	err = os_stat_file(from_cmdline, &buf1);
 	if (err < 0) {
-		printk(KERN_ERR "Couldn't stat '%s', err = %d\n", from_cmdline,
-		       -err);
+		pr_err("Couldn't stat '%s', err = %d\n", from_cmdline, -err);
 		return 0;
 	}
 	err = os_stat_file(from_cow, &buf2);
 	if (err < 0) {
-		printk(KERN_ERR "Couldn't stat '%s', err = %d\n", from_cow,
-		       -err);
+		pr_err("Couldn't stat '%s', err = %d\n", from_cow, -err);
 		return 1;
 	}
 	if ((buf1.ust_dev == buf2.ust_dev) && (buf1.ust_ino == buf2.ust_ino))
 		return 0;
 
-	printk(KERN_ERR "Backing file mismatch - \"%s\" requested, "
-	       "\"%s\" specified in COW header of \"%s\"\n",
+	pr_err("Backing file mismatch - \"%s\" requested, \"%s\" specified in COW header of \"%s\"\n",
 	       from_cmdline, from_cow, cow);
 	return 1;
 }
@@ -637,12 +633,11 @@ static int open_ubd_file(char *file, struct openflags *openflags, int shared,
 	}
 
 	if (shared)
-		printk(KERN_INFO "Not locking \"%s\" on the host\n", file);
+		pr_info("Not locking \"%s\" on the host\n", file);
 	else {
 		err = os_lock_file(fd, openflags->w);
 		if (err < 0) {
-			printk(KERN_ERR "Failed to lock '%s', err = %d\n",
-			       file, -err);
+			pr_err("Failed to lock '%s', err = %d\n", file, -err);
 			goto out_close;
 		}
 	}
@@ -654,8 +649,8 @@ static int open_ubd_file(char *file, struct openflags *openflags, int shared,
 	err = read_cow_header(file_reader, &fd, &version, &backing_file, &mtime,
 			      &size, &sectorsize, &align, bitmap_offset_out);
 	if (err && (*backing_file_out != NULL)) {
-		printk(KERN_ERR "Failed to read COW header from COW file "
-		       "\"%s\", errno = %d\n", file, -err);
+		pr_err("Failed to read COW header from COW file \"%s\", errno = %d\n",
+		       file, -err);
 		goto out_close;
 	}
 	if (err)
@@ -667,12 +662,11 @@ static int open_ubd_file(char *file, struct openflags *openflags, int shared,
 	/* Allow switching only if no mismatch. */
 	if (asked_switch && !backing_file_mismatch(*backing_file_out, size,
 						   mtime)) {
-		printk(KERN_ERR "Switching backing file to '%s'\n",
-		       *backing_file_out);
+		pr_err("Switching backing file to '%s'\n", *backing_file_out);
 		err = write_cow_header(file, fd, *backing_file_out,
 				       sectorsize, align, &size);
 		if (err) {
-			printk(KERN_ERR "Switch failed, errno = %d\n", -err);
+			pr_err("Switch failed, errno = %d\n", -err);
 			goto out_close;
 		}
 	} else {
@@ -702,7 +696,7 @@ static int create_cow_file(char *cow_file, char *backing_file,
 	fd = open_ubd_file(cow_file, &flags, 0, NULL, NULL, NULL, NULL, NULL);
 	if (fd < 0) {
 		err = fd;
-		printk(KERN_ERR "Open of COW file '%s' failed, errno = %d\n",
+		pr_err("Open of COW file '%s' failed, errno = %d\n",
 		       cow_file, -err);
 		goto out;
 	}
@@ -752,8 +746,8 @@ static int ubd_open_dev(struct ubd *ubd_dev)
 					  &ubd_dev->cow.bitmap_len,
 					  &ubd_dev->cow.data_offset);
 		if(fd >= 0){
-			printk(KERN_INFO "Creating \"%s\" as COW file for "
-			       "\"%s\"\n", ubd_dev->file, ubd_dev->cow.file);
+			pr_info("Creating \"%s\" as COW file for \"%s\"\n",
+				ubd_dev->file, ubd_dev->cow.file);
 		}
 	}
 
@@ -770,7 +764,7 @@ static int ubd_open_dev(struct ubd *ubd_dev)
 		err = -ENOMEM;
 		ubd_dev->cow.bitmap = vmalloc(ubd_dev->cow.bitmap_len);
 		if(ubd_dev->cow.bitmap == NULL){
-			printk(KERN_ERR "Failed to vmalloc COW bitmap\n");
+			pr_err("Failed to vmalloc COW bitmap\n");
 			goto error;
 		}
 		flush_tlb_kernel_vm();
@@ -1072,8 +1066,8 @@ static int __init ubd_init(void)
 	for (i = 0; i < MAX_DEV; i++){
 		err = ubd_add(i, &error);
 		if(err)
-			printk(KERN_ERR "Failed to initialize ubd device %d :"
-			       "%s\n", i, error);
+			pr_err("Failed to initialize ubd device %d :%s\n",
+			       i, error);
 	}
 	mutex_unlock(&ubd_lock);
 	return 0;
@@ -1087,7 +1081,7 @@ static int __init ubd_driver_init(void){
 
 	/* Set by CONFIG_BLK_DEV_UBD_SYNC or ubd=sync.*/
 	if(global_openflags.s){
-		printk(KERN_INFO "ubd: Synchronous mode\n");
+		pr_info("ubd: Synchronous mode\n");
 		/* Letting ubd=sync be like using ubd#s= instead of ubd#= is
 		 * enough. So use anyway the io thread. */
 	}
@@ -1095,16 +1089,15 @@ static int __init ubd_driver_init(void){
 	io_pid = start_io_thread(stack + PAGE_SIZE - sizeof(void *),
 				 &thread_fd);
 	if(io_pid < 0){
-		printk(KERN_ERR
-		       "ubd : Failed to start I/O thread (errno = %d) - "
-		       "falling back to synchronous I/O\n", -io_pid);
+		pr_err("ubd : Failed to start I/O thread (errno = %d) - falling back to synchronous I/O\n",
+		       -io_pid);
 		io_pid = -1;
 		return 0;
 	}
 	err = um_request_irq(UBD_IRQ, thread_fd, IRQ_READ, ubd_intr,
 			     0, "ubd", ubd_devs);
 	if(err != 0)
-		printk(KERN_ERR "um_request_irq failed - errno = %d\n", -err);
+		pr_err("um_request_irq failed - errno = %d\n", -err);
 	return 0;
 }
 
@@ -1120,7 +1113,7 @@ static int ubd_open(struct block_device *bdev, fmode_t mode)
 	if(ubd_dev->count == 0){
 		err = ubd_open_dev(ubd_dev);
 		if(err){
-			printk(KERN_ERR "%s: Can't open \"%s\": errno = %d\n",
+			pr_err("%s: Can't open \"%s\": errno = %d\n",
 			       disk->disk_name, ubd_dev->file, -err);
 			goto out;
 		}
@@ -1258,8 +1251,7 @@ static bool submit_request(struct io_thread_req *io_req, struct ubd *dev)
 			     sizeof(io_req));
 	if (n != sizeof(io_req)) {
 		if (n != -EAGAIN)
-			printk("write to io thread failed, "
-			       "errno = %d\n", -n);
+			printk("write to io thread failed, errno = %d\n", -n);
 		else if (list_empty(&dev->restart))
 			list_add(&dev->restart, &restart);
 
@@ -1405,8 +1397,8 @@ static void do_io(struct io_thread_req *req)
 		/* fds[0] is always either the rw image or our cow file */
 		n = os_sync_file(req->fds[0]);
 		if (n != 0) {
-			printk("do_io - sync failed err = %d "
-			       "fd = %d\n", -n, req->fds[0]);
+			printk("do_io - sync failed err = %d fd = %d\n",
+			       -n, req->fds[0]);
 			req->error = 1;
 		}
 		return;
@@ -1440,8 +1432,8 @@ static void do_io(struct io_thread_req *req)
 				len -= n;
 				n = os_read_file(req->fds[bit], buf, len);
 				if (n < 0) {
-					printk("do_io - read failed, err = %d "
-					       "fd = %d\n", -n, req->fds[bit]);
+					printk("do_io - read failed, err = %d fd = %d\n",
+					       -n, req->fds[bit]);
 					req->error = 1;
 					return;
 				}
@@ -1450,8 +1442,8 @@ static void do_io(struct io_thread_req *req)
 		} else {
 			n = os_write_file(req->fds[bit], buf, len);
 			if(n != len){
-				printk("do_io - write failed err = %d "
-				       "fd = %d\n", -n, req->fds[bit]);
+				printk("do_io - write failed err = %d fd = %d\n",
+				       -n, req->fds[bit]);
 				req->error = 1;
 				return;
 			}
@@ -1483,11 +1475,11 @@ int io_thread(void *arg)
 				 sizeof(struct io_thread_req *));
 		if(n != sizeof(struct io_thread_req *)){
 			if(n < 0)
-				printk("io_thread - read failed, fd = %d, "
-				       "err = %d\n", kernel_fd, -n);
+				printk("io_thread - read failed, fd = %d, err = %d\n",
+				       kernel_fd, -n);
 			else {
-				printk("io_thread - short read, fd = %d, "
-				       "length = %d\n", kernel_fd, n);
+				printk("io_thread - short read, fd = %d, length = %d\n",
+				       kernel_fd, n);
 			}
 			continue;
 		}
diff --git a/arch/um/drivers/umcast_kern.c b/arch/um/drivers/umcast_kern.c
index f5ba6e3..35855f2 100644
--- a/arch/um/drivers/umcast_kern.c
+++ b/arch/um/drivers/umcast_kern.c
@@ -40,11 +40,11 @@ static void umcast_init(struct net_device *dev, void *data)
 	dpri->dev = dev;
 
 	if (dpri->unicast) {
-		printk(KERN_INFO "ucast backend address: %s:%u listen port: "
-		       "%u\n", dpri->addr, dpri->rport, dpri->lport);
+		pr_info("ucast backend address: %s:%u listen port: %u\n",
+			dpri->addr, dpri->rport, dpri->lport);
 	} else {
-		printk(KERN_INFO "mcast backend multicast address: %s:%u, "
-		       "TTL:%u\n", dpri->addr, dpri->lport, dpri->ttl);
+		pr_info("mcast backend multicast address: %s:%u, TTL:%u\n",
+			dpri->addr, dpri->lport, dpri->ttl);
 	}
 }
 
@@ -81,16 +81,15 @@ static int mcast_setup(char *str, char **mac_out, void *data)
 	remain = split_if_spec(str, mac_out, &init->addr, &port_str, &ttl_str,
 			       NULL);
 	if (remain != NULL) {
-		printk(KERN_ERR "mcast_setup - Extra garbage on "
-		       "specification : '%s'\n", remain);
+		pr_err("mcast_setup - Extra garbage on specification : '%s'\n",
+		       remain);
 		return 0;
 	}
 
 	if (port_str != NULL) {
 		init->lport = simple_strtoul(port_str, &last, 10);
 		if ((*last != '\0') || (last == port_str)) {
-			printk(KERN_ERR "mcast_setup - Bad port : '%s'\n",
-			       port_str);
+			pr_err("mcast_setup - Bad port : '%s'\n", port_str);
 			return 0;
 		}
 	}
@@ -98,8 +97,7 @@ static int mcast_setup(char *str, char **mac_out, void *data)
 	if (ttl_str != NULL) {
 		init->ttl = simple_strtoul(ttl_str, &last, 10);
 		if ((*last != '\0') || (last == ttl_str)) {
-			printk(KERN_ERR "mcast_setup - Bad ttl : '%s'\n",
-			       ttl_str);
+			pr_err("mcast_setup - Bad ttl : '%s'\n", ttl_str);
 			return 0;
 		}
 	}
@@ -107,8 +105,8 @@ static int mcast_setup(char *str, char **mac_out, void *data)
 	init->unicast = false;
 	init->rport = init->lport;
 
-	printk(KERN_INFO "Configured mcast device: %s:%u-%u\n", init->addr,
-	       init->lport, init->ttl);
+	pr_info("Configured mcast device: %s:%u-%u\n",
+		init->addr, init->lport, init->ttl);
 
 	return 1;
 }
@@ -127,16 +125,16 @@ static int ucast_setup(char *str, char **mac_out, void *data)
 	remain = split_if_spec(str, mac_out, &init->addr,
 			       &lport_str, &rport_str, NULL);
 	if (remain != NULL) {
-		printk(KERN_ERR "ucast_setup - Extra garbage on "
-		       "specification : '%s'\n", remain);
+		pr_err("ucast_setup - Extra garbage on specification : '%s'\n",
+		       remain);
 		return 0;
 	}
 
 	if (lport_str != NULL) {
 		init->lport = simple_strtoul(lport_str, &last, 10);
 		if ((*last != '\0') || (last == lport_str)) {
-			printk(KERN_ERR "ucast_setup - Bad listen port : "
-			       "'%s'\n", lport_str);
+			pr_err("ucast_setup - Bad listen port : '%s'\n",
+			       lport_str);
 			return 0;
 		}
 	}
@@ -144,16 +142,16 @@ static int ucast_setup(char *str, char **mac_out, void *data)
 	if (rport_str != NULL) {
 		init->rport = simple_strtoul(rport_str, &last, 10);
 		if ((*last != '\0') || (last == rport_str)) {
-			printk(KERN_ERR "ucast_setup - Bad remote port : "
-			       "'%s'\n", rport_str);
+			pr_err("ucast_setup - Bad remote port : '%s'\n",
+			       rport_str);
 			return 0;
 		}
 	}
 
 	init->unicast = true;
 
-	printk(KERN_INFO "Configured ucast device: :%u -> %s:%u\n",
-	       init->lport, init->addr, init->rport);
+	pr_info("Configured ucast device: :%u -> %s:%u\n",
+		init->lport, init->addr, init->rport);
 
 	return 1;
 }
diff --git a/arch/um/drivers/umcast_user.c b/arch/um/drivers/umcast_user.c
index 95abd89..36332b8 100644
--- a/arch/um/drivers/umcast_user.c
+++ b/arch/um/drivers/umcast_user.c
@@ -25,8 +25,7 @@ static struct sockaddr_in *new_addr(char *addr, unsigned short port)
 
 	sin = uml_kmalloc(sizeof(struct sockaddr_in), UM_GFP_KERNEL);
 	if (sin == NULL) {
-		printk(KERN_ERR "new_addr: allocation of sockaddr_in "
-		       "failed\n");
+		pr_err("new_addr: allocation of sockaddr_in failed\n");
 		return NULL;
 	}
 	sin->sin_family = AF_INET;
@@ -79,15 +78,13 @@ static int umcast_open(void *data)
 
 	if (fd < 0) {
 		err = -errno;
-		printk(KERN_ERR "umcast_open : data socket failed, "
-		       "errno = %d\n", errno);
+		pr_err("umcast_open : data socket failed, errno = %d\n", errno);
 		goto out;
 	}
 
 	if (setsockopt(fd, SOL_SOCKET, SO_REUSEADDR, &yes, sizeof(yes)) < 0) {
 		err = -errno;
-		printk(KERN_ERR "umcast_open: SO_REUSEADDR failed, "
-		       "errno = %d\n", errno);
+		pr_err("umcast_open: SO_REUSEADDR failed, errno = %d\n", errno);
 		goto out_close;
 	}
 
@@ -96,8 +93,8 @@ static int umcast_open(void *data)
 		if (setsockopt(fd, SOL_IP, IP_MULTICAST_TTL, &pri->ttl,
 			       sizeof(pri->ttl)) < 0) {
 			err = -errno;
-			printk(KERN_ERR "umcast_open: IP_MULTICAST_TTL "
-			       "failed, error = %d\n", errno);
+			pr_err("umcast_open: IP_MULTICAST_TTL failed, error = %d\n",
+			       errno);
 			goto out_close;
 		}
 
@@ -105,8 +102,8 @@ static int umcast_open(void *data)
 		if (setsockopt(fd, SOL_IP, IP_MULTICAST_LOOP,
 			       &yes, sizeof(yes)) < 0) {
 			err = -errno;
-			printk(KERN_ERR "umcast_open: IP_MULTICAST_LOOP "
-			       "failed, error = %d\n", errno);
+			pr_err("umcast_open: IP_MULTICAST_LOOP failed, error = %d\n",
+			       errno);
 			goto out_close;
 		}
 	}
@@ -114,8 +111,7 @@ static int umcast_open(void *data)
 	/* bind socket to the address */
 	if (bind(fd, (struct sockaddr *) lsin, sizeof(*lsin)) < 0) {
 		err = -errno;
-		printk(KERN_ERR "umcast_open : data bind failed, "
-		       "errno = %d\n", errno);
+		pr_err("umcast_open : data bind failed, errno = %d\n", errno);
 		goto out_close;
 	}
 
@@ -126,13 +122,10 @@ static int umcast_open(void *data)
 		if (setsockopt(fd, SOL_IP, IP_ADD_MEMBERSHIP,
 			       &mreq, sizeof(mreq)) < 0) {
 			err = -errno;
-			printk(KERN_ERR "umcast_open: IP_ADD_MEMBERSHIP "
-			       "failed, error = %d\n", errno);
-			printk(KERN_ERR "There appears not to be a "
-			       "multicast-capable network interface on the "
-			       "host.\n");
-			printk(KERN_ERR "eth0 should be configured in order "
-			       "to use the multicast transport.\n");
+			pr_err("umcast_open: IP_ADD_MEMBERSHIP failed, error = %d\n",
+			       errno);
+			pr_err("There appears not to be a multicast-capable network interface on the host\n");
+			pr_err("eth0 should be configured in order to use the multicast transport\n");
 			goto out_close;
 		}
 	}
@@ -157,8 +150,8 @@ static void umcast_close(int fd, void *data)
 		mreq.imr_interface.s_addr = 0;
 		if (setsockopt(fd, SOL_IP, IP_DROP_MEMBERSHIP,
 			       &mreq, sizeof(mreq)) < 0) {
-			printk(KERN_ERR "umcast_close: IP_DROP_MEMBERSHIP "
-			       "failed, error = %d\n", errno);
+			pr_err("umcast_close: IP_DROP_MEMBERSHIP failed, error = %d\n",
+			       errno);
 		}
 	}
 
diff --git a/arch/um/drivers/vde_kern.c b/arch/um/drivers/vde_kern.c
index 6a365fa..3d2bc4e 100644
--- a/arch/um/drivers/vde_kern.c
+++ b/arch/um/drivers/vde_kern.c
@@ -44,7 +44,7 @@ static int vde_read(int fd, struct sk_buff *skb, struct uml_net_private *lp)
 		return vde_user_read(pri->conn, skb_mac_header(skb),
 				     skb->dev->mtu + ETH_HEADER_OTHER);
 
-	printk(KERN_ERR "vde_read - we have no VDECONN to read from");
+	pr_err("vde_read - we have no VDECONN to read from\nx");
 	return -EBADF;
 }
 
@@ -56,7 +56,7 @@ static int vde_write(int fd, struct sk_buff *skb, struct uml_net_private *lp)
 		return vde_user_write((void *)pri->conn, skb->data,
 				      skb->len);
 
-	printk(KERN_ERR "vde_write - we have no VDECONN to write to");
+	pr_err("vde_write - we have no VDECONN to write to\n");
 	return -EBADF;
 }
 
@@ -83,14 +83,12 @@ static int vde_setup(char *str, char **mac_out, void *data)
 				&init->group, &mode_str, &init->descr, NULL);
 
 	if (remain != NULL)
-		printk(KERN_WARNING "vde_setup - Ignoring extra data :"
-		       "'%s'\n", remain);
+		pr_warn("vde_setup - Ignoring extra data :'%s'\n", remain);
 
 	if (port_str != NULL) {
 		init->port = simple_strtoul(port_str, &last, 10);
 		if ((*last != '\0') || (last == port_str)) {
-			printk(KERN_ERR "vde_setup - Bad port : '%s'\n",
-						port_str);
+			pr_err("vde_setup - Bad port : '%s'\n", port_str);
 			return 0;
 		}
 	}
@@ -98,14 +96,13 @@ static int vde_setup(char *str, char **mac_out, void *data)
 	if (mode_str != NULL) {
 		init->mode = simple_strtoul(mode_str, &last, 8);
 		if ((*last != '\0') || (last == mode_str)) {
-			printk(KERN_ERR "vde_setup - Bad mode : '%s'\n",
-						mode_str);
+			pr_err("vde_setup - Bad mode : '%s'\n", mode_str);
 			return 0;
 		}
 	}
 
-	printk(KERN_INFO "Configured vde device: %s\n", init->vde_switch ?
-	       init->vde_switch : "(default socket)");
+	pr_info("Configured vde device: %s\n",
+		init->vde_switch ? init->vde_switch : "(default socket)");
 
 	return 1;
 }
diff --git a/arch/um/drivers/vde_user.c b/arch/um/drivers/vde_user.c
index 893573b..849baf8 100644
--- a/arch/um/drivers/vde_user.c
+++ b/arch/um/drivers/vde_user.c
@@ -22,12 +22,11 @@ static int vde_user_init(void *data, void *dev)
 
 	if (conn == NULL) {
 		err = -errno;
-		printk(KERN_ERR "vde_user_init: vde_open failed, "
-		       "errno = %d\n", errno);
+		pr_err("vde_user_init: vde_open failed, errno = %d\n", errno);
 		return err;
 	}
 
-	printk(KERN_INFO "vde backend - connection opened\n");
+	pr_info("vde backend - connection opened\n");
 
 	pri->conn = conn;
 
@@ -41,7 +40,7 @@ static int vde_user_open(void *data)
 	if (pri->conn != NULL)
 		return vde_datafd(pri->conn);
 
-	printk(KERN_WARNING "vde_open - we have no VDECONN to open");
+	pr_warn("vde_open - we have no VDECONN to open\n");
 	return -EINVAL;
 }
 
@@ -50,7 +49,7 @@ static void vde_remove(void *data)
 	struct vde_data *pri = data;
 
 	if (pri->conn != NULL) {
-		printk(KERN_INFO "vde backend - closing connection\n");
+		pr_info("vde backend - closing connection\n");
 		vde_close(pri->conn);
 		pri->conn = NULL;
 		kfree(pri->args);
@@ -58,7 +57,7 @@ static void vde_remove(void *data)
 		return;
 	}
 
-	printk(KERN_WARNING "vde_remove - we have no VDECONN to remove");
+	pr_warn("vde_remove - we have no VDECONN to remove\n");
 }
 
 const struct net_user_info vde_user_info = {
@@ -78,8 +77,7 @@ void vde_init_libstuff(struct vde_data *vpri, struct vde_init *init)
 
 	vpri->args = uml_kmalloc(sizeof(struct vde_open_args), UM_GFP_KERNEL);
 	if (vpri->args == NULL) {
-		printk(KERN_ERR "vde_init_libstuff - vde_open_args "
-		       "allocation failed");
+		pr_err("vde_init_libstuff - vde_open_args allocation failed\n");
 		return;
 	}
 
diff --git a/arch/um/drivers/xterm.c b/arch/um/drivers/xterm.c
index 939ca36..6f8dd5b 100644
--- a/arch/um/drivers/xterm.c
+++ b/arch/um/drivers/xterm.c
@@ -99,7 +99,7 @@ static int xterm_open(int input, int output, int primary, void *d,
 	 * will work but w/o it we can be pretty sure it won't.
 	 */
 	if (getenv("DISPLAY") == NULL) {
-		printk(KERN_ERR "xterm_open: $DISPLAY not set.\n");
+		pr_err("xterm_open: $DISPLAY not set\n");
 		return -ENODEV;
 	}
 
@@ -112,15 +112,13 @@ static int xterm_open(int input, int output, int primary, void *d,
 	fd = mkstemp(file);
 	if (fd < 0) {
 		err = -errno;
-		printk(KERN_ERR "xterm_open : mkstemp failed, errno = %d\n",
-		       errno);
+		pr_err("xterm_open : mkstemp failed, errno = %d\n", errno);
 		return err;
 	}
 
 	if (unlink(file)) {
 		err = -errno;
-		printk(KERN_ERR "xterm_open : unlink failed, errno = %d\n",
-		       errno);
+		pr_err("xterm_open : unlink failed, errno = %d\n", errno);
 		close(fd);
 		return err;
 	}
@@ -128,8 +126,8 @@ static int xterm_open(int input, int output, int primary, void *d,
 
 	fd = os_create_unix_socket(file, sizeof(file), 1);
 	if (fd < 0) {
-		printk(KERN_ERR "xterm_open : create_unix_socket failed, "
-		       "errno = %d\n", -fd);
+		pr_err("xterm_open : create_unix_socket failed, errno = %d\n",
+		       -fd);
 		return fd;
 	}
 
@@ -137,30 +135,28 @@ static int xterm_open(int input, int output, int primary, void *d,
 	pid = run_helper(NULL, NULL, argv);
 	if (pid < 0) {
 		err = pid;
-		printk(KERN_ERR "xterm_open : run_helper failed, "
-		       "errno = %d\n", -err);
+		pr_err("xterm_open : run_helper failed, errno = %d\n", -err);
 		goto out_close1;
 	}
 
 	err = os_set_fd_block(fd, 0);
 	if (err < 0) {
-		printk(KERN_ERR "xterm_open : failed to set descriptor "
-		       "non-blocking, err = %d\n", -err);
+		pr_err("xterm_open : failed to set descriptor non-blocking, err = %d\n",
+		       -err);
 		goto out_kill;
 	}
 
 	new = xterm_fd(fd, &data->helper_pid);
 	if (new < 0) {
 		err = new;
-		printk(KERN_ERR "xterm_open : os_rcv_fd failed, err = %d\n",
-		       -err);
+		pr_err("xterm_open : os_rcv_fd failed, err = %d\n", -err);
 		goto out_kill;
 	}
 
 	err = os_set_fd_block(new, 0);
 	if (err) {
-		printk(KERN_ERR "xterm_open : failed to set xterm "
-		       "descriptor non-blocking, err = %d\n", -err);
+		pr_err("xterm_open : failed to set xterm descriptor non-blocking, err = %d\n",
+		       -err);
 		goto out_close2;
 	}
 
diff --git a/arch/um/drivers/xterm_kern.c b/arch/um/drivers/xterm_kern.c
index e8f9957..60ddb57 100644
--- a/arch/um/drivers/xterm_kern.c
+++ b/arch/um/drivers/xterm_kern.c
@@ -39,7 +39,7 @@ int xterm_fd(int socket, int *pid_out)
 
 	data = kmalloc(sizeof(*data), GFP_KERNEL);
 	if (data == NULL) {
-		printk(KERN_ERR "xterm_fd : failed to allocate xterm_wait\n");
+		pr_err("xterm_fd : failed to allocate xterm_wait\n");
 		return -ENOMEM;
 	}
 
@@ -52,8 +52,8 @@ int xterm_fd(int socket, int *pid_out)
 	err = um_request_irq(XTERM_IRQ, socket, IRQ_READ, xterm_interrupt,
 			     IRQF_SHARED, "xterm", data);
 	if (err) {
-		printk(KERN_ERR "xterm_fd : failed to get IRQ for xterm, "
-		       "err = %d\n",  err);
+		pr_err("xterm_fd : failed to get IRQ for xterm, err = %d\n",
+		       err);
 		ret = err;
 		goto out;
 	}
diff --git a/arch/um/kernel/exec.c b/arch/um/kernel/exec.c
index 0d7103c..08e95e1 100644
--- a/arch/um/kernel/exec.c
+++ b/arch/um/kernel/exec.c
@@ -28,8 +28,8 @@ void flush_thread(void)
 	ret = ret || unmap(&current->mm->context.id, STUB_END,
 			   host_task_size - STUB_END, 1, &data);
 	if (ret) {
-		printk(KERN_ERR "flush_thread - clearing address space failed, "
-		       "err = %d\n", ret);
+		pr_err("flush_thread - clearing address space failed, err = %d\n",
+		       ret);
 		force_sig(SIGKILL, current);
 	}
 	get_safe_registers(current_pt_regs()->regs.gp,
diff --git a/arch/um/kernel/exitcode.c b/arch/um/kernel/exitcode.c
index 41ebbfe..bdaecb1 100644
--- a/arch/um/kernel/exitcode.c
+++ b/arch/um/kernel/exitcode.c
@@ -70,8 +70,7 @@ static int make_proc_exitcode(void)
 
 	ent = proc_create("exitcode", 0600, NULL, &exitcode_proc_fops);
 	if (ent == NULL) {
-		printk(KERN_WARNING "make_proc_exitcode : Failed to register "
-		       "/proc/exitcode\n");
+		pr_warn("make_proc_exitcode : Failed to register /proc/exitcode\n");
 		return 0;
 	}
 	return 0;
diff --git a/arch/um/kernel/initrd.c b/arch/um/kernel/initrd.c
index 55cead8..9e473ca 100644
--- a/arch/um/kernel/initrd.c
+++ b/arch/um/kernel/initrd.c
@@ -32,7 +32,7 @@ static int __init read_initrd(void)
 	 * ask for no memory.
 	 */
 	if (size == 0) {
-		printk(KERN_ERR "\"%s\" is a zero-size initrd\n", initrd);
+		pr_err("\"%s\" is a zero-size initrd\n", initrd);
 		return 0;
 	}
 
@@ -68,15 +68,13 @@ static int load_initrd(char *filename, void *buf, int size)
 
 	fd = os_open_file(filename, of_read(OPENFLAGS()), 0);
 	if (fd < 0) {
-		printk(KERN_ERR "Opening '%s' failed - err = %d\n", filename,
-		       -fd);
+		pr_err("Opening '%s' failed - err = %d\n", filename, -fd);
 		return -1;
 	}
 	n = os_read_file(fd, buf, size);
 	if (n != size) {
-		printk(KERN_ERR "Read of %d bytes from '%s' failed, "
-		       "err = %d\n", size,
-		       filename, -n);
+		pr_err("Read of %d bytes from '%s' failed, err = %d\n",
+		       size, filename, -n);
 		return -1;
 	}
 
diff --git a/arch/um/kernel/irq.c b/arch/um/kernel/irq.c
index 1d8505b..961c64e 100644
--- a/arch/um/kernel/irq.c
+++ b/arch/um/kernel/irq.c
@@ -91,9 +91,9 @@ static int activate_fd(int irq, int fd, int type, void *dev_id)
 	spin_lock_irqsave(&irq_lock, flags);
 	for (irq_fd = active_fds; irq_fd != NULL; irq_fd = irq_fd->next) {
 		if ((irq_fd->fd == fd) && (irq_fd->type == type)) {
-			printk(KERN_ERR "Registering fd %d twice\n", fd);
-			printk(KERN_ERR "Irqs : %d, %d\n", irq_fd->irq, irq);
-			printk(KERN_ERR "Ids : 0x%p, 0x%p\n", irq_fd->id,
+			pr_err("Registering fd %d twice\n", fd);
+			pr_err("Irqs : %d, %d\n", irq_fd->irq, irq);
+			pr_err("Ids : 0x%p, 0x%p\n", irq_fd->id,
 			       dev_id);
 			goto out_unlock;
 		}
@@ -205,15 +205,13 @@ static struct irq_fd *find_irq_by_fd(int fd, int irqnum, int *index_out)
 		i++;
 	}
 	if (irq == NULL) {
-		printk(KERN_ERR "find_irq_by_fd doesn't have descriptor %d\n",
-		       fd);
+		pr_err("find_irq_by_fd doesn't have descriptor %d\n", fd);
 		goto out;
 	}
 	fdi = os_get_pollfd(i);
 	if ((fdi != -1) && (fdi != fd)) {
-		printk(KERN_ERR "find_irq_by_fd - mismatch between active_fds "
-		       "and pollfds, fd %d vs %d, need %d\n", irq->fd,
-		       fdi, fd);
+		pr_err("find_irq_by_fd - mismatch between active_fds and pollfds, fd %d vs %d, need %d\n",
+		       irq->fd, fdi, fd);
 		irq = NULL;
 		goto out;
 	}
diff --git a/arch/um/kernel/physmem.c b/arch/um/kernel/physmem.c
index 30fdd5d..5debbc6 100644
--- a/arch/um/kernel/physmem.c
+++ b/arch/um/kernel/physmem.c
@@ -67,11 +67,9 @@ void map_memory(unsigned long virt, unsigned long phys, unsigned long len,
 	err = os_map_memory((void *) virt, fd, offset, len, r, w, x);
 	if (err) {
 		if (err == -ENOMEM)
-			printk(KERN_ERR "try increasing the host's "
-			       "/proc/sys/vm/max_map_count to <physical "
-			       "memory size>/4096\n");
-		panic("map_memory(0x%lx, %d, 0x%llx, %ld, %d, %d, %d) failed, "
-		      "err = %d\n", virt, fd, offset, len, r, w, x, err);
+			pr_err("try increasing the host's /proc/sys/vm/max_map_count to <physical memory size>/4096\n");
+		panic("map_memory(0x%lx, %d, 0x%llx, %ld, %d, %d, %d) failed, err = %d\n",
+		      virt, fd, offset, len, r, w, x, err);
 	}
 }
 
@@ -198,10 +196,10 @@ static int setup_iomem(void)
 	while (region != NULL) {
 		err = os_map_memory((void *) iomem_start, region->fd, 0,
 				    region->size, 1, 1, 0);
-		if (err)
-			printk(KERN_ERR "Mapping iomem region for driver '%s' "
-			       "failed, errno = %d\n", region->driver, -err);
-		else {
+		if (err) {
+			pr_err("Mapping iomem region for driver '%s' failed, errno = %d\n",
+			       region->driver, -err);
+		} else {
 			region->virt = iomem_start;
 			region->phys = __pa(region->virt);
 		}
diff --git a/arch/um/kernel/process.c b/arch/um/kernel/process.c
index f17bca8..6978301 100644
--- a/arch/um/kernel/process.c
+++ b/arch/um/kernel/process.c
@@ -334,7 +334,7 @@ int __init make_proc_sysemu(void)
 
 	if (ent == NULL)
 	{
-		printk(KERN_WARNING "Failed to register /proc/sysemu\n");
+		pr_warn("Failed to register /proc/sysemu\n");
 		return 0;
 	}
 
diff --git a/arch/um/kernel/sigio.c b/arch/um/kernel/sigio.c
index b5e0cbb..951aea2 100644
--- a/arch/um/kernel/sigio.c
+++ b/arch/um/kernel/sigio.c
@@ -27,8 +27,8 @@ int write_sigio_irq(int fd)
 	err = um_request_irq(SIGIO_WRITE_IRQ, fd, IRQ_READ, sigio_interrupt,
 			     0, "write sigio", NULL);
 	if (err) {
-		printk(KERN_ERR "write_sigio_irq : um_request_irq failed, "
-		       "err = %d\n", err);
+		pr_err("write_sigio_irq : um_request_irq failed, err = %d\n",
+		       err);
 		return -1;
 	}
 	sigio_irq_fd = fd;
diff --git a/arch/um/kernel/skas/mmu.c b/arch/um/kernel/skas/mmu.c
index 94abdcc..14bc89a 100644
--- a/arch/um/kernel/skas/mmu.c
+++ b/arch/um/kernel/skas/mmu.c
@@ -74,8 +74,8 @@ int init_new_context(struct task_struct *task, struct mm_struct *mm)
 
 	ret = init_new_ldt(to_mm, from_mm);
 	if (ret < 0) {
-		printk(KERN_ERR "init_new_context_skas - init_ldt"
-		       " failed, errno = %d\n", ret);
+		pr_err("init_new_context_skas - init_ldt failed, errno = %d\n",
+		       ret);
 		goto out_free;
 	}
 
@@ -110,7 +110,7 @@ void uml_setup_stubs(struct mm_struct *mm)
 				      VM_MAYEXEC | VM_DONTCOPY | VM_PFNMAP,
 				      mm->context.stub_pages);
 	if (err) {
-		printk(KERN_ERR "install_special_mapping returned %d\n", err);
+		pr_err("install_special_mapping returned %d\n", err);
 		goto out;
 	}
 	return;
@@ -145,8 +145,7 @@ void destroy_context(struct mm_struct *mm)
 	 * 1 cases, since they shouldn't happen either.
 	 */
 	if (mmu->id.u.pid < 2) {
-		printk(KERN_ERR "corrupt mm_context - pid = %d\n",
-		       mmu->id.u.pid);
+		pr_err("corrupt mm_context - pid = %d\n", mmu->id.u.pid);
 		return;
 	}
 	os_kill_ptraced_process(mmu->id.u.pid, 1);
diff --git a/arch/um/kernel/smp.c b/arch/um/kernel/smp.c
index 5c8c3ea..f8e952a 100644
--- a/arch/um/kernel/smp.c
+++ b/arch/um/kernel/smp.c
@@ -44,13 +44,13 @@ void smp_send_stop(void)
 {
 	int i;
 
-	printk(KERN_INFO "Stopping all CPUs...");
+	pr_info("Stopping all CPUs...");
 	for (i = 0; i < num_online_cpus(); i++) {
 		if (i == current_thread->cpu)
 			continue;
 		os_write_file(cpu_data[i].ipi_pipe[1], "S", 1);
 	}
-	printk(KERN_CONT "done\n");
+	pr_cont("done\n");
 }
 
 static cpumask_t smp_commenced_mask = CPU_MASK_NONE;
@@ -68,7 +68,7 @@ static int idle_proc(void *cpup)
 
 	wmb();
 	if (cpu_test_and_set(cpu, cpu_callin_map)) {
-		printk(KERN_ERR "huh, CPU#%d already present??\n", cpu);
+		pr_err("huh, CPU#%d already present??\n", cpu);
 		BUG();
 	}
 
@@ -120,7 +120,7 @@ void smp_prepare_cpus(unsigned int maxcpus)
 	os_set_fd_async(cpu_data[me].ipi_pipe[0]);
 
 	for (cpu = 1; cpu < ncpus; cpu++) {
-		printk(KERN_INFO "Booting processor %d...\n", cpu);
+		pr_info("Booting processor %d...\n", cpu);
 
 		idle = idle_thread(cpu);
 
@@ -130,8 +130,8 @@ void smp_prepare_cpus(unsigned int maxcpus)
 		while (waittime-- && !cpu_isset(cpu, cpu_callin_map))
 			cpu_relax();
 
-		printk(KERN_INFO "%s\n",
-		       cpu_isset(cpu, cpu_calling_map) ? "done" : "failed");
+		pr_info("%s\n",
+			cpu_isset(cpu, cpu_calling_map) ? "done" : "failed");
 	}
 }
 
@@ -150,7 +150,7 @@ int __cpu_up(unsigned int cpu, struct task_struct *tidle)
 
 int setup_profiling_timer(unsigned int multiplier)
 {
-	printk(KERN_INFO "setup_profiling_timer\n");
+	pr_info("setup_profiling_timer\n");
 	return 0;
 }
 
@@ -173,13 +173,13 @@ void IPI_handler(int cpu)
 			break;
 
 		case 'S':
-			printk(KERN_INFO "CPU#%d stopping\n", cpu);
+			pr_info("CPU#%d stopping\n", cpu);
 			while (1)
 				pause();
 			break;
 
 		default:
-			printk(KERN_ERR "CPU#%d received unknown IPI [%c]!\n",
+			pr_err("CPU#%d received unknown IPI [%c]!\n",
 			       cpu, c);
 			break;
 		}
diff --git a/arch/um/kernel/sysrq.c b/arch/um/kernel/sysrq.c
index 799d7e4..ac059de 100644
--- a/arch/um/kernel/sysrq.c
+++ b/arch/um/kernel/sysrq.c
@@ -25,7 +25,7 @@ static void do_stack_trace(unsigned long *sp, unsigned long bp)
 	unsigned long addr;
 	struct stack_frame *frame = (struct stack_frame *)bp;
 
-	printk(KERN_INFO "Call Trace:\n");
+	pr_info("Call Trace:\n");
 	while (((long) sp & (THREAD_SIZE-1)) != 0) {
 		addr = *sp;
 		if (__kernel_text_address(addr)) {
@@ -36,14 +36,14 @@ static void do_stack_trace(unsigned long *sp, unsigned long bp)
 				reliable = 1;
 			}
 
-			printk(KERN_INFO " [<%08lx>]", addr);
-			printk(KERN_CONT " %s", reliable ? "" : "? ");
+			pr_info(" [<%08lx>]", addr);
+			pr_cont(" %s", reliable ? "" : "? ");
 			print_symbol(KERN_CONT "%s", addr);
-			printk(KERN_CONT "\n");
+			pr_cont("\n");
 		}
 		sp++;
 	}
-	printk(KERN_INFO "\n");
+	pr_info("\n");
 }
 
 static unsigned long get_frame_pointer(struct task_struct *task,
@@ -71,8 +71,7 @@ void show_stack(struct task_struct *task, unsigned long *stack)
 	int i;
 
 	if (!segv_regs && os_is_signal_stack()) {
-		printk(KERN_ERR "Received SIGSEGV in SIGSEGV handler,"
-				" aborting stack trace!\n");
+		pr_err("Received SIGSEGV in SIGSEGV handler, aborting stack trace!\n");
 		return;
 	}
 
@@ -83,16 +82,16 @@ void show_stack(struct task_struct *task, unsigned long *stack)
 	if (!stack)
 		sp = get_stack_pointer(task, segv_regs);
 
-	printk(KERN_INFO "Stack:\n");
+	pr_info("Stack:\n");
 	stack = sp;
 	for (i = 0; i < 3 * STACKSLOTS_PER_LINE; i++) {
 		if (kstack_end(stack))
 			break;
 		if (i && ((i % STACKSLOTS_PER_LINE) == 0))
-			printk(KERN_CONT "\n");
-		printk(KERN_CONT " %08lx", *stack++);
+			pr_cont("\n");
+		pr_cont(" %08lx", *stack++);
 	}
-	printk(KERN_CONT "\n");
+	pr_cont("\n");
 
 	do_stack_trace(sp, bp);
 }
diff --git a/arch/um/kernel/time.c b/arch/um/kernel/time.c
index 117568d..a209c83 100644
--- a/arch/um/kernel/time.c
+++ b/arch/um/kernel/time.c
@@ -84,8 +84,8 @@ static void __init setup_itimer(void)
 
 	err = request_irq(TIMER_IRQ, um_timer, 0, "timer", NULL);
 	if (err != 0)
-		printk(KERN_ERR "register_timer : request_irq failed - "
-		       "errno = %d\n", -err);
+		pr_err("register_timer : request_irq failed - errno = %d\n",
+		       -err);
 
 	itimer_clockevent.mult = div_sc(HZ, NSEC_PER_SEC, 32);
 	itimer_clockevent.max_delta_ns =
@@ -94,7 +94,7 @@ static void __init setup_itimer(void)
 		clockevent_delta2ns(1, &itimer_clockevent);
 	err = clocksource_register_hz(&itimer_clocksource, USEC_PER_SEC);
 	if (err) {
-		printk(KERN_ERR "clocksource_register_hz returned %d\n", err);
+		pr_err("clocksource_register_hz returned %d\n", err);
 		return;
 	}
 	clockevents_register_device(&itimer_clockevent);
diff --git a/arch/um/kernel/tlb.c b/arch/um/kernel/tlb.c
index 9472079..4022640 100644
--- a/arch/um/kernel/tlb.c
+++ b/arch/um/kernel/tlb.c
@@ -73,8 +73,7 @@ static int do_ops(struct host_vm_change *hvc, int end,
 				      finished, &hvc->data);
 			break;
 		default:
-			printk(KERN_ERR "Unknown op type %d in do_ops\n",
-			       op->type);
+			pr_err("Unknown op type %d in do_ops\n", op->type);
 			BUG();
 			break;
 		}
@@ -282,8 +281,7 @@ void fix_range_common(struct mm_struct *mm, unsigned long start_addr,
 
 	/* This is not an else because ret is modified above */
 	if (ret) {
-		printk(KERN_ERR "fix_range_common: failed, killing current "
-		       "process\n");
+		pr_err("fix_range_common: failed, killing current process\n");
 		force_sig(SIGKILL, current);
 	}
 }
@@ -434,7 +432,7 @@ void flush_tlb_page(struct vm_area_struct *vma, unsigned long address)
 	return;
 
 kill:
-	printk(KERN_ERR "Failed to flush page for address 0x%lx\n", address);
+	pr_err("Failed to flush page for address 0x%lx\n", address);
 	force_sig(SIGKILL, current);
 }
 
diff --git a/arch/um/kernel/trap.c b/arch/um/kernel/trap.c
index 4a6235b7..d036fbf 100644
--- a/arch/um/kernel/trap.c
+++ b/arch/um/kernel/trap.c
@@ -153,7 +153,7 @@ static void show_segv_info(struct uml_pt_regs *regs)
 		fi->error_code);
 
 	print_vma_addr(KERN_CONT " in ", UPT_IP(regs));
-	printk(KERN_CONT "\n");
+	pr_cont("\n");
 }
 
 static void bad_segv(struct faultinfo fi, unsigned long ip)
@@ -280,8 +280,7 @@ void relay_signal(int sig, struct siginfo *si, struct uml_pt_regs *regs)
 
 	if (!UPT_IS_USER(regs)) {
 		if (sig == SIGBUS)
-			printk(KERN_ERR "Bus error - the host /dev/shm or /tmp "
-			       "mount likely just ran out of space\n");
+			pr_err("Bus error - the host /dev/shm or /tmp mount likely just ran out of space\n");
 		panic("Kernel mode signal %d", sig);
 	}
 
@@ -305,8 +304,8 @@ void relay_signal(int sig, struct siginfo *si, struct uml_pt_regs *regs)
 #endif
 		break;
 	default:
-		printk(KERN_ERR "Attempted to relay unknown signal %d (si_code = %d)\n",
-			sig, si->si_code);
+		pr_err("Attempted to relay unknown signal %d (si_code = %d)\n",
+		       sig, si->si_code);
 	}
 
 	force_sig_info(sig, &clean_si, current);
diff --git a/arch/um/os-Linux/aio.c b/arch/um/os-Linux/aio.c
index 19a5315..87bdf90 100644
--- a/arch/um/os-Linux/aio.c
+++ b/arch/um/os-Linux/aio.c
@@ -88,7 +88,7 @@ static int do_aio(aio_context_t ctx, enum aio_type type, int fd, char *buf,
 		iocbp->aio_nbytes = sizeof(c);
 		break;
 	default:
-		printk(KERN_ERR "Bogus op in do_aio - %d\n", type);
+		pr_err("Bogus op in do_aio - %d\n", type);
 		return -EINVAL;
 	}
 
@@ -110,8 +110,8 @@ static int aio_thread(void *arg)
 		if (n < 0) {
 			if (errno == EINTR)
 				continue;
-			printk(KERN_ERR "aio_thread - io_getevents failed, "
-			       "errno = %d\n", errno);
+			pr_err("aio_thread - io_getevents failed, errno = %d\n",
+			       errno);
 		}
 		else {
 			reply = ((struct aio_thread_reply)
@@ -120,8 +120,8 @@ static int aio_thread(void *arg)
 			reply_fd = ((struct aio_context *) reply.data)->reply_fd;
 			err = write(reply_fd, &reply, sizeof(reply));
 			if (err != sizeof(reply))
-				printk(KERN_ERR "aio_thread - write failed, "
-				       "fd = %d, err = %d\n", reply_fd, errno);
+				pr_err("aio_thread - write failed, fd = %d, err = %d\n",
+				       reply_fd, errno);
 		}
 	}
 	return 0;
@@ -150,8 +150,7 @@ static int do_not_aio(struct aio_thread_req *req)
 		n = read(req->io_fd, &c, sizeof(c));
 		break;
 	default:
-		printk(KERN_ERR "do_not_aio - bad request type : %d\n",
-		       req->type);
+		pr_err("do_not_aio - bad request type : %d\n", req->type);
 		return -EINVAL;
 	}
 
@@ -177,13 +176,10 @@ static int not_aio_thread(void *arg)
 		err = read(aio_req_fd_r, &req, sizeof(req));
 		if (err != sizeof(req)) {
 			if (err < 0)
-				printk(KERN_ERR "not_aio_thread - "
-				       "read failed, fd = %d, err = %d\n",
-				       aio_req_fd_r,
-				       errno);
+				pr_err("not_aio_thread - read failed, fd = %d, err = %d\n",
+				       aio_req_fd_r, errno);
 			else {
-				printk(KERN_ERR "not_aio_thread - short "
-				       "read, fd = %d, length = %d\n",
+				pr_err("not_aio_thread - short read, fd = %d, length = %d\n",
 				       aio_req_fd_r, err);
 			}
 			continue;
@@ -193,8 +189,8 @@ static int not_aio_thread(void *arg)
 						     .err	= err });
 		err = write(req.aio->reply_fd, &reply, sizeof(reply));
 		if (err != sizeof(reply))
-			printk(KERN_ERR "not_aio_thread - write failed, "
-			       "fd = %d, err = %d\n", req.aio->reply_fd, errno);
+			pr_err("not_aio_thread - write failed, fd = %d, err = %d\n",
+			       req.aio->reply_fd, errno);
 	}
 
 	return 0;
@@ -230,11 +226,9 @@ out_close_pipe:
 	aio_req_fd_r = -1;
 out:
 #ifndef HAVE_AIO_ABI
-	printk(KERN_INFO "/usr/include/linux/aio_abi.h not present during "
-	       "build\n");
+	pr_info("/usr/include/linux/aio_abi.h not present during build\n");
 #endif
-	printk(KERN_INFO "2.6 host AIO support not used - falling back to "
-	       "I/O thread\n");
+	pr_info("2.6 host AIO support not used - falling back to I/O thread\n");
 	return 0;
 }
 
@@ -246,8 +240,8 @@ static int init_aio_26(void)
 
 	if (io_setup(256, &ctx)) {
 		err = -errno;
-		printk(KERN_ERR "aio_thread failed to initialize context, "
-		       "err = %d\n", errno);
+		pr_err("aio_thread failed to initialize context, err = %d\n",
+		       errno);
 		return err;
 	}
 
@@ -258,7 +252,7 @@ static int init_aio_26(void)
 
 	aio_pid = err;
 
-	printk(KERN_INFO "Using 2.6 host AIO\n");
+	pr_info("Using 2.6 host AIO\n");
 	return 0;
 }
 
@@ -275,8 +269,8 @@ static int submit_aio_26(enum aio_type type, int io_fd, char *buf, int len,
 		err = write(aio->reply_fd, &reply, sizeof(reply));
 		if (err != sizeof(reply)) {
 			err = -errno;
-			printk(KERN_ERR "submit_aio_26 - write failed, "
-			       "fd = %d, err = %d\n", aio->reply_fd, -err);
+			pr_err("submit_aio_26 - write failed, fd = %d, err = %d\n",
+			       aio->reply_fd, -err);
 		}
 		else err = 0;
 	}
@@ -326,8 +320,7 @@ static int init_aio(void)
 	if (!aio_24) {
 		err = init_aio_26();
 		if (err && (errno == ENOSYS)) {
-			printk(KERN_INFO "2.6 AIO not supported on the "
-			       "host - reverting to 2.4 AIO\n");
+			pr_info("2.6 AIO not supported on the host - reverting to 2.4 AIO\n");
 			aio_24 = 1;
 		}
 		else return err;
diff --git a/arch/um/os-Linux/drivers/ethertap_kern.c b/arch/um/os-Linux/drivers/ethertap_kern.c
index f424600..79ae671 100644
--- a/arch/um/os-Linux/drivers/ethertap_kern.c
+++ b/arch/um/os-Linux/drivers/ethertap_kern.c
@@ -30,10 +30,10 @@ static void etap_init(struct net_device *dev, void *data)
 	epri->control_fd = -1;
 	epri->dev = dev;
 
-	printk(KERN_INFO "ethertap backend - %s", epri->dev_name);
+	pr_info("ethertap backend - %s", epri->dev_name);
 	if (epri->gate_addr != NULL)
-		printk(KERN_CONT ", IP = %s", epri->gate_addr);
-	printk(KERN_CONT "\n");
+		pr_cont(", IP = %s", epri->gate_addr);
+	pr_cont("\n");
 }
 
 static int etap_read(int fd, struct sk_buff *skb, struct uml_net_private *lp)
@@ -74,7 +74,7 @@ int ethertap_setup(char *str, char **mac_out, void *data)
 			    &init->gate_addr))
 		return 0;
 	if (init->dev_name == NULL) {
-		printk(KERN_ERR "ethertap_setup : Missing tap device name\n");
+		pr_err("ethertap_setup : Missing tap device name\n");
 		return 0;
 	}
 
diff --git a/arch/um/os-Linux/drivers/ethertap_user.c b/arch/um/os-Linux/drivers/ethertap_user.c
index 2e097cd..85b9179 100644
--- a/arch/um/os-Linux/drivers/ethertap_user.c
+++ b/arch/um/os-Linux/drivers/ethertap_user.c
@@ -45,15 +45,13 @@ static void etap_change(int op, unsigned char *addr, unsigned char *netmask,
 	memcpy(change.netmask, netmask, sizeof(change.netmask));
 	CATCH_EINTR(n = write(fd, &change, sizeof(change)));
 	if (n != sizeof(change)) {
-		printk(KERN_ERR "etap_change - request failed, err = %d\n",
-		       errno);
+		pr_err("etap_change - request failed, err = %d\n", errno);
 		return;
 	}
 
 	output = uml_kmalloc(UM_KERN_PAGE_SIZE, UM_GFP_KERNEL);
 	if (output == NULL)
-		printk(KERN_ERR "etap_change : Failed to allocate output "
-		       "buffer\n");
+		pr_err("etap_change : Failed to allocate output buffer\n");
 	read_output(fd, output, UM_KERN_PAGE_SIZE);
 	if (output != NULL) {
 		printk("%s", output);
@@ -123,12 +121,11 @@ static int etap_tramp(char *dev, char *gate, int control_me,
 	CATCH_EINTR(n = read(control_me, &c, sizeof(c)));
 	if (n != sizeof(c)) {
 		err = -errno;
-		printk(KERN_ERR "etap_tramp : read of status failed, "
-		       "err = %d\n", -err);
+		pr_err("etap_tramp : read of status failed, err = %d\n", -err);
 		return err;
 	}
 	if (c != 1) {
-		printk(KERN_ERR "etap_tramp : uml_net failed\n");
+		pr_err("etap_tramp : uml_net failed\n");
 		err = helper_wait(pid);
 	}
 	return err;
@@ -147,16 +144,16 @@ static int etap_open(void *data)
 	err = socketpair(AF_UNIX, SOCK_DGRAM, 0, data_fds);
 	if (err) {
 		err = -errno;
-		printk(KERN_ERR "etap_open - data socketpair failed - "
-		       "err = %d\n", errno);
+		pr_err("etap_open - data socketpair failed - err = %d\n",
+		       errno);
 		return err;
 	}
 
 	err = socketpair(AF_UNIX, SOCK_STREAM, 0, control_fds);
 	if (err) {
 		err = -errno;
-		printk(KERN_ERR "etap_open - control socketpair failed - "
-		       "err = %d\n", errno);
+		pr_err("etap_open - control socketpair failed - err = %d\n",
+		       errno);
 		goto out_close_data;
 	}
 
@@ -167,15 +164,14 @@ static int etap_open(void *data)
 	read_output(control_fds[0], output, output_len);
 
 	if (output == NULL)
-		printk(KERN_ERR "etap_open : failed to allocate output "
-		       "buffer\n");
+		pr_err("etap_open : failed to allocate output buffer\n");
 	else {
 		printk("%s", output);
 		kfree(output);
 	}
 
 	if (err < 0) {
-		printk(KERN_ERR "etap_tramp failed - err = %d\n", -err);
+		pr_err("etap_tramp failed - err = %d\n", -err);
 		goto out_close_control;
 	}
 
@@ -201,12 +197,12 @@ static void etap_close(int fd, void *data)
 	close(fd);
 
 	if (shutdown(pri->data_fd, SHUT_RDWR) < 0)
-		printk(KERN_ERR "etap_close - shutdown data socket failed, "
-		       "errno = %d\n", errno);
+		pr_err("etap_close - shutdown data socket failed, errno = %d\n",
+		       errno);
 
 	if (shutdown(pri->control_fd, SHUT_RDWR) < 0)
-		printk(KERN_ERR "etap_close - shutdown control socket "
-		       "failed, errno = %d\n", errno);
+		pr_err("etap_close - shutdown control socket failed, errno = %d\n",
+		       errno);
 
 	close(pri->data_fd);
 	pri->data_fd = -1;
diff --git a/arch/um/os-Linux/drivers/tuntap_kern.c b/arch/um/os-Linux/drivers/tuntap_kern.c
index d9d56e5..b2c8f2e 100644
--- a/arch/um/os-Linux/drivers/tuntap_kern.c
+++ b/arch/um/os-Linux/drivers/tuntap_kern.c
@@ -29,10 +29,10 @@ static void tuntap_init(struct net_device *dev, void *data)
 	tpri->fd = -1;
 	tpri->dev = dev;
 
-	printk(KERN_INFO "TUN/TAP backend - ");
+	pr_info("TUN/TAP backend - ");
 	if (tpri->gate_addr != NULL)
-		printk(KERN_CONT "IP = %s", tpri->gate_addr);
-	printk(KERN_CONT "\n");
+		pr_cont("IP = %s", tpri->gate_addr);
+	pr_cont("\n");
 }
 
 static int tuntap_read(int fd, struct sk_buff *skb, struct uml_net_private *lp)
diff --git a/arch/um/os-Linux/drivers/tuntap_user.c b/arch/um/os-Linux/drivers/tuntap_user.c
index 1c5edf8..62738d8 100644
--- a/arch/um/os-Linux/drivers/tuntap_user.c
+++ b/arch/um/os-Linux/drivers/tuntap_user.c
@@ -102,22 +102,20 @@ static int tuntap_open_tramp(char *gate, int *fd_out, int me, int remote,
 	*used_out = n;
 	if (n < 0) {
 		err = -errno;
-		printk(KERN_ERR "tuntap_open_tramp : recvmsg failed - "
-		       "errno = %d\n", errno);
+		pr_err("tuntap_open_tramp : recvmsg failed - errno = %d\n",
+		       errno);
 		return err;
 	}
 	helper_wait(pid);
 
 	cmsg = CMSG_FIRSTHDR(&msg);
 	if (cmsg == NULL) {
-		printk(KERN_ERR "tuntap_open_tramp : didn't receive a "
-		       "message\n");
+		pr_err("tuntap_open_tramp : didn't receive a message\n");
 		return -EINVAL;
 	}
 	if ((cmsg->cmsg_level != SOL_SOCKET) ||
 	   (cmsg->cmsg_type != SCM_RIGHTS)) {
-		printk(KERN_ERR "tuntap_open_tramp : didn't receive a "
-		       "descriptor\n");
+		pr_err("tuntap_open_tramp : didn't receive a descriptor\n");
 		return -EINVAL;
 	}
 	*fd_out = ((int *) CMSG_DATA(cmsg))[0];
@@ -140,8 +138,8 @@ static int tuntap_open(void *data)
 		pri->fd = os_open_file("/dev/net/tun",
 				       of_cloexec(of_rdwr(OPENFLAGS())), 0);
 		if (pri->fd < 0) {
-			printk(KERN_ERR "Failed to open /dev/net/tun, "
-			       "err = %d\n", -pri->fd);
+			pr_err("Failed to open /dev/net/tun, err = %d\n",
+			       -pri->fd);
 			return pri->fd;
 		}
 		memset(&ifr, 0, sizeof(ifr));
@@ -149,8 +147,7 @@ static int tuntap_open(void *data)
 		strlcpy(ifr.ifr_name, pri->dev_name, sizeof(ifr.ifr_name));
 		if (ioctl(pri->fd, TUNSETIFF, &ifr) < 0) {
 			err = -errno;
-			printk(KERN_ERR "TUNSETIFF failed, errno = %d\n",
-			       errno);
+			pr_err("TUNSETIFF failed, errno = %d\n", errno);
 			close(pri->fd);
 			return err;
 		}
@@ -159,8 +156,8 @@ static int tuntap_open(void *data)
 		err = socketpair(AF_UNIX, SOCK_DGRAM, 0, fds);
 		if (err) {
 			err = -errno;
-			printk(KERN_ERR "tuntap_open : socketpair failed - "
-			       "errno = %d\n", errno);
+			pr_err("tuntap_open : socketpair failed - errno = %d\n",
+			       errno);
 			return err;
 		}
 
@@ -176,8 +173,7 @@ static int tuntap_open(void *data)
 		if (err < 0) {
 			printk("%s", output);
 			free_output_buffer(buffer);
-			printk(KERN_ERR "tuntap_open_tramp failed - "
-			       "err = %d\n", -err);
+			pr_err("tuntap_open_tramp failed - err = %d\n", -err);
 			return err;
 		}
 
diff --git a/arch/um/os-Linux/file.c b/arch/um/os-Linux/file.c
index 8bf76d4..e77a9a5 100644
--- a/arch/um/os-Linux/file.c
+++ b/arch/um/os-Linux/file.c
@@ -288,8 +288,7 @@ int os_file_size(const char *file, unsigned long long *size_out)
 
 	err = os_stat_file(file, &buf);
 	if (err < 0) {
-		printk(KERN_ERR "Couldn't stat \"%s\" : err = %d\n", file,
-		       -err);
+		pr_err("Couldn't stat \"%s\" : err = %d\n", file, -err);
 		return err;
 	}
 
@@ -300,14 +299,14 @@ int os_file_size(const char *file, unsigned long long *size_out)
 		fd = open(file, O_RDONLY, 0);
 		if (fd < 0) {
 			err = -errno;
-			printk(KERN_ERR "Couldn't open \"%s\", "
-			       "errno = %d\n", file, errno);
+			pr_err("Couldn't open \"%s\", errno = %d\n",
+			       file, errno);
 			return err;
 		}
 		if (ioctl(fd, BLKGETSIZE, &blocks) < 0) {
 			err = -errno;
-			printk(KERN_ERR "Couldn't get the block size of "
-			       "\"%s\", errno = %d\n", file, errno);
+			pr_err("Couldn't get the block size of \"%s\", errno = %d\n",
+			       file, errno);
 			close(fd);
 			return err;
 		}
@@ -326,8 +325,7 @@ int os_file_modtime(const char *file, unsigned long *modtime)
 
 	err = os_stat_file(file, &buf);
 	if (err < 0) {
-		printk(KERN_ERR "Couldn't stat \"%s\" : err = %d\n", file,
-		       -err);
+		pr_err("Couldn't stat \"%s\" : err = %d\n", file, -err);
 		return err;
 	}
 
@@ -368,8 +366,7 @@ int os_pipe(int *fds, int stream, int close_on_exec)
 	return 0;
 
  error:
-	printk(KERN_ERR "os_pipe : Setting FD_CLOEXEC failed, err = %d\n",
-	       -err);
+	pr_err("os_pipe : Setting FD_CLOEXEC failed, err = %d\n", -err);
 	close(fds[1]);
 	close(fds[0]);
 	return err;
@@ -386,16 +383,16 @@ int os_set_fd_async(int fd)
 	flags |= O_ASYNC | O_NONBLOCK;
 	if (fcntl(fd, F_SETFL, flags) < 0) {
 		err = -errno;
-		printk(KERN_ERR "os_set_fd_async : failed to set O_ASYNC "
-		       "and O_NONBLOCK on fd # %d, errno = %d\n", fd, errno);
+		pr_err("os_set_fd_async : failed to set O_ASYNC and O_NONBLOCK on fd # %d, errno = %d\n",
+		       fd, errno);
 		return err;
 	}
 
 	if ((fcntl(fd, F_SETSIG, SIGIO) < 0) ||
 	    (fcntl(fd, F_SETOWN, os_getpid()) < 0)) {
 		err = -errno;
-		printk(KERN_ERR "os_set_fd_async : Failed to fcntl F_SETOWN "
-		       "(or F_SETSIG) fd %d, errno = %d\n", fd, errno);
+		pr_err("os_set_fd_async : Failed to fcntl F_SETOWN (or F_SETSIG) fd %d, errno = %d\n",
+		       fd, errno);
 		return err;
 	}
 
@@ -502,13 +499,12 @@ int os_rcv_fd(int fd, int *helper_pid_out)
 
 	cmsg = CMSG_FIRSTHDR(&msg);
 	if (cmsg == NULL) {
-		printk(KERN_ERR "rcv_fd didn't receive anything, "
-		       "error = %d\n", errno);
+		pr_err("rcv_fd didn't receive anything, error = %d\n", errno);
 		return -1;
 	}
 	if ((cmsg->cmsg_level != SOL_SOCKET) ||
 	    (cmsg->cmsg_type != SCM_RIGHTS)) {
-		printk(KERN_ERR "rcv_fd didn't receive a descriptor\n");
+		pr_err("rcv_fd didn't receive a descriptor\n");
 		return -1;
 	}
 
@@ -528,8 +524,8 @@ int os_create_unix_socket(const char *file, int len, int close_on_exec)
 	if (close_on_exec) {
 		err = os_set_exec_close(sock);
 		if (err < 0)
-			printk(KERN_ERR "create_unix_socket : "
-			       "close_on_exec failed, err = %d", -err);
+			pr_err("create_unix_socket : close_on_exec failed, err = %d\n",
+			       -err);
 	}
 
 	addr.sun_family = AF_UNIX;
@@ -568,8 +564,7 @@ int os_lock_file(int fd, int excl)
 		goto out;
 	}
 
-	printk(KERN_ERR "F_SETLK failed, file already locked by pid %d\n",
-	       lock.l_pid);
+	pr_err("F_SETLK failed, file already locked by pid %d\n", lock.l_pid);
 	err = save;
  out:
 	return err;
diff --git a/arch/um/os-Linux/helper.c b/arch/um/os-Linux/helper.c
index 0f6af24..001a2a7 100644
--- a/arch/um/os-Linux/helper.c
+++ b/arch/um/os-Linux/helper.c
@@ -52,15 +52,14 @@ int run_helper(void (*pre_exec)(void *), void *pre_data, char **argv)
 	ret = socketpair(AF_UNIX, SOCK_STREAM, 0, fds);
 	if (ret < 0) {
 		ret = -errno;
-		printk(KERN_ERR "run_helper : pipe failed, errno = %d\n",
-		       errno);
+		pr_err("run_helper : pipe failed, errno = %d\n", errno);
 		goto out_free;
 	}
 
 	ret = os_set_exec_close(fds[1]);
 	if (ret < 0) {
-		printk(KERN_ERR "run_helper : setting FD_CLOEXEC failed, "
-		       "ret = %d\n", -ret);
+		pr_err("run_helper : setting FD_CLOEXEC failed, ret = %d\n",
+		       -ret);
 		goto out_close;
 	}
 
@@ -74,8 +73,7 @@ int run_helper(void (*pre_exec)(void *), void *pre_data, char **argv)
 	pid = clone(helper_child, (void *) sp, CLONE_VM, &data);
 	if (pid < 0) {
 		ret = -errno;
-		printk(KERN_ERR "run_helper : clone failed, errno = %d\n",
-		       errno);
+		pr_err("run_helper : clone failed, errno = %d\n", errno);
 		goto out_free2;
 	}
 
@@ -92,8 +90,8 @@ int run_helper(void (*pre_exec)(void *), void *pre_data, char **argv)
 	} else {
 		if (n < 0) {
 			n = -errno;
-			printk(KERN_ERR "run_helper : read on pipe failed, "
-			       "ret = %d\n", -n);
+			pr_err("run_helper : read on pipe failed, ret = %d\n",
+			       -n);
 			ret = n;
 		}
 		CATCH_EINTR(waitpid(pid, NULL, __WCLONE));
@@ -124,21 +122,20 @@ int run_helper_thread(int (*proc)(void *), void *arg, unsigned int flags,
 	pid = clone(proc, (void *) sp, flags, arg);
 	if (pid < 0) {
 		err = -errno;
-		printk(KERN_ERR "run_helper_thread : clone failed, "
-		       "errno = %d\n", errno);
+		pr_err("run_helper_thread : clone failed, errno = %d\n", errno);
 		return err;
 	}
 	if (stack_out == NULL) {
 		CATCH_EINTR(pid = waitpid(pid, &status, __WCLONE));
 		if (pid < 0) {
 			err = -errno;
-			printk(KERN_ERR "run_helper_thread - wait failed, "
-			       "errno = %d\n", errno);
+			pr_err("run_helper_thread - wait failed, errno = %d\n",
+			       errno);
 			pid = err;
 		}
 		if (!WIFEXITED(status) || (WEXITSTATUS(status) != 0))
-			printk(KERN_ERR "run_helper_thread - thread "
-			       "returned status 0x%x\n", status);
+			pr_err("run_helper_thread - thread returned status 0x%x\n",
+			       status);
 		free_stack(stack, 0);
 	} else
 		*stack_out = stack;
@@ -152,12 +149,12 @@ int helper_wait(int pid)
 
 	CATCH_EINTR(ret = waitpid(pid, &status, wflags));
 	if (ret < 0) {
-		printk(KERN_ERR "helper_wait : waitpid process %d failed, "
-		       "errno = %d\n", pid, errno);
+		pr_err("helper_wait : waitpid process %d failed, errno = %d\n",
+		       pid, errno);
 		return -errno;
 	} else if (!WIFEXITED(status) || WEXITSTATUS(status) != 0) {
-		printk(KERN_ERR "helper_wait : process %d exited with "
-		       "status 0x%x\n", pid, status);
+		pr_err("helper_wait : process %d exited with status 0x%x\n",
+		       pid, status);
 		return -ECHILD;
 	} else
 		return 0;
diff --git a/arch/um/os-Linux/irq.c b/arch/um/os-Linux/irq.c
index 487a55e..98746c4 100644
--- a/arch/um/os-Linux/irq.c
+++ b/arch/um/os-Linux/irq.c
@@ -29,8 +29,8 @@ int os_waiting_for_events(struct irq_fd *active_fds)
 	if (n < 0) {
 		err = -errno;
 		if (errno != EINTR)
-			printk(KERN_ERR "os_waiting_for_events:"
-			       " poll returned %d, errno = %d\n", n, errno);
+			pr_err("os_waiting_for_events: poll returned %d, errno = %d\n",
+			       n, errno);
 		return err;
 	}
 
@@ -88,9 +88,7 @@ void os_free_irq_by_cb(int (*test)(struct irq_fd *, void *), void *arg,
 			struct irq_fd *old_fd = *prev;
 			if ((pollfds[i].fd != -1) &&
 			    (pollfds[i].fd != (*prev)->fd)) {
-				printk(KERN_ERR "os_free_irq_by_cb - "
-				       "mismatch between active_fds and "
-				       "pollfds, fd %d vs %d\n",
+				pr_err("os_free_irq_by_cb - mismatch between active_fds and pollfds, fd %d vs %d\n",
 				       (*prev)->fd, pollfds[i].fd);
 				goto out;
 			}
diff --git a/arch/um/os-Linux/process.c b/arch/um/os-Linux/process.c
index 3a46345..ca87bde 100644
--- a/arch/um/os-Linux/process.c
+++ b/arch/um/os-Linux/process.c
@@ -32,14 +32,14 @@ unsigned long os_process_pc(int pid)
 	sprintf(proc_stat, "/proc/%d/stat", pid);
 	fd = open(proc_stat, O_RDONLY, 0);
 	if (fd < 0) {
-		printk(KERN_ERR "os_process_pc - couldn't open '%s', "
-		       "errno = %d\n", proc_stat, errno);
+		pr_err("os_process_pc - couldn't open '%s', errno = %d\n",
+		       proc_stat, errno);
 		goto out;
 	}
 	CATCH_EINTR(err = read(fd, buf, sizeof(buf)));
 	if (err < 0) {
-		printk(KERN_ERR "os_process_pc - couldn't read '%s', "
-		       "err = %d\n", proc_stat, errno);
+		pr_err("os_process_pc - couldn't read '%s', err = %d\n",
+		       proc_stat, errno);
 		goto out_close;
 	}
 	os_close_file(fd);
@@ -47,8 +47,7 @@ unsigned long os_process_pc(int pid)
 	if (sscanf(buf, "%*d " COMM_SCANF " %*c %*d %*d %*d %*d %*d %*d %*d "
 		   "%*d %*d %*d %*d %*d %*d %*d %*d %*d %*d %*d %*d %*d %*d "
 		   "%*d %*d %*d %*d %*d %lu", &pc) != 1)
-		printk(KERN_ERR "os_process_pc - couldn't find pc in '%s'\n",
-		       buf);
+		pr_err("os_process_pc - couldn't find pc in '%s'\n", buf);
  out_close:
 	close(fd);
  out:
@@ -67,8 +66,7 @@ int os_process_parent(int pid)
 	snprintf(stat, sizeof(stat), "/proc/%d/stat", pid);
 	fd = open(stat, O_RDONLY, 0);
 	if (fd < 0) {
-		printk(KERN_ERR "Couldn't open '%s', errno = %d\n", stat,
-		       errno);
+		pr_err("Couldn't open '%s', errno = %d\n", stat, errno);
 		return parent;
 	}
 
@@ -76,15 +74,14 @@ int os_process_parent(int pid)
 	close(fd);
 
 	if (n < 0) {
-		printk(KERN_ERR "Couldn't read '%s', errno = %d\n", stat,
-		       errno);
+		pr_err("Couldn't read '%s', errno = %d\n", stat, errno);
 		return parent;
 	}
 
 	parent = FAILURE_PID;
 	n = sscanf(data, "%*d " COMM_SCANF " %*c %d", &parent);
 	if (n != 1)
-		printk(KERN_ERR "Failed to scan '%s'\n", data);
+		pr_err("Failed to scan '%s'\n", data);
 
 	return parent;
 }
@@ -185,28 +182,26 @@ int __init can_drop_memory(void)
 	void *addr;
 	int fd, ok = 0;
 
-	printk(KERN_INFO "Checking host MADV_REMOVE support...");
+	pr_info("Checking host MADV_REMOVE support...");
 	fd = create_mem_file(UM_KERN_PAGE_SIZE);
 	if (fd < 0) {
-		printk(KERN_ERR "Creating test memory file failed, "
-		       "err = %d\n", -fd);
+		pr_err("Creating test memory file failed, err = %d\n", -fd);
 		goto out;
 	}
 
 	addr = mmap64(NULL, UM_KERN_PAGE_SIZE, PROT_READ | PROT_WRITE,
 		      MAP_SHARED, fd, 0);
 	if (addr == MAP_FAILED) {
-		printk(KERN_ERR "Mapping test memory file failed, "
-		       "err = %d\n", -errno);
+		pr_err("Mapping test memory file failed, err = %d\n", -errno);
 		goto out_close;
 	}
 
 	if (madvise(addr, UM_KERN_PAGE_SIZE, MADV_REMOVE) != 0) {
-		printk(KERN_ERR "MADV_REMOVE failed, err = %d\n", -errno);
+		pr_err("MADV_REMOVE failed, err = %d\n", -errno);
 		goto out_unmap;
 	}
 
-	printk(KERN_CONT "OK\n");
+	pr_cont("OK\n");
 	ok = 1;
 
 out_unmap:
diff --git a/arch/um/os-Linux/sigio.c b/arch/um/os-Linux/sigio.c
index 14633a5..a9208a7 100644
--- a/arch/um/os-Linux/sigio.c
+++ b/arch/um/os-Linux/sigio.c
@@ -62,8 +62,8 @@ static int write_sigio_thread(void *unused)
 		if (n < 0) {
 			if (errno == EINTR)
 				continue;
-			printk(KERN_ERR "write_sigio_thread : poll returned "
-			       "%d, errno = %d\n", n, errno);
+			pr_err("write_sigio_thread : poll returned %d, errno = %d\n",
+			       n, errno);
 		}
 		for (i = 0; i < fds->used; i++) {
 			p = &fds->poll[i];
@@ -73,10 +73,8 @@ static int write_sigio_thread(void *unused)
 				CATCH_EINTR(n = read(sigio_private[1], &c,
 						     sizeof(c)));
 				if (n != sizeof(c))
-					printk(KERN_ERR
-					       "write_sigio_thread : "
-					       "read on socket failed, "
-					       "err = %d\n", errno);
+					pr_err("write_sigio_thread : read on socket failed, err = %d\n",
+					       errno);
 				tmp = current_poll;
 				current_poll = next_poll;
 				next_poll = tmp;
@@ -91,8 +89,7 @@ static int write_sigio_thread(void *unused)
 
 			CATCH_EINTR(n = write(respond_fd, &c, sizeof(c)));
 			if (n != sizeof(c))
-				printk(KERN_ERR "write_sigio_thread : "
-				       "write on socket failed, err = %d\n",
+				pr_err("write_sigio_thread : write on socket failed, err = %d\n",
 				       errno);
 		}
 	}
@@ -109,8 +106,7 @@ static int need_poll(struct pollfds *polls, int n)
 
 	new = uml_kmalloc(n * sizeof(struct pollfd), UM_GFP_ATOMIC);
 	if (new == NULL) {
-		printk(KERN_ERR "need_poll : failed to allocate new "
-		       "pollfds\n");
+		pr_err("need_poll : failed to allocate new pollfds\n");
 		return -ENOMEM;
 	}
 
@@ -135,15 +131,13 @@ static void update_thread(void)
 	flags = set_signals(0);
 	CATCH_EINTR(n = write(sigio_private[0], &c, sizeof(c)));
 	if (n != sizeof(c)) {
-		printk(KERN_ERR "update_thread : write failed, err = %d\n",
-		       errno);
+		pr_err("update_thread : write failed, err = %d\n", errno);
 		goto fail;
 	}
 
 	CATCH_EINTR(n = read(sigio_private[0], &c, sizeof(c)));
 	if (n != sizeof(c)) {
-		printk(KERN_ERR "update_thread : read failed, err = %d\n",
-		       errno);
+		pr_err("update_thread : read failed, err = %d\n", errno);
 		goto fail;
 	}
 
@@ -243,8 +237,7 @@ static struct pollfd *setup_initial_poll(int fd)
 
 	p = uml_kmalloc(sizeof(struct pollfd), UM_GFP_KERNEL);
 	if (p == NULL) {
-		printk(KERN_ERR "setup_initial_poll : failed to allocate "
-		       "poll\n");
+		pr_err("setup_initial_poll : failed to allocate poll\n");
 		return NULL;
 	}
 	*p = ((struct pollfd) { .fd		= fd,
@@ -271,14 +264,14 @@ static void write_sigio_workaround(void)
 
 	err = os_pipe(l_write_sigio_fds, 1, 1);
 	if (err < 0) {
-		printk(KERN_ERR "write_sigio_workaround - os_pipe 1 failed, "
-		       "err = %d\n", -err);
+		pr_err("write_sigio_workaround - os_pipe 1 failed, err = %d\n",
+		       -err);
 		return;
 	}
 	err = os_pipe(l_sigio_private, 1, 1);
 	if (err < 0) {
-		printk(KERN_ERR "write_sigio_workaround - os_pipe 2 failed, "
-		       "err = %d\n", -err);
+		pr_err("write_sigio_workaround - os_pipe 2 failed, err = %d\n",
+		       -err);
 		goto out_close1;
 	}
 
@@ -345,8 +338,8 @@ void sigio_broken(int fd, int read)
 	sigio_lock();
 	err = need_poll(&all_sigio_fds, all_sigio_fds.used + 1);
 	if (err) {
-		printk(KERN_ERR "maybe_sigio_broken - failed to add pollfd "
-		       "for descriptor %d\n", fd);
+		pr_err("maybe_sigio_broken - failed to add pollfd for descriptor %d\n",
+		       fd);
 		goto out;
 	}
 
@@ -434,8 +427,7 @@ static void __init check_one_sigio(void (*proc)(int, int))
 
 	initial_thread_cb(openpty_cb, &pty);
 	if (pty.err) {
-		printk(KERN_ERR "check_one_sigio failed, errno = %d\n",
-		       -pty.err);
+		pr_err("check_one_sigio failed, errno = %d\n", -pty.err);
 		return;
 	}
 
@@ -443,37 +435,35 @@ static void __init check_one_sigio(void (*proc)(int, int))
 	slave = pty.slave;
 
 	if ((master == -1) || (slave == -1)) {
-		printk(KERN_ERR "check_one_sigio failed to allocate a "
-		       "pty\n");
+		pr_err("check_one_sigio failed to allocate a pty\n");
 		return;
 	}
 
 	/* Not now, but complain so we now where we failed. */
 	err = raw(master);
 	if (err < 0) {
-		printk(KERN_ERR "check_one_sigio : raw failed, errno = %d\n",
-		      -err);
+		pr_err("check_one_sigio : raw failed, errno = %d\n", -err);
 		return;
 	}
 
 	err = async_pty(master, slave);
 	if (err < 0) {
-		printk(KERN_ERR "check_one_sigio : sigio_async failed, "
-		       "err = %d\n", -err);
+		pr_err("check_one_sigio : sigio_async failed, err = %d\n",
+		       -err);
 		return;
 	}
 
 	if (sigaction(SIGIO, NULL, &old) < 0) {
-		printk(KERN_ERR "check_one_sigio : sigaction 1 failed, "
-		       "errno = %d\n", errno);
+		pr_err("check_one_sigio : sigaction 1 failed, errno = %d\n",
+		       errno);
 		return;
 	}
 
 	new = old;
 	new.sa_handler = handler;
 	if (sigaction(SIGIO, &new, NULL) < 0) {
-		printk(KERN_ERR "check_one_sigio : sigaction 2 failed, "
-		       "errno = %d\n", errno);
+		pr_err("check_one_sigio : sigaction 2 failed, errno = %d\n",
+		       errno);
 		return;
 	}
 
@@ -484,8 +474,8 @@ static void __init check_one_sigio(void (*proc)(int, int))
 	close(slave);
 
 	if (sigaction(SIGIO, &old, NULL) < 0)
-		printk(KERN_ERR "check_one_sigio : sigaction 3 failed, "
-		       "errno = %d\n", errno);
+		pr_err("check_one_sigio : sigaction 3 failed, errno = %d\n",
+		       errno);
 }
 
 static void tty_output(int master, int slave)
@@ -493,46 +483,43 @@ static void tty_output(int master, int slave)
 	int n;
 	char buf[512];
 
-	printk(KERN_INFO "Checking that host ptys support output SIGIO...");
+	pr_info("Checking that host ptys support output SIGIO...");
 
 	memset(buf, 0, sizeof(buf));
 
 	while (write(master, buf, sizeof(buf)) > 0) ;
 	if (errno != EAGAIN)
-		printk(KERN_ERR "tty_output : write failed, errno = %d\n",
-		       errno);
+		pr_err("tty_output : write failed, errno = %d\n", errno);
 	while (((n = read(slave, buf, sizeof(buf))) > 0) &&
 	       !({ barrier(); got_sigio; }))
 		;
 
 	if (got_sigio) {
-		printk(KERN_CONT "Yes\n");
+		pr_cont("Yes\n");
 		pty_output_sigio = 1;
 	} else if (n == -EAGAIN)
-		printk(KERN_CONT "No, enabling workaround\n");
+		pr_cont("No, enabling workaround\n");
 	else
-		printk(KERN_CONT "tty_output : read failed, err = %d\n", n);
+		pr_cont("tty_output : read failed, err = %d\n", n);
 }
 
 static void tty_close(int master, int slave)
 {
-	printk(KERN_INFO "Checking that host ptys support SIGIO on "
-	       "close...");
+	pr_info("Checking that host ptys support SIGIO on close...");
 
 	close(slave);
 	if (got_sigio) {
-		printk(KERN_CONT "Yes\n");
+		pr_cont("Yes\n");
 		pty_close_sigio = 1;
 	} else
-		printk(KERN_CONT "No, enabling workaround\n");
+		pr_cont("No, enabling workaround\n");
 }
 
 static void __init check_sigio(void)
 {
 	if ((access("/dev/ptmx", R_OK) < 0) &&
 	    (access("/dev/ptyp0", R_OK) < 0)) {
-		printk(KERN_WARNING "No pseudo-terminals available - "
-		       "skipping pty SIGIO check\n");
+		pr_warn("No pseudo-terminals available - skipping pty SIGIO check\n");
 		return;
 	}
 	check_one_sigio(tty_output);
diff --git a/arch/um/os-Linux/skas/mem.c b/arch/um/os-Linux/skas/mem.c
index 4f0da16..7352a2d 100644
--- a/arch/um/os-Linux/skas/mem.c
+++ b/arch/um/os-Linux/skas/mem.c
@@ -55,9 +55,9 @@ static inline long do_syscall_stub(struct mm_id * mm_idp, void **addr)
 
 	n = ptrace_setregs(pid, syscall_regs);
 	if (n < 0) {
-		printk(KERN_ERR "Registers - \n");
+		pr_err("Registers -\n");
 		for (i = 0; i < MAX_REG_NR; i++)
-			printk(KERN_ERR "\t%d\t0x%lx\n", i, syscall_regs[i]);
+			pr_err("\t%d\t0x%lx\n", i, syscall_regs[i]);
 		panic("do_syscall_stub : PTRACE_SETREGS failed, errno = %d\n",
 		      -n);
 	}
@@ -79,26 +79,23 @@ static inline long do_syscall_stub(struct mm_id * mm_idp, void **addr)
 	offset = *((unsigned long *) mm_idp->stack + 1);
 	if (offset) {
 		data = (unsigned long *)(mm_idp->stack + offset - STUB_DATA);
-		printk(KERN_ERR "do_syscall_stub : ret = %ld, offset = %ld, "
-		       "data = %p\n", ret, offset, data);
+		pr_err("do_syscall_stub : ret = %ld, offset = %ld, data = %p\n",
+		       ret, offset, data);
 		syscall = (unsigned long *)((unsigned long)data + data[0]);
-		printk(KERN_ERR "do_syscall_stub: syscall %ld failed, "
-		       "return value = 0x%lx, expected return value = 0x%lx\n",
+		pr_err("do_syscall_stub: syscall %ld failed, return value = 0x%lx, expected return value = 0x%lx\n",
 		       syscall[0], ret, syscall[7]);
-		printk(KERN_ERR "    syscall parameters: "
-		       "0x%lx 0x%lx 0x%lx 0x%lx 0x%lx 0x%lx\n",
+		pr_err("    syscall parameters: 0x%lx 0x%lx 0x%lx 0x%lx 0x%lx 0x%lx\n",
 		       syscall[1], syscall[2], syscall[3],
 		       syscall[4], syscall[5], syscall[6]);
 		for (n = 1; n < data[0]/sizeof(long); n++) {
 			if (n == 1)
-				printk(KERN_ERR "    additional syscall "
-				       "data:");
+				pr_err("    additional syscall data:");
 			if (n % 4 == 1)
-				printk("\n" KERN_ERR "      ");
-			printk("  0x%lx", data[n]);
+				pr_err("      ");
+			pr_cont("  0x%lx", data[n]);
 		}
 		if (n > 1)
-			printk("\n");
+			pr_cont("\n");
 	}
 	else ret = 0;
 
diff --git a/arch/um/os-Linux/skas/process.c b/arch/um/os-Linux/skas/process.c
index 7f8b3de..26619e3 100644
--- a/arch/um/os-Linux/skas/process.c
+++ b/arch/um/os-Linux/skas/process.c
@@ -34,9 +34,9 @@ static int ptrace_dump_regs(int pid)
 	if (ptrace(PTRACE_GETREGS, pid, 0, regs) < 0)
 		return -errno;
 
-	printk(KERN_ERR "Stub registers -\n");
+	pr_err("Stub registers -\n");
 	for (i = 0; i < ARRAY_SIZE(regs); i++)
-		printk(KERN_ERR "\t%d - %lx\n", i, regs[i]);
+		pr_err("\t%d - %lx\n", i, regs[i]);
 
 	return 0;
 }
@@ -64,8 +64,8 @@ void wait_stub_done(int pid)
 
 		err = ptrace(PTRACE_CONT, pid, 0, 0);
 		if (err) {
-			printk(KERN_ERR "wait_stub_done : continue failed, "
-			       "errno = %d\n", errno);
+			pr_err("wait_stub_done : continue failed, errno = %d\n",
+			       errno);
 			fatal_sigsegv();
 		}
 	}
@@ -78,11 +78,9 @@ void wait_stub_done(int pid)
 bad_wait:
 	err = ptrace_dump_regs(pid);
 	if (err)
-		printk(KERN_ERR "Failed to get registers from stub, "
-		       "errno = %d\n", -err);
-	printk(KERN_ERR "wait_stub_done : failed to wait for SIGTRAP, "
-	       "pid = %d, n = %d, errno = %d, status = 0x%x\n", pid, n, errno,
-	       status);
+		pr_err("Failed to get registers from stub, errno = %d\n", -err);
+	pr_err("wait_stub_done : failed to wait for SIGTRAP, pid = %d, n = %d, errno = %d, status = 0x%x\n",
+	       pid, n, errno, status);
 	if (bad_stop)
 		kill(pid, SIGKILL);
 	else
@@ -98,14 +96,13 @@ static void get_skas_faultinfo(int pid, struct faultinfo *fi)
 
 	err = get_fp_registers(pid, fpregs);
 	if (err < 0) {
-		printk(KERN_ERR "save_fp_registers returned %d\n",
-		       err);
+		pr_err("save_fp_registers returned %d\n", err);
 		fatal_sigsegv();
 	}
 	err = ptrace(PTRACE_CONT, pid, 0, SIGSEGV);
 	if (err) {
-		printk(KERN_ERR "Failed to continue stub, pid = %d, "
-		       "errno = %d\n", pid, errno);
+		pr_err("Failed to continue stub, pid = %d, errno = %d\n",
+		       pid, errno);
 		fatal_sigsegv();
 	}
 	wait_stub_done(pid);
@@ -118,8 +115,7 @@ static void get_skas_faultinfo(int pid, struct faultinfo *fi)
 
 	err = put_fp_registers(pid, fpregs);
 	if (err < 0) {
-		printk(KERN_ERR "put_fp_registers returned %d\n",
-		       err);
+		pr_err("put_fp_registers returned %d\n", err);
 		fatal_sigsegv();
 	}
 }
@@ -150,15 +146,15 @@ static void handle_trap(int pid, struct uml_pt_regs *regs,
 		err = ptrace(PTRACE_POKEUSER, pid, PT_SYSCALL_NR_OFFSET,
 			     __NR_getpid);
 		if (err < 0) {
-			printk(KERN_ERR "handle_trap - nullifying syscall "
-			       "failed, errno = %d\n", errno);
+			pr_err("handle_trap - nullifying syscall failed, errno = %d\n",
+			       errno);
 			fatal_sigsegv();
 		}
 
 		err = ptrace(PTRACE_SYSCALL, pid, 0, 0);
 		if (err < 0) {
-			printk(KERN_ERR "handle_trap - continuing to end of "
-			       "syscall failed, errno = %d\n", errno);
+			pr_err("handle_trap - continuing to end of syscall failed, errno = %d\n",
+			       errno);
 			fatal_sigsegv();
 		}
 
@@ -167,10 +163,9 @@ static void handle_trap(int pid, struct uml_pt_regs *regs,
 		    (WSTOPSIG(status) != SIGTRAP + 0x80)) {
 			err = ptrace_dump_regs(pid);
 			if (err)
-				printk(KERN_ERR "Failed to get registers "
-				       "from process, errno = %d\n", -err);
-			printk(KERN_ERR "handle_trap - failed to wait at "
-			       "end of syscall, errno = %d, status = %d\n",
+				pr_err("Failed to get registers from process, errno = %d\n",
+				       -err);
+			pr_err("handle_trap - failed to wait at end of syscall, errno = %d, status = %d\n",
 			       errno, status);
 			fatal_sigsegv();
 		}
@@ -193,8 +188,8 @@ static int userspace_tramp(void *stack)
 	signal(SIGWINCH, SIG_IGN);
 	err = set_interval();
 	if (err) {
-		printk(KERN_ERR "userspace_tramp - setting timer failed, "
-		       "errno = %d\n", err);
+		pr_err("userspace_tramp - setting timer failed, errno = %d\n",
+		       err);
 		exit(1);
 	}
 
@@ -206,8 +201,8 @@ static int userspace_tramp(void *stack)
 	addr = mmap64((void *) STUB_CODE, UM_KERN_PAGE_SIZE,
 		      PROT_EXEC, MAP_FIXED | MAP_PRIVATE, fd, offset);
 	if (addr == MAP_FAILED) {
-		printk(KERN_ERR "mapping mmap stub at 0x%lx failed, "
-		       "errno = %d\n", STUB_CODE, errno);
+		pr_err("mapping mmap stub at 0x%lx failed, errno = %d\n",
+		       STUB_CODE, errno);
 		exit(1);
 	}
 
@@ -217,8 +212,7 @@ static int userspace_tramp(void *stack)
 			    UM_KERN_PAGE_SIZE, PROT_READ | PROT_WRITE,
 			    MAP_FIXED | MAP_SHARED, fd, offset);
 		if (addr == MAP_FAILED) {
-			printk(KERN_ERR "mapping segfault stack "
-			       "at 0x%lx failed, errno = %d\n",
+			pr_err("mapping segfault stack at 0x%lx failed, errno = %d\n",
 			       STUB_DATA, errno);
 			exit(1);
 		}
@@ -236,8 +230,8 @@ static int userspace_tramp(void *stack)
 		sa.sa_sigaction = (void *) v;
 		sa.sa_restorer = NULL;
 		if (sigaction(SIGSEGV, &sa, NULL) < 0) {
-			printk(KERN_ERR "userspace_tramp - setting SIGSEGV "
-			       "handler failed - errno = %d\n", errno);
+			pr_err("userspace_tramp - setting SIGSEGV handler failed - errno = %d\n",
+			       errno);
 			exit(1);
 		}
 	}
@@ -262,8 +256,7 @@ int start_userspace(unsigned long stub_stack)
 		     MAP_PRIVATE | MAP_ANONYMOUS, -1, 0);
 	if (stack == MAP_FAILED) {
 		err = -errno;
-		printk(KERN_ERR "start_userspace : mmap failed, "
-		       "errno = %d\n", errno);
+		pr_err("start_userspace : mmap failed, errno = %d\n", errno);
 		return err;
 	}
 
@@ -274,8 +267,7 @@ int start_userspace(unsigned long stub_stack)
 	pid = clone(userspace_tramp, (void *) sp, flags, (void *) stub_stack);
 	if (pid < 0) {
 		err = -errno;
-		printk(KERN_ERR "start_userspace : clone failed, "
-		       "errno = %d\n", errno);
+		pr_err("start_userspace : clone failed, errno = %d\n", errno);
 		return err;
 	}
 
@@ -283,31 +275,30 @@ int start_userspace(unsigned long stub_stack)
 		CATCH_EINTR(n = waitpid(pid, &status, WUNTRACED | __WALL));
 		if (n < 0) {
 			err = -errno;
-			printk(KERN_ERR "start_userspace : wait failed, "
-			       "errno = %d\n", errno);
+			pr_err("start_userspace : wait failed, errno = %d\n",
+			       errno);
 			goto out_kill;
 		}
 	} while (WIFSTOPPED(status) && (WSTOPSIG(status) == SIGVTALRM));
 
 	if (!WIFSTOPPED(status) || (WSTOPSIG(status) != SIGSTOP)) {
 		err = -EINVAL;
-		printk(KERN_ERR "start_userspace : expected SIGSTOP, got "
-		       "status = %d\n", status);
+		pr_err("start_userspace : expected SIGSTOP, got status = %d\n",
+		       status);
 		goto out_kill;
 	}
 
 	if (ptrace(PTRACE_OLDSETOPTIONS, pid, NULL,
 		   (void *) PTRACE_O_TRACESYSGOOD) < 0) {
 		err = -errno;
-		printk(KERN_ERR "start_userspace : PTRACE_OLDSETOPTIONS "
-		       "failed, errno = %d\n", errno);
+		pr_err("start_userspace : PTRACE_OLDSETOPTIONS failed, errno = %d\n",
+		       errno);
 		goto out_kill;
 	}
 
 	if (munmap(stack, UM_KERN_PAGE_SIZE) < 0) {
 		err = -errno;
-		printk(KERN_ERR "start_userspace : munmap failed, "
-		       "errno = %d\n", errno);
+		pr_err("start_userspace : munmap failed, errno = %d\n", errno);
 		goto out_kill;
 	}
 
@@ -331,7 +322,7 @@ void userspace(struct uml_pt_regs *regs)
 	interrupt_end();
 
 	if (getitimer(ITIMER_VIRTUAL, &timer))
-		printk(KERN_ERR "Failed to get itimer, errno = %d\n", errno);
+		pr_err("Failed to get itimer, errno = %d\n", errno);
 	nsecs = timer.it_value.tv_sec * UM_NSEC_PER_SEC +
 		timer.it_value.tv_usec * UM_NSEC_PER_USEC;
 	nsecs += os_nsecs();
@@ -358,28 +349,27 @@ void userspace(struct uml_pt_regs *regs)
 					     singlestepping(NULL));
 
 		if (ptrace(op, pid, 0, 0)) {
-			printk(KERN_ERR "userspace - ptrace continue "
-			       "failed, op = %d, errno = %d\n", op, errno);
+			pr_err("userspace - ptrace continue failed, op = %d, errno = %d\n",
+			       op, errno);
 			fatal_sigsegv();
 		}
 
 		CATCH_EINTR(err = waitpid(pid, &status, WUNTRACED | __WALL));
 		if (err < 0) {
-			printk(KERN_ERR "userspace - wait failed, "
-			       "errno = %d\n", errno);
+			pr_err("userspace - wait failed, errno = %d\n", errno);
 			fatal_sigsegv();
 		}
 
 		regs->is_user = 1;
 		if (ptrace(PTRACE_GETREGS, pid, 0, regs->gp)) {
-			printk(KERN_ERR "userspace - PTRACE_GETREGS failed, "
-			       "errno = %d\n", errno);
+			pr_err("userspace - PTRACE_GETREGS failed, errno = %d\n",
+			       errno);
 			fatal_sigsegv();
 		}
 
 		if (get_fp_registers(pid, regs->fp)) {
-			printk(KERN_ERR "userspace -  get_fp_registers failed, "
-			       "errno = %d\n", errno);
+			pr_err("userspace -  get_fp_registers failed, errno = %d\n",
+			       errno);
 			fatal_sigsegv();
 		}
 
@@ -429,8 +419,8 @@ void userspace(struct uml_pt_regs *regs)
 				unblock_signals();
 				break;
 			default:
-				printk(KERN_ERR "userspace - child stopped "
-				       "with signal %d\n", sig);
+				pr_err("userspace - child stopped with signal %d\n",
+				       sig);
 				fatal_sigsegv();
 			}
 			pid = userspace_pid[0];
@@ -486,15 +476,15 @@ int copy_context_skas0(unsigned long new_stack, int pid)
 	err = ptrace_setregs(pid, thread_regs);
 	if (err < 0) {
 		err = -errno;
-		printk(KERN_ERR "copy_context_skas0 : PTRACE_SETREGS "
-		       "failed, pid = %d, errno = %d\n", pid, -err);
+		pr_err("copy_context_skas0 : PTRACE_SETREGS failed, pid = %d, errno = %d\n",
+		       pid, -err);
 		return err;
 	}
 
 	err = put_fp_registers(pid, thread_fp_regs);
 	if (err < 0) {
-		printk(KERN_ERR "copy_context_skas0 : put_fp_registers "
-		       "failed, pid = %d, err = %d\n", pid, err);
+		pr_err("copy_context_skas0 : put_fp_registers failed, pid = %d, err = %d\n",
+		       pid, err);
 		return err;
 	}
 
@@ -508,8 +498,8 @@ int copy_context_skas0(unsigned long new_stack, int pid)
 	err = ptrace(PTRACE_CONT, pid, 0, 0);
 	if (err) {
 		err = -errno;
-		printk(KERN_ERR "Failed to continue new process, pid = %d, "
-		       "errno = %d\n", pid, errno);
+		pr_err("Failed to continue new process, pid = %d, errno = %d\n",
+		       pid, errno);
 		return err;
 	}
 
@@ -517,8 +507,8 @@ int copy_context_skas0(unsigned long new_stack, int pid)
 
 	pid = data->err;
 	if (pid < 0) {
-		printk(KERN_ERR "copy_context_skas0 - stub-parent reports "
-		       "error %d\n", -pid);
+		pr_err("copy_context_skas0 - stub-parent reports error %d\n",
+		       -pid);
 		return pid;
 	}
 
@@ -528,8 +518,8 @@ int copy_context_skas0(unsigned long new_stack, int pid)
 	 */
 	wait_stub_done(pid);
 	if (child_data->err != STUB_DATA) {
-		printk(KERN_ERR "copy_context_skas0 - stub-child reports "
-		       "error %ld\n", child_data->err);
+		pr_err("copy_context_skas0 - stub-child reports error %ld\n",
+		       child_data->err);
 		err = child_data->err;
 		goto out_kill;
 	}
@@ -537,8 +527,8 @@ int copy_context_skas0(unsigned long new_stack, int pid)
 	if (ptrace(PTRACE_OLDSETOPTIONS, pid, NULL,
 		   (void *)PTRACE_O_TRACESYSGOOD) < 0) {
 		err = -errno;
-		printk(KERN_ERR "copy_context_skas0 : PTRACE_OLDSETOPTIONS "
-		       "failed, errno = %d\n", errno);
+		pr_err("copy_context_skas0 : PTRACE_OLDSETOPTIONS failed, errno = %d\n",
+		       errno);
 		goto out_kill;
 	}
 
@@ -606,8 +596,7 @@ int start_idle_thread(void *stack, jmp_buf *switch_buf)
 		kmalloc_ok = 0;
 		return 1;
 	default:
-		printk(KERN_ERR "Bad sigsetjmp return in "
-		       "start_idle_thread - %d\n", n);
+		pr_err("Bad sigsetjmp return in start_idle_thread - %d\n", n);
 		fatal_sigsegv();
 	}
 	longjmp(*switch_buf, 1);
diff --git a/arch/um/os-Linux/time.c b/arch/um/os-Linux/time.c
index d6037c1..2899473 100644
--- a/arch/um/os-Linux/time.c
+++ b/arch/um/os-Linux/time.c
@@ -61,8 +61,7 @@ long long disable_timer(void)
 	long long remain, max = UM_NSEC_PER_SEC / UM_HZ;
 
 	if (setitimer(ITIMER_VIRTUAL, &time, &time) < 0)
-		printk(KERN_ERR "disable_timer - setitimer failed, "
-		       "errno = %d\n", errno);
+		pr_err("disable_timer - setitimer failed, errno = %d\n", errno);
 
 	remain = timeval_to_ns(&time.it_value);
 	if (remain > max)
diff --git a/arch/um/os-Linux/tty.c b/arch/um/os-Linux/tty.c
index aca9032..373aa73 100644
--- a/arch/um/os-Linux/tty.c
+++ b/arch/um/os-Linux/tty.c
@@ -32,8 +32,7 @@ int get_pty(void)
 	fd = open("/dev/ptmx", O_RDWR);
 	if (fd < 0) {
 		err = -errno;
-		printk(KERN_ERR "get_pty : Couldn't open /dev/ptmx - "
-		       "err = %d\n", errno);
+		pr_err("get_pty : Couldn't open /dev/ptmx - err = %d\n", errno);
 		return err;
 	}
 
@@ -42,15 +41,14 @@ int get_pty(void)
 
 	if (info.res < 0) {
 		err = -info.err;
-		printk(KERN_ERR "get_pty : Couldn't grant pty - "
-		       "errno = %d\n", -info.err);
+		pr_err("get_pty : Couldn't grant pty - errno = %d\n",
+		       -info.err);
 		goto out;
 	}
 
 	if (unlockpt(fd) < 0) {
 		err = -errno;
-		printk(KERN_ERR "get_pty : Couldn't unlock pty - "
-		       "errno = %d\n", errno);
+		pr_err("get_pty : Couldn't unlock pty - errno = %d\n", errno);
 		goto out;
 	}
 	return fd;
diff --git a/arch/um/os-Linux/umid.c b/arch/um/os-Linux/umid.c
index e53dd97..955abbd 100644
--- a/arch/um/os-Linux/umid.c
+++ b/arch/um/os-Linux/umid.c
@@ -35,8 +35,7 @@ static int __init make_uml_dir(void)
 
 		err = -ENOENT;
 		if (home == NULL) {
-			printk(KERN_ERR "make_uml_dir : no value in "
-			       "environment for $HOME\n");
+			pr_err("make_uml_dir : no value in environment for $HOME\n");
 			goto err;
 		}
 		strlcpy(dir, home, sizeof(dir));
@@ -138,7 +137,7 @@ static inline int is_umdir_used(char *dir)
 
 	n = snprintf(file, sizeof(file), "%s/pid", dir);
 	if (n >= sizeof(file)) {
-		printk(KERN_ERR "is_umdir_used - pid filename too long\n");
+		pr_err("is_umdir_used - pid filename too long\n");
 		err = -E2BIG;
 		goto out;
 	}
@@ -148,8 +147,8 @@ static inline int is_umdir_used(char *dir)
 	if (fd < 0) {
 		fd = -errno;
 		if (fd != -ENOENT) {
-			printk(KERN_ERR "is_umdir_used : couldn't open pid "
-			       "file '%s', err = %d\n", file, -fd);
+			pr_err("is_umdir_used : couldn't open pid file '%s', err = %d\n",
+			       file, -fd);
 		}
 		goto out;
 	}
@@ -157,25 +156,24 @@ static inline int is_umdir_used(char *dir)
 	err = 0;
 	n = read(fd, pid, sizeof(pid));
 	if (n < 0) {
-		printk(KERN_ERR "is_umdir_used : couldn't read pid file "
-		       "'%s', err = %d\n", file, errno);
+		pr_err("is_umdir_used : couldn't read pid file '%s', err = %d\n",
+		       file, errno);
 		goto out_close;
 	} else if (n == 0) {
-		printk(KERN_ERR "is_umdir_used : couldn't read pid file "
-		       "'%s', 0-byte read\n", file);
+		pr_err("is_umdir_used : couldn't read pid file '%s', 0-byte read\n",
+		       file);
 		goto out_close;
 	}
 
 	p = strtoul(pid, &end, 0);
 	if (end == pid) {
-		printk(KERN_ERR "is_umdir_used : couldn't parse pid file "
-		       "'%s', errno = %d\n", file, errno);
+		pr_err("is_umdir_used : couldn't parse pid file '%s', errno = %d\n",
+		       file, errno);
 		goto out_close;
 	}
 
 	if ((kill(p, 0) == 0) || (errno != ESRCH)) {
-		printk(KERN_ERR "umid \"%s\" is already in use by pid %d\n",
-		       umid, p);
+		pr_err("umid \"%s\" is already in use by pid %d\n", umid, p);
 		return 1;
 	}
 
@@ -199,8 +197,8 @@ static int umdir_take_if_dead(char *dir)
 
 	ret = remove_files_and_dir(dir);
 	if (ret) {
-		printk(KERN_ERR "is_umdir_used - remove_files_and_dir "
-		       "failed with err = %d\n", ret);
+		pr_err("is_umdir_used - remove_files_and_dir failed with err = %d\n",
+		       ret);
 	}
 	return ret;
 }
@@ -216,16 +214,15 @@ static void __init create_pid_file(void)
 
 	fd = open(file, O_RDWR | O_CREAT | O_EXCL, 0644);
 	if (fd < 0) {
-		printk(KERN_ERR "Open of machine pid file \"%s\" failed: "
-		       "%s\n", file, strerror(errno));
+		pr_err("Open of machine pid file \"%s\" failed: %s\n",
+		       file, strerror(errno));
 		return;
 	}
 
 	snprintf(pid, sizeof(pid), "%d\n", getpid());
 	n = write(fd, pid, strlen(pid));
 	if (n != strlen(pid))
-		printk(KERN_ERR "Write of pid file failed - err = %d\n",
-		       errno);
+		pr_err("Write of pid file failed - err = %d\n", errno);
 
 	close(fd);
 }
@@ -258,8 +255,8 @@ static int __init make_umid(void)
 		strlcat(tmp, "XXXXXX", sizeof(tmp));
 		fd = mkstemp(tmp);
 		if (fd < 0) {
-			printk(KERN_ERR "make_umid - mkstemp(%s) failed: "
-			       "%s\n", tmp, strerror(errno));
+			pr_err("make_umid - mkstemp(%s) failed: %s\n",
+			       tmp, strerror(errno));
 			err = -errno;
 			goto err;
 		}
@@ -293,8 +290,7 @@ static int __init make_umid(void)
 	}
 	if (err) {
 		err = -errno;
-		printk(KERN_ERR "Failed to create '%s' - err = %d\n", umid,
-		       errno);
+		pr_err("Failed to create '%s' - err = %d\n", umid, errno);
 		goto err;
 	}
 
@@ -316,8 +312,8 @@ static int __init make_umid_init(void)
 	 * If initializing with the given umid failed, then try again with
 	 * a random one.
 	 */
-	printk(KERN_ERR "Failed to initialize umid \"%s\", trying with a "
-	       "random umid\n", umid);
+	pr_err("Failed to initialize umid \"%s\", trying with a random umid\n",
+	       umid);
 	*umid = '\0';
 	make_umid();
 
@@ -336,7 +332,7 @@ int __init umid_file_name(char *name, char *buf, int len)
 
 	n = snprintf(buf, len, "%s%s/%s", uml_dir, umid, name);
 	if (n >= len) {
-		printk(KERN_ERR "umid_file_name : buffer too short\n");
+		pr_err("umid_file_name : buffer too short\n");
 		return -E2BIG;
 	}
 
-- 
1.8.1.2.459.gbcd45b4.dirty


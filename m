Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932077AbaLHWNh (ORCPT <rfc822;w@1wt.eu>);
	Mon, 8 Dec 2014 17:13:37 -0500
Received: from out02.mta.xmission.com ([166.70.13.232]:53434 "EHLO
	out02.mta.xmission.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754042AbaLHWNc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 8 Dec 2014 17:13:32 -0500
From: ebiederm@xmission.com (Eric W. Biederman)
To: Andy Lutomirski <luto@amacapital.net>
Cc: Linux Containers <containers@lists.linux-foundation.org>,
        Josh Triplett <josh@joshtriplett.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Kees Cook <keescook@chromium.org>,
        Michael Kerrisk-manpages <mtk.manpages@gmail.com>,
        Linux API <linux-api@vger.kernel.org>,
        linux-man <linux-man@vger.kernel.org>,
        "linux-kernel\@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        LSM <linux-security-module@vger.kernel.org>,
        Casey Schaufler <casey@schaufler-ca.com>,
        "Serge E. Hallyn" <serge@hallyn.com>,
        Richard Weinberger <richard@nod.at>,
        Kenton Varda <kenton@sandstorm.io>, stable <stable@vger.kernel.org>
References: <52e0643bd47b1e5c65921d6e00aea1f724bb510a.1417281801.git.luto@amacapital.net>
	<87h9xez20g.fsf@x220.int.ebiederm.org>
	<CALCETrXOz4C7Tu8mggBtR=k47ZmkuAhinVUxWJSFyS1Ep0HvRw@mail.gmail.com>
	<87mw75ygwp.fsf@x220.int.ebiederm.org>
	<CALCETrVfO4sBdZcQiZXsofPZMj7pqKeVbX+4g3dAj6WjUca+1w@mail.gmail.com>
	<87fvcxyf28.fsf_-_@x220.int.ebiederm.org>
	<874mtdyexp.fsf_-_@x220.int.ebiederm.org>
	<CALCETrXyC7XPaqj6oe-TmyypOVc_CkZbF6UAAx8YfkyD=gEMOQ@mail.gmail.com>
	<87a935u3nj.fsf@x220.int.ebiederm.org>
	<CALCETrXkEOiyzpvqtXtk1f4sL+M1Q-Y6rV=K91ez3yv2nb4Y0Q@mail.gmail.com>
	<87388xodlj.fsf@x220.int.ebiederm.org>
	<CALCETrXWx2-ZejEHmOi7aSoF-qJMRGR5yseeMhuurZwJRrQbUg@mail.gmail.com>
	<87h9x5re41.fsf_-_@x220.int.ebiederm.org>
Date: Mon, 08 Dec 2014 16:11:15 -0600
In-Reply-To: <87h9x5re41.fsf_-_@x220.int.ebiederm.org> (Eric W. Biederman's
	message of "Mon, 08 Dec 2014 16:06:06 -0600")
Message-ID: <87mw6xpzb0.fsf_-_@x220.int.ebiederm.org>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/24.3 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
X-XM-AID: U2FsdGVkX1+MnR/9RkKfkICXTPsjCrOkmzmcNcBlXj8=
X-SA-Exim-Connect-IP: 67.3.210.55
X-SA-Exim-Mail-From: ebiederm@xmission.com
X-Spam-Report: * -1.0 ALL_TRUSTED Passed through trusted hosts only via SMTP
	*  0.0 TVD_RCVD_IP Message was received from an IP address
	*  0.7 XMSubLong Long Subject
	*  1.5 TR_Symld_Words too many words that have symbols inside
	*  1.5 XMNoVowels Alpha-numberic number with no vowels
	*  0.0 T_TM2_M_HEADER_IN_MSG BODY: No description available.
	*  0.8 BAYES_50 BODY: Bayes spam probability is 40 to 60%
	*      [score: 0.5000]
	* -0.0 DCC_CHECK_NEGATIVE Not listed in DCC
	*      [sa07 1397; Body=1 Fuz1=1 Fuz2=1]
	*  1.0 XMSubMetaSx_00 1+ Sexy Words
	*  1.0 T_XMDrugObfuBody_08 obfuscated drug references
	*  1.2 XMSubMetaSSx_00 1+ SortaSexy Words + 1 Sexy Word
X-Spam-DCC: XMission; sa07 1397; Body=1 Fuz1=1 Fuz2=1 
X-Spam-Combo: ******;Andy Lutomirski <luto@amacapital.net>
X-Spam-Relay-Country: 
X-Spam-Timing: total 771 ms - load_scoreonly_sql: 0.06 (0.0%),
	signal_user_changed: 3.2 (0.4%), b_tie_ro: 2.3 (0.3%), parse: 1.83 (0.2%),
	extract_message_metadata: 18 (2.3%), get_uri_detail_list: 5 (0.7%),
	tests_pri_-1000: 6 (0.8%), tests_pri_-950: 1.38 (0.2%), tests_pri_-900: 1.18
	(0.2%), tests_pri_-400: 40 (5.2%), check_bayes: 39 (5.1%), b_tokenize: 16
	(2.1%), b_tok_get_all: 15 (1.9%), b_comp_prob: 2.7 (0.3%), b_tok_touch_all:
	3.6 (0.5%), b_finish: 0.70 (0.1%), tests_pri_0: 687 (89.1%), tests_pri_500: 7
	(0.9%), rewrite_mail: 0.00 (0.0%)
Subject: [CFT][PATCH 6/7] userns: Add a knob to disable setgroups on a per user namespace basis
X-Spam-Flag: No
X-SA-Exim-Version: 4.2.1 (built Wed, 24 Sep 2014 11:00:52 -0600)
X-SA-Exim-Scanned: Yes (on in02.mta.xmission.com)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


- Expose the knob to user space through a proc file /proc/<pid>/setgroups

  A value of 0 means the setgroups system call is disabled in the
  current processes user namespace and can not be enabled in the
  future in this user namespace.

  A value of 1 means the segtoups system call is enabled.

- Descedent user namespaces inherit the value of setgroups from
  their parents.

- A proc file is used (instead of a sysctl) as sysctls
  currently do not pass in a struct file so file_ns_capable
  is unusable.

Cc: stable@vger.kernel.org
Signed-off-by: "Eric W. Biederman" <ebiederm@xmission.com>
---
 fs/proc/base.c                 | 31 ++++++++++----
 include/linux/user_namespace.h | 25 +++++++++++
 kernel/groups.c                |  1 +
 kernel/user.c                  |  1 +
 kernel/user_namespace.c        | 97 ++++++++++++++++++++++++++++++++++++++++++
 5 files changed, 147 insertions(+), 8 deletions(-)

diff --git a/fs/proc/base.c b/fs/proc/base.c
index 772efa45a452..4ebed9f01d97 100644
--- a/fs/proc/base.c
+++ b/fs/proc/base.c
@@ -2386,7 +2386,7 @@ static int proc_tgid_io_accounting(struct seq_file *m, struct pid_namespace *ns,
 #endif /* CONFIG_TASK_IO_ACCOUNTING */
 
 #ifdef CONFIG_USER_NS
-static int proc_id_map_open(struct inode *inode, struct file *file,
+static int proc_userns_open(struct inode *inode, struct file *file,
 	const struct seq_operations *seq_ops)
 {
 	struct user_namespace *ns = NULL;
@@ -2418,7 +2418,7 @@ err:
 	return ret;
 }
 
-static int proc_id_map_release(struct inode *inode, struct file *file)
+static int proc_userns_release(struct inode *inode, struct file *file)
 {
 	struct seq_file *seq = file->private_data;
 	struct user_namespace *ns = seq->private;
@@ -2428,17 +2428,17 @@ static int proc_id_map_release(struct inode *inode, struct file *file)
 
 static int proc_uid_map_open(struct inode *inode, struct file *file)
 {
-	return proc_id_map_open(inode, file, &proc_uid_seq_operations);
+	return proc_userns_open(inode, file, &proc_uid_seq_operations);
 }
 
 static int proc_gid_map_open(struct inode *inode, struct file *file)
 {
-	return proc_id_map_open(inode, file, &proc_gid_seq_operations);
+	return proc_userns_open(inode, file, &proc_gid_seq_operations);
 }
 
 static int proc_projid_map_open(struct inode *inode, struct file *file)
 {
-	return proc_id_map_open(inode, file, &proc_projid_seq_operations);
+	return proc_userns_open(inode, file, &proc_projid_seq_operations);
 }
 
 static const struct file_operations proc_uid_map_operations = {
@@ -2446,7 +2446,7 @@ static const struct file_operations proc_uid_map_operations = {
 	.write		= proc_uid_map_write,
 	.read		= seq_read,
 	.llseek		= seq_lseek,
-	.release	= proc_id_map_release,
+	.release	= proc_userns_release,
 };
 
 static const struct file_operations proc_gid_map_operations = {
@@ -2454,7 +2454,7 @@ static const struct file_operations proc_gid_map_operations = {
 	.write		= proc_gid_map_write,
 	.read		= seq_read,
 	.llseek		= seq_lseek,
-	.release	= proc_id_map_release,
+	.release	= proc_userns_release,
 };
 
 static const struct file_operations proc_projid_map_operations = {
@@ -2462,7 +2462,20 @@ static const struct file_operations proc_projid_map_operations = {
 	.write		= proc_projid_map_write,
 	.read		= seq_read,
 	.llseek		= seq_lseek,
-	.release	= proc_id_map_release,
+	.release	= proc_userns_release,
+};
+
+static int proc_setgroups_open(struct inode *inode, struct file *file)
+{
+	return proc_userns_open(inode, file, &proc_setgroups_seq_operations);
+}
+
+static const struct file_operations proc_setgroups_operations = {
+	.open		= proc_setgroups_open,
+	.write		= proc_setgroups_write,
+	.read		= seq_read,
+	.llseek		= seq_lseek,
+	.release	= proc_userns_release,
 };
 #endif /* CONFIG_USER_NS */
 
@@ -2572,6 +2585,7 @@ static const struct pid_entry tgid_base_stuff[] = {
 	REG("uid_map",    S_IRUGO|S_IWUSR, proc_uid_map_operations),
 	REG("gid_map",    S_IRUGO|S_IWUSR, proc_gid_map_operations),
 	REG("projid_map", S_IRUGO|S_IWUSR, proc_projid_map_operations),
+	REG("setgroups",  S_IRUGO|S_IWUSR, proc_setgroups_operations),
 #endif
 #ifdef CONFIG_CHECKPOINT_RESTORE
 	REG("timers",	  S_IRUGO, proc_timers_operations),
@@ -2913,6 +2927,7 @@ static const struct pid_entry tid_base_stuff[] = {
 	REG("uid_map",    S_IRUGO|S_IWUSR, proc_uid_map_operations),
 	REG("gid_map",    S_IRUGO|S_IWUSR, proc_gid_map_operations),
 	REG("projid_map", S_IRUGO|S_IWUSR, proc_projid_map_operations),
+	REG("setgroups",  S_IRUGO|S_IWUSR, proc_setgroups_operations),
 #endif
 };
 
diff --git a/include/linux/user_namespace.h b/include/linux/user_namespace.h
index 41cc26e5a350..6451c401dcf6 100644
--- a/include/linux/user_namespace.h
+++ b/include/linux/user_namespace.h
@@ -17,6 +17,12 @@ struct uid_gid_map {	/* 64 bytes -- 1 cache line */
 	} extent[UID_GID_MAP_MAX_EXTENTS];
 };
 
+enum user_namespace_flags {
+	USERNS_SETGROUPS_ALLOWED,
+};
+
+#define USERNS_INIT_FLAGS BIT(USERNS_SETGROUPS_ALLOWED)
+
 struct user_namespace {
 	struct uid_gid_map	uid_map;
 	struct uid_gid_map	gid_map;
@@ -27,6 +33,7 @@ struct user_namespace {
 	kuid_t			owner;
 	kgid_t			group;
 	unsigned int		proc_inum;
+	unsigned long		flags;
 
 	/* Register of per-UID persistent keyrings for this namespace */
 #ifdef CONFIG_PERSISTENT_KEYRINGS
@@ -46,6 +53,22 @@ static inline bool userns_gid_mappings_established(const struct user_namespace *
 	return established;
 }
 
+static inline bool userns_setgroups_allowed(const struct user_namespace *ns)
+{
+	bool allowed;
+	smp_mb__before_atomic();
+	allowed = test_bit(USERNS_SETGROUPS_ALLOWED, &ns->flags);
+	smp_mb__after_atomic();
+	return allowed;
+}
+
+static inline void userns_disable_setgroups(struct user_namespace *ns)
+{
+	smp_mb__before_atomic();
+	clear_bit(USERNS_SETGROUPS_ALLOWED, &ns->flags);
+	smp_mb__after_atomic();
+}
+
 #ifdef CONFIG_USER_NS
 
 static inline struct user_namespace *get_user_ns(struct user_namespace *ns)
@@ -69,9 +92,11 @@ struct seq_operations;
 extern const struct seq_operations proc_uid_seq_operations;
 extern const struct seq_operations proc_gid_seq_operations;
 extern const struct seq_operations proc_projid_seq_operations;
+extern const struct seq_operations proc_setgroups_seq_operations;
 extern ssize_t proc_uid_map_write(struct file *, const char __user *, size_t, loff_t *);
 extern ssize_t proc_gid_map_write(struct file *, const char __user *, size_t, loff_t *);
 extern ssize_t proc_projid_map_write(struct file *, const char __user *, size_t, loff_t *);
+extern ssize_t proc_setgroups_write(struct file *, const char __user *, size_t, loff_t *);
 #else
 
 static inline struct user_namespace *get_user_ns(struct user_namespace *ns)
diff --git a/kernel/groups.c b/kernel/groups.c
index e0335e44f76a..2f136fda7c4d 100644
--- a/kernel/groups.c
+++ b/kernel/groups.c
@@ -222,6 +222,7 @@ bool may_setgroups(void)
 	 * the user namespace has been established.
 	 */
 	return userns_gid_mappings_established(user_ns) &&
+		userns_setgroups_allowed(user_ns) &&
 		ns_capable(user_ns, CAP_SETGID);
 }
 
diff --git a/kernel/user.c b/kernel/user.c
index 4efa39350e44..2d09940c9632 100644
--- a/kernel/user.c
+++ b/kernel/user.c
@@ -51,6 +51,7 @@ struct user_namespace init_user_ns = {
 	.owner = GLOBAL_ROOT_UID,
 	.group = GLOBAL_ROOT_GID,
 	.proc_inum = PROC_USER_INIT_INO,
+	.flags = USERNS_INIT_FLAGS,
 #ifdef CONFIG_PERSISTENT_KEYRINGS
 	.persistent_keyring_register_sem =
 	__RWSEM_INITIALIZER(init_user_ns.persistent_keyring_register_sem),
diff --git a/kernel/user_namespace.c b/kernel/user_namespace.c
index 413f60fd5983..3d128f91ced3 100644
--- a/kernel/user_namespace.c
+++ b/kernel/user_namespace.c
@@ -98,6 +98,11 @@ int create_user_ns(struct cred *new)
 	ns->level = parent_ns->level + 1;
 	ns->owner = owner;
 	ns->group = group;
+	ns->flags = USERNS_INIT_FLAGS;
+
+	/* Copy USERNS_SETGROUPS_ALLOWED from the parent user namespace */
+	if (!userns_setgroups_allowed(parent_ns))
+		userns_disable_setgroups(ns);
 
 	set_cred_user_ns(new, ns);
 
@@ -841,6 +846,98 @@ static bool new_idmap_permitted(const struct file *file,
 	return false;
 }
 
+static void *setgroups_m_start(struct seq_file *seq, loff_t *ppos)
+{
+	struct user_namespace *ns = seq->private;
+
+	return (*ppos == 0) ?  ns : NULL;
+}
+
+static void *setgroups_m_next(struct seq_file *seq, void *v, loff_t *ppos)
+{
+	++*ppos;
+	return NULL;
+}
+
+static void setgroups_m_stop(struct seq_file *seq, void *v)
+{
+}
+
+static int setgroups_m_show(struct seq_file *seq, void *v)
+{
+	struct user_namespace *ns = seq->private;
+
+	seq_printf(seq, "%s\n",
+		   test_bit(USERNS_SETGROUPS_ALLOWED, &ns->flags) ?
+		   "allow" : "deny");
+	return 0;
+}
+
+const struct seq_operations proc_setgroups_seq_operations = {
+	.start	= setgroups_m_start,
+	.stop = setgroups_m_stop,
+	.next = setgroups_m_next,
+	.show = setgroups_m_show,
+};
+
+ssize_t proc_setgroups_write(struct file *file, const char __user *buf,
+			     size_t count, loff_t *ppos)
+{
+	struct seq_file *seq = file->private_data;
+	struct user_namespace *ns = seq->private;
+	char kbuf[8], *pos;
+	bool setgroups_allowed;
+	ssize_t ret;
+
+	ret = -EACCES;
+	if (!file_ns_capable(file, ns, CAP_SYS_ADMIN))
+		goto out;
+
+	/* Only allow a very narrow range of strings to be written */
+	ret = -EINVAL;
+	if ((*ppos != 0) || (count >= sizeof(kbuf)))
+		goto out;
+
+	/* What was written? */
+	ret = -EFAULT;
+	if (copy_from_user(kbuf, buf, count))
+		goto out;
+	kbuf[count] = '\0';
+	pos = kbuf;
+
+	/* What is being requested? */
+	ret = -EINVAL;
+	if (strncmp(pos, "allow", 5) == 0) {
+		pos += 5;
+		setgroups_allowed = true;
+	}
+	else if (strncmp(pos, "deny", 4) == 0) {
+		pos += 4;
+		setgroups_allowed = false;
+	}
+	else
+		goto out;
+
+	/* Verify there is not trailing junk on the line */
+	pos = skip_spaces(pos);
+	if (*pos != '\0')
+		goto out;
+
+	if (setgroups_allowed) {
+		ret = -EPERM;
+		if (!userns_setgroups_allowed(ns))
+			goto out;
+	} else {
+		userns_disable_setgroups(ns);
+	}
+
+	/* Report a successful write */
+	*ppos = count;
+	ret = count;
+out:
+	return ret;
+}
+
 static void *userns_get(struct task_struct *task)
 {
 	struct user_namespace *user_ns;
-- 
1.9.1


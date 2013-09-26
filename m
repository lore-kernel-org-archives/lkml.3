Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754666Ab3IZAiX (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Sep 2013 20:38:23 -0400
Received: from smtprelay0103.hostedemail.com ([216.40.44.103]:55194 "EHLO
	smtprelay.hostedemail.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1753992Ab3IZAiW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Sep 2013 20:38:22 -0400
X-Session-Marker: 6A6F6540706572636865732E636F6D
X-Spam-Summary: 2,0,0,,d41d8cd98f00b204,joe@perches.com,:::::::,RULES_HIT:2:41:69:355:379:541:599:960:966:973:982:988:989:1260:1261:1277:1311:1313:1314:1345:1359:1373:1437:1515:1516:1518:1535:1593:1594:1605:1730:1747:1777:1792:2196:2198:2199:2200:2393:2553:2559:2562:2828:2895:3138:3139:3140:3141:3142:3622:3653:3865:3866:3867:3868:3870:3871:3872:3873:3874:4049:4118:4250:4321:4385:5007:6757:7652:7903:7904:8957:10004:10848:11026:11232:11473:11658:11914:12043:12291:12296:12438:12517:12519:12555:12683:12740:13869,0,RBL:none,CacheIP:none,Bayesian:0.5,0.5,0.5,Netcheck:none,DomainCache:0,MSF:not bulk,SPF:fn,MSBL:0,DNSBL:none,Custom_rules:0:0:0
X-HE-Tag: toys94_82e433896fc62
X-Filterd-Recvd-Size: 7859
Message-ID: <1380155897.17366.38.camel@joe-AO722>
Subject: Re: [PATCH] checkpatch: Find CamelCase definitions of
 struct/union/enum
From: Joe Perches <joe@perches.com>
To: Al Viro <viro@ZenIV.linux.org.uk>
Cc: Andrew Morton <akpm@linux-foundation.org>,
        Andy Whitcroft <apw@shadowen.org>, LKML <linux-kernel@vger.kernel.org>
Date: Wed, 25 Sep 2013 17:38:17 -0700
In-Reply-To: <20130925201124.GA13318@ZenIV.linux.org.uk>
References: <1380047934.3575.100.camel@joe-AO722>
	 <20130925152432.GY13318@ZenIV.linux.org.uk>
	 <1380123344.17366.5.camel@joe-AO722>
	 <20130925161949.GZ13318@ZenIV.linux.org.uk>
	 <1380136920.17366.15.camel@joe-AO722>
	 <20130925201124.GA13318@ZenIV.linux.org.uk>
Content-Type: text/plain; charset="ISO-8859-1"
X-Mailer: Evolution 3.6.4-0ubuntu1 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2013-09-25 at 21:11 +0100, Al Viro wrote:
> On Wed, Sep 25, 2013 at 12:22:00PM -0700, Joe Perches wrote:
> > It's pretty obvious from fs/binfmt_misc.c that you have
> > your own taste.
> > 
> > $ scripts/checkpatch.pl -f --strict fs/binfmt_misc.c
> > [...]
> > total: 45 errors, 39 warnings, 10 checks, 725 lines checked
> 
> *snort*

gasp, chuckle, wheeze, smile.

> Most of those are whitespace noise, mostly having nothing whatsoever
> to do with me or my taste.  The rest...  Let's see:
[]
> Overall: checkpatch.pl has produced 2 reasonable suggestions and pointed to
> a place that is badly written for reasons unrelated to ones mentioned in
> the output.  That, along with some amount of BS was buried under tons of noise
> about whitespace.

A lot of those whitespace noises are the documented preferred
style in CodingStyle.

It's your choice to modify them or not.

Here's what some of those whitespaces elements are that
checkpatch offers to make more CodingStyle conformant via:

$ scripts/checkpatch.pl -f --fix --strict \
	--types=spacing,pointer_location,code_indent,space_before_tab \
	fs/binfmt_misc.c
$ mv fs/binfmt_misc.c.EXPERIMENTAL-checkpatch-fixes fs/binfmt_misc.c

---

 fs/binfmt_misc.c | 68 ++++++++++++++++++++++++++++----------------------------
 1 file changed, 34 insertions(+), 34 deletions(-)

diff --git a/fs/binfmt_misc.c b/fs/binfmt_misc.c
index 1c740e1..fc53386 100644
--- a/fs/binfmt_misc.c
+++ b/fs/binfmt_misc.c
@@ -108,7 +108,7 @@ static Node *check_file(struct linux_binprm *bprm)
 static int load_misc_binary(struct linux_binprm *bprm)
 {
 	Node *fmt;
-	struct file * interp_file = NULL;
+	struct file *interp_file = NULL;
 	char iname[BINPRM_BUF_SIZE];
 	const char *iname_addr = iname;
 	int retval;
@@ -138,12 +138,12 @@ static int load_misc_binary(struct linux_binprm *bprm)
 		/* if the binary should be opened on behalf of the
 		 * interpreter than keep it open and assign descriptor
 		 * to it */
- 		fd_binary = get_unused_fd();
- 		if (fd_binary < 0) {
- 			retval = fd_binary;
- 			goto _ret;
- 		}
- 		fd_install(fd_binary, bprm->file);
+		fd_binary = get_unused_fd();
+		if (fd_binary < 0) {
+			retval = fd_binary;
+			goto _ret;
+		}
+		fd_install(fd_binary, bprm->file);
 
 		/* if the binary is not readable than enforce mm->dumpable=0
 		   regardless of the interpreter's permissions */
@@ -156,31 +156,31 @@ static int load_misc_binary(struct linux_binprm *bprm)
 		bprm->interp_flags |= BINPRM_FLAGS_EXECFD;
 		bprm->interp_data = fd_binary;
 
- 	} else {
- 		allow_write_access(bprm->file);
- 		fput(bprm->file);
- 		bprm->file = NULL;
- 	}
+	} else {
+		allow_write_access(bprm->file);
+		fput(bprm->file);
+		bprm->file = NULL;
+	}
 	/* make argv[1] be the path to the binary */
-	retval = copy_strings_kernel (1, &bprm->interp, bprm);
+	retval = copy_strings_kernel(1, &bprm->interp, bprm);
 	if (retval < 0)
 		goto _error;
 	bprm->argc++;
 
 	/* add the interp as argv[0] */
-	retval = copy_strings_kernel (1, &iname_addr, bprm);
+	retval = copy_strings_kernel(1, &iname_addr, bprm);
 	if (retval < 0)
 		goto _error;
-	bprm->argc ++;
+	bprm->argc++;
 
 	/* Update interp in case binfmt_script needs it. */
 	retval = bprm_change_interp(iname, bprm);
 	if (retval < 0)
 		goto _error;
 
-	interp_file = open_exec (iname);
-	retval = PTR_ERR (interp_file);
-	if (IS_ERR (interp_file))
+	interp_file = open_exec(iname);
+	retval = PTR_ERR(interp_file);
+	if (IS_ERR(interp_file))
 		goto _error;
 
 	bprm->file = interp_file;
@@ -192,7 +192,7 @@ static int load_misc_binary(struct linux_binprm *bprm)
 		memset(bprm->buf, 0, BINPRM_BUF_SIZE);
 		retval = kernel_read(bprm->file, 0, bprm->buf, BINPRM_BUF_SIZE);
 	} else
-		retval = prepare_binprm (bprm);
+		retval = prepare_binprm(bprm);
 
 	if (retval < 0)
 		goto _error;
@@ -235,9 +235,9 @@ static char *scanarg(char *s, char del)
 	return s;
 }
 
-static char * check_special_flags (char * sfs, Node * e)
+static char *check_special_flags(char *sfs, Node *e)
 {
-	char * p = sfs;
+	char *p = sfs;
 	int cont = 1;
 
 	/* special flags */
@@ -369,7 +369,7 @@ static Node *create_entry(const char __user *buffer, size_t count)
 		goto Einval;
 
 
-	p = check_special_flags (p, e);
+	p = check_special_flags(p, e);
 
 	if (*p == '\n')
 		p++;
@@ -419,7 +419,7 @@ static void entry_status(Node *e, char *page)
 {
 	char *dp;
 	char *status = "disabled";
-	const char * flags = "flags: ";
+	const char *flags = "flags: ";
 
 	if (test_bit(Enabled, &e->flags))
 		status = "enabled";
@@ -433,18 +433,18 @@ static void entry_status(Node *e, char *page)
 	dp = page + strlen(page);
 
 	/* print the special flags */
-	sprintf (dp, "%s", flags);
-	dp += strlen (flags);
+	sprintf(dp, "%s", flags);
+	dp += strlen(flags);
 	if (e->flags & MISC_FMT_PRESERVE_ARGV0) {
-		*dp ++ = 'P';
+		*dp++ = 'P';
 	}
 	if (e->flags & MISC_FMT_OPEN_BINARY) {
-		*dp ++ = 'O';
+		*dp++ = 'O';
 	}
 	if (e->flags & MISC_FMT_CREDENTIALS) {
-		*dp ++ = 'C';
+		*dp++ = 'C';
 	}
-	*dp ++ = '\n';
+	*dp++ = '\n';
 
 
 	if (!test_bit(Magic, &e->flags)) {
@@ -473,7 +473,7 @@ static void entry_status(Node *e, char *page)
 
 static struct inode *bm_get_inode(struct super_block *sb, int mode)
 {
-	struct inode * inode = new_inode(sb);
+	struct inode *inode = new_inode(sb);
 
 	if (inode) {
 		inode->i_ino = get_next_ino();
@@ -513,13 +513,13 @@ static void kill_node(Node *e)
 /* /<entry> */
 
 static ssize_t
-bm_entry_read(struct file * file, char __user * buf, size_t nbytes, loff_t *ppos)
+bm_entry_read(struct file *file, char __user *buf, size_t nbytes, loff_t *ppos)
 {
 	Node *e = file_inode(file)->i_private;
 	ssize_t res;
 	char *page;
 
-	if (!(page = (char*) __get_free_page(GFP_KERNEL)))
+	if (!(page = (char *)__get_free_page(GFP_KERNEL)))
 		return -ENOMEM;
 
 	entry_status(e, page);
@@ -639,7 +639,7 @@ bm_status_read(struct file *file, char __user *buf, size_t nbytes, loff_t *ppos)
 	return simple_read_from_buffer(buf, nbytes, ppos, s, strlen(s));
 }
 
-static ssize_t bm_status_write(struct file * file, const char __user * buffer,
+static ssize_t bm_status_write(struct file *file, const char __user *buffer,
 		size_t count, loff_t *ppos)
 {
 	int res = parse_command(buffer, count);
@@ -674,7 +674,7 @@ static const struct super_operations s_ops = {
 	.evict_inode	= bm_evict_inode,
 };
 
-static int bm_fill_super(struct super_block * sb, void * data, int silent)
+static int bm_fill_super(struct super_block *sb, void *data, int silent)
 {
 	static struct tree_descr bm_files[] = {
 		[2] = {"status", &bm_status_operations, S_IWUSR|S_IRUGO},



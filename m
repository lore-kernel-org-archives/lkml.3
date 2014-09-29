Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754565AbaI2TfR (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Sep 2014 15:35:17 -0400
Received: from out03.mta.xmission.com ([166.70.13.233]:47690 "EHLO
	out03.mta.xmission.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750933AbaI2TfN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Sep 2014 15:35:13 -0400
From: ebiederm@xmission.com (Eric W. Biederman)
To: Miklos Szeredi <miklos@szeredi.hu>
Cc: Alexander Viro <viro@zeniv.linux.org.uk>,
        Serge Hallyn <serge.hallyn@ubuntu.com>,
        fuse-devel <fuse-devel@lists.sourceforge.net>,
        Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Linux-Fsdevel <linux-fsdevel@vger.kernel.org>,
        "Serge E. Hallyn" <serge@hallyn.com>
References: <20140911181034.GA58733@ubuntu-hedt>
	<87d2am3r8a.fsf@x220.int.ebiederm.org>
	<20140924132925.GA48721@ubuntu-hedt>
	<87y4t9ndw5.fsf@x220.int.ebiederm.org>
	<CAJfpegs3QNdKMZWmN324OqHFw+e2qwU9kfkQ491==yP_JRrcWw@mail.gmail.com>
	<87wq8reftb.fsf@x220.int.ebiederm.org>
	<20140925184403.GB28101@ubuntu-hedt>
	<87bnq3a4xy.fsf@x220.int.ebiederm.org>
	<20140925194825.GB39447@ubuntu-hedt>
	<874mvtkfg2.fsf@x220.int.ebiederm.org>
	<20140927042447.GA19672@ubuntu-hedt>
Date: Mon, 29 Sep 2014 12:34:44 -0700
In-Reply-To: <20140927042447.GA19672@ubuntu-hedt> (Seth Forshee's message of
	"Fri, 26 Sep 2014 23:24:47 -0500")
Message-ID: <87tx3qdxuz.fsf@x220.int.ebiederm.org>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/24.3 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
X-XM-AID: U2FsdGVkX1/ZYnOxGgFWFNaC4hcGuBBWDEQZaUnnsaM=
X-SA-Exim-Connect-IP: 98.234.51.111
X-SA-Exim-Mail-From: ebiederm@xmission.com
X-Spam-Report: * -1.0 ALL_TRUSTED Passed through trusted hosts only via SMTP
	*  0.7 XMSubLong Long Subject
	*  0.0 T_TM2_M_HEADER_IN_MSG BODY: No description available.
	*  0.8 BAYES_50 BODY: Bayes spam probability is 40 to 60%
	*      [score: 0.5000]
	* -0.0 DCC_CHECK_NEGATIVE Not listed in DCC
	*      [sa04 1397; Body=1 Fuz1=1 Fuz2=1]
	*  1.8 MISSING_SUBJECT Missing Subject: header
	*  1.0 MISSING_FROM Missing From: header
	*  1.0 T_XMDrugObfuBody_04 obfuscated drug references
	*  1.0 XMSubGarbage Subject is 100% non-alphanumeric garbage
	*  1.0 T_XMDrugObfuBody_08 obfuscated drug references
	*  0.1 XMSolicitRefs_0 Weightloss drug
	*  0.3 XM_UncommonTLD01 Less-common TLD
	*  0.5 XMNoSubject No subject header
X-Spam-DCC: XMission; sa04 1397; Body=1 Fuz1=1 Fuz2=1 
X-Spam-Combo: *******;Miklos Szeredi <miklos@szeredi.hu>
X-Spam-Relay-Country: 
Subject: Re: [PATCH v2 0/3] fuse: Add support for mounts from pid/user namespaces
X-Spam-Flag: No
X-SA-Exim-Version: 4.2.1 (built Wed, 24 Sep 2014 11:00:52 -0600)
X-SA-Exim-Scanned: Yes (on in01.mta.xmission.com)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Seth Forshee <seth.forshee@canonical.com> writes:

> On Fri, Sep 26, 2014 at 06:41:33PM -0700, Eric W. Biederman wrote:
>> >> I am on the fence about what to do when a uid from the filesystem server
>> >> or for other filesystems the on-disk data structures does not map, but
>> >> make_bad_inode is simpler in conception.  So make_bad_inode seems like
>> >> a good place to start.   For fuse especially this isn't hard because
>> >> the make_bad_inode calls are already there to handle a change in i_mode.
>> >
>> > I agree that if we're unsure then make_bad_inode is a more logical place
>> > to start, since it's easier to loosen the restrictions later than to
>> > tighten them. I've got an initiail implementation that I'm in the
>> > process of testing. If you want to take a look I've pushed it to:
>> >
>> >   git://kernel.ubuntu.com/sforshee/linux.git fuse-userns 
>> 
>> Thanks.  If I can scrape together enough focus I will look at it.
>> 
>> As a second best thing here are my prototype from when I was looking at
>> performing this fuse conversion last.  Given that you had missed
>> checking the from_kuid permission checks, it might be worth comparing
>> and seeing if there is something else in these patches that would be
>> worth including.
>
> I think all of the from_kuid checks have been there for at least the
> last two rounds of patches, but let me know if you see one I missed.
>
> Looking at your patches, I see a lot that looks familiar. Seems like a
> good sign :-)
>
> I do see a few things I missed though. I've pointed those out below, and
> in those cases I'm updating my patches. There are also some other
> differences which I don't believe require any changes on my part, and
> I've provided explanations for those. I also asked a few questions.
>
> Miklos, are you satisfied with Eric's explanations about using a single
> namespace and the permissions checks on uids? If so I should be able to
> send updated patches early next week, otherwise let's continue trying to
> resolve the points of disagreement.
>
>> -static void fuse_fillattr(struct inode *inode, struct fuse_attr *attr,
>> +static int fuse_fillattr(struct inode *inode, struct fuse_attr *attr,
>>  			  struct kstat *stat)
>>  {
>>  	unsigned int blkbits;
>> @@ -905,8 +905,12 @@ static void fuse_fillattr(struct inode *inode, struct fuse_attr *attr,
>>  	stat->ino = attr->ino;
>>  	stat->mode = (inode->i_mode & S_IFMT) | (attr->mode & 07777);
>>  	stat->nlink = attr->nlink;
>> -	stat->uid = make_kuid(&init_user_ns, attr->uid);
>> -	stat->gid = make_kgid(&init_user_ns, attr->gid);
>> +	stat->uid = make_kuid(fc->user_ns, attr->uid);
>> +	if (!uid_valid(stat->uid))
>> +		return -EOVERFLOW;
>> +	stat->gid = make_kgid(fc->user_ns, attr->gid);
>> +	if (!gid_valid(stat->gid))
>> +		return -EOVERFLOW;
>
> If we were to go with the invalid id approach these checks shouldn't be
> necessary, and they'll get converted to the overflow ids for
> userspace.

Correct.  

> In my make_bad_inode patches I'm doing this check when we update the
> inode and returning -EINVAL if it doesn't map. 

In fuse_change_attributes?  That seems reasonable.

> fuse_fillattr to just copy them from the inode, since fuse always
> updates the inode right before calling fuse_fillattr anyway and that
> makes it clear why we don't need to check the results of the
> conversion.

Agreed.  There is no point in having that code twice.

>>  static int fuse_do_getattr(struct inode *inode, struct kstat *stat,
>> @@ -973,7 +978,8 @@ static int fuse_do_getattr(struct inode *inode, struct kstat *stat,
>>  					       attr_timeout(&outarg),
>>  					       attr_version);
>>  			if (stat)
>> -				fuse_fillattr(inode, &outarg.attr, stat);
>> +				err = fuse_fillattr(inode, &outarg.attr,
>> +						    stat);
>>  		}
>>  	}
>>  	return err;
>
> So right before calling fuse_fillattr here fuse_change_attributes is
> called to update the inode, so it appears your patches would have
> allowed setting inode->i_iuid to INVALID_UID?

Quite possibly. I am scratching my head about that one.

>> @@ -624,6 +626,8 @@ void fuse_conn_put(struct fuse_conn *fc)
>>  	if (atomic_dec_and_test(&fc->count)) {
>>  		if (fc->destroy_req)
>>  			fuse_request_free(fc->destroy_req);
>> +		put_user_ns(fc->user_ns);
>> +		fc->user_ns = NULL;
>>  		fc->release(fc);
>>  	}
>>  }
>
> I did this in fuse_free_con, but now looking again this is a bug for
> cuse since it uses a different release method. I've updated my tree to
> do it here instead.


>> @@ -1033,6 +1037,7 @@ static int fuse_fill_super(struct super_block *sb, void *data, int silent)
>>  	sb->s_maxbytes = MAX_LFS_FILESIZE;
>>  	sb->s_time_gran = 1;
>>  	sb->s_export_op = &fuse_export_operations;
>> +	sb->s_user_ns = get_user_ns(current_user_ns());
>>  
>>  	file = fget(d.fd);
>>  	err = -EINVAL;
>> @@ -1149,6 +1154,7 @@ static void fuse_kill_sb_anon(struct super_block *sb)
>>  	}
>>  
>>  	kill_anon_super(sb);
>> +	put_user_ns(sb->s_user_ns);
>>  }
>
> What's the point of s_user_ns? It doesn't seem to be used anywhere.

Not in these patches, and the field isn't added here either.  It was my
exporting of the user namespace that ids are enconded in the filesystem
to generic code in the vfs.  By default that I am setting that field
to init_user_ns.

Looking through my tree the only real user of it is the quota code.

However for acls and other xattrs we may also care.  

For block based filesystems I woudn't expect to need the fuse connection
structure and storing the user namespace there.  So that field becomes
a lot less redundant in the general case.

>> @@ -2210,7 +2213,7 @@ static int fuse_setlk(struct file *file, struct file_lock *fl, int flock)
>>  	struct fuse_conn *fc = get_fuse_conn(inode);
>>  	struct fuse_req *req;
>>  	int opcode = (fl->fl_flags & FL_SLEEP) ? FUSE_SETLKW : FUSE_SETLK;
>> -	pid_t pid = fl->fl_type != F_UNLCK ? current->tgid : 0;
>> +	struct pid *pid = fl->fl_type != F_UNLCK ? task_tgid(current) : NULL;
>>  	int err;
>>  
>>  	if (fl->fl_lmops && fl->fl_lmops->lm_grant) {
>
> D'oh, I did totally miss this file locking stuff. Your changes look
> good, so I'll pretty much take them verbatim.

Sounds good.

>> @@ -628,6 +630,8 @@ void fuse_conn_put(struct fuse_conn *fc)
>>  			fuse_request_free(fc->destroy_req);
>>  		put_user_ns(fc->user_ns);
>>  		fc->user_ns = NULL;
>> +		put_pid_ns(fc->pid_ns);
>> +		fc->pid_ns = NULL;
>>  		fc->release(fc);
>>  	}
>>  }
>
> And I had a leak here for cuse as with the userns.
>
>> From 55226d169826abd110d9bc60a6b079f6be3f6a46 Mon Sep 17 00:00:00 2001
>> From: "Eric W. Biederman" <ebiederm@xmission.com>
>> Date: Fri, 5 Oct 2012 10:18:28 -0700
>> Subject: [PATCH 3/4] userns: fuse unprivileged mount suport
>> 
>> Signed-off-by: "Eric W. Biederman" <ebiederm@xmission.com>
>> ---
>>  fs/fuse/inode.c | 2 +-
>>  1 file changed, 1 insertion(+), 1 deletion(-)
>> 
>> diff --git a/fs/fuse/inode.c b/fs/fuse/inode.c
>> index 5284d7fda269..75f5326868e0 100644
>> --- a/fs/fuse/inode.c
>> +++ b/fs/fuse/inode.c
>> @@ -1164,7 +1164,7 @@ static void fuse_kill_sb_anon(struct super_block *sb)
>>  static struct file_system_type fuse_fs_type = {
>>  	.owner		= THIS_MODULE,
>>  	.name		= "fuse",
>> -	.fs_flags	= FS_HAS_SUBTYPE,
>> +	.fs_flags	= FS_HAS_SUBTYPE | FS_USERNS_MOUNT,
>>  	.mount		= fuse_mount,
>>  	.kill_sb	= fuse_kill_sb_anon,
>>  };
>
> I have the order of my patches switched, then this one squashed in with
> the one which adds userns support to fuse.

It is nice having this as a separate patch because it allows incremental
progress.   Then this patch can be added when victory is declared.

Although looking at my code this looks like this patch is probably a
little early in the series ;-)

>> From 6ae88ecfe4e8c8998478932ca225d1d9753b6c4b Mon Sep 17 00:00:00 2001
>> From: "Eric W. Biederman" <ebiederm@xmission.com>
>> Date: Fri, 5 Oct 2012 14:33:36 -0700
>> Subject: [PATCH 4/4] fuse: Only allow read/writing user xattrs
>> 
>> In the context of unprivileged mounts supporting anything except
>> xattrs with the "user." prefix seems foolish.  Return -EOPNOSUPP
>> for all other types of xattrs.
>> 
>> Cc: Miklos Szeredi <miklos@szeredi.hu>
>> Signed-off-by: "Eric W. Biederman" <ebiederm@xmission.com>
>> ---
>>  fs/fuse/dir.c | 7 +++++++
>>  1 file changed, 7 insertions(+)
>> 
>> diff --git a/fs/fuse/dir.c b/fs/fuse/dir.c
>> index d74c75a057cd..d84f5b819fab 100644
>> --- a/fs/fuse/dir.c
>> +++ b/fs/fuse/dir.c
>> @@ -13,6 +13,7 @@
>>  #include <linux/sched.h>
>>  #include <linux/namei.h>
>>  #include <linux/slab.h>
>> +#include <linux/xattr.h>
>>  
>>  static bool fuse_use_readdirplus(struct inode *dir, struct dir_context *ctx)
>>  {
>> @@ -1868,6 +1869,9 @@ static int fuse_setxattr(struct dentry *entry, const char *name,
>>  	if (fc->no_setxattr)
>>  		return -EOPNOTSUPP;
>>  
>> +	if (strncmp(name, XATTR_USER_PREFIX, XATTR_USER_PREFIX_LEN) != 0)
>> +		return -EOPNOTSUPP;
>> +
>>  	req = fuse_get_req_nopages(fc);
>>  	if (IS_ERR(req))
>>  		return PTR_ERR(req);
>> @@ -1911,6 +1915,9 @@ static ssize_t fuse_getxattr(struct dentry *entry, const char *name,
>>  	if (fc->no_getxattr)
>>  		return -EOPNOTSUPP;
>>  
>> +	if (strncmp(name, XATTR_USER_PREFIX, XATTR_USER_PREFIX_LEN) != 0)
>> +		return -EOPNOTSUPP;
>> +
>>  	req = fuse_get_req_nopages(fc);
>>  	if (IS_ERR(req))
>>  		return PTR_ERR(req);
>
> This I hadn't considered, but it seems reasonable. Two questions though.
>
> Why shouldn't we let root-owned mounts support namespaces other than
> "user."?

Are there any users of fuse who care.  Certainly the core use case of
fuse is unprivileged mounts and in that case nosuid should take care of
this.

> Thinking ahead to (hopefully) allowing other filesystems to be mounted
> from user namespaces, should this be enforced by the vfs instead?

Potentially.  I would have to look to see how hard it is to lift this
code into the vfs.  At least historically the xattr interface was ugly
enough getting some of this stuff into the vfs would require
refactoring.

My tenative patches in this area look pretty rough.  For ext2 I
just implemented:

+       if (dentry->d_inode->i_sb->s_user_ns != &init_user_ns)
+               return -EOPNOTSUPP;
+

So for ext2 I did honor allow things to happen as you would have
suspected.

But if we are not going to require specifying nosuid looking closely at
xattrs and acls and security attributes seems pretty important.

Looking at all of this my guess is we probably want to write a list of
rules for unprivileged mounting of filesystems.  So that people can
(a) review the basic theory in case they are aware of anything we may
    have missed.
(b) Have a reference for the whatever filesystems come next.

Eric




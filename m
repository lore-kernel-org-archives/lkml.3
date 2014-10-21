Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933895AbaJUVeT (ORCPT <rfc822;w@1wt.eu>);
	Tue, 21 Oct 2014 17:34:19 -0400
Received: from e36.co.us.ibm.com ([32.97.110.154]:49723 "EHLO
	e36.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933668AbaJUVeN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 21 Oct 2014 17:34:13 -0400
In-Reply-To: <CALCETrWrqDAbq5uxPxZ=MjfSDetuZa94pNF2EH3abE6PhJm6=g@mail.gmail.com>
References: <1413296756-25071-1-git-send-email-seth.forshee@canonical.com> <1413296756-25071-5-git-send-email-seth.forshee@canonical.com> <OFD40DA8DF.F78EA39D-ON86257D71.0057C4DC-86257D71.0064055D@us.ibm.com> <878ukis9oh.fsf@x220.int.ebiederm.org> <20141014205955.GA10908@ubuntu-mba51> <877g02pd7f.fsf@x220.int.ebiederm.org> <CALCETrU3Gzo-dx9uNH3Wuqa8Brk8xcxQsw7YGgVd74simXK0gw@mail.gmail.com> <20141015073951.GB10908@ubuntu-mba51> <CALCETrWnHfXN9VK9P-97XiVN6LkWr1nV4CxMpsRPGCOMc1xvvg@mail.gmail.com> <20141021212151.GB83801@ubuntu-hedt> <CALCETrWrqDAbq5uxPxZ=MjfSDetuZa94pNF2EH3abE6PhJm6=g@mail.gmail.com>
To: Andy Lutomirski <luto@amacapital.net>
Cc: "Eric W. Biederman" <ebiederm@xmission.com>,
        fuse-devel@lists.sourceforge.net,
        Linux FS Devel <linux-fsdevel@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Miklos Szeredi <miklos@szeredi.hu>,
        "Serge H. Hallyn" <serge.hallyn@ubuntu.com>
MIME-Version: 1.0
Subject: Re: [fuse-devel] [PATCH v4 4/5] fuse: Support privileged xattrs only with a
 mount option
X-KeepSent: 497DB250:D815133A-86257D78:007665A1;
 type=4; name=$KeepSent
X-Mailer: IBM Notes Release 9.0.1 October 14, 2013
From: Michael j Theall <mtheall@us.ibm.com>
Message-ID: <OF497DB250.D815133A-ON86257D78.007665A1-86257D78.00767AED@us.ibm.com>
Date: Tue, 21 Oct 2014 16:34:05 -0500
X-MIMETrack: Serialize by Router on D03NM132/03/M/IBM(Release 9.0.1FP1|April  03, 2014) at
 10/21/2014 15:34:06,
	Serialize complete at 10/21/2014 15:34:06
Content-Type: text/plain; charset="US-ASCII"
X-TM-AS-MML: disable
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 14102121-0021-0000-0000-0000059054AC
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Andy Lutomirski <luto@amacapital.net> wrote on 10/21/2014 04:27:13 PM:

> From: Andy Lutomirski <luto@amacapital.net>
> To: Andy Lutomirski <luto@amacapital.net>, "Eric W. Biederman" 
> <ebiederm@xmission.com>, Michael j Theall/Houston/IBM@IBMUS, fuse-
> devel@lists.sourceforge.net, Linux FS Devel <linux-
> fsdevel@vger.kernel.org>, "linux-kernel@vger.kernel.org" <linux-
> kernel@vger.kernel.org>, Miklos Szeredi <miklos@szeredi.hu>, "Serge 
> H. Hallyn" <serge.hallyn@ubuntu.com>
> Date: 10/21/2014 04:27 PM
> Subject: Re: [fuse-devel] [PATCH v4 4/5] fuse: Support privileged 
> xattrs only with a mount option
> 
> On Tue, Oct 21, 2014 at 2:21 PM, Seth Forshee
> <seth.forshee@canonical.com> wrote:
> > On Wed, Oct 15, 2014 at 07:37:36AM -0700, Andy Lutomirski wrote:
> >> On Wed, Oct 15, 2014 at 12:39 AM, Seth Forshee
> >> <seth.forshee@canonical.com> wrote:
> >> > On Tue, Oct 14, 2014 at 02:19:19PM -0700, Andy Lutomirski wrote:
> >> >> On Tue, Oct 14, 2014 at 2:13 PM, Eric W. Biederman
> >> >> <ebiederm@xmission.com> wrote:
> >> >> > Seth Forshee <seth.forshee@canonical.com> writes:
> >> >> >
> >> >> >> On Tue, Oct 14, 2014 at 01:01:02PM -0700, Eric W. Biederman 
wrote:
> >> >> >>> Michael j Theall <mtheall@us.ibm.com> writes:
> >> >> >>>
> >> >> >>> > Seth Forshee <seth.forshee@canonical.com> wrote on 10/
> 14/2014 09:25:55 AM:
> >> >> >>> >
> >> >> >>> >> From: Seth Forshee <seth.forshee@canonical.com>
> >> >> >>> >> To: Miklos Szeredi <miklos@szeredi.hu>
> >> >> >>> >> Cc: fuse-devel@lists.sourceforge.net, "Serge H. Hallyn"
> >> >> >>> >> <serge.hallyn@ubuntu.com>, linux-kernel@vger.kernel.org, 
Seth
> >> >> >>> >> Forshee <seth.forshee@canonical.com>, "Eric W. Biederman"
> >> >> >>> >> <ebiederm@xmission.com>, linux-fsdevel@vger.kernel.org
> >> >> >>> >> Date: 10/14/2014 09:27 AM
> >> >> >>> >> Subject: [fuse-devel] [PATCH v4 4/5] fuse: Support 
> privileged xattrs
> >> >> >>> >> only with a mount option
> >> >> >>> >>
> >> >> >>> >> Allowing unprivileged users to provide arbitrary xattrs via 
fuse
> >> >> >>> >> mounts bypasses the normal restrictions on setting xattrs. 
Such
> >> >> >>> >> mounts should be restricted to reading and writing xattrs 
in the
> >> >> >>> >> user.* namespace.
> >> >> >>> >>
> >> >> >>> >
> >> >> >>> > Can you explain how the normal restrictions on setting 
xattrs are
> >> >> >>> > bypassed?
> >> >> >>>
> >> >> >>> If the fuse server is not run by root.  Which is a large part 
of the
> >> >> >>> point of fuse.
> >> >> >>
> >> >> >> So the server could for example return trusted.* xattrs 
> which were not
> >> >> >> set by a privileged user.
> >> >> >>
> >> >> >>> > My filesystem still needs security.* and system.*, and 
> it looks like
> >> >> >>> > xattr_permission already prevents non-privileged users 
> from accessing
> >> >> >>> > trusted.*
> >> >> >>>
> >> >> >>> If the filesystem is mounted with nosuid (typical of a 
> non-privileged
> >> >> >>> mount of fuse) then the security.* attributes are ignored.
> >> >> >>
> >> >> >> That I wasn't aware of. In fact I still haven't found where 
this
> >> >> >> restriction is implemented.
> >> >> >
> >> >> > My memory may be have been incomplete.  What I was thinking of 
is
> >> >> > security/commoncap.c the MNT_NOSUID check in get_file_caps.
> >> >> >
> >> >> > Upon inspection that appears limited to file capabilities, and 
while
> >> >> > there are a few other MNT_NOSUID checks under security the 
> feel far from
> >> >> > complete.
> >> >> >
> >> >> > Sigh.
> >> >> >
> >> >> > This deserves a hard look because if MNT_NOSUID is not 
sufficient than
> >> >> > it may be possible for me to insert a usb stick with an 
extNfilesystem
> >> >> > with the right labels having it auto-mounted nosuid and subvert 
the
> >> >> > security of something like selinux.
> >> >>
> >> >> It's this code in selinux/hooks.c:
> >> >>
> >> >>     if ((bprm->file->f_path.mnt->mnt_flags & MNT_NOSUID) ||
> >> >>         (bprm->unsafe & LSM_UNSAFE_NO_NEW_PRIVS))
> >> >>         new_tsec->sid = old_tsec->sid;
> >> >>
> >> >>
> >> >> One might argue that this should actually generate -EPERM instead 
of
> >> >> ignoring the label, but it should be safe against untrusted media.
> >> >>
> >> >> >
> >> >> >> Nonetheless, a userns mount could be done without nosuid 
(though that
> >> >> >> mount will also be unaccessible outside of that namespace).
> >> >> >>
> >> >> >>> >> It's difficult though to tell whether a mount is being 
performed
> >> >> >>> >> on behalf of an unprivileged user since fuse mounts are 
ususally
> >> >> >>> >> done via a suid root helper. Thus a new mount option,
> >> >> >>> >> privileged_xattrs, is added to indicated that xattrs from 
other
> >> >> >>> >> namespaces are allowed. This option can only be supplied by
> >> >> >>> >> system-wide root; supplying the option as an unprivileged 
user
> >> >> >>> >> will cause the mount to fail.
> >> >> >>> >
> >> >> >>> > I can't say I'm convinced that this is the right 
> direction to head.
> >> >> >>>
> >> >> >>> With respect to defaults we could keep the current default if 
you
> >> >> >>> have the global CAP_SYS_ADMIN privilege when the mount takes 
place
> >> >> >>> and then avoid breaking anything.
> >> >> >>
> >> >> >> Except that unprivileged mounts are normally done by a suid
> root helper,
> >> >> >> which is why I've required both global CAP_SYS_ADMIN and a 
> mount option
> >> >> >> to get the current default behavior.
> >> >> >
> >> >> > If nosuid is sufficient that may break existing setups for no 
good
> >> >> > reason.
> >> >> >
> >> >> > Shrug.  I won't have much time for a bit but I figured I 
> would highlight
> >> >> > the potential security hole in existing setups.  So someone with 
time
> >> >> > this week can look at that.
> >> >>
> >> >> I think I have a better solution.  I'll send it out.
> >> >
> >> > To be honest I don't understand enough about how selinux uses 
security
> >> > labels to know what level of paranoia is appropriate, so I wrote 
this
> >> > out of an excess of paranoia. If the patch you sent restricts 
things
> >> > sufficiently then I'm perfectly happy to see this patch dropped.
> >> >
> >> > And really with fuse all of this is really excess paranoia because 
(if
> >> > my other patches are applied at least) the fuse mount will be
> >> > inaccessible to any user outside the user namespace from which it 
was
> >> > mounted or its descendants.
> >> >
> >>
> >> I missed the rest of the series.  This is exciting!
> >>
> >> I'm not sure that the other protections you have are quite 
sufficient,
> >> though, without something like my patch.  I'll comment on the rest.
> >
> > I still suspect we should be doing more to limit xattrs from userns
> > mounts, since normally only root is allowed to set trusted.* and
> > security.* xattrs. Seems like this should be done more generally 
though
> > and not just specific to fuse. Something like this maybe? It probably
> > won't matter much for fuse mounts since they won't be accessible 
outside
> > the userns which did the mount, but for other filesystems the xattrs
> > could be set externally and injected into the system via a userns 
mount.
> >
> >
> > diff --git a/fs/super.c b/fs/super.c
> > index eae088f6aaae..499cd7d2d2f8 100644
> > --- a/fs/super.c
> > +++ b/fs/super.c
> > @@ -149,6 +149,7 @@ static void destroy_super(struct super_block *s)
> >                 percpu_counter_destroy(&s->s_writers.counter[i]);
> >         security_sb_free(s);
> >         WARN_ON(!list_empty(&s->s_mounts));
> > +       put_user_ns(s->s_user_ns);
> >         kfree(s->s_subtype);
> >         kfree(s->s_options);
> >         kfree_rcu(s, rcu);
> > @@ -230,6 +231,8 @@ static struct super_block *alloc_super(struct 
> file_system_type *type, int flags)
> >         s->s_shrink.count_objects = super_cache_count;
> >         s->s_shrink.batch = 1024;
> >         s->s_shrink.flags = SHRINKER_NUMA_AWARE;
> > +
> > +       s->s_user_ns = get_user_ns(&init_user_ns);
> 
> Huh?  I think I like this in principle, but shouldn't this be the
> actual userns doing the mount?
> 
> >         return s;
> >
> >  fail:
> > diff --git a/fs/xattr.c b/fs/xattr.c
> > index 64e83efb742d..383bb9f25555 100644
> > --- a/fs/xattr.c
> > +++ b/fs/xattr.c
> > @@ -40,6 +40,12 @@ xattr_permission(struct inode *inode, const 
> char *name, int mask)
> >                         return -EPERM;
> >         }
> >
> > +       /* Restrict security.* and trusted.* to mounts from 
init_user_ns. */
> > +       if (inode->i_sb->s_user_ns != &init_user_ns &&
> > +           (!strcmp(name, XATTR_SECURITY_PREFIX, 
> XATTR_SECURITY_PREFIX_LEN) ||
> > +            !strcmp(name, XATTR_TRUSTED_PREFIX, 
XATTR_TRUSTED_PREFIX_LEN)))
> > +               return -EPERM;
> > +
> 
> trusted.* should be fine already, I think -- it checks global
> capabilities.  And I still think that security.* should be left to
> LSMs, which IMO really do need to be fixed for user namespaces.
> 
> But how does this help with FUSE at all?   Does FUSE end up calling
> xattr_permission?
> 
> --Andy
> 

The xattr system calls go through xattr_permission before it ever gets to 
the FUSE ops.

Regards,
Michael Theall


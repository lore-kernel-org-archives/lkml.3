Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933139AbaLBVry (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Dec 2014 16:47:54 -0500
Received: from out02.mta.xmission.com ([166.70.13.232]:38531 "EHLO
	out02.mta.xmission.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754267AbaLBVrs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Dec 2014 16:47:48 -0500
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
Date: Tue, 02 Dec 2014 15:45:36 -0600
In-Reply-To: <CALCETrXyC7XPaqj6oe-TmyypOVc_CkZbF6UAAx8YfkyD=gEMOQ@mail.gmail.com>
	(Andy Lutomirski's message of "Tue, 2 Dec 2014 13:05:07 -0800")
Message-ID: <87a935u3nj.fsf@x220.int.ebiederm.org>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/24.3 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
X-XM-AID: U2FsdGVkX1+D8c5jUHZmmitAEngH/Vf5zAOg6cRmuTU=
X-SA-Exim-Connect-IP: 97.121.92.161
X-SA-Exim-Mail-From: ebiederm@xmission.com
X-Spam-Report: * -1.0 ALL_TRUSTED Passed through trusted hosts only via SMTP
	*  1.5 XMNoVowels Alpha-numberic number with no vowels
	*  0.7 XMSubLong Long Subject
	*  1.5 TR_Symld_Words too many words that have symbols inside
	*  0.0 TVD_RCVD_IP Message was received from an IP address
	*  0.0 T_TM2_M_HEADER_IN_MSG BODY: No description available.
	*  0.8 BAYES_50 BODY: Bayes spam probability is 40 to 60%
	*      [score: 0.5000]
	* -0.0 DCC_CHECK_NEGATIVE Not listed in DCC
	*      [sa06 1397; Body=1 Fuz1=1 Fuz2=1]
	*  1.0 T_XMDrugObfuBody_08 obfuscated drug references
	*  1.0 XMSubMetaSx_00 1+ Sexy Words
	*  1.2 XMSubMetaSSx_00 1+ SortaSexy Words + 1 Sexy Word
X-Spam-DCC: XMission; sa06 1397; Body=1 Fuz1=1 Fuz2=1 
X-Spam-Combo: ******;Andy Lutomirski <luto@amacapital.net>
X-Spam-Relay-Country: 
X-Spam-Timing: total 711 ms - load_scoreonly_sql: 0.05 (0.0%),
	signal_user_changed: 3.2 (0.5%), b_tie_ro: 2.3 (0.3%), parse: 0.92 (0.1%),
	extract_message_metadata: 27 (3.7%), get_uri_detail_list: 4.3 (0.6%),
	tests_pri_-1000: 12 (1.7%), tests_pri_-950: 1.90 (0.3%), tests_pri_-900: 1.49
	(0.2%), tests_pri_-400: 43 (6.1%), check_bayes: 42 (5.9%), b_tokenize: 17
	(2.4%), b_tok_get_all: 12 (1.7%), b_comp_prob: 5 (0.8%), b_tok_touch_all: 2.7
	(0.4%), b_finish: 1.20 (0.2%), tests_pri_0: 610 (85.8%), tests_pri_500: 6
	(0.9%), rewrite_mail: 0.00 (0.0%)
Subject: Re: [CFT][PATCH 2/3] userns: Add a knob to disable setgroups on a per user namespace basis
X-Spam-Flag: No
X-SA-Exim-Version: 4.2.1 (built Wed, 24 Sep 2014 11:00:52 -0600)
X-SA-Exim-Scanned: Yes (on in02.mta.xmission.com)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Andy Lutomirski <luto@amacapital.net> writes:

> On Tue, Dec 2, 2014 at 12:28 PM, Eric W. Biederman
> <ebiederm@xmission.com> wrote:
>>
>> - Expose the knob to user space through a proc file /proc/<pid>/setgroups
>
> Can you rename this to something clearer, e.g. userns_setgroups_mode?

I am not certain that is any clearer.  That just reads as wordier.

The userns bit is definitely confusing and wrong.  Why should we need to
spell out the scope?

>>   A value of 0 means the setgroups system call is disabled in the
>>   current processes user namespace and can not be enabled in the
>>   future in this user namespace.
>>
>>   A value of 1 means the segtoups system call is enabled.
>
> Would it make more sense to put strings like "allow" and "deny" in
> here?  That way, future extensions could add additional values.

If the implementation of the write side isn't too bad.  I would love
to see precedent elsewhere in the kernel.    What I don't expect to do
is have any values except setgroups are enabled and setgroups are
disabled.

I am fine with allowing for the possibility (that is just good
engineering) but I don't intend to seriously considering or
implementing other possibilities.

>> diff --git a/arch/s390/kernel/compat_linux.c b/arch/s390/kernel/compat_linux.c
>> index 21c91feeca2d..6d0ee1b089fb 100644
>> --- a/arch/s390/kernel/compat_linux.c
>> +++ b/arch/s390/kernel/compat_linux.c
>> @@ -252,6 +252,7 @@ COMPAT_SYSCALL_DEFINE2(s390_setgroups16, int, gidsetsize, u16 __user *, grouplis
>>         int retval;
>>
>>         if (!gid_mapping_possible(user_ns) ||
>> +           !atomic_read(&user_ns->setgroups_allowed) ||
>>             !capable(CAP_SETGID))
>>                 return -EPERM;
>
> This is now incomprehensible because of the gid_mapping_possible
> thing.  If you renamed gid_mapping_possible to
> userns_setgroup_allowed, then this could be added to the
> implementation, and this would all make sense (not to mention avoiding
> duplicating this thing).
>
>> @@ -826,6 +827,11 @@ static bool new_idmap_permitted(const struct file *file,
>>                         kuid_t uid = make_kuid(ns->parent, id);
>>                         if (uid_eq(uid, cred->euid))
>>                                 return true;
>> +               } else if (cap_setid == CAP_SETGID) {
>> +                       kgid_t gid = make_kgid(ns->parent, id);
>> +                       if (!atomic_read(&ns->setgroups_allowed) &&
>> +                           gid_eq(gid, cred->egid))
>> +                               return true;
>
> I still don't see why egid is any better than fsgid here.

Answered in my earlier response fsgid was a goof.
I can set any gid to my egid with my existing permissions.
Show me how I can do that with fsgid or fsuid and I will be happy to use
those.


>>                 }
>>         }
>>
>> @@ -844,6 +850,93 @@ static bool new_idmap_permitted(const struct file *file,
>>         return false;
>>  }
>>
>> +static void *setgroups_m_start(struct seq_file *seq, loff_t *ppos)
>> +{
>> +       struct user_namespace *ns = seq->private;
>> +
>> +       return (*ppos == 0) ?  ns : NULL;
>> +}
>> +
>> +static void *setgroups_m_next(struct seq_file *seq, void *v, loff_t *ppos)
>> +{
>> +       ++*ppos;
>> +       return NULL;
>> +}
>> +
>> +static void setgroups_m_stop(struct seq_file *seq, void *v)
>> +{
>> +}
>> +
>> +static int setgroups_m_show(struct seq_file *seq, void *v)
>> +{
>> +       struct user_namespace *ns = seq->private;
>> +
>> +       seq_printf(seq, "%u\n", atomic_read(&ns->setgroups_allowed));
>> +       return 0;
>> +}
>> +
>> +const struct seq_operations proc_setgroups_seq_operations = {
>> +       .start  = setgroups_m_start,
>> +       .stop = setgroups_m_stop,
>> +       .next = setgroups_m_next,
>> +       .show = setgroups_m_show,
>> +};
>> +
>> +ssize_t proc_setgroups_write(struct file *file, const char __user *buf,
>> +                            size_t count, loff_t *ppos)
>> +{
>> +       struct seq_file *seq = file->private_data;
>> +       struct user_namespace *ns = seq->private;
>> +       char kbuf[3];
>> +       int setgroups_allowed;
>> +       ssize_t ret;
>> +
>> +       ret = -EPERM;
>> +       if (!file_ns_capable(file, ns, CAP_SETGID))
>> +               goto out;
>
> CAP_SYS_ADMIN?  This isn't setting a gid in the namespace; it's
> reconfiguring the namespace.

Hmm.  Maybe.  It is an activity that is normally controlled by
CAP_SETGID.

Frankly I think the entire split up of the capability model is almost
totally broken.  But I think CAP_SETGID is a close approximation of the
right thing here.

>> +       /* Only allow a very narrow range of strings to be written */
>> +       ret = -EINVAL;
>> +       if ((*ppos != 0) || (count >= sizeof(kbuf)) || (count < 1))
>> +               goto out;
>> +
>> +       /* What was written? */
>> +       ret = -EFAULT;
>> +       if (copy_from_user(kbuf, buf, count))
>> +               goto out;
>> +       kbuf[count] = '\0';
>> +
>> +       /* What is being requested? */
>> +       ret = -EINVAL;
>> +       if (kbuf[0] == '0')
>> +               setgroups_allowed = 0;
>> +       else if (kbuf[0] == '1')
>> +               setgroups_allowed = 1;
>> +       else
>> +               goto out;
>> +
>> +       /* Allow a trailing newline */
>> +       ret = -EINVAL;
>> +       if ((count == 2) && (kbuf[1] != '\n'))
>> +               goto out;
>> +
>> +
>> +       if (setgroups_allowed) {
>> +               ret = -EINVAL;
>> +               if (atomic_read(&ns->setgroups_allowed) == 0)
>> +                       goto out;
>> +       } else {
>
> I would disallow this if gid_map has been written in the interest of
> sanity.

Not a chance.  That is part of making this an independent knob.  If
there is another reason for disabling setgroups you can flip this
knob even after mappings are established.

>> +               atomic_set(&ns->setgroups_allowed, 0);
>> +               /* sigh memory barriers! */
>
> I don't think that any barriers are needed.  If you ever observe
> setgroups_allowed == 0, it will stay that way forever.

Likely.   In practice the code works today.

But I need to review things closely to understand if there are barriers
needed.  But especially since it is a write once knob we can get away
with a lot.

>> +       }
>> +
>> +       /* Report a successful write */
>> +       *ppos = count;
>> +       ret = count;
>> +out:
>> +       return ret;
>> +}
>> +
>>  static void *userns_get(struct task_struct *task)
>>  {
>>         struct user_namespace *user_ns;
>
> --Andy

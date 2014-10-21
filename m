Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754586AbaJUEaQ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 21 Oct 2014 00:30:16 -0400
Received: from out02.mta.xmission.com ([166.70.13.232]:59564 "EHLO
	out02.mta.xmission.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754409AbaJUEaN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 21 Oct 2014 00:30:13 -0400
From: ebiederm@xmission.com (Eric W. Biederman)
To: Andy Lutomirski <luto@amacapital.net>
Cc: David Drysdale <drysdale@google.com>,
        Alexander Viro <viro@zeniv.linux.org.uk>,
        Meredydd Luff <meredydd@senatehouse.org>,
        "linux-kernel\@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>,
        "H. Peter Anvin" <hpa@zytor.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Kees Cook <keescook@chromium.org>, Arnd Bergmann <arnd@arndb.de>,
        X86 ML <x86@kernel.org>, linux-arch <linux-arch@vger.kernel.org>,
        Linux API <linux-api@vger.kernel.org>
References: <1401975635-6162-1-git-send-email-drysdale@google.com>
	<CALCETrVraoD+r4zxBoGd+BV5P275AXcRV_R00SSr8fjQzRHnUg@mail.gmail.com>
	<87zjcszz8y.fsf@x220.int.ebiederm.org>
	<CAHse=S-Xyk7CFn=tAGzo+tuUFt+04aBw+mGQmi=kWAaBJGALBw@mail.gmail.com>
	<CALCETrXBjLZTWVJfcsE4NA-JP9zSSgn=6ND0=cZ9BTy=CoN7pA@mail.gmail.com>
Date: Mon, 20 Oct 2014 21:29:25 -0700
In-Reply-To: <CALCETrXBjLZTWVJfcsE4NA-JP9zSSgn=6ND0=cZ9BTy=CoN7pA@mail.gmail.com>
	(Andy Lutomirski's message of "Mon, 20 Oct 2014 15:48:06 -0700")
Message-ID: <87ioje2ggq.fsf@x220.int.ebiederm.org>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/24.3 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
X-XM-AID: U2FsdGVkX19m8CJcb1iQcUwdZZFinocloQBIaY70s6A=
X-SA-Exim-Connect-IP: 68.113.178.29
X-SA-Exim-Mail-From: ebiederm@xmission.com
X-Spam-Report: * -1.0 ALL_TRUSTED Passed through trusted hosts only via SMTP
	*  0.0 TVD_RCVD_IP Message was received from an IP address
	*  0.7 XMSubLong Long Subject
	*  0.0 T_TM2_M_HEADER_IN_MSG BODY: No description available.
	*  0.8 BAYES_50 BODY: Bayes spam probability is 40 to 60%
	*      [score: 0.5000]
	* -0.0 DCC_CHECK_NEGATIVE Not listed in DCC
	*      [sa06 1397; Body=1 Fuz1=1 Fuz2=1]
	*  0.5 XM_Body_Dirty_Words Contains a dirty word
	*  1.0 T_XMDrugObfuBody_08 obfuscated drug references
	*  0.0 T_TooManySym_01 4+ unique symbols in subject
	*  1.0 T_XMDrugObfuBody_12 obfuscated drug references
	*  0.0 T_TooManySym_03 6+ unique symbols in subject
	*  0.0 T_TooManySym_02 5+ unique symbols in subject
X-Spam-DCC: XMission; sa06 1397; Body=1 Fuz1=1 Fuz2=1 
X-Spam-Combo: ***;Andy Lutomirski <luto@amacapital.net>
X-Spam-Relay-Country: 
X-Spam-Timing: total 885 ms - load_scoreonly_sql: 0.06 (0.0%),
	signal_user_changed: 3.9 (0.4%), b_tie_ro: 2.8 (0.3%), parse: 1.17 (0.1%),
	extract_message_metadata: 17 (1.9%), get_uri_detail_list: 3.2 (0.4%),
	tests_pri_-1000: 8 (0.9%), tests_pri_-950: 1.29 (0.1%), tests_pri_-900: 1.10
	(0.1%), tests_pri_-400: 31 (3.6%), check_bayes: 30 (3.4%), b_tokenize: 10
	(1.1%), b_tok_get_all: 12 (1.3%), b_comp_prob: 3.8 (0.4%), b_tok_touch_all:
	2.6 (0.3%), b_finish: 0.70 (0.1%), tests_pri_0: 810 (91.6%), tests_pri_500: 7
	(0.8%), rewrite_mail: 0.00 (0.0%)
Subject: Re: [PATCHv4 RESEND 0/3] syscalls,x86: Add execveat() system call
X-Spam-Flag: No
X-SA-Exim-Version: 4.2.1 (built Wed, 24 Sep 2014 11:00:52 -0600)
X-SA-Exim-Scanned: Yes (on in02.mta.xmission.com)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Andy Lutomirski <luto@amacapital.net> writes:

> On Mon, Oct 20, 2014 at 6:48 AM, David Drysdale <drysdale@google.com> wrote:
>> On Sun, Oct 19, 2014 at 1:20 AM, Eric W. Biederman
>> <ebiederm@xmission.com> wrote:
>>> Andy Lutomirski <luto@amacapital.net> writes:
>>>
>>>> [Added Eric Biederman, since I think your tree might be a reasonable
>>>> route forward for these patches.]
>>>>
>>>> On Thu, Jun 5, 2014 at 6:40 AM, David Drysdale <drysdale@google.com> wrote:
>>>>> Resending, adding cc:linux-api.
>>>>>
>>>>> Also, it may help to add a little more background -- this patch is
>>>>> needed as a (small) part of implementing Capsicum in the Linux kernel.
>>>>>
>>>>> Capsicum is a security framework that has been present in FreeBSD since
>>>>> version 9.0 (Jan 2012), and is based on concepts from object-capability
>>>>> security [1].
>>>>>
>>>>> One of the features of Capsicum is capability mode, which locks down
>>>>> access to global namespaces such as the filesystem hierarchy.  In
>>>>> capability mode, /proc is thus inaccessible and so fexecve(3) doesn't
>>>>> work -- hence the need for a kernel-space
>>>>
>>>> I just found myself wanting this syscall for another reason: injecting
>>>> programs into sandboxes or otherwise heavily locked-down namespaces.
>>>>
>>>> For example, I want to be able to reliably do something like nsenter
>>>> --namespace-flags-here toybox sh.  Toybox's shell is unusual in that
>>>> it is more or less fully functional, so this should Just Work (tm),
>>>> except that the toybox binary might not exist in the namespace being
>>>> entered.  If execveat were available, I could rig nsenter or a similar
>>>> tool to open it with O_CLOEXEC, enter the namespace, and then call
>>>> execveat.
>>>>
>>>> Is there any reason that these patches can't be merged more or less as
>>>> is for 3.19?
>>>
>>> Yes.  There is a silliness in how it implements fexecve.  The fexecve
>>> case should be use the empty string "" not a NULL pointer to indication
>>> that.  That change will then harmonize execveat with the other ...at
>>> system calls and simplify the code and remove a special case.  I believe
>>> using the empty string "" requires implementing the AT_EMPTY_PATH flag.
>>
>> Good point -- I'll shift to "" + AT_EMPTY_PATH.
>
> Pending a better idea, I would also see if the patches can be changed
> to return an error if d_path ends up with an "(unreachable)" thing
> rather than failing inexplicably later on.

For my reference we are talking about  

> @@ -1489,7 +1524,21 @@ static int do_execve_common(struct filename *filename,
>  	sched_exec();
> 
>  	bprm->file = file;
> -	bprm->filename = bprm->interp = filename->name;
> +	if (filename && fd == AT_FDCWD) {
> +		bprm->filename = filename->name;
> +	} else {
> +		pathbuf = kmalloc(PATH_MAX, GFP_TEMPORARY);
> +		if (!pathbuf) {
> +			retval = -ENOMEM;
> +			goto out_unmark;
> +		}
> +		bprm->filename = d_path(&file->f_path, pathbuf, PATH_MAX);
> +		if (IS_ERR(bprm->filename)) {
> +			retval = PTR_ERR(bprm->filename);
> +			goto out_unmark;
> +		}
> +	}
> +	bprm->interp = bprm->filename;
> 
>  	retval = bprm_mm_init(bprm);
>  	if (retval)

The interesting case for fexecve is when we either don't know what files
are present or we don't want to depend on which files are present.

As Al pointed out d_path really isn't the right solution.  It fails when
printing /proc/self/fd/${fd}/${filename->name} would work, and the
"(deleted)" or "(unreachable)" strings are wrong.

The test for today's cases should be:
if ((filename->name[0] == '/') || fd == AT_FDCWD) {
	bprm->filename = filename->name;
} 

To handle the case where the file descriptor is relevant.

For the case where the file descriptor is relevant let me suggest
setting bprm->filename and bprm->interp to:

/dev/fd/${fd}/${filename->name}

It is more a description of what we have done but as a magic string it
is descriptive.  Documetation/devices.txt documents that /dev/fd/ should
exist, making it an unambiguous path.  Further these days the kernel
sets the device naming policy in dev, so I think we are strongly safe in
using that path in any event.

I think execveat is interesting in the kernel because the motivating
cases are the cases where anything except a static executable is
uninteresting.

Now it has been suggested creating a dupfs or a mini-proc.  I think that
sounds like a nice companion, to the concept of a locked down root.
But I don't think it removes the need for execveat (because we still
have the case where we don't want to care what is mounted, and are happy
to use static executables). 

Eric


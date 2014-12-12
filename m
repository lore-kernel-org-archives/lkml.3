Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759319AbaLLBal (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Dec 2014 20:30:41 -0500
Received: from mail-lb0-f169.google.com ([209.85.217.169]:33481 "EHLO
	mail-lb0-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756961AbaLLBah convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Dec 2014 20:30:37 -0500
MIME-Version: 1.0
In-Reply-To: <87iohh3c9c.fsf@x220.int.ebiederm.org>
References: <52e0643bd47b1e5c65921d6e00aea1f724bb510a.1417281801.git.luto@amacapital.net>
 <87fvcxyf28.fsf_-_@x220.int.ebiederm.org> <874mtdyexp.fsf_-_@x220.int.ebiederm.org>
 <CALCETrXyC7XPaqj6oe-TmyypOVc_CkZbF6UAAx8YfkyD=gEMOQ@mail.gmail.com>
 <87a935u3nj.fsf@x220.int.ebiederm.org> <CALCETrXkEOiyzpvqtXtk1f4sL+M1Q-Y6rV=K91ez3yv2nb4Y0Q@mail.gmail.com>
 <87388xodlj.fsf@x220.int.ebiederm.org> <CALCETrXWx2-ZejEHmOi7aSoF-qJMRGR5yseeMhuurZwJRrQbUg@mail.gmail.com>
 <87h9x5re41.fsf_-_@x220.int.ebiederm.org> <87mw6xpzb0.fsf_-_@x220.int.ebiederm.org>
 <CALCETrU-o5mPr1jCaLXDuuF6J2N470zAtx=8Fa-SjF=ZpdE8mQ@mail.gmail.com>
 <87ppbtn4mv.fsf@x220.int.ebiederm.org> <CALCETrXSScp77BUJR5NSTh5-RnEZ9rqELSGJBeEzgdQ-OtohuQ@mail.gmail.com>
 <87a92xn2io.fsf@x220.int.ebiederm.org> <87r3w8liw4.fsf@x220.int.ebiederm.org>
 <87iohklfvj.fsf_-_@x220.int.ebiederm.org> <87fvcok11h.fsf_-_@x220.int.ebiederm.org>
 <CALCETrVfKiXuY=KY_=nHpkTyLWgpy_3DK=4Mr2mhpyX9z1TzrA@mail.gmail.com>
 <971ad3f6-90fd-4e3f-916c-8988af3c826d@email.android.com> <CALCETrWpzvNm=fjOa3_+4QOqYP8qZUJvQAd6AsRZ71xyHZQRCg@mail.gmail.com>
 <87wq5zf83t.fsf@x220.int.ebiederm.org> <87iohh3c9c.fsf@x220.int.ebiederm.org>
From: Andy Lutomirski <luto@amacapital.net>
Date: Thu, 11 Dec 2014 17:30:15 -0800
Message-ID: <CALCETrV-nqDwa09pHC76uE6OMe3D7zZMGYqyUf98WUtZbXUXdw@mail.gmail.com>
Subject: Re: [CFT][PATCH 7/8] userns: Add a knob to disable setgroups on a per
 user namespace basis
To: "Eric W. Biederman" <ebiederm@xmission.com>
Cc: Linux Containers <containers@lists.linux-foundation.org>,
        Josh Triplett <josh@joshtriplett.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Kees Cook <keescook@chromium.org>,
        Michael Kerrisk-manpages <mtk.manpages@gmail.com>,
        Linux API <linux-api@vger.kernel.org>,
        linux-man <linux-man@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        LSM <linux-security-module@vger.kernel.org>,
        Casey Schaufler <casey@schaufler-ca.com>,
        "Serge E. Hallyn" <serge@hallyn.com>,
        Richard Weinberger <richard@nod.at>,
        Kenton Varda <kenton@sandstorm.io>, stable <stable@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Dec 11, 2014 at 5:09 PM, Eric W. Biederman
<ebiederm@xmission.com> wrote:
> ebiederm@xmission.com (Eric W. Biederman) writes:
>
>> Andy Lutomirski <luto@amacapital.net> writes:
>>
>>> On Tue, Dec 9, 2014 at 4:04 PM, Eric W.Biederman <ebiederm@xmission.com> wrote:
>>>>
>>>>
>>>> On December 9, 2014 4:28:38 PM CST, Andy Lutomirski <luto@amacapital.net> wrote:
>>>>>On Tue, Dec 9, 2014 at 12:42 PM, Eric W. Biederman
>>>>><ebiederm@xmission.com> wrote:
>>>>>>
>>>>>> - Expose the knob to user space through a proc file
>>>>>/proc/<pid>/setgroups
>>>>>>
>>>>>>   A value of "deny" means the setgroups system call is disabled in
>>>>>the
>>>>>>   current processes user namespace and can not be enabled in the
>>>>>>   future in this user namespace.
>>>>>>
>>>>>>   A value of "allow" means the segtoups system call is enabled.
>>>>>>
>>>>>> - Descendant user namespaces inherit the value of setgroups from
>>>>>>   their parents.
>>>>>>
>>>>>> - A proc file is used (instead of a sysctl) as sysctls
>>>>>>   currently do not pass in a struct file so file_ns_capable
>>>>>>   is unusable.
>>>>>
>>>>>Reviewed-by: Andy Lutomirski <luto@amacapital.net>
>>>>>
>>>>>But I still don't like the name "setgroups".  People may look at that
>>>>>and have no clue what the scope of the setting is.  And anyone who, as
>>>>>root, writes "deny" to /proc/self/setgroups, thinking that it acts on
>>>>>self, will be in for a surprise.
>>>>
>>>> True setgroups isn't perfect.  Documenting it in a manpage may have to be enough. The only real improvement I can think of would be to make the setting a sysctl.   But I think pursuing that approaches the point where perfection is the enemy of getting this problem fixed.
>>>>
>>>
>>> Would "userns_setgroups" be okay?
>>
>> Maybe.
>>
>> I just played with this and this is a much bigger booby trap than I had
>> realized.  Disabling setgroups disables the possibility of logging in the
>> future and since it is a one way switch the only way out is to reboot.
>>
>> Hooray our software checks the returns of setgroups.  Booh.  This is a
>> really nasty knob to have anywhere.
>>
>> I need to think about this a little bit.  Giving root the power to shoot
>> himself in the foot is one thing.  Giving root a loaded gun pointed at
>> his foot with the hammer pulled back, and a sign that says I dare you to
>> pull the trigger, seems like a bad idea.
>>
>> I think I need to reduce when that knob can be used.  Grr.
>> Back to the drawing board!
>
> I tried out a bunch of things and finally found a simple rule.  Don't
> allow setgroups to be disabled after setgroups has been enabled in a
> user namespace.  Or in practical terms don't allow setgroups to be
> disabled after the gid_map has been set.
>
> Which in practice pretty nearly means that we are only allowing writes
> to setgroups when it is a single process and it's eventual children that
> can be affected.
>
> At which point I don't think a name change would make things any
> clearer.

The name change still helps the user to does:

$ ls /proc/self

"setgroups?  what's that?"

>
> I have also updated the code to move the permission checks to open
> where they belong (doh!).  Patch follows.

Will review and test.

>
> Eric
>
>
>
>
>
>



-- 
Andy Lutomirski
AMA Capital Management, LLC

Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754600Ab3JKUrm (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 Oct 2013 16:47:42 -0400
Received: from out02.mta.xmission.com ([166.70.13.232]:36113 "EHLO
	out02.mta.xmission.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752217Ab3JKUrj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 Oct 2013 16:47:39 -0400
From: ebiederm@xmission.com (Eric W. Biederman)
To: Matthew Garrett <mjg59@srcf.ucam.org>
Cc: Richard Weinberger <richard@nod.at>,
        Richard Weinberger <richard.weinberger@gmail.com>,
        Vivek Goyal <vgoyal@redhat.com>,
        Daniel Kiper <daniel.kiper@oracle.com>, hbabu@us.ibm.com,
        "H. Peter Anvin" <hpa@linux.intel.com>,
        Kees Cook <keescook@chromium.org>, kexec@lists.infradead.org,
        LKML <linux-kernel@vger.kernel.org>, david.vrabel@citrix.com,
        jbeulich@suse.com, keir@xen.org, xen-devel@lists.xen.org
References: <20131011153727.GA30181@srcf.ucam.org>
	<20131011154450.GB2772@redhat.com>
	<20131011154805.GB30181@srcf.ucam.org>
	<CAFLxGvzf1sQy-d03JAnK7eDQdBXrd-zRjcKEbv_x53st5bYELg@mail.gmail.com>
	<20131011163933.GA31941@srcf.ucam.org>
	<CAFLxGvyDYHy-UbZhdQiGvXL=8t0aW8wABc0GRkwVRy8egKJMKw@mail.gmail.com>
	<20131011164400.GA32133@srcf.ucam.org> <52582B97.2060907@nod.at>
	<20131011165542.GB32133@srcf.ucam.org> <52582E7D.8080909@nod.at>
	<20131011170138.GA32619@srcf.ucam.org>
Date: Fri, 11 Oct 2013 13:44:19 -0700
In-Reply-To: <20131011170138.GA32619@srcf.ucam.org> (Matthew Garrett's message
	of "Fri, 11 Oct 2013 18:01:39 +0100")
Message-ID: <87ob6va670.fsf@tw-ebiederman.twitter.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/24.3 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
X-XM-AID: U2FsdGVkX18XOgao6hM8rTqYJz8KjnTo6OsOIQ4n1pI=
X-SA-Exim-Connect-IP: 98.207.154.105
X-SA-Exim-Mail-From: ebiederm@xmission.com
X-Spam-Report: * -1.0 ALL_TRUSTED Passed through trusted hosts only via SMTP
	*  0.7 XMSubLong Long Subject
	*  0.0 T_TM2_M_HEADER_IN_MSG BODY: T_TM2_M_HEADER_IN_MSG
	* -3.0 BAYES_00 BODY: Bayes spam probability is 0 to 1%
	*      [score: 0.0003]
	* -0.0 DCC_CHECK_NEGATIVE Not listed in DCC
	*      [sa06 1397; Body=1 Fuz1=1 Fuz2=1]
X-Spam-DCC: XMission; sa06 1397; Body=1 Fuz1=1 Fuz2=1 
X-Spam-Combo: ;Matthew Garrett <mjg59@srcf.ucam.org>
X-Spam-Relay-Country: 
Subject: Re: kexec: Clearing registers just before jumping into purgatory
X-Spam-Flag: No
X-SA-Exim-Version: 4.2.1 (built Wed, 14 Nov 2012 14:26:46 -0700)
X-SA-Exim-Scanned: Yes (on in01.mta.xmission.com)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Matthew Garrett <mjg59@srcf.ucam.org> writes:

> On Fri, Oct 11, 2013 at 06:59:41PM +0200, Richard Weinberger wrote:
>> Am 11.10.2013 18:55, schrieb Matthew Garrett:
>> > On Fri, Oct 11, 2013 at 06:47:19PM +0200, Richard Weinberger wrote:
>> > 
>> >> But you still need a magic tool which create you this list.
>> > 
>> > I just read /proc/kallsyms. I'm really not doing anything complicated.
>> > 
>> >> If you have a tool which takes two kernel images and create such
>> >> a delta, fine.
>> > 
>> > Isn't that ksplice?
>> 
>> So, you have a variant of ksplice which is able to kexec?
>
> No, I manually look up some addresses from /proc/kallsyms and then 
> modify them in the second kernel.

An interesting approach I think most of the rest of us would have just
built a module, or rebuilt our kernels.

Now if this is a backwards argument to remove that silly code path it
totally fails because now we know the code has not bit-rotted and
that there are active users.

If you are still pushing the signed-boot agenda I eagerly await your
patches to make all of this work in a sensible way with signed binaries.

Eric


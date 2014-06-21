Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757581AbaFUCZt (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 Jun 2014 22:25:49 -0400
Received: from mail-ve0-f176.google.com ([209.85.128.176]:33339 "EHLO
	mail-ve0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753880AbaFUCZs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 Jun 2014 22:25:48 -0400
MIME-Version: 1.0
In-Reply-To: <alpine.DEB.2.10.1406210143030.5170@nanos>
References: <1403129285-5038-1-git-send-email-xerofoify@gmail.com>
	<20140619052128.GV5015@mwanda>
	<CAPDOMVgwT2=iWAHOhgHSBY1B+KoWHQgCdK4idD2miwB=_eMs5Q@mail.gmail.com>
	<alpine.DEB.2.10.1406210143030.5170@nanos>
Date: Fri, 20 Jun 2014 22:25:47 -0400
Message-ID: <CAPDOMVihML8uWwBWRTPGG_abHxrW++xP9_Po7B0_KQZmDfHv-Q@mail.gmail.com>
Subject: Re: [PATCH] Check for Null return of function of affs_bread in
 function affs_truncate
From: Nick Krause <xerofoify@gmail.com>
To: Thomas Gleixner <tglx@linutronix.de>
Cc: Dan Carpenter <dan.carpenter@oracle.com>, akpm@linux-foundation.org,
        viro@zeniv.linux.org.uk, fabf@skynet.be,
        kirill.shutemov@linux.intel.com, linux-fsdevel@vger.kernel.org,
        linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Thanks for standing up for me Thomas.
If you have any ideas about what is better
please let me known.
Cheers Nick

On Fri, Jun 20, 2014 at 7:59 PM, Thomas Gleixner <tglx@linutronix.de> wrote:
> On Fri, 20 Jun 2014, Nick Krause wrote:
>
>> Ok that's fine I would return as if it's a NULL the other parts of the
>> function can't continue.
>> Nick
>>
>> On Thu, Jun 19, 2014 at 1:21 AM, Dan Carpenter <dan.carpenter@oracle.com> wrote:
>> > On Wed, Jun 18, 2014 at 06:08:05PM -0400, Nicholas Krause wrote:
>> >> Signed-off-by: Nicholas Krause <xerofoify@gmail.com>
>> >> ---
>> >>  fs/affs/file.c | 2 ++
>> >>  1 file changed, 2 insertions(+)
>> >>
>> >> diff --git a/fs/affs/file.c b/fs/affs/file.c
>> >> index a7fe57d..f26482d 100644
>> >> --- a/fs/affs/file.c
>> >> +++ b/fs/affs/file.c
>> >> @@ -923,6 +923,8 @@ affs_truncate(struct inode *inode)
>> >>
>> >>       while (ext_key) {
>> >>               ext_bh = affs_bread(sb, ext_key);
>> >> +             if (!ext_bh)
>> >> +                     return;
>> >
>> > The problem is that we don't know if we should return here or break
>> > here.  If you don't understand the code, then it's best to just leave it
>> > alone.
>
> Dan, what kind of attitude is that?
>
> Nick certainly found an issue where a possible NULL return from
> affs_bread() can cause havoc.
>
> Do YOU understand that code?
>
> If yes, you better explain, WHY Nicks finding is a false positive
> instead of just telling him off in a very inpolite way.
>
> If not, you better refrain from telling a reporter that he does not
> understand the code and should stay away.
>
> You clearly stated that you do not understand it either:
>
>> > The problem is that we don't know if we should return here or break
>> > here.
>
> The problem here is that proceeding with a known NULL pointer is wrong
> to begin with. It does not matter at all whether break or return is
> the proper thing to do. What matters is that proceeding with a NULL
> pointer is wrong to begin with, no matter what.
>
> So either explain why this is a non issue and the NULL pointer return
> cannot happen or shut up and try to find a proper solution for that
> "return" vs. "break" issue.
>
> Thanks,
>
>         tglx

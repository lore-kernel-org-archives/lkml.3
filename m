Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752771AbaGMGSa (ORCPT <rfc822;w@1wt.eu>);
	Sun, 13 Jul 2014 02:18:30 -0400
Received: from mail-vc0-f182.google.com ([209.85.220.182]:60280 "EHLO
	mail-vc0-f182.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751539AbaGMGSV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 13 Jul 2014 02:18:21 -0400
MIME-Version: 1.0
In-Reply-To: <20140711150516.GR23001@mwanda>
References: <1403129285-5038-1-git-send-email-xerofoify@gmail.com>
	<20140619052128.GV5015@mwanda>
	<CAPDOMVgwT2=iWAHOhgHSBY1B+KoWHQgCdK4idD2miwB=_eMs5Q@mail.gmail.com>
	<alpine.DEB.2.10.1406210143030.5170@nanos>
	<20140711150516.GR23001@mwanda>
Date: Sun, 13 Jul 2014 02:18:20 -0400
Message-ID: <CAPDOMVjNOWHwKvqJLfYJAMv8J-Mqm_+rLLJVki8YCqx1cKZrLg@mail.gmail.com>
Subject: Re: [PATCH] Check for Null return of function of affs_bread in
 function affs_truncate
From: Nick Krause <xerofoify@gmail.com>
To: Dan Carpenter <dan.carpenter@oracle.com>
Cc: Thomas Gleixner <tglx@linutronix.de>,
        Andrew Morton <akpm@linux-foundation.org>,
        Al Viro <viro@zeniv.linux.org.uk>, fabf@skynet.be,
        kirill.shutemov@linux.intel.com, linux-fsdevel@vger.kernel.org,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jul 11, 2014 at 11:05 AM, Dan Carpenter
<dan.carpenter@oracle.com> wrote:
> On Sat, Jun 21, 2014 at 01:59:15AM +0200, Thomas Gleixner wrote:
>> On Fri, 20 Jun 2014, Nick Krause wrote:
>>
>> > Ok that's fine I would return as if it's a NULL the other parts of the
>> > function can't continue.
>> > Nick
>> >
>> > On Thu, Jun 19, 2014 at 1:21 AM, Dan Carpenter <dan.carpenter@oracle.com> wrote:
>> > > On Wed, Jun 18, 2014 at 06:08:05PM -0400, Nicholas Krause wrote:
>> > >> Signed-off-by: Nicholas Krause <xerofoify@gmail.com>
>> > >> ---
>> > >>  fs/affs/file.c | 2 ++
>> > >>  1 file changed, 2 insertions(+)
>> > >>
>> > >> diff --git a/fs/affs/file.c b/fs/affs/file.c
>> > >> index a7fe57d..f26482d 100644
>> > >> --- a/fs/affs/file.c
>> > >> +++ b/fs/affs/file.c
>> > >> @@ -923,6 +923,8 @@ affs_truncate(struct inode *inode)
>> > >>
>> > >>       while (ext_key) {
>> > >>               ext_bh = affs_bread(sb, ext_key);
>> > >> +             if (!ext_bh)
>> > >> +                     return;
>> > >
>> > > The problem is that we don't know if we should return here or break
>> > > here.  If you don't understand the code, then it's best to just leave it
>> > > alone.
>>
>> Dan, what kind of attitude is that?
>
> I'm just catching up on email after being offline for a while.
>
> I apologize that my email came off ruder than intended.
>
> I just meant that as a general rule, sometimes you should leave the
> static checker warning there if you aren't sure what the correct fix is.
> Even when it's a real bug, don't just guess at it, you have to be sure.
> Otherwise you just create a more subtle bug that the static checker
> can't detect.
>
> regards,
> dan carpenter
>
Hey Dan,
I am pretty sure this is correct as affs_bread does not check for NULL
and I am checking
the return of this function. If you feel this patch is wrong and would
like me to rewrite it.
Cheers Nick

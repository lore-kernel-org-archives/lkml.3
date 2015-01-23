Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752948AbbAWGBb (ORCPT <rfc822;w@1wt.eu>);
	Fri, 23 Jan 2015 01:01:31 -0500
Received: from ozlabs.org ([103.22.144.67]:36669 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751092AbbAWGB2 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 23 Jan 2015 01:01:28 -0500
Message-ID: <1421992886.24984.17.camel@ellerman.id.au>
Subject: Re: [PATCH] selftests/exec: Check if the syscall exists and bail if
 not
From: Michael Ellerman <mpe@ellerman.id.au>
To: David Drysdale <drysdale@google.com>
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Linux API <linux-api@vger.kernel.org>,
        Geert Uytterhoeven <geert@linux-m68k.org>,
        Shuah Khan <shuahkh@osg.samsung.com>, davej@codemonkey.org.uk
Date: Fri, 23 Jan 2015 17:01:26 +1100
In-Reply-To: <CAHse=S_AWuY4YG7DJeU+Rma-kPuQLGZH2oqVV27RvF4unu61Aw@mail.gmail.com>
References: <1421826060-2237-1-git-send-email-mpe@ellerman.id.au>
	 <CAHse=S_AWuY4YG7DJeU+Rma-kPuQLGZH2oqVV27RvF4unu61Aw@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.12.7-0ubuntu1 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2015-01-21 at 10:22 +0000, David Drysdale wrote:
> On Wed, Jan 21, 2015 at 7:41 AM, Michael Ellerman <mpe@ellerman.id.au> wrote:
> > On systems which don't implement sys_execveat(), this test produces a
> > lot of output.
> >
> > Add a check at the beginning to see if the syscall is present, and if
> > not just note one error and return.
> 
> Good point, thanks.
> 
> > diff --git a/tools/testing/selftests/exec/execveat.c b/tools/testing/selftests/exec/execveat.c
> > index e238c9559caf..b87e4a843bea 100644
> > --- a/tools/testing/selftests/exec/execveat.c
> > +++ b/tools/testing/selftests/exec/execveat.c
> > @@ -234,6 +234,14 @@ static int run_tests(void)
> >         int fd_cloexec = open_or_die("execveat", O_RDONLY|O_CLOEXEC);
> >         int fd_script_cloexec = open_or_die("script", O_RDONLY|O_CLOEXEC);
> >
> > +       /* Check if we have execveat at all, and bail early if not */
> > +       errno = 0;
> > +       execveat_(-1, NULL, NULL, NULL, 0);
> > +       if (errno == -ENOSYS) {
> 
> Could we change this to ENOSYS (no minus) and also change
> the execveat_() function similarly, so that a binary built where
> __NR_execveat is available but running where it isn't also exits
> early?  (My bad for having the minus sign in execveat_() in the
> first place -- fingers too used to kernel mode.)

Ah yeah, me too, -ENOSYS just came naturally.

Will fix up and retest and resend.

cheers



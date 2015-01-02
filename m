Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752077AbbABNqb (ORCPT <rfc822;w@1wt.eu>);
	Fri, 2 Jan 2015 08:46:31 -0500
Received: from mail-qg0-f46.google.com ([209.85.192.46]:44475 "EHLO
	mail-qg0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750783AbbABNq3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 2 Jan 2015 08:46:29 -0500
MIME-Version: 1.0
In-Reply-To: <54985F6E.2010205@osg.samsung.com>
References: <1419159496-11558-1-git-send-email-geert@linux-m68k.org> <54985F6E.2010205@osg.samsung.com>
From: David Drysdale <drysdale@google.com>
Date: Fri, 2 Jan 2015 13:46:08 +0000
Message-ID: <CAHse=S-DZwvreXMS6gLc5CiWsEVC_4-6hgzrr1nbG8H_Ab8Sug@mail.gmail.com>
Subject: Re: [PATCH] selftests/exec: Use %zu to format size_t
To: Shuah Khan <shuahkh@osg.samsung.com>
Cc: Geert Uytterhoeven <geert@linux-m68k.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Linux API <linux-api@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Dec 22, 2014 at 6:14 PM, Shuah Khan <shuahkh@osg.samsung.com> wrote:
>
> On 12/21/2014 03:58 AM, Geert Uytterhoeven wrote:
> > On 32-bit:
> >
> > execveat.c: In function 'check_execveat_pathmax':
> > execveat.c:183: warning: format '%lu' expects type 'long unsigned int', but argument 3 has type 'size_t'
> > execveat.c:187: warning: format '%lu' expects type 'long unsigned int', but argument 2 has type 'size_t'
> >
> > Signed-off-by: Geert Uytterhoeven <geert@linux-m68k.org>
> > ---
> >  tools/testing/selftests/exec/execveat.c | 4 ++--
> >  1 file changed, 2 insertions(+), 2 deletions(-)
> >
> > diff --git a/tools/testing/selftests/exec/execveat.c b/tools/testing/selftests/exec/execveat.c
> > index 33a5c06d95caa038..d273624c93a64254 100644
> > --- a/tools/testing/selftests/exec/execveat.c
> > +++ b/tools/testing/selftests/exec/execveat.c
> > @@ -179,11 +179,11 @@ static int check_execveat_pathmax(int dot_dfd, const char *src, int is_script)
> >        */
> >       fd = open(longpath, O_RDONLY);
> >       if (fd > 0) {
> > -             printf("Invoke copy of '%s' via filename of length %lu:\n",
> > +             printf("Invoke copy of '%s' via filename of length %zu:\n",
> >                       src, strlen(longpath));
> >               fail += check_execveat(fd, "", AT_EMPTY_PATH);
> >       } else {
> > -             printf("Failed to open length %lu filename, errno=%d (%s)\n",
> > +             printf("Failed to open length %zu filename, errno=%d (%s)\n",
> >                       strlen(longpath), errno, strerror(errno));
> >               fail++;
> >       }
> >
>
>
> Applied to kernel/git/shuah/linux-kselftest.git fixes
> for 3.19-rc2
>
> thanks,
> -- Shuah

Thanks for fixing, and apologies for the delay in responding.

Acked-by: David Drysdale <drysdale@google.com>

> --
> Shuah Khan
> Sr. Linux Kernel Developer
> Open Source Innovation Group
> Samsung Research America (Silicon Valley)
> shuahkh@osg.samsung.com | (970) 217-8978

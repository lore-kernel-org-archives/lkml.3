Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757356AbaJ2VWw (ORCPT <rfc822;w@1wt.eu>);
	Wed, 29 Oct 2014 17:22:52 -0400
Received: from mail-lb0-f174.google.com ([209.85.217.174]:39135 "EHLO
	mail-lb0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755636AbaJ2VWv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 29 Oct 2014 17:22:51 -0400
MIME-Version: 1.0
In-Reply-To: <1414614013.5330.90.camel@dhcp-9-2-203-236.watson.ibm.com>
References: <alpine.LRH.2.11.1410291450290.28213@namei.org>
 <CALCETrUskFJY6hd9OCN_N1645VZ6zfwbGAuSEJNt6F_FPUi3gg@mail.gmail.com>
 <1414587599.5330.50.camel@dhcp-9-2-203-236.watson.ibm.com>
 <CALCETrWpHXp=7u2777ANJjxQ5rRqmutnEwf76dLX2s_LXf87pQ@mail.gmail.com>
 <20141029183612.GI6890@mwanda> <CALCETrU1S94M1L-UM5Rg91J4kGjJRFLiPxce5aAnPPJVeitQ_A@mail.gmail.com>
 <1414614013.5330.90.camel@dhcp-9-2-203-236.watson.ibm.com>
From: Andy Lutomirski <luto@amacapital.net>
Date: Wed, 29 Oct 2014 14:22:29 -0700
Message-ID: <CALCETrUNYRbeA7EiTfd9hXMsHrES9EMAYaS=2FHOO=Kbm6qBTg@mail.gmail.com>
Subject: Re: [GIT PULL] Fix for Integrity subsystem null pointer deref
To: Mimi Zohar <zohar@linux.vnet.ibm.com>
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        LSM List <linux-security-module@vger.kernel.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Dan Carpenter <dan.carpenter@oracle.com>,
        James Morris <jmorris@namei.org>,
        "security@kernel.org" <security@kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Oct 29, 2014 1:20 PM, "Mimi Zohar" <zohar@linux.vnet.ibm.com> wrote:
>
> On Wed, 2014-10-29 at 11:51 -0700, Andy Lutomirski wrote:
> > On Wed, Oct 29, 2014 at 11:36 AM, Dan Carpenter
> > <dan.carpenter@oracle.com> wrote:
> > > On Wed, Oct 29, 2014 at 09:23:45AM -0700, Andy Lutomirski wrote:
> > >> I have no idea what the semantics are.  All I'm saying is that it
> > >> looks like the code still accesses memory past the end of the buffer.
> > >> The buffer isn't a null pointer, so the symptom is different, but it
> > >> may still be a security bug.
> > >>
> > >> --Andy
> > >
> > > It only reads one byte into the struct "xattr_data->type" so checking
> > > for non-zero is sufficient and the patch is fine.
> >
> > Indeed.  Still... eww.  I don't like code that, upon local inspection,
> > is apparently wrong, even though it's coincidentally correct due to
> > some other far away condition.
>
> No, the code may be incomplete, but definitely not wrong.

I said "apparently wrong" instead of "wrong" for a reason :)

>
> Mimi
>

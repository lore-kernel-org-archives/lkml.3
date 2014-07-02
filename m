Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753880AbaGBNte (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Jul 2014 09:49:34 -0400
Received: from mail-qc0-f179.google.com ([209.85.216.179]:41859 "EHLO
	mail-qc0-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751708AbaGBNtc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Jul 2014 09:49:32 -0400
From: Paul Moore <paul@paul-moore.com>
To: David Drysdale <drysdale@google.com>
Cc: Andy Lutomirski <luto@amacapital.net>,
        LSM List <linux-security-module@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Alexander Viro <viro@zeniv.linux.org.uk>,
        Meredydd Luff <meredydd@senatehouse.org>,
        Kees Cook <keescook@chromium.org>,
        James Morris <james.l.morris@oracle.com>,
        Linux API <linux-api@vger.kernel.org>
Subject: Re: [PATCH 09/11] capsicum: implementations of new LSM hooks
Date: Wed, 02 Jul 2014 09:49:24 -0400
Message-ID: <1871630.hB3tXi0r3a@sifl>
User-Agent: KMail/4.13.2 (Linux/3.14.8-gentoo; KDE/4.13.2; x86_64; ; )
In-Reply-To: <CALCETrUBCL1jKfooLaqrJCb-uYrMwYPQL2v-M04NTVf2LoD_fw@mail.gmail.com>
References: <1404124096-21445-1-git-send-email-drysdale@google.com> <1404124096-21445-10-git-send-email-drysdale@google.com> <CALCETrUBCL1jKfooLaqrJCb-uYrMwYPQL2v-M04NTVf2LoD_fw@mail.gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Monday, June 30, 2014 09:05:38 AM Andy Lutomirski wrote:
> On Mon, Jun 30, 2014 at 3:28 AM, David Drysdale <drysdale@google.com> wrote:
> > If the LSM does not provide implementations of the .file_lookup and
> > .file_install LSM hooks, always use the Capsicum implementations.
> > 
> > The Capsicum implementation of file_lookup checks for a Capsicum
> > capability wrapper file and unwraps to if the appropriate rights
> > are available.
> > 
> > The Capsicum implementation of file_install checks whether the file
> > has restricted rights associated with it.  If it does, it is replaced
> > with a Capsicum capability wrapper file before installation into the
> > fdtable.
> 
> I think I fall on the "no LSM" side of the fence.  This kind of stuff
> should be available regardless of selected LSM (as it is in your
> code) ...

I agree.  Looking quickly at the patches, the code seems to take an odd 
approach of living largely outside the LSM framework, but then relying on a 
couple of LSM hooks.  Capsicum should either live fully as a LSM or fully 
outside of it, this mix seems a bit silly to me.

-- 
paul moore
www.paul-moore.com


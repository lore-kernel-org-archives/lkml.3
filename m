Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933836AbaJUVpM (ORCPT <rfc822;w@1wt.eu>);
	Tue, 21 Oct 2014 17:45:12 -0400
Received: from mail-la0-f42.google.com ([209.85.215.42]:38354 "EHLO
	mail-la0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933691AbaJUVox (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 21 Oct 2014 17:44:53 -0400
MIME-Version: 1.0
In-Reply-To: <OF497DB250.D815133A-ON86257D78.007665A1-86257D78.00767AED@us.ibm.com>
References: <1413296756-25071-1-git-send-email-seth.forshee@canonical.com>
 <1413296756-25071-5-git-send-email-seth.forshee@canonical.com>
 <OFD40DA8DF.F78EA39D-ON86257D71.0057C4DC-86257D71.0064055D@us.ibm.com>
 <878ukis9oh.fsf@x220.int.ebiederm.org> <20141014205955.GA10908@ubuntu-mba51>
 <877g02pd7f.fsf@x220.int.ebiederm.org> <CALCETrU3Gzo-dx9uNH3Wuqa8Brk8xcxQsw7YGgVd74simXK0gw@mail.gmail.com>
 <20141015073951.GB10908@ubuntu-mba51> <CALCETrWnHfXN9VK9P-97XiVN6LkWr1nV4CxMpsRPGCOMc1xvvg@mail.gmail.com>
 <20141021212151.GB83801@ubuntu-hedt> <CALCETrWrqDAbq5uxPxZ=MjfSDetuZa94pNF2EH3abE6PhJm6=g@mail.gmail.com>
 <OF497DB250.D815133A-ON86257D78.007665A1-86257D78.00767AED@us.ibm.com>
From: Andy Lutomirski <luto@amacapital.net>
Date: Tue, 21 Oct 2014 14:44:31 -0700
Message-ID: <CALCETrUF4v=H-BnSF1tUbcCsr+8=as_=10HCz2122WT7euU58w@mail.gmail.com>
Subject: Re: [fuse-devel] [PATCH v4 4/5] fuse: Support privileged xattrs only
 with a mount option
To: Michael j Theall <mtheall@us.ibm.com>
Cc: "Eric W. Biederman" <ebiederm@xmission.com>,
        fuse-devel@lists.sourceforge.net,
        Linux FS Devel <linux-fsdevel@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Miklos Szeredi <miklos@szeredi.hu>,
        "Serge H. Hallyn" <serge.hallyn@ubuntu.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Oct 21, 2014 at 2:34 PM, Michael j Theall <mtheall@us.ibm.com> wrote:
> Andy Lutomirski <luto@amacapital.net> wrote on 10/21/2014 04:27:13 PM:
>> But how does this help with FUSE at all?   Does FUSE end up calling
>> xattr_permission?
>>
>> --Andy
>>
>
> The xattr system calls go through xattr_permission before it ever gets to
> the FUSE ops.

But a malicious FUSE filesystem can just put those xattrs there by
fiat, the same way that my old FUSE-based sploit put a setuid root
copy of bash in the filesystem.  No setxattr calls are needed.

--Andy

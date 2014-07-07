Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753758AbaGGOLk (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 Jul 2014 10:11:40 -0400
Received: from mail-qa0-f52.google.com ([209.85.216.52]:56938 "EHLO
	mail-qa0-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753566AbaGGOLe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 Jul 2014 10:11:34 -0400
MIME-Version: 1.0
In-Reply-To: <53BA9094.9080401@redhat.com>
References: <1404124096-21445-1-git-send-email-drysdale@google.com>
 <53B51E81.4090700@redhat.com> <20140703183927.GA1629@google.com>
 <53B651C5.80602@redhat.com> <CAHse=S83APPfnEwO1fQbV_tNd=9zsAsZr42KbYM_He-c3C3P6A@mail.gmail.com>
 <53BA9094.9080401@redhat.com>
From: David Drysdale <drysdale@google.com>
Date: Mon, 7 Jul 2014 15:11:08 +0100
Message-ID: <CAHse=S8HutKUqjP-O=B4ByrpOnaNtdvpNxasp69sgG_U2No-4g@mail.gmail.com>
Subject: Re: [RFC PATCH 00/11] Adding FreeBSD's Capsicum security framework
 (part 1)
To: Paolo Bonzini <pbonzini@redhat.com>
Cc: LSM List <linux-security-module@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Alexander Viro <viro@zeniv.linux.org.uk>,
        Meredydd Luff <meredydd@senatehouse.org>,
        Kees Cook <keescook@chromium.org>,
        James Morris <james.l.morris@oracle.com>,
        Linux API <linux-api@vger.kernel.org>,
        qemu-devel <qemu-devel@nongnu.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jul 7, 2014 at 1:20 PM, Paolo Bonzini <pbonzini@redhat.com> wrote:
> Il 07/07/2014 12:29, David Drysdale ha scritto:
>> Capsicum capabilities are associated with the file descriptor (a la
>> F_GETFD), not the open file itself -- different FDs with different
>> associated rights can map to the same underlying open file.
>
>
> Good to know, thanks.  I suppose you have testcases that cover this.
>
> Paolo

Yeah, there's lots of tests at:
  https://github.com/google/capsicum-test
(which is in a separate repo so it's easy to run against
FreeBSD as well as the Linux code); in particular
  https://github.com/google/capsicum-test/blob/dev/capability-fd.cc
has various interactions of capability FDs.

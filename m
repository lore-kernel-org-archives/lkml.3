Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752882AbaG2IoP (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Jul 2014 04:44:15 -0400
Received: from mx1.redhat.com ([209.132.183.28]:17376 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751430AbaG2IoM (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Jul 2014 04:44:12 -0400
Message-ID: <53D75EB6.1090301@redhat.com>
Date: Tue, 29 Jul 2014 10:43:34 +0200
From: Paolo Bonzini <pbonzini@redhat.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.6.0
MIME-Version: 1.0
To: "Eric W. Biederman" <ebiederm@xmission.com>,
        David Drysdale <drysdale@google.com>
CC: LSM List <linux-security-module@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Alexander Viro <viro@zeniv.linux.org.uk>,
        Meredydd Luff <meredydd@senatehouse.org>,
        Kees Cook <keescook@chromium.org>,
        James Morris <james.l.morris@oracle.com>,
        Andy Lutomirski <luto@amacapital.net>,
        Paul Moore <paul@paul-moore.com>,
        Christoph Hellwig <hch@infradead.org>,
        Linux API <linux-api@vger.kernel.org>
Subject: Re: [RFC PATCHv2 00/11] Adding FreeBSD's Capsicum security framework
References: <1406296033-32693-1-git-send-email-drysdale@google.com>	<871tt796i0.fsf@x220.int.ebiederm.org>	<CAHse=S_7Jpb9bTXHgU8q8_UZ=ce2gwdq8C15a+jbfO_pHmV_iA@mail.gmail.com> <87ha21qja0.fsf@x220.int.ebiederm.org>
In-Reply-To: <87ha21qja0.fsf@x220.int.ebiederm.org>
X-Enigmail-Version: 1.6
Content-Type: text/plain; charset=ISO-8859-15
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Il 28/07/2014 23:13, Eric W. Biederman ha scritto:
> This notion that a shared structure should have different semantics
> depending on who is looking at it, sounds like a maintenance nightmare
> to me. 

Isn't that already with seccomp BPF filters?  You can have the parent
process set a BPF filter that forbids read on that file descriptor or
write on that file descriptor.

Effectively, this patchset provides the functionality to "hotplug" BPF
filters on a running process as more file descriptors are passed via
SCM_RIGHTS.  Except it doesn't use BPF filters, and instead uses a
separate set of discrete capabilities.

> I see two sensible implementations:
> - Add a seccomp bpf filter to struct file.

I proposed something like this, but it has some additional
implementation complications.  See the v1 thread.

But it does have to be in a file descriptor rather than a struct file.
It's part of the model that two processes can have different views of
the file descriptor (again my toy example is that of an eventfd that an
unprivileged child process can only write to).

> Additionally unless there is a process wide restriction to relative
> paths I can trivially escape your relative path implementation by simply
> doing open(.) and getting a struct file without any of those
> restrictions.

Yes, there is a prctl for that.

Paolo

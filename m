Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752104AbaKCL5g (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 Nov 2014 06:57:36 -0500
Received: from mx1.redhat.com ([209.132.183.28]:41249 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751175AbaKCL5b (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 Nov 2014 06:57:31 -0500
Message-ID: <54576D7A.1010900@redhat.com>
Date: Mon, 03 Nov 2014 12:56:42 +0100
From: Paolo Bonzini <pbonzini@redhat.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Thunderbird/31.2.0
MIME-Version: 1.0
To: David Drysdale <drysdale@google.com>, linux-kernel@vger.kernel.org,
        Alexander Viro <viro@zeniv.linux.org.uk>,
        Kees Cook <keescook@chromium.org>
CC: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Meredydd Luff <meredydd@senatehouse.org>,
        Will Drewry <wad@chromium.org>,
        Jorge Lucangeli Obes <jorgelo@google.com>,
        Ricky Zhou <rickyz@google.com>, Lee Campbell <leecam@google.com>,
        Julien Tinnes <jln@google.com>, Mike Depinet <mdepinet@google.com>,
        James Morris <james.l.morris@oracle.com>,
        Andy Lutomirski <luto@amacapital.net>,
        Paul Moore <paul@paul-moore.com>,
        Christoph Hellwig <hch@infradead.org>,
        "Eric W. Biederman" <ebiederm@xmission.com>, linux-api@vger.kernel.org,
        linux-security-module@vger.kernel.org
Subject: Re: [PATCH man-pages 3/3] open.2: describe O_BENEATH flag
References: <1415015305-15494-1-git-send-email-drysdale@google.com> <1415015305-15494-4-git-send-email-drysdale@google.com>
In-Reply-To: <1415015305-15494-4-git-send-email-drysdale@google.com>
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 03/11/2014 12:48, David Drysdale wrote:
> +.I pathname
> +is beneath the current working directory (for
> +.BR open (2))
> +or the
> +.I dirfd
> +(for
> +.BR openat (2)).
> +If the
> +.I pathname
> +is absolute or contains a path component of "..", the
> +.BR open ()
> +fails with the error
> +.BR EACCES.
> +This occurs even if ".." path component would not actually
> +escape the original directory; for example, a
> +.I pathname
> +of "subdir/../filename" would be rejected.
> +Path components that are symbolic links to absolute paths, or that are
> +relative paths containing a ".." component, will also cause the
> +.BR open ()
> +operation to fail with the error
> +.BR EACCES.

I wonder if EPERM is more appropriate than EACCES.

Apart from this, the patches look fine.

Paolo

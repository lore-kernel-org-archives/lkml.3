Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752467Ab3AVG1b (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Jan 2013 01:27:31 -0500
Received: from ozlabs.org ([203.10.76.45]:35375 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750889Ab3AVG1a (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Jan 2013 01:27:30 -0500
From: Rusty Russell <rusty@ozlabs.org>
To: Vivek Goyal <vgoyal@redhat.com>, linux-kernel@vger.kernel.org
Cc: ebiederm@xmission.com, zohar@linux.vnet.ibm.com, pjones@redhat.com,
        hpa@zytor.com, dhowells@redhat.com, jwboyer@redhat.com,
        vgoyal@redhat.com, "Mimi Zohar" <zohar@linux.vnet.ibm.com>
Subject: Re: [PATCH 0/3] ELF executable signing and verification
In-Reply-To: <1358285695-26173-1-git-send-email-vgoyal@redhat.com>
References: <1358285695-26173-1-git-send-email-vgoyal@redhat.com>
User-Agent: Notmuch/0.14 (http://notmuchmail.org) Emacs/23.4.1 (i686-pc-linux-gnu)
Date: Tue, 22 Jan 2013 14:52:19 +1030
Message-ID: <87ip6phmo4.fsf@rustcorp.com.au>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Vivek Goyal <vgoyal@redhat.com> writes:
> Hi,
>
> This is a very crude RFC for ELF executable signing and verification. This
> has been done along the lines of module signature verification.

Yes, but I'm the first to admit that's the wrong lines.

The reasons we didn't choose that for module signatures:
1) I was unaware of it,
2) We didn't have a file descriptor in the module syscall, and
3) It needs attributes, and we don't understand xattrs in cpio (though
   bsdcpio does).

#1 and #2 are no longer true; #3 is a simple matter of coding.

Since signing binaries is the New Hotness, I'd prefer not to keep
reiterating this discussion every month.  Let's beef up IMA instead...

Thanks,
Rusty.

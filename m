Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932241AbaGZT4Y (ORCPT <rfc822;w@1wt.eu>);
	Sat, 26 Jul 2014 15:56:24 -0400
Received: from mail-vc0-f172.google.com ([209.85.220.172]:57308 "EHLO
	mail-vc0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754305AbaGZT4V (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 26 Jul 2014 15:56:21 -0400
MIME-Version: 1.0
In-Reply-To: <20140726193557.GA21842@x4>
References: <20140723190230.GH3935@laptop>
	<CA+55aFyM1wqTLK0m4GQJ28f=z0iZE87=xk+1z-vm+PH1_d8nKw@mail.gmail.com>
	<53D064C7.5050807@daenzer.net>
	<CA+55aFyJhqiPv0kQ+51=Ei-zaAO+0JszxtnEyx-Gbto3SE00xw@mail.gmail.com>
	<53D1B1EF.7030603@daenzer.net>
	<20140725035527.GA30108@pg-vmw-gw1>
	<20140725140237.GB32669@home.goodmis.org>
	<CA+55aFzOoJzqJ=4RVPEBfscA8oRdr5Nv7fKx9aXYw2+frkuhwA@mail.gmail.com>
	<CA+55aFyHU4Gwk6ASTuOgh3eFPshkgy1s5zc4p7f01DwrYddFOw@mail.gmail.com>
	<CA+55aFxaXPqyDJv-SNu6Giy3eKCu_SY1wof1NaNnPTbtF9RbXQ@mail.gmail.com>
	<20140726193557.GA21842@x4>
Date: Sat, 26 Jul 2014 12:56:19 -0700
X-Google-Sender-Auth: FOP6g7WWunfoMmS9CBicS3KsyM4
Message-ID: <CA+55aFyo=HVZGEYNmz9GHqLatFHiJYTviKz_dXjqCv8b_gGxBA@mail.gmail.com>
Subject: Re: Random panic in load_balance() with 3.16-rc
From: Linus Torvalds <torvalds@linux-foundation.org>
To: Markus Trippelsdorf <markus@trippelsdorf.de>
Cc: Steven Rostedt <rostedt@goodmis.org>, Alexei Starovoitov <ast@kernel.org>,
        =?UTF-8?Q?Michel_D=C3=A4nzer?= <michel@daenzer.net>,
        Jakub Jelinek <jakub@redhat.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Debian GCC Maintainers <debian-gcc@lists.debian.org>,
        Debian Kernel Team <debian-kernel@lists.debian.org>
Content-Type: multipart/mixed; boundary=001a11369fa06a7c8404ff1e1559
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--001a11369fa06a7c8404ff1e1559
Content-Type: text/plain; charset=UTF-8

On Sat, Jul 26, 2014 at 12:35 PM, Markus Trippelsdorf
<markus@trippelsdorf.de> wrote:
>
> But fortunately the workaround for the new inode.c bug is the same as
> for the original bug: -fno-var-tracking-assignments.
>
> It would make sense to enabled it unconditionally for all debug
> configurations for now.

So how is code generation affected - if at all? Does the whole
"var-tracking-assignments" thing *only* matter for debug information?

Also, when was it introduced as an option? Can we just unconditionally
enable it, or do we need to be careful about gcc versions?

I'd *like* a debug kernel to not differ significantly from a non-debug
kernel. Most sane kernel developers (where "sane" is "me" by
definition) do not tend to use debug kernels, because the debug
overhead is absolutely disgustingly enormous at build time. But if we
then have most users using distro kernels that had debug info enabled,
it would be sad if code generation differences are huge.

So I'd prefer to just unconditionally add that
"-fno-var-tracking-assignments" to the build.

I just tested it on one file (fs/dcache.c) and it made no difference
at all for my non-debug build. Is this expected?

Because if the only effect of "-fno-var-tracking-assignments" is
potentially slightly worse debug information for variables, I'll
enable it in a jiffy if it fixes this code generation bug. But I'd
like to get that confirmed.

Finally, for CONFIG_DEBUG_INFO_REDUCED, we already use
"-fno-var-tracking". Is that a stronger version that also disables
"var-tracking-assignments"?

Also, Michel - can you try  this patch if you still have your
gcc-4.9.0 install, and send me the resulting fair.s file again?

                        Linus

--001a11369fa06a7c8404ff1e1559
Content-Type: text/plain; charset=US-ASCII; name="patch.diff"
Content-Disposition: attachment; filename="patch.diff"
Content-Transfer-Encoding: base64
X-Attachment-Id: f_hy3cywl10

IE1ha2VmaWxlIHwgMiArKwogMSBmaWxlIGNoYW5nZWQsIDIgaW5zZXJ0aW9ucygrKQoKZGlmZiAt
LWdpdCBhL01ha2VmaWxlIGIvTWFrZWZpbGUKaW5kZXggNmIyNzc0MTQ1ZDY2Li41MTQ3ZjNmMjM1
MDQgMTAwNjQ0Ci0tLSBhL01ha2VmaWxlCisrKyBiL01ha2VmaWxlCkBAIC02ODgsNiArNjg4LDgg
QEAgS0JVSUxEX0NGTEFHUwkrPSAtZm9taXQtZnJhbWUtcG9pbnRlcgogZW5kaWYKIGVuZGlmCiAK
K0tCVUlMRF9DRkxBR1MgICArPSAkKGNhbGwgY2Mtb3B0aW9uLCAtZm5vLXZhci10cmFja2luZy1h
c3NpZ25tZW50cykKKwogaWZkZWYgQ09ORklHX0RFQlVHX0lORk8KIEtCVUlMRF9DRkxBR1MJKz0g
LWcKIEtCVUlMRF9BRkxBR1MJKz0gLVdhLC1nZHdhcmYtMgo=
--001a11369fa06a7c8404ff1e1559--

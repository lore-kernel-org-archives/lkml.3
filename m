Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1161072AbaDBXxC (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Apr 2014 19:53:02 -0400
Received: from mail-vc0-f169.google.com ([209.85.220.169]:44970 "EHLO
	mail-vc0-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1030190AbaDBXxA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Apr 2014 19:53:00 -0400
MIME-Version: 1.0
In-Reply-To: <alpine.LNX.2.00.1404030145490.32122@pobox.suse.cz>
References: <20140402144219.4cafbe37@gandalf.local.home>
	<20140402221212.GD16570@mguzik.redhat.com>
	<CA+55aFyZSr4G2a1X5+EeSgKGtZvzBfBg0D0L39g-DB9TLi+ZEw@mail.gmail.com>
	<alpine.LRH.2.00.1404030119270.23421@twin.jikos.cz>
	<20140402162839.d3c00e9845e89d0f092c2ce3@linux-foundation.org>
	<CA+55aFw7NyryF3F3x05rLjt6rFwD5xUoZB06CV2mpwwRxcVHxg@mail.gmail.com>
	<alpine.LNX.2.00.1404030145490.32122@pobox.suse.cz>
Date: Wed, 2 Apr 2014 16:52:59 -0700
X-Google-Sender-Auth: Jpb89jSCqRj_FUgsGgtBia7acNU
Message-ID: <CA+55aFzo85-sdC_eDVRWcCdsK2p1JxCjswYidq-QSi5RieGmBA@mail.gmail.com>
Subject: Re: [RFC PATCH] cmdline: Hide "debug" from /proc/cmdline
From: Linus Torvalds <torvalds@linux-foundation.org>
To: Jiri Kosina <jkosina@suse.cz>
Cc: Andrew Morton <akpm@linux-foundation.org>,
        Mateusz Guzik <mguzik@redhat.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Steven Rostedt <rostedt@goodmis.org>,
        LKML <linux-kernel@vger.kernel.org>,
        Thomas Gleixner <tglx@linutronix.de>, "H. Peter Anvin" <hpa@zytor.com>,
        Borislav Petkov <bp@alien8.de>, Ingo Molnar <mingo@kernel.org>,
        Mel Gorman <mgorman@suse.de>, Kay Sievers <kay@vrfy.org>
Content-Type: multipart/mixed; boundary=047d7b3436d2044bbf04f617fc46
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--047d7b3436d2044bbf04f617fc46
Content-Type: text/plain; charset=UTF-8

On Wed, Apr 2, 2014 at 4:47 PM, Jiri Kosina <jkosina@suse.cz> wrote:
>
> Which doesn't really protect you from tasks that do open()/write()/close()
> cycle for /dev/kmsg write every 2ms though.

I don't think we should try to protect against wilful bad behavior
unless that is shown to be necessary. Yeah, if it turns out that
systemd really does that just to mess with us, we'd need to extend it,
but in the absence of proof to the contrary, maybe this simple
attached patch works?

TOTALLY UNTESTED. But it really isn't complex.

The complexity is likely to be about setting the actual default
values. So consider this a RFC and a "does this fix the problem that
Borislav reported?" test-patch.

Borislav?

                  Linus

--047d7b3436d2044bbf04f617fc46
Content-Type: text/plain; charset=US-ASCII; name="patch.diff"
Content-Disposition: attachment; filename="patch.diff"
Content-Transfer-Encoding: base64
X-Attachment-Id: f_htj9qb780

IGtlcm5lbC9wcmludGsvcHJpbnRrLmMgfCA2ICsrKysrKwogMSBmaWxlIGNoYW5nZWQsIDYgaW5z
ZXJ0aW9ucygrKQoKZGlmZiAtLWdpdCBhL2tlcm5lbC9wcmludGsvcHJpbnRrLmMgYi9rZXJuZWwv
cHJpbnRrL3ByaW50ay5jCmluZGV4IDRkYWU5Y2JlOTI1OS4uN2U0YTA0MTJkOWZmIDEwMDY0NAot
LS0gYS9rZXJuZWwvcHJpbnRrL3ByaW50ay5jCisrKyBiL2tlcm5lbC9wcmludGsvcHJpbnRrLmMK
QEAgLTQxMCw2ICs0MTAsNyBAQCBzdHJ1Y3QgZGV2a21zZ191c2VyIHsKIAl1NjQgc2VxOwogCXUz
MiBpZHg7CiAJZW51bSBsb2dfZmxhZ3MgcHJldjsKKwlzdHJ1Y3QgcmF0ZWxpbWl0X3N0YXRlIHJz
OwogCXN0cnVjdCBtdXRleCBsb2NrOwogCWNoYXIgYnVmWzgxOTJdOwogfTsKQEAgLTQ4Myw2ICs0
ODQsOCBAQCBzdGF0aWMgc3NpemVfdCBkZXZrbXNnX3JlYWQoc3RydWN0IGZpbGUgKmZpbGUsIGNo
YXIgX191c2VyICpidWYsCiAKIAlpZiAoIXVzZXIpCiAJCXJldHVybiAtRUJBREY7CisJaWYgKCFf
X19yYXRlbGltaXQoJnVzZXItPnJzLCBjdXJyZW50LT5jb21tKSkKKwkJcmV0dXJuIDA7CiAKIAly
ZXQgPSBtdXRleF9sb2NrX2ludGVycnVwdGlibGUoJnVzZXItPmxvY2spOwogCWlmIChyZXQpCkBA
IC02NzEsNiArNjc0LDkgQEAgc3RhdGljIGludCBkZXZrbXNnX29wZW4oc3RydWN0IGlub2RlICpp
bm9kZSwgc3RydWN0IGZpbGUgKmZpbGUpCiAJaWYgKCF1c2VyKQogCQlyZXR1cm4gLUVOT01FTTsK
IAorCS8qIENvbmZpZ3VyYWJsZT8gKi8KKwlyYXRlbGltaXRfc3RhdGVfaW5pdCgmdXNlci0+cnMs
IERFRkFVTFRfUkFURUxJTUlUX0lOVEVSVkFMLCBERUZBVUxUX1JBVEVMSU1JVF9CVVJTVCk7CisK
IAltdXRleF9pbml0KCZ1c2VyLT5sb2NrKTsKIAogCXJhd19zcGluX2xvY2tfaXJxKCZsb2didWZf
bG9jayk7Cg==
--047d7b3436d2044bbf04f617fc46--

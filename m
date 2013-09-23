Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753143Ab3IWQgz (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Sep 2013 12:36:55 -0400
Received: from mail-ve0-f182.google.com ([209.85.128.182]:47949 "EHLO
	mail-ve0-f182.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752938Ab3IWQgq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Sep 2013 12:36:46 -0400
MIME-Version: 1.0
In-Reply-To: <1379946831.1974.51@driftwood>
References: <CA+55aFxg-WropC74v5ir5r9kBJKEd93fgye4oTBhw5T8e8sb+g@mail.gmail.com>
	<1379946831.1974.51@driftwood>
Date: Mon, 23 Sep 2013 09:36:44 -0700
X-Google-Sender-Auth: CIu1mUtsWRlYrk2Hwb6lZdEpe5w
Message-ID: <CA+55aFxVB1L_L3V+VfVBt9snT7m_fpmaRe1cna18RfHeJRzvOQ@mail.gmail.com>
Subject: Re: Linux 3.12-rc1
From: Linus Torvalds <torvalds@linux-foundation.org>
To: Rob Landley <rob@landley.net>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Content-Type: multipart/mixed; boundary=047d7b5d4a3034703704e70fa0e5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--047d7b5d4a3034703704e70fa0e5
Content-Type: text/plain; charset=UTF-8

On Mon, Sep 23, 2013 at 7:33 AM, Rob Landley <rob@landley.net> wrote:
>
> So this log is basically:
>
> git log v3.11..v3.12-rc1 --merges --author="Linus Torvalds" \
>   | sed -n 's/ *Pull \(.*\) from \(.*\):/\2: \1/p' | sort
>
> Only with a slightly more clever "sort"?

Yes, except it's written in perl to get that simpler sort.

My silly script is designed to mimic "git shortlog" output, and it is
indeed based on the original perl version (and syntax) of that.

It also matches "Merge" in addition to "Pull", since some of my merges
end up being branches that get created from emails in my local
repository and then merged.

In case anybody wants to play with it, the perl script is attached,
and you can see the git-shortlog roots (for example, it still has the
usage string that mentions the -[hns] flags that don't actually work,
and some function called shortlog).

NOTE! It only works with the syntax that I use for merge messages,  so
while you could use it to summarize other peoples pulls and merges, it
really doesn't end up working very well for that. Maybe some
developers have adopted my syntax, but a quick look says no. Anyway,
for my use it's

    git log v3.11.. --merges --author=Torvalds | git-mergelog

and you can try to play around with other merge authors and maybe
accept a wider range of syntax, but from a quick look it looks like
none of the other maintainers that do merges have a very convenient
fixed format..

And my perl-fu is lacking, so don't laugh at my script. But if you
have improvements, feel free to send them...

                     Linus

--047d7b5d4a3034703704e70fa0e5
Content-Type: application/octet-stream; name=git-mergelog
Content-Disposition: attachment; filename=git-mergelog
Content-Transfer-Encoding: base64
X-Attachment-Id: f_hlxwv6gp0

IyEvdXNyL2Jpbi9wZXJsIC13Cgp1c2Ugc3RyaWN0Owp1c2UgR2V0b3B0OjpTdGQ7CnVzZSBGaWxl
OjpCYXNlbmFtZSBxdyhiYXNlbmFtZSBkaXJuYW1lKTsKCm91ciAoJG9wdF9oLCAkb3B0X24sICRv
cHRfcyk7CmdldG9wdHMoJ2hucycpOwoKJG9wdF9oICYmIHVzYWdlKCk7CgpzdWIgdXNhZ2UgewoJ
cHJpbnQgU1RERVJSICJVc2FnZTogJHtcYmFzZW5hbWUgJDB9IFstaF0gWy1uXSBbLXNdIDwgPGxv
Z19kYXRhPlxuIjsKICAgICAgICBleGl0KDEpOwp9CgpteSAoJW1hcCk7CgpzdWIgbWVyZ2Vsb2df
ZW50cnkoJCQpIHsKCW15ICgkbmFtZSwgJGRlc2MpID0gQF87CglteSAka2V5ID0gJG5hbWU7CgoJ
IyBzdG9yZSBkZXNjcmlwdGlvbiBpbiBhcnJheSwgaW4gZW1haWwtPntkZXNjIGxpc3R9IG1hcAoJ
aWYgKGV4aXN0cyAkbWFweyRrZXl9KSB7CgkJIyBncmFiIHJlZgoJCW15ICRvYmogPSAkbWFweyRr
ZXl9OwoKCQkjIGFkZCBkZXNjIHRvIGFycmF5CgkJcHVzaChAJG9iaiwgJGRlc2MpOwoJfSBlbHNl
IHsKCQkjIGNyZWF0ZSBuZXcgYXJyYXksIGNvbnRhaW5pbmcgMSBpdGVtCgkJbXkgQGFyciA9ICgk
ZGVzYyk7CgoJCSMgc3RvcmUgcmVmIHRvIGFycmF5CgkJJG1hcHska2V5fSA9IFxAYXJyOwoJfQp9
CgojIHNvcnQgY29tcGFyaXNvbiBmdW5jdGlvbgpzdWIgYnlfbmFtZSgkJCkgewoJbXkgKCRhLCAk
YikgPSBAXzsKCgl1YygkYSkgY21wIHVjKCRiKTsKfQpzdWIgYnlfbmJlbnRyaWVzKCQkKSB7Cglt
eSAoJGEsICRiKSA9IEBfOwoJbXkgJGFfZW50cmllcyA9ICRtYXB7JGF9OwoJbXkgJGJfZW50cmll
cyA9ICRtYXB7JGJ9OwoKCUAkYl9lbnRyaWVzIC0gQCRhX2VudHJpZXMgfHwgYnlfbmFtZSAkYSwg
JGI7Cn0KCm15ICRzb3J0X21ldGhvZCA9ICRvcHRfbiA/IFwmYnlfbmJlbnRyaWVzIDogXCZieV9u
YW1lOwoKc3ViIHN1bW1hcnlfb3V0cHV0IHsKCW15ICgkb2JqLCAkbnVtLCAka2V5KTsKCglmb3Jl
YWNoICRrZXkgKHNvcnQgJHNvcnRfbWV0aG9kIGtleXMgJW1hcCkgewoJCSRvYmogPSAkbWFweyRr
ZXl9OwoJCSRudW0gPSBAJG9iajsKCQlwcmludGYgIiVzOiAldVxuIiwgJGtleSwgJG51bTsKCX0K
fQoKc3ViIHNob3J0bG9nX291dHB1dCB7CglteSAoJG9iaiwgJG51bSwgJGtleSwgJGRlc2MpOwoK
CWZvcmVhY2ggJGtleSAoc29ydCAkc29ydF9tZXRob2Qga2V5cyAlbWFwKSB7CgkJJG9iaiA9ICRt
YXB7JGtleX07CgkJJG51bSA9IEAkb2JqOwoKCQkjIG91dHB1dCBhdXRob3IKCQlwcmludGYgIiVz
ICgldSk6XG4iLCAka2V5LCAkbnVtOwoKCQkjIG91dHB1dCBhdXRob3IncyAxLWxpbmUgc3VtbWFy
aWVzCgkJZm9yZWFjaCAkZGVzYyAocmV2ZXJzZSBAJG9iaikgewoJCQlwcmludCAiICAkZGVzY1xu
IjsKCQl9CgoJCSMgYmxhbmsgbGluZSBzZXBhcmF0aW5nIGF1dGhvciBmcm9tIG5leHQgYXV0aG9y
CgkJcHJpbnQgIlxuIjsKCX0KfQoKc3ViIGNoYW5nZWxvZ19pbnB1dCB7CglteSAoJGF1dGhvciwg
JGRlc2MpOwoKCXdoaWxlICg8PikgewoJCW5leHQgdW5sZXNzIC9eICAgICgoUHVsbCl8KE1lcmdl
KSkgKC4qKSBmcm9tIChbXlwuOl0qKS87CgkJJGF1dGhvciA9ICQ1OwoJCSRkZXNjID0gJDQ7CgkJ
bWVyZ2Vsb2dfZW50cnkoJGF1dGhvciwgJGRlc2MpOwoJfQp9CgomY2hhbmdlbG9nX2lucHV0Owok
b3B0X3MgPyAmc3VtbWFyeV9vdXRwdXQgOiAmc2hvcnRsb2dfb3V0cHV0OwpleGl0KDApOwo=
--047d7b5d4a3034703704e70fa0e5--

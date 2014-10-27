Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1750958AbaJ0ELg (ORCPT <rfc822;w@1wt.eu>);
	Mon, 27 Oct 2014 00:11:36 -0400
Received: from mail2.vodafone.ie ([213.233.128.44]:64462 "EHLO
	mail2.vodafone.ie" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750761AbaJ0ELf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 27 Oct 2014 00:11:35 -0400
X-Greylist: delayed 587 seconds by postgrey-1.27 at vger.kernel.org; Mon, 27 Oct 2014 00:11:35 EDT
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: ApYBAA/DTVRtTi0f/2dsb2JhbAANT4NiWIMGygSHSQKBIwGFAAEBBCNWEBgBExQCCwICAgcDAgECAUUGAQwBBwEBiEIIsyd4lBwBAQEBAQEBAQEBAQEBAQEBAQEBAQETBJEIB4J3gVQFlBeBUGiPJ5IRbAEBAYJIAQEB
Message-ID: <544DC3A8.1060103@draigBrady.com>
Date: Mon, 27 Oct 2014 04:01:44 +0000
From: =?UTF-8?B?UMOhZHJhaWcgQnJhZHk=?= <P@draigBrady.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130110 Thunderbird/17.0.2
MIME-Version: 1.0
To: Thomas Gleixner <tglx@linutronix.de>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
CC: Paul Eggert <eggert@cs.ucla.edu>, bug-gnulib <bug-gnulib@gnu.org>
Subject: nanosleep truncated on 64 bit Linux by 292 billion years
References: <53E0FF15.4090808@draigBrady.com> <53E13F04.70609@cs.ucla.edu> <alpine.DEB.2.10.1408060017090.3323@nanos>
In-Reply-To: <alpine.DEB.2.10.1408060017090.3323@nanos>
X-Enigmail-Version: 1.6
Content-Type: multipart/mixed;
 boundary="------------060306070608080103020106"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is a multi-part message in MIME format.
--------------060306070608080103020106
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

I noticed that nanosleep() on 64 bit, "only" supports 292 years,
rather than the full potential 292 billion years with 64 bit time_t, due to:
https://git.kernel.org/cgit/linux/kernel/git/torvalds/linux.git/tree/include/linux/time.h?id=refs/tags/v3.16#n87

Attached is a program from Paul Eggert that illustrates the bug.
Running this program on a buggy host outputs something like this:

  Setting alarm for 1 second from now ...
  Sleeping for 9223372036854775807.999999999 seconds...
  After alarm sent off, remaining time is 9223357678.462306617 seconds;
  i.e., nanosleep claimed that it slept for about 293079448610.606445 years.

Gnulib-using applications have a workaround for this bug, but a workaround
shouldn't be necessary.  For what it's worth, the bug is fixed in Solaris 11 (x86-64),
though it's present in Solaris 10 (64-bit sparc).

thanks,
Pádraig.

--------------060306070608080103020106
Content-Type: text/plain; charset=UTF-8;
 name="nanosleep-bug.c"
Content-Transfer-Encoding: base64
Content-Disposition: attachment;
 filename="nanosleep-bug.c"

I2luY2x1ZGUgPHRpbWUuaD4KI2luY2x1ZGUgPGVycm5vLmg+CiNpbmNsdWRlIDxsaW1pdHMu
aD4KI2luY2x1ZGUgPHN0ZGlvLmg+CiNpbmNsdWRlIDxzaWduYWwuaD4KI2luY2x1ZGUgPHVu
aXN0ZC5oPgoKc3RhdGljIHZvaWQKY2hlY2tfZm9yX1NJR0FMUk0gKGludCBzaWcpCnsKICBp
ZiAoc2lnICE9IFNJR0FMUk0pCiAgICBfZXhpdCAoMSk7Cn0KCmludAptYWluICh2b2lkKQp7
CiAgc3RhdGljIHN0cnVjdCBzaWdhY3Rpb24gYWN0OwogIHN0cnVjdCB0aW1lc3BlYyBmb3Jl
dmVyLCByZW1haW5pbmc7CiAgdGltZV90IHRpbWVfdF9tYXggPSAoMXVsbCA8PCAoc2l6ZW9m
IHRpbWVfdF9tYXggKiBDSEFSX0JJVCAtIDEpKSAtIDE7CiAgYWN0LnNhX2hhbmRsZXIgPSBj
aGVja19mb3JfU0lHQUxSTTsKICBzaWdlbXB0eXNldCAoJmFjdC5zYV9tYXNrKTsKICBzaWdh
Y3Rpb24gKFNJR0FMUk0sICZhY3QsIE5VTEwpOwogIGZvcmV2ZXIudHZfc2VjID0gdGltZV90
X21heDsKICBmb3JldmVyLnR2X25zZWMgPSA5OTk5OTk5OTk7CiAgcHJpbnRmICgiU2V0dGlu
ZyBhbGFybSBmb3IgMSBzZWNvbmQgZnJvbSBub3cgLi4uXG4iKTsKICBhbGFybSAoMSk7CiAg
cHJpbnRmICgiU2xlZXBpbmcgZm9yICVsbGQuJTA5bGQgc2Vjb25kcy4uLlxuIiwKCSAgKGxv
bmcgbG9uZykgZm9yZXZlci50dl9zZWMsIGZvcmV2ZXIudHZfbnNlYyk7CiAgaWYgKG5hbm9z
bGVlcCAoJmZvcmV2ZXIsICZyZW1haW5pbmcpID09IDApCiAgICByZXR1cm4gMjsKICBpZiAo
ZXJybm8gIT0gRUlOVFIpCiAgICByZXR1cm4gMzsKICBpZiAocmVtYWluaW5nLnR2X3NlYyA8
IHRpbWVfdF9tYXggLSAxMCkKICAgIHsKICAgICAgcHJpbnRmICgiQWZ0ZXIgYWxhcm0gc2Vu
dCBvZmYsIHJlbWFpbmluZyB0aW1lIGlzICVsbGQuJTA5bGQgc2Vjb25kcztcbiIsCgkgICAg
ICAobG9uZyBsb25nKSByZW1haW5pbmcudHZfc2VjLCByZW1haW5pbmcudHZfbnNlYyk7CiAg
ICAgIHByaW50ZiAoImkuZS4sIG5hbm9zbGVlcCBjbGFpbWVkIHRoYXQgaXQgc2xlcHQgZm9y
IGFib3V0ICVmIHllYXJzLlxuIiwKCSAgICAgIChmb3JldmVyLnR2X3NlYyAtIHJlbWFpbmlu
Zy50dl9zZWMpIC8gKDI0ICogNjAgKiA2MCAqIDM2NC4yNDI1KSk7CiAgICAgIHJldHVybiA0
OwogICAgfQogIHByaW50ZiAoIm9rXG4iKTsKICByZXR1cm4gMDsKfQo=
--------------060306070608080103020106--

Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752324AbaFET1Q (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Jun 2014 15:27:16 -0400
Received: from mail-vc0-f177.google.com ([209.85.220.177]:58474 "EHLO
	mail-vc0-f177.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751566AbaFET1N (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Jun 2014 15:27:13 -0400
MIME-Version: 1.0
In-Reply-To: <20140605192421.GA6248@tango.0pointer.de>
References: <1400687040.7272.28.camel@kazak.uk.xensource.com>
 <20140521230233.GA13289@wotan.suse.de> <1400753147.14637.10.camel@kazak.uk.xensource.com>
 <20140523232031.GA26450@wotan.suse.de> <1401269449.24800.7.camel@kazak.uk.xensource.com>
 <20140529232918.GG26450@wotan.suse.de> <20140601061547.GC16257@tango.0pointer.de>
 <20140605003103.GB22052@wotan.suse.de> <20140605112213.GA17673@tango.0pointer.de>
 <20140605180137.GD22052@wotan.suse.de> <20140605192421.GA6248@tango.0pointer.de>
From: Andrew Lutomirski <luto@mit.edu>
Date: Thu, 5 Jun 2014 12:26:51 -0700
X-Google-Sender-Auth: W5UwwpMdqOgPoLguwKhg3WO6Wvg
Message-ID: <CAObL_7GqnS_2AA_yCtozVT6eiT9yM+LViutw3A+DFd+0z4=A5Q@mail.gmail.com>
Subject: Re: [systemd-devel] [PATCH v5 12/14] autoconf: xen: enable explicit
 preference option for xenstored preference
To: Lennart Poettering <mzxreary@0pointer.de>
Cc: "Luis R. Rodriguez" <mcgrof@suse.com>,
        Ian Campbell <Ian.Campbell@citrix.com>, Keir Fraser <keir@xen.org>,
        Tim Deegan <tim@xen.org>, Ian Jackson <ian.jackson@eu.citrix.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        systemd-devel@lists.freedesktop.org,
        linux-security-module@vger.kernel.org,
        Eric Biederman <ebiederm@xmission.com>,
        Jan Beulich <jbeulich@suse.com>, xen-devel@lists.xenproject.org,
        "Andrew G. Morgan" <morgan@kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jun 5, 2014 at 12:24 PM, Lennart Poettering
<mzxreary@0pointer.de> wrote:
> On Thu, 05.06.14 20:01, Luis R. Rodriguez (mcgrof@suse.com) wrote:
>
>> > Hmm? You should "exec" the real daemon binary at the end, not just fork
>> > it off. That wait the shell script process is replaced by the daemon
>> > binary, which is what you want.
>>
>> I tried both just running it and also running exec foo; both presented
>> the same issue given that shell exec does not really execve.
>
> Hmmm? You shell's "exec" command doesn't actually execve()? What are you
> using? This doesn't sound very accurate...

$ strace -e execve /bin/sh -c 'exec /bin/echo test'
execve("/bin/sh", ["/bin/sh", "-c", "exec /bin/echo test"], [/* 54 vars */]) = 0
execve("/bin/echo", ["/bin/echo", "test"], [/* 54 vars */]) = 0
test
+++ exited with 0 +++

I get similar results on Ubuntu using dash.

--Andy

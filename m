Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932701AbaFPV7h (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Jun 2014 17:59:37 -0400
Received: from terminus.zytor.com ([198.137.202.10]:53684 "EHLO mail.zytor.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932529AbaFPV6x (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Jun 2014 17:58:53 -0400
Message-ID: <539F6889.8040103@zytor.com>
Date: Mon, 16 Jun 2014 14:58:33 -0700
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.5.0
MIME-Version: 1.0
To: Andy Lutomirski <luto@amacapital.net>
CC: Richard Weinberger <richard@nod.at>, X86 ML <x86@kernel.org>,
        =?UTF-8?B?VG9yYWxmIEbDtnJzdGVy?= <toralf.foerster@gmx.de>,
        Eric Paris <eparis@redhat.com>,
        Linux Kernel <linux-kernel@vger.kernel.org>
Subject: Re: 3.15: kernel BUG at kernel/auditsc.c:1525!
References: <539F1C59.6070308@gmx.de> <CAFLxGvyqPzbmfz1-WxP7z02=V-V5=p5b09HYPOFOS7Qj8eUHGw@mail.gmail.com> <CALCETrXqjHPvKw=wcdnxQWO0Y140B=a0E7eh4+PoERvU=z909w@mail.gmail.com> <539F297F.7010904@nod.at> <CALCETrU+TmaEjPSHz1LwQJvVDp8fqoDs3O4b+3gS_ewthiwnMA@mail.gmail.com> <539F2B2D.6050105@gmx.de> <CALCETrVw6f7iy4qTMgSt8k9N4rOWJ_mm9LbrtVZ9YFORacriSQ@mail.gmail.com> <539F3077.7040005@gmx.de> <CALCETrUUC6g_y4nJkSYo7MrKB8ehyXgnnuBHxGCDrq1d4zp2BQ@mail.gmail.com> <539F35A0.2050002@gmx.de> <CALCETrVseO=n6TH-msfTHRqB-OMPs_32nRELVYc=V1ZDmvFXVA@mail.gmail.com> <539F567F.2050802@gmx.de> <539F5702.5050104@nod.at> <CALCETrW7U4AHG-a9oPbOt31z3wgzhjSu8b+yGpdM4+vNinKgsA@mail.gmail.com> <539F6646.4040605@zytor.com> <CALCETrUWpXWLn4wfV6wneOwX+12fbFZ2af=JrZiwq-5RGYiT4Q@mail.gmail.com>
In-Reply-To: <CALCETrUWpXWLn4wfV6wneOwX+12fbFZ2af=JrZiwq-5RGYiT4Q@mail.gmail.com>
X-Enigmail-Version: 1.6
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> 
> For 64-bit, I want to do this instead:
> 
> https://git.kernel.org/cgit/linux/kernel/git/luto/linux.git/commit/?h=x86/seccomp-fastpath&id=a5ec2d7af2c54b55fc7201fa662138b53fbbda39
> 
> I see no reason why the 64-bit badsys code needs its own code path at
> all.  I haven't sent it yet because AFAICT it doesn't fix any bug, and
> the series it's a part of isn't ready.
> 
> I'm also contemplating rewriting the 64-bit syscall entry work path in C.
> 

Cute... although it still leaves an extra branch for the badsys.  It
might perform better than a cmov, but it might not.

	-hpa



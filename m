Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753623AbaE0T3A (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 May 2014 15:29:00 -0400
Received: from mail-qg0-f44.google.com ([209.85.192.44]:58764 "EHLO
	mail-qg0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753589AbaE0T26 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 May 2014 15:28:58 -0400
MIME-Version: 1.0
Reply-To: mtk.manpages@gmail.com
In-Reply-To: <20140527192115.GD25474@kernel.org>
References: <536101C9.9090601@gmail.com> <CAKgNAkgA_xTfRZhpyVwuACpCY7xMK89e0bK4PuVMG9reNV6Skw@mail.gmail.com>
 <20140512143451.GB13801@kernel.org> <20140521210535.GA5414@kernel.org>
 <537E0961.8040005@gmail.com> <20140526134647.GB8176@kernel.org>
 <20140526211706.GA25474@kernel.org> <5384BEC5.2080607@gmail.com> <20140527192115.GD25474@kernel.org>
From: "Michael Kerrisk (man-pages)" <mtk.manpages@gmail.com>
Date: Tue, 27 May 2014 21:28:37 +0200
Message-ID: <CAKgNAkht1vubHueYPpkRu_W5B8OYW3rPUkHeLEq5WMVbCvO47w@mail.gmail.com>
Subject: Re: [PATCH/RFC] Re: recvmmsg() timeout behavior strangeness [RESEND]
To: Arnaldo Carvalho de Melo <acme@ghostprotocols.net>
Cc: lkml <linux-kernel@vger.kernel.org>,
        "linux-man@vger.kernel.org" <linux-man@vger.kernel.org>,
        netdev <netdev@vger.kernel.org>,
        =?UTF-8?B?T25kxZllaiBCw61sa2E=?= <neleai@seznam.cz>,
        Caitlin Bestler <caitlin.bestler@gmail.com>,
        Neil Horman <nhorman@tuxdriver.com>,
        Elie De Brauwer <eliedebrauwer@gmail.com>,
        David Miller <davem@davemloft.net>,
        Steven Whitehouse <steve@chygwyn.com>,
        =?UTF-8?Q?R=C3=A9mi_Denis=2DCourmont?= 
	<remi.denis-courmont@nokia.com>,
        Paul Moore <paul@paul-moore.com>,
        Chris Friesen <chris.friesen@windriver.com>,
        Arnaldo Carvalho de Melo <acme@redhat.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, May 27, 2014 at 9:21 PM, Arnaldo Carvalho de Melo
<acme@ghostprotocols.net> wrote:
> Em Tue, May 27, 2014 at 06:35:17PM +0200, Michael Kerrisk (man-pages) escreveu:
>> On 05/26/2014 11:17 PM, Arnaldo Carvalho de Melo wrote:
>> > Can you try the attached patch on top of the first one?
>
>> Patches on patches is a way to make your testers work unnecessarily
>> harder. Also, it means that anyone else who was interested in this
>
> It was meant to highlight the changes with regard to the previous patch,
> i.e. to make things easier for reviewing.

(I don't think that works...)

>> thread likely got lost at this point, because they probably didn't
>> save the first patch. All of this to say: it makes life much easier
>> if you provide a complete new self-contained patch on each iteration.
>
> If you prefer it that way, find one attached, that I was about to send
> (but you can wait till I use your program to test it ;-) )
>
>> > It starts adding explicit parentheses on a ternary, as David requested,
>> > and then should return the remaining timeouts in cases like signals,
>> > etc.
>> >
>> > Please let me know if this is enough.
>>
>> Nope, it doesn't fix the problem. (I applied both patches against 3.15-rc7)
>
> What was the problem experienced?

The problem is that after EINTR, the timeout is not updated with the
remaining time until expiry. (This was true with just patch 1 applied,
and is also true with both patch 1 and patch 2 applied.)

Cheers,

Michael

-- 
Michael Kerrisk
Linux man-pages maintainer; http://www.kernel.org/doc/man-pages/
Linux/UNIX System Programming Training: http://man7.org/training/

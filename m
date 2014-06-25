Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755285AbaFYIea (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Jun 2014 04:34:30 -0400
Received: from mail-la0-f47.google.com ([209.85.215.47]:36192 "EHLO
	mail-la0-f47.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753978AbaFYIe1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Jun 2014 04:34:27 -0400
MIME-Version: 1.0
In-Reply-To: <1403682511.17451.21.camel@joe-AO725>
References: <1403477209-14612-1-git-send-email-minipli@googlemail.com>
	<1403477762.18747.14.camel@joe-AO725>
	<CA+rthh8D=r1kW6iDb0MqfHwA4OW-oXSA+B1AXe-0Cqperz6ZRQ@mail.gmail.com>
	<1403505219.18747.37.camel@joe-AO725>
	<87egyeqt03.fsf@rasmusvillemoes.dk>
	<CA+rthh8XwC80hq8z07k+=0J7MDA6tUtLff+J=qMuzYqTNyLKww@mail.gmail.com>
	<1403638620.29061.35.camel@joe-AO725>
	<CA+rthh9qGpkicfR+C7Qz1uOF4HUaVANVyq6YaH_Rx-80L_-YvQ@mail.gmail.com>
	<1403641843.29061.51.camel@joe-AO725>
	<CA+rthh89rYOyUd58vJO_0Nu_j+zrAMwUYSitRbT=MVoz9pO5Lw@mail.gmail.com>
	<1403643440.29061.56.camel@joe-AO725>
	<CA+rthh9gKVWix4E0ENPFBXgUMpjnb8_+aeNUi3iZpAnqzo8C1w@mail.gmail.com>
	<1403646310.29061.61.camel@joe-AO725>
	<CA+rthh8anKnxA7XuZb4BHB4a7w=Oo3LhUuD2UOwGfv2SGxLs0w@mail.gmail.com>
	<877g45qw53.fsf@rasmusvillemoes.dk>
	<1403682511.17451.21.camel@joe-AO725>
Date: Wed, 25 Jun 2014 10:34:25 +0200
Message-ID: <CA+rthh83g7W2UVbGGENmTOtamRoQvo_UD_04C2Ux5fAhvX2b9Q@mail.gmail.com>
Subject: Re: [RFC PATCH 0/3] Mark literal strings in __init / __exit code
From: Mathias Krause <minipli@googlemail.com>
To: Joe Perches <joe@perches.com>
Cc: Rasmus Villemoes <linux@rasmusvillemoes.dk>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Steven Rostedt <rostedt@goodmis.org>,
        "Rafael J. Wysocki" <rjw@rjwysocki.net>,
        Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>,
        "H. Peter Anvin" <hpa@zytor.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 25 June 2014 09:48, Joe Perches <joe@perches.com> wrote:
> On Wed, 2014-06-25 at 09:35 +0200, Rasmus Villemoes wrote:
>> Speaking of dangling pointers: A similar disaster would happen if some
>> code containing pi_* calls gets copy-pasted to some non-__init
>> function.
>
> This is my biggest issue with adding these new,
> somewhat obscure macros.

modpost will handle these cases.

>> Could checkpatch learn to warn about calling these functions
>> from the wrong context?
>
> It's not possible.  checkpatch works on patch chunks.
> Any patch chunk may not contain the function attributes.

checkpatch.pl -f might detect them, though :/

Thanks,
Mathias

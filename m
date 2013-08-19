Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751470Ab3HSX0G (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 Aug 2013 19:26:06 -0400
Received: from mail-vb0-f47.google.com ([209.85.212.47]:33714 "EHLO
	mail-vb0-f47.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751165Ab3HSX0F (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 Aug 2013 19:26:05 -0400
MIME-Version: 1.0
In-Reply-To: <CA+55aFzH7DH0d+DXgQ6T3Us6job8OvVmCJXMp2z3xit86d0ZrA@mail.gmail.com>
References: <CA+i8gKKzt3Uf7Bt88=AFyKbdHuqaTqy96nCHTtO=t+4+dhQ0Pw@mail.gmail.com>
	<CA+55aFzH7DH0d+DXgQ6T3Us6job8OvVmCJXMp2z3xit86d0ZrA@mail.gmail.com>
Date: Mon, 19 Aug 2013 16:26:03 -0700
X-Google-Sender-Auth: aU3R4KiU5BC9TDM1mwTDKbEvWlQ
Message-ID: <CA+55aFxU_n7yNmPKW=b135tf-rZ=pJzndjK6o+=6eshDCa8xAw@mail.gmail.com>
Subject: Re: commit 94fc5d9: chromium-sandbox core dumped
From: Linus Torvalds <torvalds@linux-foundation.org>
To: Emmanuel Benisty <benisty.e@gmail.com>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Richard Genoud <richard.genoud@gmail.com>,
        Al Viro <viro@zeniv.linux.org.uk>,
        Andrew Morton <akpm@linux-foundation.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Aug 19, 2013 at 1:25 PM, Linus Torvalds
<torvalds@linux-foundation.org> wrote:
>
> I suspect that last "return 0" at the end should be "return 1". Does
> that fix things for you? Untested.

Ok. Confirmed. I reproduced the bug that Richard Genoud fixed, and
also verified that yes, changing that last "return 0" in
proc_readdir_de() to "return 1" fixes the bug that Emmanuel reported.
Although I just did it with a special test-program using different
getdents buffer sizes, so I didn't verify the particular Chromium
breakage, but that does look like it's the same issue.

                    Linus

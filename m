Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751537AbaCUUhP (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 Mar 2014 16:37:15 -0400
Received: from mail-ve0-f181.google.com ([209.85.128.181]:58845 "EHLO
	mail-ve0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750749AbaCUUhN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 Mar 2014 16:37:13 -0400
MIME-Version: 1.0
In-Reply-To: <20140321201352.GC1338@pd.tnic>
References: <532C727F.1080803@st.ovgu.de>
	<20140321172742.GA2846@pd.tnic>
	<532C97DF.9010201@st.ovgu.de>
	<20140321201352.GC1338@pd.tnic>
Date: Fri, 21 Mar 2014 13:37:12 -0700
Message-ID: <CA+8MBbKXqAw_01jWNmzonPmoER==gJeK1BnyMq5eLqqFMx2NTQ@mail.gmail.com>
Subject: Re: PROBLEM: Fatal Machine Check >= 3.13.5-101.fc19.x86_64
From: Tony Luck <tony.luck@gmail.com>
To: Borislav Petkov <bp@alien8.de>
Cc: Matthias Graf <matthias.graf@st.ovgu.de>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Mar 21, 2014 at 1:13 PM, Borislav Petkov <bp@alien8.de> wrote:
> Provided the decode is correct and I'm reading it right, this looks
> like the cores get to livelock for some reason without any forward
> progress. The MCEs signal that there hasn't been any instruction retired
> in relatively long time, thus a stall.

Agreed. There are some bus level errors (low 16 bits of STATUS 0x0800)
and some timeout (low bits 0x0400)

> You say, this happens when gnome starts. Does it also happen if you
> don't start gnome, i.e. don't start X at all? Try booting into a
> runlevel without graphics.
>
> Tony, any other ideas?

My best guess is graphics? driver making wild access to some i/o regs that
never respond.  If booting without graphics works, then that adds some
weight to the theory.

Other useful tests would be to check upstream kernels 3.12, 3.13 to
see if something is odd in the Fedora additions. And 3.14-rc7 to see
if it is already fixed upstream.

If upstream 3.12 works and 3.13 breaks (and not fixed in 3.14-rc7) ...
then bisecting between 3.12 and 3.13 would be helpful.

-Tony

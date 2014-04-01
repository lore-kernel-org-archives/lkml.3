Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751416AbaDAIec (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 Apr 2014 04:34:32 -0400
Received: from mail-ie0-f178.google.com ([209.85.223.178]:44208 "EHLO
	mail-ie0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751077AbaDAIe2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 Apr 2014 04:34:28 -0400
MIME-Version: 1.0
In-Reply-To: <mvmob0mfswh.fsf@hawking.suse.de>
References: <CAOte+=YgX=0dahqCS6-=yBLHnTjoJtii3Ycx4mhrj9SqNADZzg@mail.gmail.com>
	<87r45lqcm7.fsf@igel.home>
	<20140331111833.76af70e0@alan.etchedpixels.co.uk>
	<mvm4n2ehdes.fsf@hawking.suse.de>
	<20140331133204.0c9d8358@alan.etchedpixels.co.uk>
	<mvmob0mfswh.fsf@hawking.suse.de>
Date: Tue, 1 Apr 2014 10:34:27 +0200
Message-ID: <CAOte+=YTaq76D22MRUhToFJLcb78P_LNY1p+viMHqyqwkHjLzg@mail.gmail.com>
Subject: Re: Support for netconsole as default tty/console?
From: Struan Bartlett <struan.bartlett@gmail.com>
To: Andreas Schwab <schwab@suse.de>
Cc: One Thousand Gnomes <gnomes@lxorguk.ukuu.org.uk>,
        linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 31 March 2014 14:34, Andreas Schwab <schwab@suse.de> wrote:
> One Thousand Gnomes <gnomes@lxorguk.ukuu.org.uk> writes:
>
>> It's however implemented and present. The rest is between you and the
>> relevant Kconfig maintainer. I'm sure you count as an expert ;-)
>
> Indeed.
>
> http://lists.opensuse.org/opensuse-kernel/2014-03/msg00071.html

I have just completed an implementation of a tty driver for
netconsole, which I was about to submit as a patch. When the kernel
command line is set accordingly (console=netcon0), it has the desired
effect of taking over output to /dev/console when it is loaded. Would
you say this work is wasted, or that it's worth submitting the patch
anyway?

There are differences to the ttyprintk approach. ttyprintk is
currently kernel-only, and not available as a module. ttyprintk adds
special formatting to the output, which netconsole does not. (If
netconsole were to provide special formatting, it might make sense for
it to be syslog-compatible). In defence of netconsole providing a tty
driver, many other output device modules already provide their own tty
(i.e. do not rely on ttyprintk). Also, unlike ttyprintk, netconsole is
already widely used and well documented on the web. Adding a tty
driver to netconsole would be a natural extension of functionality for
those already using it.

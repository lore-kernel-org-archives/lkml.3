Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752048AbaBQIwq (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Feb 2014 03:52:46 -0500
Received: from mail-lb0-f169.google.com ([209.85.217.169]:52965 "EHLO
	mail-lb0-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751016AbaBQIwo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Feb 2014 03:52:44 -0500
Date: Mon, 17 Feb 2014 12:52:41 +0400
From: Cyrill Gorcunov <gorcunov@gmail.com>
To: Pavel Emelyanov <xemul@parallels.com>
Cc: "Eric W. Biederman" <ebiederm@xmission.com>,
        Andrew Vagin <avagin@gmail.com>, Aditya Kali <adityakali@google.com>,
        Stephen Rothwell <sfr@canb.auug.org.au>,
        Oleg Nesterov <oleg@redhat.com>, linux-kernel@vger.kernel.org,
        criu@openvz.org, Al Viro <viro@zeniv.linux.org.uk>,
        Andrew Morton <akpm@linux-foundation.org>,
        Kees Cook <keescook@chromium.org>
Subject: Re: [CRIU] [PATCH 1/3] prctl: reduce permissions to change
 boundaries of data, brk and stack
Message-ID: <20140217085241.GR13358@moon>
References: <1392387209-330-1-git-send-email-avagin@openvz.org>
 <1392387209-330-2-git-send-email-avagin@openvz.org>
 <874n41znl5.fsf@xmission.com>
 <20140214174314.GA5518@gmail.com>
 <20140214180129.GK13358@moon>
 <8761ohqzc6.fsf@xmission.com>
 <52FE72C1.9090100@parallels.com>
 <87txc1pibc.fsf@xmission.com>
 <5301C984.40904@parallels.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <5301C984.40904@parallels.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Feb 17, 2014 at 12:34:12PM +0400, Pavel Emelyanov wrote:
...
> Maybe we can make prlctl() do lite-execve()? It will open the executable, read the
> required amount of headers and just put data red from there onto mm-struct? This 
> should be MUCH better, that full execve() with loading all binary data plus strace
> and flushing old mm-s.

Well, this would be good, except I don't know how would we deal with executables
which are running but deleted, where would we fetch these headers from? (Note the
program can map new executable region, jump there and unmap own text section).

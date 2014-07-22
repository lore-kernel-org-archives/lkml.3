Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933774AbaGVW2a (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Jul 2014 18:28:30 -0400
Received: from mail-lb0-f173.google.com ([209.85.217.173]:44036 "EHLO
	mail-lb0-f173.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932585AbaGVW2V (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Jul 2014 18:28:21 -0400
MIME-Version: 1.0
In-Reply-To: <1406067727-19683-107-git-send-email-kamal@canonical.com>
References: <1406067727-19683-1-git-send-email-kamal@canonical.com> <1406067727-19683-107-git-send-email-kamal@canonical.com>
From: Andy Lutomirski <luto@amacapital.net>
Date: Tue, 22 Jul 2014 15:27:59 -0700
Message-ID: <CALCETrWTS=z7ZD78JppwbXJKo7HA3xTJYQS=DXLbw5bNyUA_3g@mail.gmail.com>
Subject: Re: [PATCH 3.8 106/116] x86_32, entry: Do syscall exit work on badsys (CVE-2014-4508)
To: Kamal Mostafa <kamal@canonical.com>
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        stable <stable@vger.kernel.org>, kernel-team@lists.ubuntu.com,
        Roland McGrath <roland@redhat.com>,
        "H. Peter Anvin" <hpa@linux.intel.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jul 22, 2014 at 3:21 PM, Kamal Mostafa <kamal@canonical.com> wrote:
> 3.8.13.27 -stable review patch.  If anyone has any objections, please let me know.
>
> ------------------
>
> From: Andy Lutomirski <luto@amacapital.net>
>
> commit 554086d85e71f30abe46fc014fea31929a7c6a8a upstream.
>
> The bad syscall nr paths are their own incomprehensible route
> through the entry control flow.  Rearrange them to work just like
> syscalls that return -ENOSYS.
>
> This fixes an OOPS in the audit code when fast-path auditing is
> enabled and sysenter gets a bad syscall nr (CVE-2014-4508).
>
> This has probably been broken since Linux 2.6.27:
> af0575bba0 i386 syscall audit fast-path

Don't apply this without:

https://git.kernel.org/cgit/linux/kernel/git/tip/tip.git/commit/?h=x86/urgent&id=8142b215501f8b291a108a202b3a053a265b03dd

Sorry!

--Andy

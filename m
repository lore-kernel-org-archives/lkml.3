Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752469AbaGKEGP (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 Jul 2014 00:06:15 -0400
Received: from terminus.zytor.com ([198.137.202.10]:54706 "EHLO mail.zytor.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750719AbaGKEGO (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 Jul 2014 00:06:14 -0400
Message-ID: <53BF62AA.20105@zytor.com>
Date: Thu, 10 Jul 2014 21:06:02 -0700
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.6.0
MIME-Version: 1.0
To: Richard Guy Briggs <rgb@redhat.com>, linux-audit@redhat.com,
        linux-kernel@vger.kernel.org
CC: Paul Moore <pmoore@redhat.com>, Eric Paris <eparis@redhat.com>,
        Al Viro <aviro@redhat.com>, Will Drewry <wad@chromium.org>
Subject: Re: [PATCH 2/3] [RFC] seccomp: give BPF x32 bit when restoring x32
 filter
References: <cover.1405023592.git.rgb@redhat.com> <6a69eb94b4cfac5f94b229c2eb2ebc402aac722a.1405023592.git.rgb@redhat.com>
In-Reply-To: <6a69eb94b4cfac5f94b229c2eb2ebc402aac722a.1405023592.git.rgb@redhat.com>
X-Enigmail-Version: 1.6
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 07/10/2014 08:38 PM, Richard Guy Briggs wrote:
> Commit
> 	fca460f hpa@zytor.com 2012-02-19 07:56:26 -0800
> 	x32: Handle the x32 system call flag
> 
> provided a method to multiplex architecture with the syscall number for X32
> calls.
> 
> Commit
> 	8b4b9f2 pmoore@redhat.com 2013-02-15 12:21:43 -0500
> 	x86: remove the x32 syscall bitmask from syscall_get_nr()
> 
> broke audit and potentially other users of syscall_get_nr() which depend on
> that call as named.
> 
> Commit
> 	audit: add AUDIT_ARCH_X86_X32 arch definition
> 
> is required to provide the new ARCH definition AUDIT_ARCH_X86_X32 for
> syscall_get_arch().
> 
> This patch along with reverting 8b4b9f2 should satisfy other regular users of
> syscall_get_nr() without changing the seccomp interface to BPF.
> 

Incidentally: do seccomp users know that on an x86-64 system you can
recevie system calls from any of the x86 architectures, regardless of
how the program is invoked?  (This is unusual, so normally denying those
"alien" calls is the right thing to do.)

	-hpa



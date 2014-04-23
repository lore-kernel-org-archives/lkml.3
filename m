Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755594AbaDWQbN (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Apr 2014 12:31:13 -0400
Received: from terminus.zytor.com ([198.137.202.10]:40167 "EHLO mail.zytor.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751747AbaDWQbL (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Apr 2014 12:31:11 -0400
Message-ID: <5357EABB.3070400@zytor.com>
Date: Wed, 23 Apr 2014 09:30:51 -0700
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.4.0
MIME-Version: 1.0
To: Nathan Lynch <Nathan_Lynch@mentor.com>, x86@kernel.org
CC: Kees Cook <keescook@google.com>, luto@amacapital.net,
        linux-kernel@vger.kernel.org
Subject: Re: randomized placement of x86_64 vdso
References: <53554CDA.1060806@mentor.com>
In-Reply-To: <53554CDA.1060806@mentor.com>
X-Enigmail-Version: 1.6
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 04/21/2014 09:52 AM, Nathan Lynch wrote:
> Hi x86/vdso people,
> 
> I've been working on adding a vDSO to 32-bit ARM, and Kees suggested I
> look at x86_64's algorithm for placing the vDSO at a randomized offset
> above the stack VMA.  I found that when the stack top occupies the
> last slot in the PTE (is that the right term?), the vdso_addr routine
> returns an address below mm->start_stack, equivalent to
> (mm->start_stack & PAGE_MASK).  For instance if mm->start_stack is
> 0x7fff3ffffc96, vdso_addr returns 0x7fff3ffff000.
> 
> Since the address returned is always already occupied by the stack,
> get_unmapped_area detects the collision and falls back to
> vm_unmapped_area.  This results in the vdso being placed in the
> address space next to libraries etc.  While this is generally
> unnoticeable and doesn't break anything, it does mean that the vdso is
> placed below the stack when there is actually room above the stack.
> To me it also seems uncomfortably close to placing the vdso in the way
> of downward expansion of the stack.
> 
> I don't have a patch because I'm not sure what the algorithm should
> be, but thought I would bring it up as vdso_addr doesn't seem to be
> behaving as intended in all cases.
> 

If the stack occupies the last possible page, how can you say there is
"space above the stack"?

	-hpa



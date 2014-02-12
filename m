Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754590AbaBLVe5 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Feb 2014 16:34:57 -0500
Received: from unicorn.mansr.com ([81.2.72.234]:46084 "EHLO unicorn.mansr.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753763AbaBLVez convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Feb 2014 16:34:55 -0500
X-Greylist: delayed 412 seconds by postgrey-1.27 at vger.kernel.org; Wed, 12 Feb 2014 16:34:55 EST
From: =?iso-8859-1?Q?M=E5ns_Rullg=E5rd?= <mans@mansr.com>
To: Behan Webster <behanw@converseincode.com>
Cc: Christoph Hellwig <hch@infradead.org>, dl9pf@gmx.de,
        David Woodhouse <David.Woodhouse@intel.com>,
        Matthew Garrett <matthew.garrett@nebula.com>,
        ibm-acpi-devel@lists.sourceforge.net,
        platform-driver-x86@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] x86, acpi: LLVMLinux: Remove nested functions from Thinkpad ACPI
References: <1392238726-18787-1-git-send-email-dl9pf@gmx.de>
	<20140212211159.GA29409@infradead.org>
	<52FBE5A5.3040602@converseincode.com>
Date: Wed, 12 Feb 2014 21:27:59 +0000
In-Reply-To: <52FBE5A5.3040602@converseincode.com> (Behan Webster's message of
	"Wed, 12 Feb 2014 13:20:37 -0800")
Message-ID: <yw1xzjlw58dc.fsf@unicorn.mansr.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/24.3 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Behan Webster <behanw@converseincode.com> writes:

> On 02/12/14 13:11, Christoph Hellwig wrote:
>> On Wed, Feb 12, 2014 at 09:58:46PM +0100, dl9pf@gmx.de wrote:
>>> being able to compile the Linux kernel with Clang. The use of nested functions
>>> blocks this effort.
>> Is there any good way to make gcc warn about the use of nested functions?
> Interesting idea.
>
> '-Wtrampolines'
>      Warn about trampolines generated for pointers to nested functions.
>
>      A trampoline is a small piece of data or code that is created at
>      run time on the stack when the address of a nested function is
>      taken, and is used to call the nested function indirectly.  For
>      some targets, it is made up of data only and thus requires no
>      special treatment.  But, for most targets, it is made up of code
>      and thus requires the stack to be made executable in order for the
>      program to work properly.
>
> That might work.

That sounds like it will only warn if a trampoline is needed.  A nested
function whose address isn't taken, as is the case here, wouldn't
trigger this warning.

-- 
Måns Rullgård
mans@mansr.com

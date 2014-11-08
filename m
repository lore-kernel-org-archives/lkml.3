Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753659AbaKHLZz (ORCPT <rfc822;w@1wt.eu>);
	Sat, 8 Nov 2014 06:25:55 -0500
Received: from aserp1040.oracle.com ([141.146.126.69]:35931 "EHLO
	aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753519AbaKHLZx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 8 Nov 2014 06:25:53 -0500
Date: Sat, 8 Nov 2014 14:25:29 +0300
From: Dan Carpenter <dan.carpenter@oracle.com>
To: Andy Lutomirski <luto@amacapital.net>
Cc: Mimi Zohar <zohar@linux.vnet.ibm.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        LSM List <linux-security-module@vger.kernel.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        "security@kernel.org" <security@kernel.org>,
        James Morris <jmorris@namei.org>
Subject: Re: [GIT PULL] Fix for Integrity subsystem null pointer deref
Message-ID: <20141108112529.GI6890@mwanda>
References: <alpine.LRH.2.11.1410291450290.28213@namei.org>
 <CALCETrUskFJY6hd9OCN_N1645VZ6zfwbGAuSEJNt6F_FPUi3gg@mail.gmail.com>
 <1414587599.5330.50.camel@dhcp-9-2-203-236.watson.ibm.com>
 <CALCETrWpHXp=7u2777ANJjxQ5rRqmutnEwf76dLX2s_LXf87pQ@mail.gmail.com>
 <20141029183612.GI6890@mwanda>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20141029183612.GI6890@mwanda>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Source-IP: acsinet21.oracle.com [141.146.126.237]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Oct 29, 2014 at 09:36:12PM +0300, Dan Carpenter wrote:
> I fixed that exact same bug in lustre last week where the xattr size is
> not zero but it's less than the size of the struct.  So this seems like
> maybe it could be a common anti-pattern though.

It must not be very common.  I wrote a Smatch script which finds both
the lustre and the ima bugs but it doesn't find anything else major.

Apparently parsing vmcores is buggy, for example and I reported a couple
other small bugs to other lists.

fs/proc/vmcore.c:547 update_note_header_size_elf64() warn: is 'notes_section' large enough for 'struct elf64_note'?
fs/proc/vmcore.c:733 update_note_header_size_elf32() warn: is 'notes_section' large enough for 'struct elf32_note'?

regards,
dan carpenter


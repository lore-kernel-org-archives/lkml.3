Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756323AbaJ2Sg1 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 29 Oct 2014 14:36:27 -0400
Received: from userp1040.oracle.com ([156.151.31.81]:41097 "EHLO
	userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756185AbaJ2Sg0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 29 Oct 2014 14:36:26 -0400
Date: Wed, 29 Oct 2014 21:36:12 +0300
From: Dan Carpenter <dan.carpenter@oracle.com>
To: Andy Lutomirski <luto@amacapital.net>
Cc: Mimi Zohar <zohar@linux.vnet.ibm.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        LSM List <linux-security-module@vger.kernel.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        "security@kernel.org" <security@kernel.org>,
        James Morris <jmorris@namei.org>
Subject: Re: [GIT PULL] Fix for Integrity subsystem null pointer deref
Message-ID: <20141029183612.GI6890@mwanda>
References: <alpine.LRH.2.11.1410291450290.28213@namei.org>
 <CALCETrUskFJY6hd9OCN_N1645VZ6zfwbGAuSEJNt6F_FPUi3gg@mail.gmail.com>
 <1414587599.5330.50.camel@dhcp-9-2-203-236.watson.ibm.com>
 <CALCETrWpHXp=7u2777ANJjxQ5rRqmutnEwf76dLX2s_LXf87pQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CALCETrWpHXp=7u2777ANJjxQ5rRqmutnEwf76dLX2s_LXf87pQ@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Source-IP: acsinet22.oracle.com [141.146.126.238]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Oct 29, 2014 at 09:23:45AM -0700, Andy Lutomirski wrote:
> I have no idea what the semantics are.  All I'm saying is that it
> looks like the code still accesses memory past the end of the buffer.
> The buffer isn't a null pointer, so the symptom is different, but it
> may still be a security bug.
> 
> --Andy

It only reads one byte into the struct "xattr_data->type" so checking
for non-zero is sufficient and the patch is fine.

I fixed that exact same bug in lustre last week where the xattr size is
not zero but it's less than the size of the struct.  So this seems like
maybe it could be a common anti-pattern though.

regards,
dan carpenter


Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1422697Ab3DEVAr (ORCPT <rfc822;w@1wt.eu>);
	Fri, 5 Apr 2013 17:00:47 -0400
Received: from zeniv.linux.org.uk ([195.92.253.2]:53157 "EHLO
	ZenIV.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1162169Ab3DEVAp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 5 Apr 2013 17:00:45 -0400
Date: Fri, 5 Apr 2013 22:00:43 +0100
From: Al Viro <viro@ZenIV.linux.org.uk>
To: Nathan Zimmer <nzimmer@sgi.com>
Cc: akpm@linux-foundation.org, linux-kernel@vger.kernel.org,
        linux-fsdevel@vger.kernel.org,
        "Eric W. Biederman" <ebiederm@xmission.com>,
        David Woodhouse <dwmw2@infradead.org>, stable@vger.kernel.org
Subject: Re: [PATCH resend] fs/proc: Move kfree outside pde_unload_lock
Message-ID: <20130405210042.GH4068@ZenIV.linux.org.uk>
References: <515D9F8A.2060505@sgi.com>
 <1365090819-25448-1-git-send-email-nzimmer@sgi.com>
 <20130404161140.GR21522@ZenIV.linux.org.uk>
 <515DB465.1060004@sgi.com>
 <20130404204459.GU21522@ZenIV.linux.org.uk>
 <515F0456.9040803@sgi.com>
 <20130405173623.GE4068@ZenIV.linux.org.uk>
 <515F3A71.9080008@sgi.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <515F3A71.9080008@sgi.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Apr 05, 2013 at 03:56:17PM -0500, Nathan Zimmer wrote:

> That didn't produce anything.  I'll run some bisections over the
> weekend and see what I can sort out.

*Ugh*

I'd try to build with DEBUG_KMEMLEAK and slapped printks on the entry
and exit from close_pdeo().  If that doesn't show anything interesting,
it's probably unrelated to procfs...

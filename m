Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933489AbaDIPBW (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Apr 2014 11:01:22 -0400
Received: from nat28.tlf.novell.com ([130.57.49.28]:38153 "EHLO
	nat28.tlf.novell.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933291AbaDIPBV convert rfc822-to-8bit (ORCPT
	<rfc822;groupwise-linux-kernel@vger.kernel.org:5:1>);
	Wed, 9 Apr 2014 11:01:21 -0400
Message-Id: <53457CDD0200007800007483@nat28.tlf.novell.com>
X-Mailer: Novell GroupWise Internet Agent 14.0.0 
Date: Wed, 09 Apr 2014 16:01:17 +0100
From: "Jan Beulich" <JBeulich@suse.com>
To: "Andrew Cooper" <andrew.cooper3@citrix.com>,
        "David Vrabel" <david.vrabel@citrix.com>
Cc: <xen-devel@lists.xenproject.org>, <boris.ostrovsky@oracle.com>,
        <srostedt@redhat.com>, <linux-kernel@vger.kernel.org>
Subject: Re: [Xen-devel] [PATCH] x86/xen: Fix 32-bit PV guests's usage
 of kernel_stack
References: <1397052401-20220-1-git-send-email-boris.ostrovsky@oracle.com>
 <5345739202000078000073EA@nat28.tlf.novell.com>
 <53455933.2060406@citrix.com> <53455C21.6000408@citrix.com>
In-Reply-To: <53455C21.6000408@citrix.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 8BIT
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>>> On 09.04.14 at 16:41, <andrew.cooper3@citrix.com> wrote:
> The latter load however can easy fault; The arguments for %ds in 
> XSA-42/ CVE-2013-0228 applies to %{e,f,g}s as well.

And it was only that latter operation that I pointed at.

> Furthermore, I am a little concerned about the performance impact of
> this.  I would have thought that in most cases, %fs will already be
> correct, at which point reloading it twice is a waste of time.

Why would you expect %fs on the IRET path to commonly point to the
kernel segment rather than whatever user mode wants/needs? Also, I'm
not sure adding conditionals here wouldn't harm performance about as
much as the save/load/restore. If anything I'd look into open coding
GET_THREAD_INFO() without using %fs for this single case.

Jan


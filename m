Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752227AbaHVWUu (ORCPT <rfc822;w@1wt.eu>);
	Fri, 22 Aug 2014 18:20:50 -0400
Received: from userp1040.oracle.com ([156.151.31.81]:28943 "EHLO
	userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751913AbaHVWUt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 22 Aug 2014 18:20:49 -0400
Date: Fri, 22 Aug 2014 15:20:40 -0700
From: Mukesh Rathor <mukesh.rathor@oracle.com>
To: David Vrabel <david.vrabel@citrix.com>
Cc: <boris.ostrovsky@oracle.com>, <xen-devel@lists.xenproject.org>,
        <linux-kernel@vger.kernel.org>
Subject: Re: [V0 PATCH 0/2] AMD PVH domU support
Message-ID: <20140822152040.70221795@mantra.us.oracle.com>
In-Reply-To: <53F74B29.4090601@citrix.com>
References: <1408587400-18663-1-git-send-email-mukesh.rathor@oracle.com>
	<53F74B29.4090601@citrix.com>
Organization: Oracle Corporation
X-Mailer: Claws Mail 3.9.3 (GTK+ 2.24.22; x86_64-redhat-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Source-IP: ucsinet22.oracle.com [156.151.31.94]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 22 Aug 2014 14:52:41 +0100
David Vrabel <david.vrabel@citrix.com> wrote:

> On 21/08/14 03:16, Mukesh Rathor wrote:
> > Hi,
> > 
> > Here's first stab at AMD PVH domU support. Pretty much the only
> > thing needed is EFER bits set. Please review.
> 
> I'm not going to accept this until there is some ABI documentation
> stating explicitly what state non-boot CPUs will be in.
> 
> I'm particularly concerned that: a) there is a difference between AMD
> and Intel; and b) you want to change the ABI by clearing a the
> EFER.SCE bit.

Correct, I realize it changes the ABI, but I believe that is the right 
thing to do while we can, specially, since we need to fix the EFER for
NX anyways. Looking at the code, it appears this would be the final
cleanup for this ABI... :)..

However, if that's not possible, I suppose we can just leave it as is
too for the SC bit.

thanks
Mukesh

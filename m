Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754651Ab3B1WVD (ORCPT <rfc822;w@1wt.eu>);
	Thu, 28 Feb 2013 17:21:03 -0500
Received: from mail-la0-f44.google.com ([209.85.215.44]:61873 "EHLO
	mail-la0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750886Ab3B1WVA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 28 Feb 2013 17:21:00 -0500
MIME-Version: 1.0
In-Reply-To: <20130228213534.GF11360@redhat.com>
References: <20130228151333.GB11360@redhat.com>
	<1362079419.2908.390.camel@falcor1.watson.ibm.com>
	<20130228213534.GF11360@redhat.com>
Date: Thu, 28 Feb 2013 17:20:58 -0500
Message-ID: <CACLa4pum7kXK+7+8ceVSuQsKDCFebdgGVYRTMKH9GQarqCEgMQ@mail.gmail.com>
Subject: Re: IMA: How to manage user space signing policy with others
From: Eric Paris <eparis@parisplace.org>
To: Vivek Goyal <vgoyal@redhat.com>
Cc: Mimi Zohar <zohar@linux.vnet.ibm.com>,
        linux kernel mailing list <linux-kernel@vger.kernel.org>,
        LSM List <linux-security-module@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Feb 28, 2013 at 4:35 PM, Vivek Goyal <vgoyal@redhat.com> wrote:
> On Thu, Feb 28, 2013 at 02:23:39PM -0500, Mimi Zohar wrote:

I think just a second for both of you to step back and see a slightly
larger picture/problem might help.

This is a weird case where Vivek does not trust root to make the
policy decision.  If the box is configured for secure boot, it needs
to make these decisions no matter what the admin wants.  This is why
he talks about trying to merge multiple competing policies.  The
current IMA policy is controlled by whomever can first write to the
ima policy file interface.  Vivek does not want an admin to be able to
overwrite the secureboot policy.  So I get why he thinks changes may
be needed to support this use case.

The ima_tcb policy was meant to be larger than needed to determine a
trusted computing base, but it is clearly not a superset of what he is
hoping to accomplish.

So how do we take a system where the admin/software has some control
over the integrity policy (as it is today?) and the kernel/system
itself also has control (as Vivek wants it)?

It seems unsolved with what we have today....

-Eric

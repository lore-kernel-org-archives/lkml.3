Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752643Ab3G3MNp (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Jul 2013 08:13:45 -0400
Received: from aserp1040.oracle.com ([141.146.126.69]:45674 "EHLO
	aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751558Ab3G3MNn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Jul 2013 08:13:43 -0400
Date: Tue, 30 Jul 2013 14:12:32 +0200
From: Daniel Kiper <daniel.kiper@oracle.com>
To: Matt Wilson <msw@amazon.com>
Cc: Daniel Kiper <dkiper@net-space.pl>, gregkh@linuxfoundation.org,
        abyde@acunu.com, brandon@ifup.org, ebiederm@xmission.com,
        grzegorz.milos@gmail.com, konrad.wilk@oracle.com, tim@acunu.com,
        linux-kernel@vger.kernel.org,
        virtualization@lists.linux-foundation.org,
        xen-devel@lists.xensource.com, kexec@lists.infradead.org
Subject: Re: [PATCH] kexec/kdump implementation for Xen PV domU
Message-ID: <20130730121232.GB3712@debian70-amd64.local.net-space.pl>
References: <20130729171543.GA2600@router-fw-old.local.net-space.pl>
 <20130729214419.GA4239@u109add4315675089e695.ant.amazon.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20130729214419.GA4239@u109add4315675089e695.ant.amazon.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Source-IP: acsinet21.oracle.com [141.146.126.237]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jul 29, 2013 at 02:44:19PM -0700, Matt Wilson wrote:
> On Mon, Jul 29, 2013 at 07:15:43PM +0200, Daniel Kiper wrote:
> > Hi all,
> >
> > Here I am sending as attachments patches enabling kexec/kdump
> > support in Xen PV domU. Only x84_64 architecture is supported.
> > There is no support for i386 but some code could be easily reused.
> > Here is a description of patches:
>
> [...]
>
> >   - kexec-kernel-only_20121203.patch: this patch fixes timer
> >     issue on Amazon EC2 machines.
>
> Hi Daniel,
>
> Do you know the cause of this issue? Does it have something to do with
> singleshot timer migration when offlining/onlining SMP CPUs?

Sadly, no. I was not able to replicate this on my machines (I did test
on Xen 4.1). However, as I saw this issue appears on Xen 3.4 and 4.0
(IIRC version numbers used on your machines). Additionally, it does not
depend on CPU models. And it appears quite often but not always.
Maybe it is linked with singleshot timer migration.

Daniel

Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757014AbaCDWhy (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Mar 2014 17:37:54 -0500
Received: from mail-pd0-f178.google.com ([209.85.192.178]:62750 "EHLO
	mail-pd0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754195AbaCDWhw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Mar 2014 17:37:52 -0500
Date: Tue, 4 Mar 2014 14:37:50 -0800 (PST)
From: David Rientjes <rientjes@google.com>
X-X-Sender: rientjes@chino.kir.corp.google.com
To: Prarit Bhargava <prarit@redhat.com>
cc: linux-kernel@vger.kernel.org, Rui Wang <rui.y.wang@intel.com>,
        Michel Lespinasse <walken@google.com>,
        Seiji Aguchi <seiji.aguchi@hds.com>,
        Yang Zhang <yang.z.zhang@intel.com>,
        Paul Gortmaker <paul.gortmaker@windriver.com>, janet.morgan@intel.com,
        tony.luck@intel.com, ruiv.wang@gmail.com
Subject: Re: [PATCH] x86, apic, Fix missing replacement for
 VECTOR_UNDEFINED
In-Reply-To: <1393943271-17447-1-git-send-email-prarit@redhat.com>
Message-ID: <alpine.DEB.2.02.1403041436050.5421@chino.kir.corp.google.com>
References: <1393943271-17447-1-git-send-email-prarit@redhat.com>
User-Agent: Alpine 2.02 (DEB 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 4 Mar 2014, Prarit Bhargava wrote:

> linux.git commit 9345005f4eed805308193658d12e4e7e9c261e74 added
> a definition for VECTOR_UNDEFINED = -1.  There is a missing replacement in
> the io_apic.c file.  Found during debugging of another issue.
> 
> Cc: Rui Wang <rui.y.wang@intel.com>
> Cc: Michel Lespinasse <walken@google.com>
> Cc: Seiji Aguchi <seiji.aguchi@hds.com>
> Cc: Yang Zhang <yang.z.zhang@Intel.com>
> Cc: Paul Gortmaker <paul.gortmaker@windriver.com>
> Cc: janet.morgan@Intel.com
> Cc: tony.luck@Intel.com
> Cc: ruiv.wang@gmail.com
> Signed-off-by: Prarit Bhargava <prarit@redhat.com>

Acked-by: David Rientjes <rientjes@google.com>

I think it would have been better to define VECTOR_UNDEFINED to be (-1) 
rather than -1, though, to ensure it can't be used erroneously as an 
arithmetic operation.

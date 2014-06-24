Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752802AbaFXVqp (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Jun 2014 17:46:45 -0400
Received: from gate.crashing.org ([63.228.1.57]:56128 "EHLO gate.crashing.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751206AbaFXVqo (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Jun 2014 17:46:44 -0400
Message-ID: <1403646374.4587.178.camel@pasglop>
Subject: Re: [PATCH] vfio: Fix endianness handling for emulated BARs
From: Benjamin Herrenschmidt <benh@kernel.crashing.org>
To: Alexander Graf <agraf@suse.de>
Cc: Alexey Kardashevskiy <aik@ozlabs.ru>,
        Alex Williamson <alex.williamson@redhat.com>,
        linuxppc-dev@lists.ozlabs.org, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        Nikunj A Dadhania <nikunj@linux.vnet.ibm.com>
Date: Wed, 25 Jun 2014 07:46:14 +1000
In-Reply-To: <53A955F5.6050801@suse.de>
References: <1403091391-31780-1-git-send-email-aik@ozlabs.ru>
	 <1403116512.3707.175.camel@ul30vt.home> <53A233E9.6030006@ozlabs.ru>
	 <53A241F6.9010307@ozlabs.ru> <53A25D74.5000804@ozlabs.ru>
	 <1403234514.3707.278.camel@ul30vt.home> <1403305961.4587.66.camel@pasglop>
	 <53A94EBD.101@ozlabs.ru> <53A955F5.6050801@suse.de>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.12.2 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2014-06-24 at 12:41 +0200, Alexander Graf wrote:
> Is there actually any difference in generated code with this patch 
> applied and without? I would hope that iowrite..() is inlined and 
> cancels out the cpu_to_le..() calls that are also inlined?

No, the former uses byteswapping asm, the compiler can't "cancel" it
out, but the overhead of the additional byteswap might not be
measurable.

Cheers,
Ben.



Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753206Ab3F0JkJ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 Jun 2013 05:40:09 -0400
Received: from gate.crashing.org ([63.228.1.57]:48053 "EHLO gate.crashing.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752975Ab3F0JkI (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 Jun 2013 05:40:08 -0400
Message-ID: <1372325975.18612.41.camel@pasglop>
Subject: Re: [PATCH v3] powerpc: Rework iommu_table locks
From: Benjamin Herrenschmidt <benh@kernel.crashing.org>
To: Alexey Kardashevskiy <aik@ozlabs.ru>
Cc: linuxppc-dev@lists.ozlabs.org, David Gibson <david@gibson.dropbear.id.au>,
        Paul Mackerras <paulus@samba.org>, Anton Blanchard <anton@samba.org>,
        linux-kernel@vger.kernel.org
Date: Thu, 27 Jun 2013 19:39:35 +1000
In-Reply-To: <1372308796-27796-1-git-send-email-aik@ozlabs.ru>
References: <1372308796-27796-1-git-send-email-aik@ozlabs.ru>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.6.4-0ubuntu1 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2013-06-27 at 14:53 +1000, Alexey Kardashevskiy wrote:
> 
> 2. remove locks from functions being called by VFIO. The whole table
> is given to the user space so it is responsible now for races.

Sure but you still need to be careful that userspace cannot cause things
that crash the kernel. For example, look careful at what could happen if
two user space threads try to manipulate the same TCE entry at the same
time and whether that can cause a deadly kernel race... something tells
me it can.

Cheers,
Ben.



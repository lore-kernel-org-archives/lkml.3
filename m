Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752769Ab3ILORB (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Sep 2013 10:17:01 -0400
Received: from a9-78.smtp-out.amazonses.com ([54.240.9.78]:46767 "EHLO
	a9-78.smtp-out.amazonses.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751404Ab3ILORA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Sep 2013 10:17:00 -0400
Date: Thu, 12 Sep 2013 14:16:58 +0000
From: Christoph Lameter <cl@linux.com>
X-X-Sender: cl@gentwo.org
To: Dave Hansen <dave@sr71.net>
cc: Cody P Schafer <cody@linux.vnet.ibm.com>, linux-mm@kvack.org,
        linux-kernel@vger.kernel.org
Subject: Re: [RFC][PATCH] mm: percpu pages: up batch size to fix arithmetic??
 errror
In-Reply-To: <523108B7.7050101@sr71.net>
Message-ID: <00000141128835e1-8664ca3a-c439-4d9d-89cb-308664595db4-000000@email.amazonses.com>
References: <20130911220859.EB8204BB@viggo.jf.intel.com> <5230F7DD.90905@linux.vnet.ibm.com> <5230FB0A.70901@linux.vnet.ibm.com> <523108B7.7050101@sr71.net>
User-Agent: Alpine 2.02 (DEB 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-SES-Outgoing: 2013.09.12-54.240.9.78
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 11 Sep 2013, Dave Hansen wrote:

> 3. We want ->high to approximate the size of the cache which is
>    private to a given cpu.  But, that's complicated by the L3 caches
>    and hyperthreading today.

well lets keep it well below that. There are other caches (slab related
f.e.) that are also in constant use.

> I'll take one of my big systems and run it with some various ->high
> settings and see if it makes any difference.

Do you actually see contention issues on the locks? I think we have a
tendency to batch too much in too many caches.





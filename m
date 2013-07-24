Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753415Ab3GXWnG (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Jul 2013 18:43:06 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:55854 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752699Ab3GXWnE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Jul 2013 18:43:04 -0400
Date: Wed, 24 Jul 2013 15:43:01 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Alexey Kardashevskiy <aik@ozlabs.ru>
Cc: linuxppc-dev@lists.ozlabs.org, David Gibson <david@gibson.dropbear.id.au>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Paul Mackerras <paulus@samba.org>, Alexander Graf <agraf@suse.de>,
        Alex Williamson <alex.williamson@redhat.com>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org, kvm-ppc@vger.kernel.org,
        linux-mm@kvack.org, Yasuaki Ishimatsu <isimatu.yasuaki@jp.fujitsu.com>,
        Martin Schwidefsky <schwidefsky@de.ibm.com>,
        Andrea Arcangeli <aarcange@redhat.com>, Mel Gorman <mgorman@suse.de>
Subject: Re: [PATCH 04/10] powerpc: Prepare to support kernel handling of
 IOMMU map/unmap
Message-Id: <20130724154301.2af75867c51870fc0c32819b@linux-foundation.org>
In-Reply-To: <51EDE903.6010608@ozlabs.ru>
References: <1373936045-22653-1-git-send-email-aik@ozlabs.ru>
	<1373936045-22653-5-git-send-email-aik@ozlabs.ru>
	<51EDE903.6010608@ozlabs.ru>
X-Mailer: Sylpheed 3.2.0beta5 (GTK+ 2.24.10; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 23 Jul 2013 12:22:59 +1000 Alexey Kardashevskiy <aik@ozlabs.ru> wrote:

> Ping, anyone, please?

ew, you top-posted.

> Ben needs ack from any of MM people before proceeding with this patch. Thanks!

For what?  The three lines of comment in page-flags.h?   ack :)

Manipulating page->_count directly is considered poor form.  Don't
blame us if we break your code ;)

Actually, the manipulation in realmode_get_page() duplicates the
existing get_page_unless_zero() and the one in realmode_put_page()
could perhaps be placed in mm.h with a suitable name and some
documentation.  That would improve your form and might protect the code
from getting broken later on.


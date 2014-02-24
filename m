Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752803AbaBXOYk (ORCPT <rfc822;w@1wt.eu>);
	Mon, 24 Feb 2014 09:24:40 -0500
Received: from smtp.citrix.com ([66.165.176.89]:4509 "EHLO SMTP.CITRIX.COM"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752253AbaBXOYj (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 24 Feb 2014 09:24:39 -0500
X-IronPort-AV: E=Sophos;i="4.97,535,1389744000"; 
   d="scan'208";a="105196365"
Message-ID: <530B5624.8080309@citrix.com>
Date: Mon, 24 Feb 2014 14:24:36 +0000
From: David Vrabel <david.vrabel@citrix.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.16) Gecko/20121215 Iceowl/1.0b1 Icedove/3.0.11
MIME-Version: 1.0
To: Thomas Gleixner <tglx@linutronix.de>
CC: LKML <linux-kernel@vger.kernel.org>, Peter Zijlstra <peterz@infradead.org>,
        Xen <xen-devel@lists.xenproject.org>, Ingo Molnar <mingo@elte.hu>
Subject: Re: [Xen-devel] [patch 18/26] xen: Use the proper irq functions
References: <20140223212703.511977310@linutronix.de> <20140223212738.222412125@linutronix.de>
In-Reply-To: <20140223212738.222412125@linutronix.de>
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.80.2.76]
X-DLP: MIA2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 23/02/14 21:40, Thomas Gleixner wrote:
> I really can't understand why people keep adding irq_desc abuse. We
> have enough proper interfaces. Delete another 14 lines of hackery.

    generic_handler_irq() already tests for !desc so use this instead
    of generic_handle_irq_desc().  Use irq_get_irq_data() instead of
    desc->irq_data.

Otherwise,

Reviewed-by: David Vrabel <david.vrabel@citrix.com>

David

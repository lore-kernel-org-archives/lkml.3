Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755191AbaIDJV7 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Sep 2014 05:21:59 -0400
Received: from bombadil.infradead.org ([198.137.202.9]:49779 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754601AbaIDJV5 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Sep 2014 05:21:57 -0400
Date: Thu, 4 Sep 2014 11:21:35 +0200
From: Peter Zijlstra <peterz@infradead.org>
To: Sudeep Holla <sudeep.holla@arm.com>
Cc: LKML <linux-kernel@vger.kernel.org>,
        Heiko Carstens <heiko.carstens@de.ibm.com>,
        Lorenzo Pieralisi <Lorenzo.Pieralisi@arm.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        "Rafael J. Wysocki" <rjw@rjwysocki.net>,
        Bjorn Helgaas <bhelgaas@google.com>, "x86@kernel.org" <x86@kernel.org>,
        "linux-acpi@vger.kernel.org" <linux-acpi@vger.kernel.org>,
        "linux-pci@vger.kernel.org" <linux-pci@vger.kernel.org>
Subject: Re: [PATCH v4 01/11] cpumask: factor out show_cpumap into separate
 helper function
Message-ID: <20140904092135.GA346@worktop.programming.kicks-ass.net>
References: <1409763617-17074-1-git-send-email-sudeep.holla@arm.com>
 <1409763617-17074-2-git-send-email-sudeep.holla@arm.com>
 <20140904062006.GC3190@worktop.ger.corp.intel.com>
 <54082ADD.6040004@arm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8BIT
In-Reply-To: <54082ADD.6040004@arm.com>
User-Agent: Mutt/1.5.22.1 (2013-10-16)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Sep 04, 2014 at 10:03:25AM +0100, Sudeep Holla wrote:
> If I don't, every file including this header generates "warning:
> ‘cpumap_copy_to_buf’ defined but not used". Alternatively I can just
> declare here and define it elsewhere but I could not find more apt
> place than this. Any suggestions ? kernel/cpu.c ?

Sure the tail of cpu.c seems to have various other cpumask gunk in
already so it fits there. The other alternative would've been
lib/bitmap.c since that's where the various bitmap printf
implementations live.

You could make it bitmap_copy_to_buf() I suppose, and then have a
cpumask inline wrapper, to be fully consistent with the rest of the
implementations.

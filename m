Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755157AbaA1PJo (ORCPT <rfc822;w@1wt.eu>);
	Tue, 28 Jan 2014 10:09:44 -0500
Received: from mx1.redhat.com ([209.132.183.28]:63894 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754631AbaA1PJm (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 28 Jan 2014 10:09:42 -0500
Date: Tue, 28 Jan 2014 16:08:49 +0100
From: Stanislaw Gruszka <sgruszka@redhat.com>
To: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
Cc: Ben Guthro <benjamin.guthro@citrix.com>, linux-kernel@vger.kernel.org,
        "Rafael J. Wysocki" <rjw@sisk.pl>
Subject: [BUG?] Interrupts enabled after xen_acpi_processor_resume+0x0/0x34
 [xen_acpi_processor]
Message-ID: <20140128150848.GA1428@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

We have this bug report on our bugzilla:
https://bugzilla.redhat.com/show_bug.cgi?id=1058268

In short:
WARNING: CPU: 0 PID: 6733 at drivers/base/syscore.c:104 syscore_resume+0x9a/0xe0()
Interrupts enabled after xen_acpi_processor_resume+0x0/0x34 [xen_acpi_processor]

Perhaps I'm wrong, but I think sysops->resume() callback should be
atomic i.e. can not use mutexes or kmalloc(,GFP_KERNEL), what is not
true regarding xen_acpi_processor_resume(). That callback was introduced
by commit 3fac10145b766a2244422788f62dc35978613fd8. Fixing that will
not be easy IMHO, but maybe you have some ideas ? :-)

Stanislaw

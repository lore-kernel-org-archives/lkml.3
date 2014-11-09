Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753452AbaKIAvx (ORCPT <rfc822;w@1wt.eu>);
	Sat, 8 Nov 2014 19:51:53 -0500
Received: from e39.co.us.ibm.com ([32.97.110.160]:47274 "EHLO
	e39.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753259AbaKIAvv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 8 Nov 2014 19:51:51 -0500
Date: Sat, 8 Nov 2014 16:51:24 -0800
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: Alexander Monakov <amonakov@gmail.com>
Cc: Konstantin Khlebnikov <koct9i@gmail.com>, linux-acpi@vger.kernel.org,
        "Rafael J. Wysocki" <rjw@rjwysocki.net>, linux-kernel@vger.kernel.org,
        Len Brown <lenb@kernel.org>, Tom Boshoven <tomboshoven@gmail.com>,
        x86@kernel.org, Josh Triplett <josh@joshtriplett.org>
Subject: Re: [PATCH] ACPI/osl: speedup grace period in acpi_os_map_cleanup
Message-ID: <20141109005124.GG4901@linux.vnet.ibm.com>
Reply-To: paulmck@linux.vnet.ibm.com
References: <20141108094717.9388.34638.stgit@zurg>
 <20141108221347.GF4901@linux.vnet.ibm.com>
 <CABtfrpDryV5XEzBOttTuGZ7Tvyy4QUo1pajvO07=6tpozjVLzQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CABtfrpDryV5XEzBOttTuGZ7Tvyy4QUo1pajvO07=6tpozjVLzQ@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-TM-AS-MML: disable
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 14110900-0033-0000-0000-0000029DB82D
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Nov 09, 2014 at 03:24:34AM +0400, Alexander Monakov wrote:
> On Sun, Nov 9, 2014 at 1:13 AM, Paul E. McKenney
> <paulmck@linux.vnet.ibm.com> wrote:
> >
> > Did anyone try replacing the synchronize_rcu() with
> > synchronize_rcu_expedited()?  That should provide substantial speedups
> > over synchronize_rcu().
> 
> I've just briefly tested it on my laptop, and it also helps to avoid the issue.

OK, good.

In the past, synchronize_rcu_expedited() has been a bit unfriendly to
battery-powered platforms and to real-time and HPC workloads, but
recent changes for the most part fix this.

							Thanx, Paul


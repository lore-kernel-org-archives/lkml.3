Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757281Ab3LFIjv (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Dec 2013 03:39:51 -0500
Received: from e06smtp13.uk.ibm.com ([195.75.94.109]:47525 "EHLO
	e06smtp13.uk.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757231Ab3LFIjr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Dec 2013 03:39:47 -0500
Subject: Re: [PATCH 1/6] GenWQE PCI support, health monitoring and recovery
From: Frank Haverkamp <haver@linux.vnet.ibm.com>
Reply-To: haver@linux.vnet.ibm.com
To: Arnd Bergmann <arnd@arndb.de>
Cc: linux-kernel@vger.kernel.org, gregkh@linuxfoundation.org,
        cody@linux.vnet.ibm.com, schwidefsky@de.ibm.com, utz.bacher@de.ibm.com,
        mmarek@suse.cz, rmallon@gmail.com, jsvogt@de.ibm.com,
        MIJUNG@de.ibm.com, cascardo@linux.vnet.ibm.com, michael@ibmra.de
In-Reply-To: <201312052131.42316.arnd@arndb.de>
References: <1386080903-27160-1-git-send-email-haver@linux.vnet.ibm.com>
	 <201312050338.54841.arnd@arndb.de>
	 <1386247827.11866.6.camel@oc7383187364.ibm.com>
	 <201312052131.42316.arnd@arndb.de>
Content-Type: text/plain; charset="UTF-8"
Organization: IBM
Date: Fri, 06 Dec 2013 09:39:41 +0100
Message-ID: <1386319181.7915.4.camel@oc7383187364.ibm.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.3 (2.28.3-30.el6) 
Content-Transfer-Encoding: 7bit
X-TM-AS-MML: disable
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 13120608-2966-0000-0000-000009981E56
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Arnd,

Am Donnerstag, den 05.12.2013, 21:31 +0100 schrieb Arnd Bergmann:
> On Thursday 05 December 2013, Frank Haverkamp wrote:
> > > > Was wrong, as already pointed out before. It is now:
> > > > 
> > > > struct genwqe_mem {
> > > >     __u64 addr;
> > > >     __u64 size;
> > > >     int direction;
> > > > };
> > > > 
> > > > I hope the int is ok here.
> > > 
> > > No, it's not. The problem is that sizeof(struct genwqe_mem) is now 24 on
> > > most architectures (including x86-64) and 20 on x86-32.
> > 
> > Interesting. So int is like long architecture specific. I changed it to
> > be __u64 too, to avoid any problem.
> 
> The solution is ok, but the problem is different from what you thought:
> 
> On all architectures that Linux runs on, 'int' is 32 bit. The problem is
> again the alignment of __u64. On normal architectures, it is naturally
> aligned, and gcc adds 4 byte padding so that 'sizeof (struct genwqe_mem)'
> is  multiple of the required alignment. On x86-32, the required alignment
> for the __u64 members is only 4 bytes, so no padding is added.
> 
> 	Arnd
> 

now I understand. Interesting. I wondered how one could check this
automatically such that others don't repeat the mistakes I did.

I hope I have fixed all those issues now in my latest posting, or do you
still see some?

Other than that, is the code ready for inclusion now, or do you still
like to have other changes done (hopefully not, but if so which ones)?

Thanks

Frank



Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752690Ab3LEUbx (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Dec 2013 15:31:53 -0500
Received: from moutng.kundenserver.de ([212.227.126.187]:53662 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751056Ab3LEUbt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Dec 2013 15:31:49 -0500
From: Arnd Bergmann <arnd@arndb.de>
To: haver@linux.vnet.ibm.com
Subject: Re: [PATCH 1/6] GenWQE PCI support, health monitoring and recovery
Date: Thu, 5 Dec 2013 21:31:42 +0100
User-Agent: KMail/1.12.2 (Linux/3.8.0-22-generic; KDE/4.3.2; x86_64; ; )
Cc: linux-kernel@vger.kernel.org, gregkh@linuxfoundation.org,
        cody@linux.vnet.ibm.com, schwidefsky@de.ibm.com, utz.bacher@de.ibm.com,
        mmarek@suse.cz, rmallon@gmail.com, jsvogt@de.ibm.com,
        MIJUNG@de.ibm.com, cascardo@linux.vnet.ibm.com, michael@ibmra.de
References: <1386080903-27160-1-git-send-email-haver@linux.vnet.ibm.com> <201312050338.54841.arnd@arndb.de> <1386247827.11866.6.camel@oc7383187364.ibm.com>
In-Reply-To: <1386247827.11866.6.camel@oc7383187364.ibm.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <201312052131.42316.arnd@arndb.de>
X-Provags-ID: V02:K0:m7TJlUhPD5dsCOGQH5m3I1wgzh9fVdJ4PDA+7dewMKf
 mjeYyBnAs3zK4Sr/C1TxLn/gGBrbiOJ5GklhkItRB+UxKzru+V
 w4Nkz/RHXzMemWjEdqeiexEutTpZmSJgY2cZEKm5071yEJV1p1
 JyNYQakptggtUOncgTi2St1SK92WD9N+uKbF64oH/iYzI+y9ue
 LJfTX/oK9NZIhbaNfBMr1K/bmt5r3mH2UyCyeKQ5QCgFjUCzux
 OsahBWqAbDQanHJ8aFoqzoZqPIOItIWTJ7n9tQ24PfQe9j3hMp
 nI92psCQO1WzJ8RRC0affUagmhGG9cdrMXfOoyEMFJbLR9IxCh
 Si8tRP58u0pTnghoTwRk=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thursday 05 December 2013, Frank Haverkamp wrote:
> > > Was wrong, as already pointed out before. It is now:
> > > 
> > > struct genwqe_mem {
> > >     __u64 addr;
> > >     __u64 size;
> > >     int direction;
> > > };
> > > 
> > > I hope the int is ok here.
> > 
> > No, it's not. The problem is that sizeof(struct genwqe_mem) is now 24 on
> > most architectures (including x86-64) and 20 on x86-32.
> 
> Interesting. So int is like long architecture specific. I changed it to
> be __u64 too, to avoid any problem.

The solution is ok, but the problem is different from what you thought:

On all architectures that Linux runs on, 'int' is 32 bit. The problem is
again the alignment of __u64. On normal architectures, it is naturally
aligned, and gcc adds 4 byte padding so that 'sizeof (struct genwqe_mem)'
is  multiple of the required alignment. On x86-32, the required alignment
for the __u64 members is only 4 bytes, so no padding is added.

	Arnd

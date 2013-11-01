Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754559Ab3KAQ1a (ORCPT <rfc822;w@1wt.eu>);
	Fri, 1 Nov 2013 12:27:30 -0400
Received: from mx0.aculab.com ([213.249.233.131]:55149 "HELO mx0.aculab.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1752828Ab3KAQ13 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 1 Nov 2013 12:27:29 -0400
X-MimeOLE: Produced By Microsoft Exchange V6.5
Content-class: urn:content-classes:message
MIME-Version: 1.0
Content-Type: text/plain;
	charset="Windows-1252"
Content-Transfer-Encoding: 8BIT
Subject: RE: perf events ring buffer memory barrier on powerpc
Date: Fri, 1 Nov 2013 16:25:29 -0000
Message-ID: <AE90C24D6B3A694183C094C60CF0A2F6026B73D4@saturn3.aculab.com>
In-Reply-To: <OF3CB471BA.BACC7843-ON42257C16.0055EF23-42257C16.0058875B@il.ibm.com>
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
Thread-Topic: perf events ring buffer memory barrier on powerpc
Thread-Index: Ac7XHG4wfY6ad4u+TjSC18bMRKor8gAAd0vA
References: <CAFTL4hxn47KFKZPLgKeBxxdaAbA4vg9QVzctuW4ZrSgmfX5bAQ@mail.gmail.com> <OFB9096CCA.68AAFFFB-ON42257C12.0044F107-42257C12.00457129@il.ibm.com> <20131028132634.GO19466@laptop.lan> <20131028163418.GD4126@linux.vnet.ibm.com> <20131028201735.GA15629@redhat.com> <OF58D85F5A.03E37A80-ON42257C12.0070E552-42257C12.00734308@il.ibm.com> <20131030092725.GL4126@linux.vnet.ibm.com> <OFC6B7100E.31C6B190-ON42257C14.004841C6-42257C14.004A0EA6@il.ibm.com> <20131031043258.GQ4126@linux.vnet.ibm.com> <OFDF23985D.1D949148-ON42257C15.002DEB25-42257C15.0036DF93@il.ibm.com> <20131031152543.GC4067@linux.vnet.ibm.com> <OF3CB471BA.BACC7843-ON42257C16.0055EF23-42257C16.0058875B@il.ibm.com>
From: "David Laight" <David.Laight@ACULAB.COM>
To: "Victor Kaplansky" <VICTORK@il.ibm.com>, <paulmck@linux.vnet.ibm.com>
Cc: "Michael Neuling" <mikey@neuling.org>,
        "Mathieu Desnoyers" <mathieu.desnoyers@polymtl.ca>,
        "Peter Zijlstra" <peterz@infradead.org>,
        "LKML" <linux-kernel@vger.kernel.org>,
        "Oleg Nesterov" <oleg@redhat.com>,
        "Linux PPC dev" <linuxppc-dev@ozlabs.org>,
        "Anton Blanchard" <anton@samba.org>,
        "Frederic Weisbecker" <fweisbec@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> But "broken" compiler is much wider issue to be deeply discussed in this
> thread. I'm pretty sure that kernel have tons of very subtle
> code that actually creates locks and memory ordering. Such code
> usually just use the "barrier()"  approach to tell gcc not to combine
> or move memory accesses around it.

gcc will do unexpected memory accesses for bit fields that are
adjacent to volatile data.
In particular it may generate 64bit sized (and aligned) RMW cycles
when accessing bit fields.
And yes, this has caused real problems.

	David



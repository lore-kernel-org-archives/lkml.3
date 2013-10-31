Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754153Ab3JaM4x (ORCPT <rfc822;w@1wt.eu>);
	Thu, 31 Oct 2013 08:56:53 -0400
Received: from e06smtp16.uk.ibm.com ([195.75.94.112]:60859 "EHLO
	e06smtp16.uk.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753970Ab3JaM4v (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 31 Oct 2013 08:56:51 -0400
In-Reply-To: <AE90C24D6B3A694183C094C60CF0A2F6026B73CC@saturn3.aculab.com>
References: <20131023141948.GB3566@localhost.localdomain> <20131025173749.GG19466@laptop.lan> <CAFTL4hxn47KFKZPLgKeBxxdaAbA4vg9QVzctuW4ZrSgmfX5bAQ@mail.gmail.com> <OFB9096CCA.68AAFFFB-ON42257C12.0044F107-42257C12.00457129@il.ibm.com> <20131028132634.GO19466@laptop.lan> <20131028163418.GD4126@linux.vnet.ibm.com> <20131028201735.GA15629@redhat.com> <OF58D85F5A.03E37A80-ON42257C12.0070E552-42257C12.00734308@il.ibm.com> <20131030092725.GL4126@linux.vnet.ibm.com> <OFC6B7100E.31C6B190-ON42257C14.004841C6-42257C14.004A0EA6@il.ibm.com> <20131031043258.GQ4126@linux.vnet.ibm.com> <OFDF23985D.1D949148-ON42257C15.002DEB25-42257C15.0036DF93@il.ibm.com> <AE90C24D6B3A694183C094C60CF0A2F6026B73CC@saturn3.aculab.com>
Subject: RE: perf events ring buffer memory barrier on powerpc
X-KeepSent: F094B66E:899BE5FF-42257C15:0045F3A1;
 type=4; name=$KeepSent
To: "David Laight" <David.Laight@aculab.com>
Cc: "Anton Blanchard" <anton@samba.org>,
        "Frederic Weisbecker" <fweisbec@gmail.com>,
        "LKML" <linux-kernel@vger.kernel.org>,
        "Linux PPC dev" <linuxppc-dev@ozlabs.org>,
        "Mathieu Desnoyers" <mathieu.desnoyers@polymtl.ca>,
        "Michael Neuling" <mikey@neuling.org>,
        "Oleg Nesterov" <oleg@redhat.com>, paulmck@linux.vnet.ibm.com,
        "Peter Zijlstra" <peterz@infradead.org>
X-Mailer: Lotus Notes Release 8.5.3 September 15, 2011
Message-ID: <OFF094B66E.899BE5FF-ON42257C15.0045F3A1-42257C15.0046FE15@il.ibm.com>
From: Victor Kaplansky <VICTORK@il.ibm.com>
Date: Thu, 31 Oct 2013 14:55:25 +0200
X-MIMETrack: Serialize by Router on D06ML319/06/M/IBM(Release 8.5.3FP5|July 31, 2013) at
 31/10/2013 14:55:18
MIME-Version: 1.0
Content-type: text/plain; charset=US-ASCII
X-TM-AS-MML: No
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 13103112-3548-0000-0000-000007018ECA
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

"David Laight" <David.Laight@aculab.com> wrote on 10/31/2013 02:28:56 PM:

> So even though the wmb() in the writer ensures the writes are correctly
> ordered, the reader can read the old value from the second location from
> its local cache.

In case of circular buffer, the only thing that producer reads is @tail,
and nothing wrong will happen if producer reads old value of @tail.
Moreover,
adherents of smp_mb() insert it *after* the read of @tail, so it cannot
prevent reading of old value anyway.
-- Victor


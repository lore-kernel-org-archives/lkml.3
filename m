Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754848Ab3KAQVY (ORCPT <rfc822;w@1wt.eu>);
	Fri, 1 Nov 2013 12:21:24 -0400
Received: from mx0.aculab.com ([213.249.233.131]:55065 "HELO mx0.aculab.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1754691Ab3KAQVW convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 1 Nov 2013 12:21:22 -0400
X-MimeOLE: Produced By Microsoft Exchange V6.5
Content-class: urn:content-classes:message
MIME-Version: 1.0
Content-Type: text/plain;
	charset="Windows-1252"
Content-Transfer-Encoding: 8BIT
Subject: RE: [PATCH] x86: Run checksumming in parallel accross multiple alu's
Date: Fri, 1 Nov 2013 16:18:50 -0000
Message-ID: <AE90C24D6B3A694183C094C60CF0A2F6026B73D3@saturn3.aculab.com>
In-Reply-To: <20131101160802.GB8467@hmsreliant.think-freely.org>
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
Thread-Topic: [PATCH] x86: Run checksumming in parallel accross multiple alu's
Thread-Index: Ac7XHGKwZRWzpBB+QLe4781eYGhW5gAATgEw
References: <201310300525.r9U5Pdqo014902@ib.usersys.redhat.com> <20131030110214.GA10220@localhost.localdomain> <52710B09.6090302@redhat.com> <20131031183003.GC25894@hmsreliant.think-freely.org> <1383320566.1737.0.camel@bwh-desktop.uk.level5networks.com> <20131101160802.GB8467@hmsreliant.think-freely.org>
From: "David Laight" <David.Laight@ACULAB.COM>
To: "Neil Horman" <nhorman@tuxdriver.com>,
        "Ben Hutchings" <bhutchings@solarflare.com>
Cc: "Doug Ledford" <dledford@redhat.com>, "Ingo Molnar" <mingo@kernel.org>,
        "Eric Dumazet" <eric.dumazet@gmail.com>,
        <linux-kernel@vger.kernel.org>, <netdev@vger.kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> How would you suggest replacing the jumps in this case?  I agree it would be
> faster here, but I'm not sure how I would implement an increment using a single
> conditional move.

I think you need 3 instructions, move a 0, conditionally move a 1
then add. I suspect it won't be a win!

If you do 'win' it is probably very dependent on how the instructions
get scheduled onto the execution units - which will probably make
it very cpu type dependant.

	David





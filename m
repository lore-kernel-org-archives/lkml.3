Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754183Ab3J3MUg (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Oct 2013 08:20:36 -0400
Received: from mx0.aculab.com ([213.249.233.131]:49636 "HELO mx0.aculab.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1754101Ab3J3MUc convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Oct 2013 08:20:32 -0400
X-MimeOLE: Produced By Microsoft Exchange V6.5
Content-class: urn:content-classes:message
MIME-Version: 1.0
Content-Type: text/plain;
	charset="Windows-1252"
Content-Transfer-Encoding: 8BIT
Subject: RE: [PATCH] x86: Run checksumming in parallel accross multiple alu's
Date: Wed, 30 Oct 2013 12:18:06 -0000
Message-ID: <AE90C24D6B3A694183C094C60CF0A2F6026B73C5@saturn3.aculab.com>
In-Reply-To: <20131030110214.GA10220@localhost.localdomain>
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
Thread-Topic: [PATCH] x86: Run checksumming in parallel accross multiple alu's
Thread-Index: Ac7VX1YMylFBT3CjSAeF/hrFTfozCQACiV8g
References: <201310300525.r9U5Pdqo014902@ib.usersys.redhat.com> <20131030110214.GA10220@localhost.localdomain>
From: "David Laight" <David.Laight@ACULAB.COM>
To: "Neil Horman" <nhorman@tuxdriver.com>,
        "Doug Ledford" <dledford@redhat.com>
Cc: "Ingo Molnar" <mingo@kernel.org>, "Eric Dumazet" <eric.dumazet@gmail.com>,
        <linux-kernel@vger.kernel.org>, <netdev@vger.kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> /me wonders if rearranging the instructions into this order:
> adcq 0*8(src), res1
> adcq 1*8(src), res2
> adcq 2*8(src), res1

Those have to be sequenced.

Using a 64bit lea to add 32bit quantities should avoid the
dependencies on the flags register.
However you'd need to get 3 of those active to beat a 64bit adc.

	David



